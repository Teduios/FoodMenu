//
//  StepsViewController.m
//  Menu
//
//  Created by 陈龙 on 16/4/17.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "StepsViewController.h"

#import "ThemeCell.h"
#import "StepsCell.h"
#define kUserPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"user"]
#define kUserCollectPath [kUserPath stringByAppendingPathComponent:@"user.data"]


@interface StepsViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UILabel *TitleLabel;

@property (weak, nonatomic) IBOutlet UIView *naviView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSArray *ingredientsArray;

@property (nonatomic, assign)BOOL isCollect;

@property (nonatomic, strong)NSMutableArray *colloctArray;

@end

@implementation StepsViewController

#pragma mark - 懒加载

-(NSMutableArray *)colloctArray
{
    if (!_colloctArray) {
        _colloctArray = [NSMutableArray array];
        [_colloctArray addObjectsFromArray:[NSKeyedUnarchiver unarchiveObjectWithFile:kUserCollectPath]];
    }
    return _colloctArray;
}

-(NSArray *)ingredientsArray
{
    if (!_ingredientsArray) {
        
        NSString *tmp = [self.stepData.ingredients stringByReplacingOccurrencesOfString:@";" withString:@","];
        _ingredientsArray = [tmp componentsSeparatedByString:@","];
    }
    return _ingredientsArray;
}


- (IBAction)collectBtn:(UIButton *)sender {
    self.isCollect = !self.isCollect;
    sender.selected = self.isCollect;
}
#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // 为了让tableView自适应高度需要设置如下两个属性：
    self.tableView.estimatedRowHeight = 70;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.TitleLabel.text = self.stepData.title;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.stepData.albums[0]] placeholderImage:[UIImage imageNamed:@"正在加载"]];
    
    self.isCollect = [[NSUserDefaults standardUserDefaults] boolForKey:self.stepData.ID];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    WK(weakSelf)

    if (self.isCollect == YES){
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if(![[NSUserDefaults standardUserDefaults] boolForKey:weakSelf.stepData.ID]){
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:weakSelf.stepData.ID];
            }
        });
        
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (![[NSFileManager defaultManager] fileExistsAtPath:kUserPath]){
                [[NSFileManager defaultManager] createDirectoryAtPath:kUserPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            if (![weakSelf.colloctArray containsObject:weakSelf.stepData]) {
                weakSelf.stepData.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:weakSelf.stepData.albums[0]]];
                [weakSelf.colloctArray addObject:weakSelf.stepData];
                
                [NSKeyedArchiver archiveRootObject:weakSelf.colloctArray toFile:kUserCollectPath];
            }
            
            
        });
    }
    else
    {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if([[NSUserDefaults standardUserDefaults] boolForKey:weakSelf.stepData.ID])
            {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:weakSelf.stepData.ID];
            }
        });

        if ([weakSelf.colloctArray containsObject:weakSelf.stepData]) {
                [weakSelf.colloctArray removeObject:weakSelf.stepData];
                [NSKeyedArchiver archiveRootObject:weakSelf.colloctArray toFile:kUserCollectPath];
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if(section == 2)
    {
        return self.stepData.steps.count;
    }
    else
    {
        return self.ingredientsArray.count * 0.5 + 1;
        
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"themeCell" forIndexPath:indexPath];
        cell.titleLabel.text = self.stepData.title;
        cell.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:18];
        cell.imtroLabel.text = self.stepData.imtro;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.collectButton.selected = self.isCollect;
        return cell;
    }
    else if(indexPath.section == 1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"foodCell" forIndexPath:indexPath];
        
        if (indexPath.row == 0) {
            cell.detailTextLabel.text = @"";
            cell.textLabel.text = @"食材";
            cell.textLabel.font = [UIFont systemFontOfSize:18];
            cell.textLabel.textColor = [UIColor blackColor];
        }
        else
        {
            cell.textLabel.textColor = [UIColor darkGrayColor];
            cell.textLabel.font = [UIFont systemFontOfSize:14];
            cell.textLabel.text = self.ingredientsArray[(indexPath.row - 1) * 2] ;
            cell.detailTextLabel.text = self.ingredientsArray[(indexPath.row - 1) * 2 + 1] ;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else
    {
        StepsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"stepCell" forIndexPath:indexPath];
        cell.titleLabel.text = [NSString stringWithFormat:@"步骤%ld",((NSInteger)indexPath.row) + 1];
        
        [cell.stepsImageView sd_setImageWithURL:[NSURL URLWithString:self.stepData.steps[indexPath.row].img] placeholderImage:[UIImage imageNamed:@"正在加载"]];
        [cell.stepsImageView setRoundLayer:5 bounds:YES borderWidth:0 borderColor:0];

        cell.stepsLabel.text = self.stepData.steps[indexPath.row].step;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.naviView.alpha = self.tableView.contentOffset.y / 136;
    self.naviView.backgroundColor = kRGBColor(227, 59, 65, 1.0);
}

- (IBAction)backClickBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
