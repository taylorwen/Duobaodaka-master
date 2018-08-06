//
//  ProductLtdModel.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/23.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ProductLtdModel.h"

@implementation ProductLtdItem
@synthesize brandid,canyurenshu,cateid,codes_table,content,def_renshu,description,gonumber,keywords,maxqishu,member_object,money,order,picarr,pid,pos,q_user,q_content,q_counttime,q_eng_time,q_showtime,q_uid,q_user_code,qishu,renqi,shenyurenshu,sid,thumb,time,title,title2,title_style,xsjx_time,yunjiage,zongrenshu;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ProductLtdList
@synthesize rows;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
+ (Class)Rows_class {
    return [ProductLtdItem class];
}
@end

@implementation ProductHistoryLtdItem
@synthesize brandid,canyurenshu,cateid,codes_table,content,def_renshu,description,gonumber,keywords,maxqishu,member_object,money,order,picarr,pid,pos,q_user,q_content,q_counttime,q_eng_time,q_showtime,q_uid,q_user_code,qishu,renqi,shenyurenshu,sid,thumb,time,title,title2,title_style,xsjx_time,yunjiage,zongrenshu;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation ProductHistoryLtdList
@synthesize rows;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
+ (Class)Rows_class {
    return [ProductHistoryLtdItem class];
}
@end


@implementation ProductLtdModel

+ (void)getLtdProduct:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetLtdProduct];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getHistoryLtdProduct:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetHistoryLtdProduct];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}
@end
