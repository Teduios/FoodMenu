//
//  SortViewController.m
//  Menu
//
//  Created by 陈龙 on 16/4/17.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "SortViewController.h"
#import "GroupsCell.h"
#import "ListCell.h"
#import "SearchViewController.h"

@interface SortViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong)NSArray<GroupsModel *> *groupsArray;

@property (nonatomic, strong)NSArray<GroupsListModel *> *listArray;

@property (nonatomic) CGFloat lineSpace;

@end

@implementation SortViewController

- (CGFloat)lineSpace{
    return (kScreenW - 80 - 3*70)/6;
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.searchBtn setRoundLayer:5 bounds:YES borderWidth:0 borderColor:0];
    
    [DataManager getFoodGoups:^(NSArray<GroupsModel *> *groups, NSError *error) {
        self.groupsArray = groups;
        self.listArray = self.groupsArray[0].list;
        [self.tableView reloadData];
        [self.collectionView reloadData];
        NSIndexPath *selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        //默认选择第一行
        [self.tableView selectRowAtIndexPath:selectedIndexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchClickBtn:(id)sender {
    [self performSegueWithIdentifier:@"gotoSearchVC" sender:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSNumber *)sender
{
    UIViewController *vc = segue.destinationViewController;
    if ([vc isKindOfClass:[SearchViewController class]]) {
        SearchViewController *searchVC = (SearchViewController *)vc;
        if (!sender) {
            [searchVC.searchField becomeFirstResponder];
        }
        else
        {
            searchVC.searchFood = self.listArray[sender.integerValue];
        }
    }
}



#pragma mark - UICollectionView Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"gotoSearchVC" sender:@(indexPath.row)];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.listArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"listCell" forIndexPath:indexPath];
    cell.titleLabel.text = self.listArray[indexPath.row].name;
    [cell.titleLabel setRoundLayer:12 bounds:YES borderWidth:1 borderColor:[UIColor lightGrayColor]];
    return cell;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return self.lineSpace;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 15;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(15, self.lineSpace * 2, 15, self.lineSpace * 2);
}


#pragma mark - UITableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    GroupsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupsCell" forIndexPath:indexPath];

    cell.groupsLabel.text = self.groupsArray[indexPath.row].name;
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.listArray = self.groupsArray[indexPath.row].list;
    [self.collectionView reloadData];
}






@end
