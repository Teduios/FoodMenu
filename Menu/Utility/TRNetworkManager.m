//
//  TRNetworkManager.m
//  Demo01-AFNetworking
//
//  Created by tarena on 16/1/14.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "TRNetworkManager.h"
#import "AFNetworking.h"

@implementation TRNetworkManager
//菜谱大全
+ (void)sendGetMenuWithMenu:(NSString *)menu pn:(NSString*)pn rn:(NSString *)rn success:(successBlock)success failure:(failureBlock)failure {
    
    //和AFNetworing相关的调用
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *pa = @{@"menu":menu,@"pn":pn,@"rn":rn,@"key":kKey};
    NSString *url = @"https://apis.juhe.cn/cook/query.php";
    [manager POST:url parameters:pa constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([MenuModel parseJSON:responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];


}

//按标签检索菜谱
+ (void)sendGetCidWithCid:(NSInteger)cid pn:(NSString*)pn rn:(NSString *)rn success:(successBlock)success failure:(failureBlock)failure
{
     AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *pa = @{@"cid":@(cid),@"pn":pn,@"rn":rn,@"key":kKey};
    NSString *url = @"https://apis.juhe.cn/cook/index";
    [manager POST:url parameters:pa constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([MenuModel parseJSON:responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];
    


}

//按菜谱ID查看详细
+ (void)sendGetIDWithID:(NSInteger)ID success:(successBlock)success failure:(failureBlock)failure
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *pa = @{@"id":@(ID),@"key":kKey};
    NSString *url = @"https://apis.juhe.cn/cook/queryid";
    [manager POST:url parameters:pa constructingBodyWithBlock:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success([MenuModel parseJSON:responseObject]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(error);
    }];

}






@end
