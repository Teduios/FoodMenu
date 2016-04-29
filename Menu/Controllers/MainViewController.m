//
//  MainViewController.m
//  FoodMenu
//
//  Created by tarena033 on 16/4/6.
//  Copyright © 2016年 cl. All rights reserved.
//

#import "MainViewController.h"
#import "MenuModel.h"
#import "AdView.h"
#import "UIButton+WebCache.h"
#import "StepsViewController.h"
#import "CommendCell.h"
#import "CommendHeadCell.h"
#import "GuessHeadCell.h"
#import "UIScrollView+Refresh.h"
#import "UIView+HUD.h"

#define kCommendPath [kCachesPath stringByAppendingPathComponent:@"Commend.data"]


typedef enum
{
    HEAD, COMMEND, GUESS,
}GotoType;

typedef void(^COMMENDBLOCK)(NSIndexPath *indexPath);

@interface MainViewController ()<UITableViewDataSource, UITableViewDelegate,AdViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *naviView;

@property (nonatomic, strong)NSArray *headerArray;

@property (nonatomic, strong)NSArray *commendArray;

@property (nonatomic, strong)NSArray *guessArray;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;




@end

@implementation MainViewController


-(void)AdView:(AdView *)adview didSelectorAtIndex:(NSInteger)index {

    [self performSegueWithIdentifier:@"gotoStepsVC" sender:@[@(index),@(HEAD)]];
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSArray *)sender {
    UIViewController *vc = segue.destinationViewController;
    if ([vc isKindOfClass:[StepsViewController class]]) {
        MenuResultDataModel *data = nil;
        switch ([sender[1] integerValue]) {
            case HEAD:
      
                data = self.headerArray[(NSInteger)[sender[0] integerValue]];
                break;
            case COMMEND:
    
                data = self.commendArray[(NSInteger)[sender[0] integerValue]];
                break;
            case GUESS:
  
                data = self.guessArray[(NSInteger)[sender[0] integerValue]];
                break;
                
            default:
                return;
        }
        StepsViewController *stepsVC = (StepsViewController *)vc;
        stepsVC.stepData = data;
    }

}

-(void)gotoStepsVC:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"gotoStepsVC" sender:@[@(sender.tag),@(COMMEND)]];
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    else
    {
        if (indexPath.row == 0) {
            return;
        }
        else
        {
            [self performSegueWithIdentifier:@"gotoStepsVC" sender:@[@(indexPath.row - 1),@(GUESS)]];
        }
    }
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    WK(weakSelf)
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView addHeaderRefresh:^{
        [weakSelf creatAllView];
         [weakSelf.tableView endHeaderRefresh];
            [weakSelf.view hideBusyHUD];
    }];
    [self.tableView beginHeaderRefresh];
    [self.view showBusyHUD];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)creatAllView
{
    //创建头部视图
    [self creatHeaderView];
    
    //创建推荐视图
    [self creatCommendTableView];
    
    [self creatGuessTableView];
    
}

