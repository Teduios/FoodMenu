//
//  MenuModel.h
//  Menu
//
//  Created by tarena033 on 16/4/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MenuResultModel,MenuResultDataModel,MenuResultDataStepsModel;
@interface MenuModel : NSObject

@property (nonatomic, strong) MenuResultModel *result;

@property (nonatomic, copy) NSString *resultCode;

@property (nonatomic, copy) NSString *reason;

@property (nonatomic, assign) NSInteger errorCode;

@end
@interface MenuResultModel : NSObject

@property (nonatomic, copy) NSString *totalNum;

@property (nonatomic, strong) NSArray<MenuResultDataModel *> *data;

@property (nonatomic, copy) NSString *pn;

@property (nonatomic, copy) NSString *rn;

@end

@interface MenuResultDataModel : NSObject

@property (nonatomic, copy) NSString *burden;

@property (nonatomic, strong) NSArray<NSString *> *albums;

@property (nonatomic, copy) NSString *imtro;

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *ingredients;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) NSArray<MenuResultDataStepsModel *> *steps;

@property (nonatomic, copy) NSString *tags;
//收藏图片数据
@property (nonatomic, strong)NSData *imageData;


@end

@interface MenuResultDataStepsModel : NSObject

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *step;

@end

