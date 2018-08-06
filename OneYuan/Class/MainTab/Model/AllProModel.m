//
//  AllProModel.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "AllProModel.h"

@implementation AllProPeriod
@synthesize goodsID,codeID,codeState,codePeriod;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation AllProPeriodList
@synthesize Rows;
+ (Class)Rows_class {
    return [AllProPeriod class];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation AllProItme
@synthesize pid,sid,cateid,brandid,title,money,yunjiage,zongrenshu,canyurenshu,shenyurenshu,qishu,thumb,time;

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

@implementation AllProList
@synthesize count,Rows;
+ (Class)Rows_class {
    return [AllProItme class];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation AllProModel

+(void)getAllProduct:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"])
    {
        NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetCateProList];
        [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
    }else
    {
        //上线前专用接口
        NSString* url = [oyBasePHPUrl stringByAppendingString:oyOfflineProductlist];
        [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
    }
    
    
}

+(void)getGoodsPeriodByCodeId:(NSString*)codeId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetUserCode];
    [[XBApi SharedXBApi] requestWithURL:url paras:nil type:XBHttpResponseType_Json success:success failure:failure];
}

@end
