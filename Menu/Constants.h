//
//  Constants.h
//  Menu
//
//  Created by tarena033 on 16/4/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

/** 屏幕宽 */
#define kScreenW [UIScreen mainScreen].bounds.size.width
/** Caches路径 */
#define kCachesPath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0]

#define kRGBColor(R,G,B,Alpha) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:Alpha]

#define kHeaderViewPath [kCachesPath stringByAppendingPathComponent:@"head.data"]

#define kKey @"e8920440822b2553112473e273b061d0"

#define kGuessPath [kCachesPath stringByAppendingPathComponent:@"Guess.data"]

#define WK(weakSelf) \
__weak __typeof(&*self)weakSelf = self;

#endif /* Constants_h */