#pragma mark - 创建表头视图
//创建表头视图
-(void)creatHeaderView
{
    self.headerArray = [NSKeyedUnarchiver unarchiveObjectWithFile:kHeaderViewPath];
    if (self.headerArray.count != 0) {
        NSMutableArray *urlStr = [NSMutableArray array];
        NSMutableArray *allTitle = [NSMutableArray array];
        for (MenuResultDataModel *data in self.headerArray) {
            [urlStr addObject:data.albums[0]];
            [allTitle addObject:data.title];
        }
        
        AdView *adview = [[AdView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200) imageNames:urlStr titles:allTitle];
        adview.delegate = self;
        self.tableView.tableHeaderView = adview;
    }
    else
    {
        [self getNetworkAboutHeadView];
    }
}
-(void)getNetworkAboutHeadView
{
    WK(weakSelf)
    [TRNetworkManager sendGetCidWithCid:6 pn:[RandowManagar stringFromRandow:145] rn:@"5" success:^(MenuModel *responseObject){
        if (responseObject.result.data.count < 5) {
            
        [DataManager getAfternoonTeaList:^(NSArray<MenuResultDataModel *> *afternoonTeaList, NSError *error) {
                [weakSelf loadHeaderView:[RandowManagar randowWithRangeArray:afternoonTeaList count:5]];
            }];
        }
        else
        {
            [weakSelf loadHeaderView:responseObject.result.data];
        }
    }
    failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}

//加载表头视图
-(void)loadHeaderView:(NSArray<MenuResultDataModel *> *)array
{
    self.headerArray = array;

    NSMutableArray *urlStr = [NSMutableArray array];
    NSMutableArray *allTitle = [NSMutableArray array];
    for (MenuResultDataModel *data in self.headerArray) {
        [urlStr addObject:data.albums[0]];
        [allTitle addObject:data.title];
    }
    
    AdView *adview = [[AdView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 200) imageNames:urlStr titles:allTitle];
    adview.delegate = self;
    self.tableView.tableHeaderView = adview;
    [NSKeyedArchiver archiveRootObject:self.headerArray toFile:kHeaderViewPath];
}

#pragma mark - 获取猜你喜欢的数据

-(void)creatCommendTableView
{
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"time"] != [TimeManager cidAboutTime]) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [[NSUserDefaults standardUserDefaults] setInteger:[TimeManager cidAboutTime] forKey:@"time"];
        });
        [self getNetworkAboutCommendTableView];
    }
    else
    {
        self.commendArray = [NSKeyedUnarchiver unarchiveObjectWithFile:kCommendPath];
        [self.tableView reloadData];
        if (self.commendArray == nil) {
            [self getNetworkAboutCommendTableView];
        }
    }
}
//网上获取
-(void)getNetworkAboutCommendTableView
{
    WK(weakSelf)
    [TRNetworkManager sendGetCidWithCid:[TimeManager cidAboutTime] pn:[RandowManagar stringFromRandow:120] rn:@"30" success:^(MenuModel *responseObject){
        if (responseObject.result.data.count < 10 ) {
            
            [weakSelf loadCommendPlistData];
            
        }
        else
        {

            weakSelf.commendArray = [RandowManagar randowWithRangeArray:responseObject.result.data count:10];

            [weakSelf.tableView reloadData];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [NSKeyedArchiver archiveRootObject:weakSelf.commendArray toFile:kCommendPath];
            });
            
        }
    }
    failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
}
//获取本地数据
-(void)loadCommendPlistData
{
    WK(weakSelf)
    if ([TimeManager cidAboutTime] == 37) {
        [DataManager getBreakfirstList:^(NSArray<MenuResultDataModel *> *breakfirstList, NSError *error) {
            weakSelf.commendArray = [RandowManagar randowWithRangeArray:breakfirstList count:10];
            
            [weakSelf.tableView reloadData];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [NSKeyedArchiver archiveRootObject:weakSelf.commendArray toFile:kCommendPath];
            });
            
        }];
    }
    else if([TimeManager cidAboutTime] == 38)
    {
        [DataManager getLunchList:^(NSArray<MenuResultDataModel *> *lunchList, NSError *error) {
            weakSelf.commendArray = [RandowManagar randowWithRangeArray:lunchList count:10];
            [weakSelf.tableView reloadData];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [NSKeyedArchiver archiveRootObject:weakSelf.commendArray toFile:kCommendPath];
            });
        }];
    }
    else if([TimeManager cidAboutTime] == 39)
    {
        [DataManager getAfternoonTeaList:^(NSArray<MenuResultDataModel *> *afternoonTeaList, NSError *error) {
            weakSelf.commendArray = [RandowManagar randowWithRangeArray:afternoonTeaList count:10];
            [weakSelf.tableView reloadData];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [NSKeyedArchiver archiveRootObject:weakSelf.commendArray toFile:kCommendPath];
            });
        }];
    }
    else if([TimeManager cidAboutTime] == 40)
    {
        [DataManager getDinnerList:^(NSArray<MenuResultDataModel *> *dinnerList, NSError *error) {
            weakSelf.commendArray = [RandowManagar randowWithRangeArray:dinnerList count:10];
            [weakSelf.tableView reloadData];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [NSKeyedArchiver archiveRootObject:weakSelf.commendArray toFile:kCommendPath];
            });
        }];
    }
    else
    {
        [DataManager getSnackList:^(NSArray<MenuResultDataModel *> *snackList, NSError *error) {
            weakSelf.commendArray = [RandowManagar randowWithRangeArray:snackList count:10];
            [weakSelf.tableView reloadData];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [NSKeyedArchiver archiveRootObject:weakSelf.commendArray toFile:kCommendPath];
            });
        }];
    }
}

#pragma mark - 获取推荐视图的数据
-(void)creatGuessTableView
{
    self.guessArray = [NSKeyedUnarchiver unarchiveObjectWithFile:kGuessPath];
    if (self.guessArray.count != 0 ) {
        [self.tableView reloadData];
    }
    else
    {
        [self getNetworkAboutGuessTableView];
    }
}

-(void)getNetworkAboutGuessTableView
{
    WK(weakSelf)
    [TRNetworkManager sendGetCidWithCid:(arc4random() % 3 + 1) pn:[RandowManagar stringFromRandow:120] rn:@"30" success:^(MenuModel *responseObject){
        if (responseObject.result.data.count < 10) {
            [weakSelf loadGuessPlistData];
        }
        else
        {
            weakSelf.guessArray = [RandowManagar randowWithRangeArray:responseObject.result.data count:10];
            [weakSelf.tableView reloadData];
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                [NSKeyedArchiver archiveRootObject:weakSelf.guessArray toFile:kGuessPath];
            });
            
        }
    }
    failure:^(NSError *error) {
        NSLog(@"%@", error);
        }];

}

