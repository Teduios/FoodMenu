//
//  RockViewController.m
//  Menu
//
//  Created by tarena033 on 16/4/20.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "RockViewController.h"
#import "RockCell.h"
#import "StepsViewController.h"

@interface RockViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *rockImage;

- (IBAction)backClickBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, strong)NSArray *resultArray;
@end

@implementation RockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setApplicationSupportsShakeToEdit:YES];
    [self becomeFirstResponder];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    self.tableView.hidden = YES;
    self.titleLabel.hidden = YES;
    WK(weakSelf)
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.rockImage.transform = CGAffineTransformMakeRotation(M_PI * 1 / 6);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            weakSelf.rockImage.transform = CGAffineTransformMakeRotation(0);
        } completion:nil];
    }];
    [TRNetworkManager sendGetCidWithCid:[RandowManagar cidFromRandow] pn:[NSString stringWithFormat:@"%u", arc4random() % 120] rn:@"10" success:^(MenuModel *responseObject) {
        weakSelf.resultArray = responseObject.result.data;
        if (weakSelf.resultArray) {
            weakSelf.tableView.hidden = NO;
            [weakSelf.tableView reloadData];
        }
        else
        {
            weakSelf.titleLabel.hidden = NO;
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

#pragma mark - UITableViewDataSource/Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.resultArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RockCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RockCell" forIndexPath:indexPath];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    MenuResultDataModel *data = self.resultArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:data.albums[0]] placeholderImage:[UIImage imageNamed:@"正在加载"]];
    cell.titleLabel.text = data.title;
    cell.tagLabel.text = data.tags;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"goStepsVC" sender:indexPath];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath *)sender
{
    UIViewController *vc = segue.destinationViewController;
    if ([vc isKindOfClass:[StepsViewController class]]) {
        StepsViewController *stepsVC = (StepsViewController *)vc;
        stepsVC.stepData = self.resultArray[sender.row];
    }
    
}

- (IBAction)backClickBtn:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
