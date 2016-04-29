//
//  CommendCell.h
//  Menu
//
//  Created by tarena033 on 16/4/14.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommendCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *guessImageView;
@property (weak, nonatomic) IBOutlet UIButton *leftCommendBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightCommendBtn;
@property (weak, nonatomic) IBOutlet UILabel *leftCommendLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightCommendLabel;
@property (weak, nonatomic) IBOutlet UILabel *guessLabel;

@end
