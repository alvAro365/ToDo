//
//  ToDoListData.m
//  ToDoList
//
//  Created by Alvar Aronija on 01/02/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

#import "ToDoListData.h"
#import "AAToDoItem.h"

@interface ToDoListData()

@property (nonatomic) NSUserDefaults *savedToDoList;

@end

@implementation ToDoListData

-(instancetype)init {
    self = [super init];
    if(self) {
        self.toDoList = [[NSMutableArray alloc] init];
        self.doneList = [[NSMutableArray alloc] init];
        self.savedToDoList = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

-(void)saveData {
    
    NSData *dataToDoList = [NSKeyedArchiver archivedDataWithRootObject:self.toDoList];
    NSData *dataDoneList = [NSKeyedArchiver archivedDataWithRootObject:self.doneList];
    [self.savedToDoList setObject:dataToDoList forKey:@"toDoList"];
    [self.savedToDoList setObject:dataDoneList forKey:@"doneList"];
}

-(NSMutableArray*)getToDoList {
    NSData *dataToDoList = [self.savedToDoList objectForKey:@"toDoList"];
    NSArray *toDoListArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataToDoList];
    if(toDoListArray) {
        self.toDoList = toDoListArray.mutableCopy;
    }
    return self.toDoList;
}

-(NSMutableArray*)getDoneList {
    NSData *dataDoneList = [self.savedToDoList objectForKey:@"doneList"];
    NSArray *doneListArray = [NSKeyedUnarchiver unarchiveObjectWithData:dataDoneList];
    if (doneListArray) {
        self.doneList = doneListArray.mutableCopy;
    }
    return self.doneList;
}


@end
