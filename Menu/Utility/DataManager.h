//
//  DataManager.h
//  Menu
//
//  Created by 陈龙 on 16/4/9.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GroupsModel.h"

@interface DataManager : NSObject
+ (void)getBreakfirstList:(void(^)(NSArray<MenuResultDataModel *> *breakfirstList, NSError *error))completionHandler;

+ (void)getLunchList:(void (^)(NSArray<MenuResultDataModel *> *lunchList, NSError *error))completionHandler;

+ (void)getAfternoonTeaList:(void (^)(NSArray<MenuResultDataModel *> *afternoonTeaList, NSError *error))completionHandler;

+ (void)getDinnerList:(void (^)(NSArray<MenuResultDataModel *> *dinnerList, NSError *error))completionHandler;

+ (void)getSnackList:(void (^)(NSArray<MenuResultDataModel *> *snackList, NSError *error))completionHandler;

+ (void)getZheCai:(void (^)(NSArray<MenuResultDataModel *> *ZheCai, NSError *error))completionHandler;

+ (NSArray *)getFoodIndex;

+ (void)getFoodGoups:(void(^)(NSArray<GroupsModel *> *groups, NSError *error))completionHandler;

+ (NSArray *)getRockData;
@end
