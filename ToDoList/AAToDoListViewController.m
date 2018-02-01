//
//  XYZToDoListViewController.m
//  ToDoList
//
//  Created by Alvar Aronija on 12/01/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

#import "AAToDoListViewController.h"
#import "AAToDoItem.h"
#import "AAAddToDoItemViewController.h"
#import "AppDelegate.h"

@interface AAToDoListViewController ()

@property NSMutableArray *toDoItems;
@property NSDictionary *sections;
@property NSMutableArray *doneItems;
@property NSArray *sectionTitels;

@end

@implementation AAToDoListViewController

- (IBAction)unWindToList:(UIStoryboardSegue *)segue {
    
    AAAddToDoItemViewController *source = [segue sourceViewController];
    
    AAToDoItem *item = source.toDoItem;
    
    if (item != nil) {
        [self.toDoItems addObject:item];
        [self saveToDos];
        [self.tableView reloadData];
    }
    
}

-(void)saveToDos{
    NSData *dataToDo = [NSKeyedArchiver archivedDataWithRootObject:self.toDoItems];
    NSData *dataDone = [NSKeyedArchiver archivedDataWithRootObject:self.doneItems];
    [self.savedToDos setObject:dataToDo forKey:@"toDoItems"];
    [self.savedToDos setObject:dataDone forKey:@"doneItems"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 //   self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.toDoItems = [[NSMutableArray alloc] init];
    self.doneItems = [[NSMutableArray alloc] init];
    self.savedToDos = [NSUserDefaults standardUserDefaults];
    
    [self getData];
}

-(void)getData {
    
    NSData *dataToDo = [self.savedToDos objectForKey:@"toDoItems"];
    NSData *dataDone = [self.savedToDos objectForKey:@"doneItems"];
    NSArray *toDoItems = [NSKeyedUnarchiver unarchiveObjectWithData:dataToDo];
    NSArray *doneItems = [NSKeyedUnarchiver unarchiveObjectWithData:dataDone];
    
    
    if(toDoItems) {
        self.toDoItems = toDoItems.mutableCopy;
    }
    if(doneItems) {
        self.doneItems = doneItems.mutableCopy;
    }
    
    self.sections = @{@"To-Do" : self.toDoItems,
                      @"Done"  : self.doneItems
                      };
    self.sectionTitels = [self.sections allKeys];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sectionTitels count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *sectionTitle = [self.sectionTitels objectAtIndex:section];
    NSArray *sectionToDos = [self.sections objectForKey:sectionTitle];
    return [sectionToDos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoItemCell" forIndexPath:indexPath];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    
    AAToDoItem *toDoItem = nil;
    if(indexPath.section == 0) {
        toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
        cell.textLabel.text = toDoItem.itemName;
        [cell addGestureRecognizer:longPressGesture];
    
    }else {
        AAToDoItem *doneItem = [self.doneItems objectAtIndex:indexPath.row];
        cell.textLabel.text = doneItem.itemName;
        if(doneItem.completed) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
    
}

- (void)longPress:(UILongPressGestureRecognizer *)gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        UITableViewCell *cell = (UITableViewCell*) [gesture view];
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        if(indexPath.section == 0) {
            AAToDoItem *importantItem = [self.toDoItems objectAtIndex:indexPath.row];
            importantItem.isImportant = !importantItem.isImportant;
            [self saveToDos];
            [self.tableView reloadData];
            
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 0) {
        AAToDoItem *tappedItem = [self.toDoItems objectAtIndex:indexPath.row];
        tappedItem.completed = !tappedItem.completed;
        if(tappedItem.completed) {
            if(self.doneItems) {
                [self.doneItems addObject:tappedItem];
                [self.toDoItems removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        if(indexPath.section == 0) {
            [self.toDoItems removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.doneItems removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    [self saveToDos];
    
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return [self.sectionTitels objectAtIndex:section];
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return [self.sectionTitels indexOfObject:title];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0) {
        AAToDoItem *importantItem = [self.toDoItems objectAtIndex:indexPath.row];
        
        if(importantItem.isImportant){
            cell.textLabel.textColor = [UIColor redColor];
        } else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
        
        if(importantItem.completed){
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.textLabel.textColor = [UIColor greenColor];
        
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
}




/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    AAToDoItem *item = [self.toDoItems objectAtIndex:fromIndexPath.row];
    
    if(fromIndexPath != toIndexPath) {
       
        [self.toDoItems removeObjectAtIndex:fromIndexPath.row];
        [self.doneItems insertObject:item atIndex:toIndexPath.row];
        [tableView reloadData];
        
        
    }
    
    
}
*/




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
