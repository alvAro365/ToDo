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
NSString *const TO_DO_LIST = @"toDoList";
NSString *const DONE_LIST = @"doneList";

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
    [self savingData:self.toDoList with:TO_DO_LIST];
    [self savingData:self.doneList with:DONE_LIST];
}

-(NSMutableArray*)getToDoList {
    [self setDataList:self.savedToDoList with:TO_DO_LIST];
    return self.toDoList;
}

-(NSMutableArray*)getDoneList {
    [self setDataList:self.savedToDoList with:DONE_LIST];
    return self.doneList;
}

- (void)setDataList:(NSUserDefaults*)savedData with:(NSString*)theKey {
    
    NSData *dataToDoList= [savedData objectForKey:theKey];
    NSArray *itemsData = [NSKeyedUnarchiver unarchiveObjectWithData:dataToDoList];
    if (itemsData && [theKey isEqualToString:TO_DO_LIST]) {
        self.toDoList = itemsData.mutableCopy;
    }
    else if(itemsData && [theKey isEqualToString:DONE_LIST]) {
        self.doneList = itemsData.mutableCopy;
    }
}

- (void)savingData:(NSMutableArray*)theData with:(NSString*)theKey {
    NSData *dataList = [NSKeyedArchiver archivedDataWithRootObject:theData];
    [self.savedToDoList setObject:dataList forKey:theKey];
    
}


@end
