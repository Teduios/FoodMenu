//
//  UILabel+TRLabel.h
//  TRWeatherForcast
//
//  Created by tarena on 15/11/18.
//  Copyright © 2015年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (TRLabel)
//给定CGRect, 返回一个已经创建好的UILabel
+ (UILabel *)labelWithFrame:(CGRect)frame andCenter:(CGPoint)center;

@end
