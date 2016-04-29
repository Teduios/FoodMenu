//
//  SetViewController.m
//  Menu
//
//  Created by 陈龙 on 16/4/20.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "SetViewController.h"
#define kUserIcon [kCachesPath stringByAppendingPathComponent:@"userIcon.data"]

@interface SetViewController ()<UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
- (IBAction)backClickBtn:(id)sender;

- (IBAction)iocnBtn:(id)sender;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewTopConstraint;

- (IBAction)replaceBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *replaceBtn;
@property (weak, nonatomic) IBOutlet UITextField *nickField;
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewBottomConstraint;

@end

@implementation SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.nickField.text = self.nickName;
    [self.iconBtn setBackgroundImage:self.iconImage forState:UIControlStateNormal];
    [self.iconBtn setRoundLayer:40 bounds:YES borderWidth:5 borderColor:[UIColor darkGrayColor]];
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //取消键盘通知监听
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //添加键盘通知监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)openKeyboard:(NSNotification *)notification
{
     WK(weakSelf)
    //按照键盘的高度修改输入框底部的约束的constant
    NSInteger option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.inputViewBottomConstraint.constant =  180 - keyboardFrame.size.height ;
    self.inputViewTopConstraint.constant = keyboardFrame.size.height - 146;

    
    
    [UIView animateWithDuration:duration delay: duration / keyboardFrame.size.height * 110 options:option animations:^{
        [weakSelf.view layoutIfNeeded];
 
    } completion:nil];
    
}
-(void)closeKeyboard:(NSNotification *)notification
{
     WK(weakSelf)
    //修改输入框底部的约束的constant为0
    //按照键盘的高度修改输入框底部的约束的constant
    NSInteger option = [notification.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    self.inputViewBottomConstraint.constant = 0;
    self.inputViewTopConstraint.constant =  146 ;
    
    [UIView animateWithDuration:duration delay:0 options:option animations:^{
        [weakSelf.view layoutIfNeeded];

    } completion:nil];
}



- (IBAction)gotoReplaceBtn:(id)sender {
    [self.nickField resignFirstResponder];
}

- (IBAction)backClickBtn:(id)sender {
    [self.nickField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)iocnBtn:(id)sender {
    [self.nickField resignFirstResponder];
    WK(weakSelf)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请选择" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *actionPhoto = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
       [weakSelf chooseHeadImage:(UIImagePickerControllerSourceTypePhotoLibrary)];
    }];
    UIAlertAction *actionCarema = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf chooseHeadImage:(UIImagePickerControllerSourceTypeCamera)];
    }];
    UIAlertAction *actionCancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
 
    [alert addAction:actionCancel];
    [alert addAction:actionCarema];
    [alert addAction:actionPhoto];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)chooseHeadImage:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    //允许编辑图片
    imagePicker.allowsEditing = YES;
    //类型 是 相机  或  相册
    imagePicker.sourceType = type;
    //设置代理
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

/** 选择图片的处理 */
- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    // 取得编辑过的图片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    //    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.iconBtn setBackgroundImage:image forState:UIControlStateNormal];
    [self dismissViewControllerAnimated:YES completion:nil];
     [self.iconBtn setRoundLayer:40 bounds:YES borderWidth:5 borderColor:[UIColor darkGrayColor]];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)replaceBtn:(id)sender {
    [self.nickField resignFirstResponder];
    WK(weakSelf)
    self.dataBlock(self.nickField.text, [self.iconBtn backgroundImageForState:UIControlStateNormal]);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *dataImage = UIImagePNGRepresentation([weakSelf.iconBtn backgroundImageForState:UIControlStateNormal]);
        [dataImage writeToFile:kUserIcon atomically:YES];
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[NSUserDefaults standardUserDefaults] setObject:weakSelf.nickField.text forKey:@"userNick"];
    });
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
