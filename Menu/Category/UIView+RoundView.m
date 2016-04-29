//
//  UIView+RoundView.m
//  Menu
//
//  Created by CL on 16/4/17.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "UIView+RoundView.h"

@implementation UIView (RoundView)
- (void)setRoundLayer:(CGFloat)radius bounds:(BOOL)bounds borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}
@end
