//
//  AAToDoItem.m
//  ToDoList
//
//  Created by Alvar Aronija on 29/01/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

#import "AAToDoItem.h"

@implementation AAToDoItem

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.itemName forKey:@"itemName"];
    [aCoder encodeBool:self.completed forKey:@"completed"];
    [aCoder encodeBool:self.isImportant forKey:@"isImportant"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    
    if(self) {
        self.itemName = [aDecoder decodeObjectForKey:@"itemName"];
        self.completed = [aDecoder decodeBoolForKey:@"completed"];
        self.isImportant = [aDecoder decodeBoolForKey:@"isImportant"];
        
    
    }
    return self;
}

@end
