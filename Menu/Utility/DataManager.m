//
//  DataManager.m
//  Menu
//
//  Created by 陈龙 on 16/4/9.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
+ (NSArray *)getArrFromPlist:(NSString *)plistName{
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]];
}

+ (void)getBreakfirstList:(void (^)(NSArray<MenuResultDataModel *> *, NSError *))completionHandler
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *tmpArr = [MenuResultDataModel parseJSON:[self getArrFromPlist:@"BreakfirstList"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(tmpArr, nil);
        });
    });
}

+ (void)getLunchList:(void (^)(NSArray<MenuResultDataModel *> *, NSError *))completionHandler
{
    WK(weakSelf)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *tmpArr = [MenuResultDataModel parseJSON:[weakSelf getArrFromPlist:@"LunchList"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(tmpArr, nil);
        });
    });
}

+ (void)getAfternoonTeaList:(void (^)(NSArray<MenuResultDataModel *> *, NSError *))completionHandler
{
    WK(weakSelf)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *tmpArr = [MenuResultDataModel parseJSON:[weakSelf getArrFromPlist:@"AfternoonTeaList"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(tmpArr, nil);
        });
    });
}

+ (void)getDinnerList:(void (^)(NSArray<MenuResultDataModel *> *, NSError *))completionHandler
{
    WK(weakSelf)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *tmpArr = [MenuResultDataModel parseJSON:[weakSelf getArrFromPlist:@"DinnerList"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(tmpArr, nil);
        });
    });
}

+ (void)getSnackList:(void (^)(NSArray<MenuResultDataModel *> *, NSError *))completionHandler
{
    WK(weakSelf)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *tmpArr = [MenuResultDataModel parseJSON:[weakSelf getArrFromPlist:@"SnackList"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(tmpArr, nil);
        });
    });
}

+ (void)getZheCai:(void (^)(NSArray<MenuResultDataModel *> *, NSError *))completionHandler
{
    WK(weakSelf)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *tmpArr = [MenuResultDataModel parseJSON:[weakSelf getArrFromPlist:@"ZheCai"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(tmpArr, nil);
        });
    });
}

+ (NSArray *)getFoodIndex
{
    return @[@1,@2,@3];
}

+(void)getFoodGoups:(void (^)(NSArray<GroupsModel *> *, NSError *))completionHandler
{
    WK(weakSelf)
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *tmpArr = [GroupsModel parseJSON:[weakSelf getArrFromPlist:@"FoodGoups"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(tmpArr, nil);
        });
    });
}

+ (NSArray *)getRockData
{
    return @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@101,@102,@104,@105,@107,@108,@109,@110,@111,@112,@113,@114,@115,@116,@117,@118,@119,@123,@124,@125,@126,@127];
}




@end
