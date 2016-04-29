//
//  MineViewController.m
//  Menu
//
//  Created by 陈龙 on 16/4/19.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "MineViewController.h"
#import "UIView+HUD.h"
#import "SetViewController.h"
#define kUserIcon [kCachesPath stringByAppendingPathComponent:@"userIcon.data"]

@interface MineViewController ()

@property (weak, nonatomic) IBOutlet UIButton *icon;
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
@property (weak, nonatomic) IBOutlet UIButton *sharkBtn;
@property (weak, nonatomic) IBOutlet UIButton *cleanBtn;
- (IBAction)cleanBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *nickLable;

- (IBAction)setClickBtn:(id)sender;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackOpaque];
    if ([[NSFileManager defaultManager] fileExistsAtPath:kUserIcon]) {
        [self.icon setBackgroundImage:[[UIImage alloc]initWithData:[NSData dataWithContentsOfFile:kUserIcon]] forState:(UIControlStateNormal)];
    }
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userNick"]) {
        self.nickLable.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userNick"];
    }
    
    
    [self.icon setRoundLayer:40 bounds:YES borderWidth:5 borderColor:[UIColor darkGrayColor]];
    [self.collectBtn setRoundLayer:5 bounds:YES borderWidth:1 borderColor:[UIColor darkGrayColor]];
    [self.setBtn setRoundLayer:5 bounds:YES borderWidth:1 borderColor:[UIColor darkGrayColor]];
    [self.sharkBtn setRoundLayer:5 bounds:YES borderWidth:1 borderColor:[UIColor darkGrayColor]];
    [self.cleanBtn setRoundLayer:5 bounds:YES borderWidth:1 borderColor:[UIColor darkGrayColor]];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (IBAction)cleanBtn:(id)sender {
    WK(weakSelf)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否要清除缓存" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionClean = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

        [[[SDWebImageManager sharedManager]imageCache] clearDisk];
        [weakSelf.view showWarning:@"清理成功"];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];

    [alert addAction:actionClean];
    [alert addAction:actionCancel];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}
- (IBAction)setClickBtn:(id)sender {

    SetViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"SetViewController"];
    svc.nickName = self.nickLable.text;
    svc.iconImage = [self.icon backgroundImageForState:UIControlStateNormal];

        WK(weakSelf)
        svc.dataBlock = ^(NSString *nickName, UIImage *iconImage){
        [weakSelf.icon setBackgroundImage:iconImage forState:UIControlStateNormal];
            weakSelf.nickLable.text = nickName;
            [weakSelf.icon setRoundLayer:40 bounds:YES borderWidth:5 borderColor:[UIColor darkGrayColor]];

        };
 
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:svc];

    [self presentViewController:navc animated:YES completion:nil];
}
@end
