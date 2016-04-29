//
//  TimeManager.h
//  Menu
//
//  Created by 陈龙 on 16/4/9.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeManager : NSObject
//提供当前用餐时间
+(NSInteger)cidAboutTime;
//提供当前用餐时间话语
+(NSString *)stringAboutTime;
//提供当前日期
+(NSInteger)dayAboutTime;
//提供当前餐时
+(NSString *)foodAboutTime;
//提供当前小时
+(NSInteger)hourAboutTime;
@end
