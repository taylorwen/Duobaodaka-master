//
//  MineMyAreaModel.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineMyAreaModel.h"

@implementation MineMyAreaItem
@synthesize isdefault, jiedao,mobile,pid,qq,sheng,shi,xian,shouhuoren,tell,time,uid,youbian;

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation MineMyAreaList
+(Class)regions_class
{
    return [MineMyAreaItem class];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation MineMyAreaInfo
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation MineMyAreaModel

+ (void)getArea:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyAddreasAddUrl];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}
+ (void)getEditAddress:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyAddressEdit];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}
@end
