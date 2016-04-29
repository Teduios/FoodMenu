//
//  GoupsModel.m
//  Menu
//
//  Created by 陈龙 on 16/4/17.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "GroupsModel.h"

@implementation GroupsModel 

+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"list":[GroupsListModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"parentID":@"parentId"};
}

@end


@implementation GroupsListModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"ID":@"id"};
}

@end


