//
//  RandowManagar.m
//  Menu
//
//  Created by tarena033 on 16/4/9.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "RandowManagar.h"

@implementation RandowManagar
+(NSArray *)randowWithRangeArray:(NSArray *)array count:(NSInteger)count
{
    NSMutableArray *rangeArray = [array mutableCopy];
    NSMutableArray *resultArray = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        int t = arc4random() % rangeArray.count;
        resultArray[i] = rangeArray[t];
        [rangeArray removeObjectAtIndex:t];
        if (rangeArray.count == 0) {
            break;
        }
    }
    return [resultArray copy];
}

+(NSString *)stringFromRandow:(NSInteger)count
{
    return [NSString stringWithFormat:@"%ld", arc4random() % (count + 1)] ;
}

+(NSInteger)cidFromRandow
{
    NSArray *array = [DataManager getRockData];
    NSInteger index = arc4random() % array.count;
    return [array[index] integerValue];
}


@end
