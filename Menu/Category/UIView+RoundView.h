//
//  UIView+RoundView.h
//  Menu
//
//  Created by CL on 16/4/17.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RoundView)
- (void)setRoundLayer:(CGFloat)cornerRadius bounds:(BOOL)bounds borderWidth:(CGFloat)width borderColor:(UIColor *)color;
@end
