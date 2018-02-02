//
//  AAToDoItem.h
//  ToDoList
//
//  Created by Alvar Aronija on 29/01/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AAToDoItem : NSObject <NSCoding>

@property NSString *itemName;
@property BOOL completed;
@property BOOL isImportant;

@end
