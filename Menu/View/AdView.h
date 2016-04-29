//
//  AdView.h
//  Demo8
//
//  Created by tarena on 16/2/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AdView;

@protocol AdViewDelegate <NSObject>
@required
-(void)AdView:(AdView*)adview didSelectorAtIndex:(NSInteger)index;
@end

@interface AdView : UIView

@property(nonatomic,weak)id<AdViewDelegate> delegate;
//不确定有多少个图片 也不确定图片的名字
//不确定每个图片或者说 每个广告的标题或标语不确定
//不确定 在不同的应用的 尺寸

//这些不确定的东西，可以在创建该视图对象时的初始化方法中通过 传入的参数确定
-(id)initWithFrame:(CGRect)frame imageNames:(NSArray*)imageNames titles:(NSArray*)titles;


@end






