//
//  SetViewController.h
//  Menu
//
//  Created by 陈龙 on 16/4/20.
//  Copyright © 2016年 tarena. All rights reserved.
//

typedef void(^MyBlock)(NSString *, UIImage *);

#import <UIKit/UIKit.h>

@interface SetViewController : UIViewController
@property (nonatomic, copy)MyBlock dataBlock;
@property (nonatomic, copy)NSString *nickName;
@property (nonatomic, strong)UIImage *iconImage;
@end
