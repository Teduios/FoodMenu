//
//  RandowManagar.h
//  Menu
//
//  Created by tarena033 on 16/4/9.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RandowManagar : NSObject
//随机场景下标
+(NSArray *)randowWithRangeArray:(NSArray *)array count:(NSInteger)count;

//随机页数下标
+(NSString *)stringFromRandow:(NSInteger)count;
//随机菜系中的一个下标
+(NSInteger)cidFromRandow;
@end
