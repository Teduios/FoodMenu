//
//  MyCollectViewController.m
//  Menu
//
//  Created by tarena033 on 16/4/20.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "MyCollectViewController.h"
#import "CollectCell.h"
#import "StepsViewController.h"
#define kUserPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"user"]
#define kUserCollectPath [kUserPath stringByAppendingPathComponent:@"user.data"]


@interface MyCollectViewController ()<UITableViewDataSource, UITableViewDelegate>
- (IBAction)backClickBtn:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *collectArray;

@end

@implementation MyCollectViewController


#pragma mark - UITableViewDataSource/Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collectArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collectCell" forIndexPath:indexPath];
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    MenuResultDataModel *data = self.collectArray[indexPath.row];
    UIImage *image = [[UIImage alloc]initWithData:data.imageData];
    cell.imgView.image = image;
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
    [self performSegueWithIdentifier:@"stillGotoStepVC" sender:indexPath];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    WK(weakSelf)
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        MenuResultDataModel *data = weakSelf.collectArray[indexPath.row];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:data.ID];
        [self.collectArray removeObjectAtIndex:indexPath.row];
        
        [tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewRowAnimationRight];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [NSKeyedArchiver archiveRootObject:weakSelf.collectArray toFile:kUserCollectPath];
        });
       
        
    }
}

#pragma mark - 跳转

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(NSIndexPath *)sender
{
    UIViewController *vc = segue.destinationViewController;
    if ([vc isKindOfClass:[StepsViewController class]]) {
        StepsViewController *stepsVC = (StepsViewController *)vc;
        stepsVC.stepData = self.collectArray[sender.row];
        
    }
}

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.collectArray = [[NSKeyedUnarchiver unarchiveObjectWithFile:kUserCollectPath] mutableCopy] ;
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backClickBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
