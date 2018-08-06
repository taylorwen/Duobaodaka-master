//
//  ShowOrderModel.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ShowOrderModel.h"

@implementation ShowOrderItem
@synthesize gonumber,huode,q_end_time,sd_content,sd_email,sd_id,sd_ip,sd_mobile,sd_photolist,sd_ping,sd_qishu,sd_shopid,sd_shopsid,sd_thumbs,sd_time,sd_title,sd_userid,sd_username,sd_zhan,title,sd_photo;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ShowOrderList
@synthesize count,Rows;
+(Class)Rows_class
{
    return [ShowOrderItem class];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ShowOrderSingleItem
@synthesize gonumber,huode,q_end_time,sd_content,sd_email,sd_id,sd_ip,sd_mobile,sd_photolist,sd_ping,sd_qishu,sd_shopid,sd_shopsid,sd_thumbs,sd_time,sd_title,sd_userid,sd_username,sd_zhan,title,sd_photo;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ShowOrderSingleItemList
@synthesize Rows;
+(Class)Rows_class
{
    return [ShowOrderSingleItem class];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ShowOrderDetail
@synthesize text;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ShowOrderReplyList
@synthesize Rows;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ShowOrderModel
+ (void)getShowGoodsList:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyShowGoodsList];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getPostSingleDetail:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetSingleDetail];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getPostDetail:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetShowGoodsDetail];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getUploadPostContent:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBasePHPUrl stringByAppendingString:oyNewGetShowImageContent];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}
@end
