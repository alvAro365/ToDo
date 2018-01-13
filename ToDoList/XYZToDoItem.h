//
//  XYZToDoItem.h
//  ToDoList
//
//  Created by Alvar Aronija on 13/01/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XYZToDoItem : NSObject

@property NSString *itemName;
@property BOOL completed;
@property (readonly) NSDate *creationDate;


@end
