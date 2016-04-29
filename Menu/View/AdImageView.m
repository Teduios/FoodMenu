//
//  AdImageView.m
//  音乐播放器滚动界面
//
//  Created by zx on 16/2/28.
//  Copyright © 2016年 zx. All rights reserved.
//

#import "AdImageView.h"

@implementation AdImageView


-(void)addTapListenter:(TAP_IMAGE_BLOCK)tapImage {
    self.tapImage_block = tapImage;
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self addGestureRecognizer:tap];
}

-(void)tapGestureRecognizer:(UITapGestureRecognizer*)sender {
    self.tapImage_block(self);
}

@end
