//
//  TimeManager.m
//  Menu
//
//  Created by 陈龙 on 16/4/9.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "TimeManager.h"

@implementation TimeManager

+(NSInteger)cidAboutTime
{
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH";
    NSInteger hourNow = [[formatter stringFromDate:date] integerValue];
    
    if (hourNow >= 4 && hourNow < 9) {
        return 37;
    }
    else if(hourNow >= 9 && hourNow < 13)
    {
        return 38;
    }
    else if(hourNow >= 13 && hourNow < 16)
    {
        return 39;
    }
    else if(hourNow >= 16 && hourNow < 20)
    {
        return 40;
    }
    else
    {
        return 61;
    }
}

+(NSString *)stringAboutTime
{
    switch ([self cidAboutTime])
    {
        case 37:
            return @"美   好   的   一   天   从   早   餐   开   始";
        case 38:
            return @"吃   饱   午   餐   才   有   力   气   干   活";
        case 39:
            return @"喝   杯   下   午   茶   放   松   一   下   吧";
        case 40:
            return @"跟   家   人   一   起   共   进   晚   餐   吧";
        default:
            return @"少   吃   点   夜   宵   早   点   休   息   吧";
    }
}

+(NSString *)foodAboutTime
{
    switch ([self cidAboutTime])
    {
        case 37:
            return @"早餐";
        case 38:
            return @"午餐";
        case 39:
            return @"下午茶";
        case 40:
            return @"晚餐";
        default:
            return @"夜宵";
    }
}

+(NSInteger)dayAboutTime
{
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd";
    NSInteger dayNow = [[formatter stringFromDate:date] integerValue];
    return dayNow;
}

+(NSInteger)hourAboutTime
{
    NSDate *date =[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH";
    NSInteger hourNow = [[formatter stringFromDate:date] integerValue];
    return hourNow;
}

@end
