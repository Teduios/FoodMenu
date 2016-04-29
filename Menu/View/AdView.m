//
//  AdView.m
//  Demo8
//
//  Created by tarena on 16/2/28.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "AdView.h"
#import "AdImageView.h"



typedef enum {
    LEFT,
    RIGHT
}NEXT_TYPE;

typedef enum {
    ADD,
    SUB
}ADD_TYPE;


@interface AdView () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong)UIPageControl *pageControl;
//所有图片名称的数组
@property (nonatomic, strong)NSArray *allImageNames;
//所有广告语的数组 (暂时没有用到)
@property (nonatomic, strong)NSArray *allTitles;
//当前屏幕显示的图片在数组的索引
@property (nonatomic, assign)NSInteger currentImageIndex;
//所有图片数量
@property (nonatomic, assign)NSInteger imageCount;
//中间的UIImageView
@property (nonatomic, strong)AdImageView* centerImageView;
//左边的UIImageView
@property (nonatomic, strong)AdImageView* leftImageView;
//右边的UIImageView
@property (nonatomic, strong)AdImageView* rightImageView;

@property (nonatomic, strong)UILabel *centerlabel;

@property (nonatomic, strong)UILabel *leftlabel;

@property (nonatomic, strong)UILabel *rightlabel;
@end


@implementation AdView


-(id)initWithFrame:(CGRect)frame imageNames:(NSArray*)imageNames titles:(NSArray*)titles {
 
    if (self = [super initWithFrame:frame]) {
        self.allImageNames = imageNames;
        self.allTitles = titles;
        self.imageCount = self.allImageNames.count;
        self.currentImageIndex = 0;
        
        [self setupScrollView];
        [self setupPageControl];
        [self setupImageView];
        //设置 开始时 左中右 默认的图片
        [self setupDefaultImage];
        
    }
    return self;
    

}


-(void)setupScrollView {
    //frame 设置 scrollView 显示范围
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    [self addSubview:self.scrollView];
    //设置代理
    self.scrollView.delegate = self;
    //设置scrollView 滚动范围
    self.scrollView.contentSize = CGSizeMake(self.bounds.size.width * 3, self.bounds.size.height);
    //设置scrollView 的便宜量
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    //设置scrollView 整页翻
    self.scrollView.pagingEnabled = YES;
    //去掉水平滚动的 灰条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    //边缘不弹跳
    self.scrollView.bounces = NO;
    
}


-(void)setupPageControl {
    self.pageControl = [[UIPageControl alloc]init];
    
    //动态获取 pageControl， 根据有多少页（多少个原点）来自动计算实际的大小
    CGSize size = [self.pageControl sizeForNumberOfPages:self.imageCount];
    
    self.pageControl.frame = CGRectMake(0, 0, size.width, size.height);
    //设置 pageControl 的中心点
    self.pageControl.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height - 10);

    
    //设置颜色
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    self.pageControl.userInteractionEnabled = NO;
    //设置页数
    self.pageControl.numberOfPages = self.imageCount;
    [self addSubview:self.pageControl];
}

-(void)setupImageView {
    //创建左边的 ImageView 并添加到 scrollView
    self.leftImageView = [[AdImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.leftlabel = [UILabel labelWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20) andCenter:CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height - 30)];
    
    self.leftlabel.shadowColor = [UIColor grayColor];
    self.leftlabel.shadowOffset = CGSizeMake(1, 1);
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.leftlabel];
    
    
    
    //创建右边的 ImageView 并添加到 scrollView
    self.rightImageView = [[AdImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width * 2, 0, self.bounds.size.width, self.bounds.size.height)];

    self.rightlabel = [UILabel labelWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20) andCenter:CGPointMake(self.bounds.size.width * 2.5, self.bounds.size.height - 30)];
    self.rightlabel.shadowColor = [UIColor grayColor];
    self.rightlabel.shadowOffset = CGSizeMake(1, 1);
    
    [self.scrollView addSubview:self.rightImageView];
    [self.scrollView addSubview:self.rightlabel];
    //创建中间的 ImageView 并添加到 scrollView
    self.centerImageView = [[AdImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];

    self.centerlabel = [UILabel labelWithFrame:CGRectMake(0, 0, self.bounds.size.width, 20) andCenter:CGPointMake(self.bounds.size.width * 1.5, self.bounds.size.height - 30)];
    self.centerlabel.shadowColor = [UIColor grayColor];
    self.centerlabel.shadowOffset = CGSizeMake(1, 1);
    
    WK(weakSelf)
    //给图片添加点钟事件
    [self.centerImageView addTapListenter:^() {
        //点中事件的方法
        [weakSelf tapImage];
    }];
    
    
    [self.scrollView addSubview:self.centerImageView];
    [self.scrollView addSubview:self.centerlabel];
}

