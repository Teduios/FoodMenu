//
//  SearchViewController.m
//  Menu
//
//  Created by 陈龙 on 16/4/17.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchCell.h"
#import "StepsViewController.h"
#import "UIView+HUD.h"
#import "UIScrollView+Refresh.h"

@interface SearchViewController ()<UITableViewDataSource, UITableViewDelegate>


//隐藏label，用于提示没有搜索结果
@property (weak, nonatomic) IBOutlet UILabel *hiddenLabel;
//隐藏view，用于遮挡tableview的点击响应
@property (weak, nonatomic) IBOutlet UIView *hiddenView;
//搜索文本框背景
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//搜索结果
@property (nonatomic, strong)NSMutableArray *searchResult;
//当前搜索下标
@property (nonatomic, assign)NSInteger index;
//纪录前一次的搜索text,以免重复搜索
@property (nonatomic, copy)NSString *preSearchText;

@property (nonatomic, assign)NSInteger resultNum;
//判断是否是标签搜索还是自己搜索
@property (nonatomic, assign)BOOL isLabelSearch;




@end

@implementation SearchViewController

#pragma mark - 懒加载

-(NSMutableArray *)searchResult
{
    if (!_searchResult) {
        _searchResult = [NSMutableArray array];
    }
    return _searchResult;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]init];
    WK(weakSelf)
    self.index = 0;
    self.searchField.text = self.searchFood.name;
    self.preSearchText = self.searchField.text;
    [self.searchImageView setRoundLayer:5 bounds:YES borderWidth:0 borderColor:0];
    if (self.searchField.text.length) {
        self.isLabelSearch = YES;
        [TRNetworkManager sendGetCidWithCid:self.searchFood.ID.integerValue pn:@"0" rn:@"30" success:^(MenuModel *responseObject) {
            [weakSelf.searchResult addObjectsFromArray:responseObject.result.data];
            if (weakSelf.searchResult.count <= 6) {
                weakSelf.tableView.mj_footer.hidden = YES;
            }
            else
            {
                weakSelf.tableView.mj_footer.hidden = NO;
            }
            
            [weakSelf.tableView reloadData];
            [weakSelf.view hideBusyHUD];
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
 
        [self.view showBusyHUD];
        
    }
    else
    {
        self.isLabelSearch = NO;
        self.hiddenView.hidden = NO;
        [self.searchField becomeFirstResponder];
    }
    [self createFootRefresh];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)createFootRefresh
{
    WK(weakSelf)
    
   
    [self.tableView addBackFooterRefresh:^{
        if (self.isLabelSearch == YES) {
            self.index += 30;
            [TRNetworkManager sendGetCidWithCid:self.searchFood.ID.integerValue pn:[NSString stringWithFormat:@"%ld", self.index] rn:@"30" success:^(MenuModel *responseObject) {
                weakSelf.resultNum = weakSelf.searchResult.count;
                for (MenuResultDataModel *data in responseObject.result.data) {
                    if (![weakSelf.searchResult containsObject:data])
                        [weakSelf.searchResult addObject:data];
                }
                
                if (weakSelf.searchResult.count == weakSelf.resultNum || responseObject.result.data.count == 0) {
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                else
                {
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView endFooterRefresh];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@", error);
            }];
        }
        else if (self.isLabelSearch == NO)
        {
            self.index += 30;
            [TRNetworkManager sendGetMenuWithMenu:self.searchField.text pn:[NSString stringWithFormat:@"%ld", self.index] rn:@"30" success:^(MenuModel *responseObject) {
                weakSelf.resultNum = weakSelf.searchResult.count;
                for (MenuResultDataModel *data in responseObject.result.data) {
                    if (![weakSelf.searchResult containsObject:data])
                        [weakSelf.searchResult addObject:data];
                    
                }
                if (weakSelf.searchResult.count == weakSelf.resultNum||responseObject.result.data.count == 0) {
                    
                    [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                }
                else
                {
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView endFooterRefresh];
                }
            } failure:^(NSError *error) {
                NSLog(@"%@", error);
            }];
           
        }
    }];
    
    
    
}
#pragma mark - UITableViewDelegate/UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResult.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    MenuResultDataModel *data = self.searchResult[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:data.albums[0]] placeholderImage:[UIImage imageNamed:@"正在加载"]];
    cell.titleLabel.text = data.title;
    cell.tagLabel.text = data.tags;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchField resignFirstResponder];
    [self performSegueWithIdentifier:@"alsoGotoStepsVC" sender:@(indexPath.row)];
}


- (IBAction)backClickBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)searchBtn:(id)sender {

    WK(weakSelf)
    [self.tableView.mj_footer resetNoMoreData];
    self.hiddenView.hidden = YES;
    //如果与前一次搜索相同并且不为空，则去取数据
    if (![self.preSearchText isEqualToString:self.searchField.text] && self.searchField.text.length != 0) {
        self.isLabelSearch = NO;
        [self.searchResult removeAllObjects];
        [TRNetworkManager sendGetMenuWithMenu:self.searchField.text pn:@"0" rn:@"30" success:^(MenuModel *responseObject) {
       
            [weakSelf.searchResult addObjectsFromArray:responseObject.result.data];
            if (weakSelf.searchResult.count == 0 ||responseObject.result.data.count == 0) {
                weakSelf.hiddenLabel.hidden = NO;
                weakSelf.hiddenView.hidden = NO;
                weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            }
            weakSelf.preSearchText = weakSelf.searchField.text;
            [weakSelf.view hideBusyHUD];
            [weakSelf.tableView setContentOffset:CGPointMake(0, 0) animated:NO];
            weakSelf.index = 0;
            if (weakSelf.searchResult.count <= 6) {
                weakSelf.tableView.mj_footer.hidden = YES;
            }
            else
            {
                weakSelf.tableView.mj_footer.hidden = NO;
            }
            [weakSelf.tableView reloadData];
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
        [self.view showBusyHUD];
        
    }
    
    [self.searchField resignFirstResponder];
}




#pragma mark - 其他方法
- (IBAction)gotoSearch:(id)sender {
    [self searchBtn:nil];
}
- (IBAction)valueChanged:(id)sender {
    self.hiddenLabel.hidden = YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchField resignFirstResponder];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchField resignFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSNumber *)sender
{
    UIViewController *vc = segue.destinationViewController;
    if ([vc isKindOfClass:[StepsViewController class]]) {
        StepsViewController *stepsVC = (StepsViewController *)vc;
        stepsVC.stepData = self.searchResult[sender.integerValue];
    }

}




@end
