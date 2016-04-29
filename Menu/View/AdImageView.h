//
//  AdImageView.h
//  音乐播放器滚动界面
//
//  Created by zx on 16/2/28.
//  Copyright © 2016年 zx. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^TAP_IMAGE_BLOCK)();
@interface AdImageView : UIImageView
@property(nonatomic,copy)TAP_IMAGE_BLOCK tapImage_block;
//添加监听
-(void)addTapListenter:(TAP_IMAGE_BLOCK)tapImage;
@end
