//
//  MineShowOrderModel.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineShowOrderModel.h"

@implementation MineShowOrderItem
@synthesize gonumber,huode,q_end_time,sd_content,sd_email,sd_id,sd_ip,sd_mobile,sd_photolist,sd_ping,sd_qishu,sd_shopid,sd_shopsid,sd_thumbs,sd_time,sd_title,sd_userid,sd_username,sd_zhan,title,sd_photo;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation MineUnshowOrderItem
@synthesize shop_id,sid,thumb,title,qishu,ip,q_end_time,q_user_code,gonumber,zongrenshu;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation MineShowOrderList
@synthesize postCount,unPostCount,listItems;
+ (Class)listItems_class {
    return [MineShowOrderItem class];
}

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation MineShowOrderModel

+ (void)getShowOrderlist:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyShowGoodsList];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getUnShowOrderlist:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBasePHPUrl stringByAppendingString:oyNewGetUnShowPro];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)postShowOrderImage:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBasePHPUrl stringByAppendingString:oyNewPostShowImage];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)postShowOrderContent:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBasePHPUrl stringByAppendingString:oyNewGetShowImageContent];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}
@end