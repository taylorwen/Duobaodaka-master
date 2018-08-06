//
//  ProductModel.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ProductModel.h"

@implementation ProductPics
@synthesize picName,picRemark;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ProductTopic
@synthesize Topic,Reply;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ProductInfo
@synthesize  brandid, canyurenshu,cateid,codes_table,shopcodes_1,content, def_renshu,description,gonumber,keywords,maxqishu,money,order,picarr,pos,q_content,q_user,q_user_code,q_counttime,q_showtime,q_end_time,q_uid,qishu,renqi,shenyurenshu,sid,thumb,time,title,title2,title_style,xsjx_time,yunjiage,zongrenshu,shengyutime,lottery_code,lottery_no,lottery_time;

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ProductInfoChild
@synthesize addgroup,band,email,emailcode,groupid,img,jingyan,login,mobile,mobilecode,money,passcode,password,qianming,reg_key,score,time,uid,user_ip,username,yaoqing;

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ProductNextPeriod
@synthesize pid,qishu,sid;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ProductDetail
@synthesize Rows1,Rows2,Rows3;
+(Class)Rows1_class
{
    return [ProductPics class];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end


@implementation ProductLottery
@synthesize brandid,canyurenshu,cateid,gonumber,huode,ip,pid,q_end_time,q_showtime,q_uid,q_user_code,qishu,shenyurenshu,thumb,title,uphoto,username,zongrenshu,sid,money;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ProductCodeBuy
@synthesize codes;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ProductLotteryDetail
@synthesize Rows1,Rows2,Rows3,Rows4;
+(Class)Rows1_class
{
    return [ProductPics class];
}
+(Class)Rows4_class
{
    return [ProductCodeBuy class];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ProductModel

+ (void)getGoodDetail:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetProductsDetail];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getGoodLottery:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetProductsDetail];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getCodesBuy:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetUserCode];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}
@end