-(void)loadGuessPlistData
{
    WK(weakSelf)
    [DataManager getZheCai:^(NSArray<MenuResultDataModel *> *ZheCai, NSError *error) {
        weakSelf.guessArray = [RandowManagar randowWithRangeArray:ZheCai count:10];
        [weakSelf.tableView reloadData];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSKeyedArchiver archiveRootObject:weakSelf.guessArray toFile:kGuessPath];
        });
    }];
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return section == 0 ?  (self.commendArray.count + 1) / 2 + 1: self.guessArray.count + 1;
 
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            GuessHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GuessHeadCell" forIndexPath:indexPath];
            cell.foodLabel.text = [TimeManager stringAboutTime];
            [cell.foodLabel setRoundLayer:10 bounds:YES borderWidth:0 borderColor:0];
            cell.foodLabel.backgroundColor = kRGBColor(227, 59, 65, 0.8);
            cell.guessHeadLabel.text = [NSString stringWithFormat:@"%@",[TimeManager foodAboutTime]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
            
        }
        else
        {
            CommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommendCell" forIndexPath:indexPath];
            MenuResultDataModel *leftData = self.commendArray[(indexPath.row - 1) * 2];
            NSURL *url = [NSURL URLWithString:leftData.albums[0]];
            [cell.leftCommendBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
            [cell.leftCommendBtn setRoundLayer:5 bounds:YES borderWidth:1 borderColor:kRGBColor(227, 59, 65, 0.8)];
            
       
            [cell.leftCommendBtn addTarget:self action:@selector(gotoStepsVC:) forControlEvents:UIControlEventTouchUpInside];
            cell.leftCommendBtn.tag = (indexPath.row - 1) * 2;
            cell.leftCommendLabel.text = leftData.title;
            
            
            NSInteger indexRight = (indexPath.row - 1) * 2 + 1;
            if (indexRight == self.commendArray.count) {
                
            }
            else
            {
                MenuResultDataModel *rightData = self.commendArray[indexRight];
                NSURL *url = [NSURL URLWithString:rightData.albums[0]];
                [cell.rightCommendBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal];
                [cell.rightCommendBtn setRoundLayer:5 bounds:YES borderWidth:0 borderColor:0];
      
                
                cell.rightCommendLabel.text = rightData.title;
                
                cell.rightCommendBtn.layer.borderWidth = 1;
                cell.rightCommendBtn.layer.borderColor = kRGBColor(227, 59, 65, 0.8).CGColor;
                
                [cell.rightCommendBtn addTarget:self action:@selector(gotoStepsVC:) forControlEvents:UIControlEventTouchUpInside];
                cell.rightCommendBtn.tag = indexRight;
                
            }
            cell.leftCommendBtn.hidden = NO;
            cell.leftCommendLabel.hidden = NO;
            cell.rightCommendBtn.hidden = NO;
            cell.rightCommendLabel.hidden = NO;
            cell.guessImageView.hidden = YES;
            cell.guessLabel.hidden = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else
    {
        if (indexPath.row == 0) {
            CommendHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommendHeadCell" forIndexPath:indexPath];
             cell.guessHeadLabel.text = @"今日推荐";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        else
        {
            CommendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommendCell" forIndexPath:indexPath];
            MenuResultDataModel *data = self.guessArray[indexPath.row - 1];
            NSURL *url = [NSURL URLWithString:data.albums[0]];
            [cell.guessImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"正在加载"]];
            [cell.guessImageView setRoundLayer:5 bounds:YES borderWidth:1 borderColor:kRGBColor(227, 59, 65, 0.8)];
        
            cell.guessLabel.text = data.title;
            cell.leftCommendBtn.hidden = YES;
            cell.leftCommendLabel.hidden = YES;
            cell.rightCommendBtn.hidden = YES;
            cell.rightCommendLabel.hidden = YES;
            cell.guessImageView.hidden = NO;
            cell.guessLabel.hidden = NO;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }
    
  
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if(indexPath.row == 0)
            return 80;
        else
        {
            return (kScreenW - 30)/2 + 10;
        }
    }
    else
    {
        if(indexPath.row == 0)
            return 40;
        else
        {
            return 230;
        }
    }
        
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.naviView.alpha = self.tableView.contentOffset.y / 136;
    self.naviView.backgroundColor = kRGBColor(227, 59, 65, 1.0);
    if (self.tableView.contentOffset.y >= 219 && self.tableView.contentOffset.y < 1035) {
        self.titleLabel.text = [NSString stringWithFormat:@"%@",[TimeManager foodAboutTime]];
    }
    else if (self.tableView.contentOffset.y >= 1035) {
        self.titleLabel.text = @"今日推荐";
    }
    else
    {
        self.titleLabel.text = @"";
    }
}

- (IBAction)topClickBtn:(id)sender {
   [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}



@end
