//
//  MenuModel.m
//  Menu
//
//  Created by tarena033 on 16/4/7.
//  Copyright © 2016年 tarena. All rights reserved.
//

#import "MenuModel.h"

@implementation MenuModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"result":[MenuResultModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"resultCode":@"resultcode",@"errorCode":@"error_code"};
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_result forKey:@"result"];
    [aCoder encodeObject:_resultCode forKey:@"resultCode"];
    [aCoder encodeObject:_reason forKey:@"reason"];
    [aCoder encodeInteger:_errorCode forKey:@"errorCode"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _result = [aDecoder decodeObjectForKey:@"result"];
        _resultCode = [aDecoder decodeObjectForKey:@"resultCode"];
        _reason = [aDecoder decodeObjectForKey:@"reason"];
        _errorCode = [aDecoder decodeIntegerForKey:@"errorCode"];
    }
    return self;
}

@end
@implementation MenuResultModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"data":[MenuResultDataModel class]};
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_totalNum forKey:@"totalNum"];
    [aCoder encodeObject:_data forKey:@"data"];
    [aCoder encodeObject:_pn forKey:@"pn"];
    [aCoder encodeObject:_rn forKey:@"rn"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _totalNum = [aDecoder decodeObjectForKey:@"totalNum"];
        _data = [aDecoder decodeObjectForKey:@"data"];
        _pn = [aDecoder decodeObjectForKey:@"pn"];
        _rn = [aDecoder decodeObjectForKey:@"rn"];
    }
    return self;
}

@end


@implementation MenuResultDataModel
+ (NSDictionary *)modelContainerPropertyGenericClass
{
    return @{@"steps":[MenuResultDataStepsModel class]};
}

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"ID":@"id"};
}

//当使用数组的containtObject,或者NSSet等 对象的匹配方法时, 会自动调用.
- (BOOL)isEqual:(id)object{
    /*
     使用runtime,遍历对象的所有属性, 通过匹配每个属性是否相等, 如果都相等,则返回真.
     */
    return [self.ID modelIsEqual:((MenuResultDataModel *)object).ID];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_burden forKey:@"burden"];
    [aCoder encodeObject:_albums forKey:@"albums"];
    [aCoder encodeObject:_imtro forKey:@"imtro"];
    [aCoder encodeObject:_ID forKey:@"ID"];
    [aCoder encodeObject:_ingredients forKey:@"ingredients"];
    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeObject:_steps forKey:@"steps"];
    [aCoder encodeObject:_tags forKey:@"tags"];
    [aCoder encodeObject:_imageData forKey:@"imageData"];

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _burden = [aDecoder decodeObjectForKey:@"burden"];
        _albums = [aDecoder decodeObjectForKey:@"albums"];
        _imtro = [aDecoder decodeObjectForKey:@"imtro"];
        _ID = [aDecoder decodeObjectForKey:@"ID"];
        _ingredients = [aDecoder decodeObjectForKey:@"ingredients"];
        _title = [aDecoder decodeObjectForKey:@"title"];
        _steps = [aDecoder decodeObjectForKey:@"steps"];
        _tags = [aDecoder decodeObjectForKey:@"tags"];
        _imageData = [aDecoder decodeObjectForKey:@"imageData"];
    }
    return self;
}
@end


@implementation MenuResultDataStepsModel
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_img forKey:@"img"];
    [aCoder encodeObject:_step forKey:@"step"];

}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _img = [aDecoder decodeObjectForKey:@"img"];
        _step = [aDecoder decodeObjectForKey:@"step"];

    }
    return self;
}
@end


