//
//  TRNetworkManager.h
//  Demo01-AFNetworking
//
//  Created by tarena on 16/1/14.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuModel.h"


typedef void(^successBlock)(MenuModel* responseObject);
typedef void(^failureBlock)(NSError *error);
@interface TRNetworkManager : NSObject

+ (void)sendGetMenuWithMenu:(NSString *)menu pn:(NSString*)pn rn:(NSString *)rn success:(successBlock)success failure:(failureBlock)failure;

+ (void)sendGetCidWithCid:(NSInteger)cid pn:(NSString*)pn rn:(NSString *)rn success:(successBlock)success failure:(failureBlock)failure;

+ (void)sendGetIDWithID:(NSInteger)ID success:(successBlock)success failure:(failureBlock)failure;






@end
