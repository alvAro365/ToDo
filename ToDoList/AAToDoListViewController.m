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
#import "ToDoListData.h"

@interface AAToDoListViewController ()

@property NSDictionary *sections;
@property NSArray *sectionTitels;
@property ToDoListData *toDoListData;

@end

@implementation AAToDoListViewController

- (IBAction)unWindToList:(UIStoryboardSegue *)segue {
    AAAddToDoItemViewController *source = [segue sourceViewController];
    AAToDoItem *item = source.toDoItem;
    if (item != nil) {
        [[self.toDoListData toDoList] addObject:item];
        NSLog(@"TodolistData todolist count: %lu", (unsigned long)[[self.toDoListData toDoList] count]);
        [self.toDoListData saveData];
        [self.tableView reloadData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.toDoListData = [[ToDoListData alloc] init];
    [self initializeData];
    //   self.navigationItem.leftBarButtonItem = self.editButtonItem;
}

-(void)initializeData {
    self.sections = @{@"To-Do" : [self.toDoListData getToDoList],
                      @"Done"  : [self.toDoListData getDoneList],
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
    if (indexPath.section == 0) {
        toDoItem = [[self.toDoListData toDoList] objectAtIndex:indexPath.row];
        cell.textLabel.text = toDoItem.itemName;
        [cell addGestureRecognizer:longPressGesture];
    }
    else {
        AAToDoItem *doneItem = [[self.toDoListData doneList] objectAtIndex:indexPath.row];
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
            AAToDoItem *importantItem = [[self.toDoListData toDoList] objectAtIndex:indexPath.row];
            importantItem.isImportant = !importantItem.isImportant;
            [self.toDoListData saveData];
            [self.tableView reloadData];
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if(indexPath.section == 0) {
        AAToDoItem *tappedItem = [[self.toDoListData toDoList] objectAtIndex:indexPath.row];
        tappedItem.completed = !tappedItem.completed;
        if(tappedItem.completed) {
            if([self.toDoListData doneList]) {
                [[self.toDoListData doneList] addObject:tappedItem];
                [[self.toDoListData toDoList] removeObjectAtIndex:indexPath.row];
                [self.toDoListData saveData];
                [self.tableView reloadData];
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 0) {
            [[self.toDoListData toDoList] removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else {
            [[self.toDoListData doneList] removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    }
    [self.toDoListData saveData];
    
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [self.sectionTitels objectAtIndex:section];    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return [self.sectionTitels indexOfObject:title];
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0) {
        AAToDoItem *toDoItem = [[self.toDoListData toDoList] objectAtIndex:indexPath.row];
        
        if (toDoItem.isImportant) {
            cell.textLabel.textColor = [UIColor redColor];
        }
        else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
        
        if (toDoItem.completed) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    else {
        cell.textLabel.textColor = [UIColor blackColor];
    }
}




/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 
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