-(void)setupDefaultImage {

    //左

    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.allImageNames[self.imageCount - 1]] placeholderImage:[UIImage imageNamed:@"正在加载"]];
    self.leftlabel.text = self.allTitles[self.imageCount - 1];
     //中

    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:self.allImageNames[0]] placeholderImage:[UIImage imageNamed:@"正在加载"]];
    self.centerlabel.text = self.allTitles[0];
     //右

    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.allImageNames[1]] placeholderImage:[UIImage imageNamed:@"正在加载"]];
    self.rightlabel.text = self.allTitles[1];
    //记录当前界面的索引
    self.currentImageIndex = 0;
    self.pageControl.currentPage = self.currentImageIndex;
    
}

#pragma mark scrollView代理方法 滚动已经停止
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //更换scrollView 中的三个imageView中的图片
    [self reloadImage];
    
    //位置移动回到中间
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    //修改分页控制上的小圆点
    self.pageControl.currentPage = self.currentImageIndex;
    
}

-(void)reloadImage {
    //获取 滑动完的便宜量
    CGPoint offset  = self.scrollView.contentOffset;
    if (offset.x < self.bounds.size.width) {
        //向右 所有索引 -1
        self.currentImageIndex = [self computeNextIndex:self.currentImageIndex nextType:RIGHT];
    }else if(offset.x > self.bounds.size.width){ //向左
        //向左 所有索引 +1
        self.currentImageIndex = [self computeNextIndex:self.currentImageIndex nextType:LEFT];
    }
    //换中间图片

    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:self.allImageNames[self.currentImageIndex]] placeholderImage:[UIImage imageNamed:@"正在加载"]];
    self.centerlabel.text = self.allTitles[self.currentImageIndex];
    //换右边的图片
    NSInteger rIndex = [self computeIndex:self.currentImageIndex nextType:ADD];

    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.allImageNames[rIndex]] placeholderImage:[UIImage imageNamed:@"正在加载"]];
    self.rightlabel.text = self.allTitles[rIndex];
    //换左边的图片
    NSInteger lIndex = [self computeIndex:self.currentImageIndex nextType:SUB];

    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.allImageNames[lIndex]] placeholderImage:[UIImage imageNamed:@"正在加载"]];
    self.leftlabel.text = self.allTitles[lIndex];
}

//根据左右 求出下一步 下标
-(NSInteger)computeNextIndex:(NSInteger)index nextType:(NEXT_TYPE)type {
    switch (type) {
        case RIGHT:
            return --index < 0 ? self.imageCount - 1 : index;
            break;
        case LEFT:
            return ++index > self.imageCount-1 ? 0 : index;
    }
}

//在当前索引上  加1  或  减1
-(NSInteger)computeIndex:(NSInteger)index nextType:(ADD_TYPE)type {
    switch (type) {
        case ADD:
            return ++index > self.imageCount-1 ? 0 : index;
            break;
        case SUB:
            return --index < 0 ? self.imageCount - 1 : index;
    }
}


//点中图片
-(void)tapImage {
    if (self.delegate != nil) {
        [self.delegate AdView:self didSelectorAtIndex:self.currentImageIndex];
    }
}


@end
















