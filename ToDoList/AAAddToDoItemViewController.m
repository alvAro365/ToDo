//
//  XYZAddToDoItemViewController.m
//  ToDoList
//
//  Created by Alvar Aronija on 12/01/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

#import "AAAddToDoItemViewController.h"


@interface AAAddToDoItemViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation AAAddToDoItemViewController

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if(sender != self.doneButton) return;
    if (self.textField.text.length > 0) {
        self.toDoItem = [[AAToDoItem alloc] init];
        self.toDoItem.itemName = self.textField.text;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
