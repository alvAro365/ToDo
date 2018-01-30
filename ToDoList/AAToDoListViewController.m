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



@end

@implementation AAToDoListViewController

- (IBAction)unWindToList:(UIStoryboardSegue *)segue {
    
    AAAddToDoItemViewController *source = [segue sourceViewController];
    
    AAToDoItem *item = source.toDoItem;
    
    if (item != nil) {
        [self.toDoItems addObject:item];
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.toDoItems];
        [self.savedToDos setObject:data forKey:@"toDoItems"];
        [self.tableView reloadData];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.toDoItems = [[NSMutableArray alloc] init];
    self.savedToDos = [NSUserDefaults standardUserDefaults];
    
    
    NSData *itemsData = [self.savedToDos objectForKey:@"toDoItems"];
    NSArray *items = [NSKeyedUnarchiver unarchiveObjectWithData:itemsData];
    
    if(items) {
        self.toDoItems = items.mutableCopy;
    

    }
    
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [self.toDoItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ToDoItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    AAToDoItem *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];
    cell.textLabel.text = toDoItem.itemName;

    //TODO: get boolean value form NSUserdefaults
    if (toDoItem.completed) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    AAToDoItem *tappedItem = [self.toDoItems objectAtIndex:indexPath.row];
    
    tappedItem.completed = !tappedItem.completed;
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //if row is deleted remove it from the list
    
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.toDoItems removeObjectAtIndex:indexPath.row];
        //updates the view
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    
    //TODO: fixa save new array to NSUserDefaults
    
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
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
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
