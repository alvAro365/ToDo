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
     //   [self.doneItems addObject:item];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.toDoItems];
        [self.savedToDos setObject:data forKey:@"toDoItems"];
        [self.tableView reloadData];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
 //   self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.toDoItems = [[NSMutableArray alloc] init];
    self.doneItems = [[NSMutableArray alloc] init];
    self.savedToDos = [NSUserDefaults standardUserDefaults];
    
    
    
    
    NSData *itemsData = [self.savedToDos objectForKey:@"toDoItems"];
    NSArray *items = [NSKeyedUnarchiver unarchiveObjectWithData:itemsData];
    
    if(items) {
        self.toDoItems = items.mutableCopy;
    

    }
    
    self.sections = @{@"To-Do" : self.toDoItems,
                      @"Done"  : self.doneItems
                      };
    
    self.sectionTitels = [self.sections allKeys];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return [self.sectionTitels count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSString *sectionTitle = [self.sectionTitels objectAtIndex:section];
    NSArray *sectionToDos = [self.sections objectForKey:sectionTitle];
    
#warning Incomplete implementation, return the number of rows
    return [sectionToDos count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ToDoItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    if(indexPath.section == 0) {
        AAToDoItem *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
        cell.textLabel.text = toDoItem.itemName;

        //TODO: get boolean value form NSUserdefaults
        if (toDoItem.completed) {
            NSLog(@"TodoSection: %ld", (long)indexPath.section);
            
            [self.doneItems addObject:toDoItem];
            [self.toDoItems removeObjectAtIndex:indexPath.row];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
            
        } else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    if(indexPath.section == 1) {
        
        if (self.doneItems) {
            AAToDoItem *doneItem = [self.doneItems objectAtIndex:indexPath.row];
            
            if (doneItem.completed) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            
            cell.textLabel.text = doneItem.itemName;
            NSLog(@"Done item: %d", doneItem.completed);
            
            if(!doneItem.completed) {
                NSLog(@"Done item 2: %d", doneItem.completed);
                cell.accessoryType = UITableViewCellAccessoryNone;
                [self.toDoItems addObject:doneItem];
                [self.doneItems removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView reloadData];
            }
        }

    }
    
    
    

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    
    if(indexPath.section == 0) {
        AAToDoItem *tappedItem = [self.toDoItems objectAtIndex:indexPath.row];
        tappedItem.completed = !tappedItem.completed;
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }else {
        AAToDoItem *tappedItem = [self.doneItems objectAtIndex:indexPath.row];
        NSLog(@"Section: %ld", (long)indexPath.section);
        tappedItem.completed = !tappedItem.completed;
        
        NSLog(@"Tapped item: %d",tappedItem.completed);
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //if row is deleted remove it from the list
    
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        
        if(indexPath.section == 0) {
            [self.toDoItems removeObjectAtIndex:indexPath.row];
            //updates the view
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self.doneItems removeObjectAtIndex:indexPath.row];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            
        }

    }
    
    //TODO: fixa save new array to NSUserDefaults
    
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [self.sectionTitels objectAtIndex:section];
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return [self.sectionTitels indexOfObject:title];
}


// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
    if(fromIndexPath != toIndexPath) {
        
        
        
    
        
    
    }
    
}



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
