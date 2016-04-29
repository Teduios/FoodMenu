//
//  GoupsModel.h
//  Menu
//
//  Created by 陈龙 on 16/4/17.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GroupsListModel;
@interface GroupsModel : NSObject

@property (nonatomic, copy) NSString *name;
//parentId
@property (nonatomic, copy) NSString *parentID;

@property (nonatomic, strong) NSArray<GroupsListModel *> *list;

@end
@interface GroupsListModel : NSObject
//id
@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *parentId;

@property (nonatomic, copy) NSString *name;

@end

