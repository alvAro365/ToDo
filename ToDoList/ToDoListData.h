//
//  ToDoListData.h
//  ToDoList
//
//  Created by Alvar Aronija on 01/02/2018.
//  Copyright © 2018 Alvar Aronija. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoListData : NSObject


@property (nonatomic) NSMutableArray *toDoList;
@property (nonatomic) NSMutableArray *doneList;


-(instancetype)init;
-(void)saveData;
-(NSMutableArray*)getToDoList;
-(NSMutableArray*)getDoneList;

@end
