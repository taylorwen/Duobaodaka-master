//
//  HomeModel.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "HomeModel.h"

@implementation HomeAd
@synthesize pid,img,link,color,title,_type;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation HomeTenModel
@synthesize pid,sid,cateid,brandid,title,money,yunjiage,zongrenshu,canyurenshu,shenyurenshu,qishu,thumb,time;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation HomeAdList
//@synthesize Rows;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
+ (Class)Rows_class {
    return [HomeAd class];
}
@end

@implementation HomeHotest
@synthesize pid,sid,cateid,brandid,title,money,yunjiage,zongrenshu,canyurenshu,shenyurenshu,qishu,thumb,time;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end


@implementation HomeNewing
@synthesize brandid,canyurenshu,cateid,gonumber,huode,ip,pid,q_end_time,q_showtime,q_uid,q_user_code,qishu,shenyurenshu,thumb,title,uphoto,username,zongrenshu,sid;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation HomeNewed
@synthesize codeGoodsID,codeGoodsPic,codeGoodsSName,codeID,codePeriod,codeState,userName,userWeb;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation HomeGuideProModel
@synthesize click_url,create_time,end_time,event,_id,image_height_hdpi,image_height_xhdpi,image_url_hdpi,image_width_xhdpi,start_time,title,update_time;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}

@end

@implementation HomeLimitedProModel
@synthesize _id,height,width,image,url;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation WinProModel
@synthesize time,title,qishu,pid,huode;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation HomeModel

+ (void)getAds:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyAdList];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getTenPro:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetTenProList];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getNewing:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyNewest];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getHotest:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"])
    {
        NSString* url = [oyBaseNewUrl stringByAppendingString:oyHotestProduct];
        [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
    }else
    {
        //上线前专用接口
        NSString* url = [oyBasePHPUrl stringByAppendingString:oyOfflineProductlist];
        [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
    }
    
}

+ (void)getHomePage:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyHotestProduct];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getLimitedPro:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBasePHPUrl stringByAppendingString:oyNewGetLimitedActivity];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getHomeGuide:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBasePHPUrl stringByAppendingString:oyNewGetGuidePro];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getWinProduct:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBasePHPUrl stringByAppendingString:oyNewGetWinProduct];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}
@end
