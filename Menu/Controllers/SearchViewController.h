//
//  SearchViewController.h
//  Menu
//
//  Created by 陈龙 on 16/4/17.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController
//接收传过来的对象
@property (nonatomic, strong)GroupsListModel *searchFood;
//搜索文本框
@property (weak, nonatomic) IBOutlet UITextField *searchField;
@end
