//
//  CartModel.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "CartModel.h"

@implementation CartItem
@synthesize pid,title,qishu,money,thumb,yunjiage,sid,gonumber;
@end

@implementation CartProduct
@synthesize  brandid, canyurenshu,cateid,codes_table,shopcodes_1,content, def_renshu,description,gonumber,keywords,maxqishu,money,order,picarr,pos,q_content,q_user,q_user_code,q_counttime,q_showtime,q_end_time,q_uid,qishu,renqi,shenyurenshu,sid,thumb,time,title,title2,title_style,xsjx_time,yunjiage,zongrenshu;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end


@implementation CartResult
@synthesize state,str;
@end

@implementation CartResultAsnyc
@synthesize state;
@end

@implementation CartModel

+ (void)addorUpdateCart:(CartItem*)item
{
    [[XBDbHandler sharedInstance] insertOrUpdateWithModelArr:@[item] byPrimaryKey:@"pid"];
}

+ (void)quertCart:(NSString*)key value:(NSObject*)value block:(void (^)(NSArray* result))block
{
    NSArray* arr = [[XBDbHandler sharedInstance] queryWithClass:[CartItem class] key:key value:value orderByKey:nil desc:NO];
    if(block != NULL)
        block(arr);
}

+ (NSArray*)quertCart2:(NSString*)key value:(NSObject*)value
{
    NSArray* arr = [[XBDbHandler sharedInstance] queryWithClass:[CartItem class] key:key value:value orderByKey:nil desc:NO];
    return arr;
}

+ (void)removeCart:(CartItem*)item
{
    [[XBDbHandler sharedInstance] deleteModels:@[item] withPrimaryKey:@"pid"];
}

+ (void)removeAllCart
{
    NSArray* arr = [[XBDbHandler sharedInstance] queryWithClass:[CartItem class] key:nil value:nil orderByKey:nil desc:NO];
    for (CartItem* item in arr) {
        [[XBDbHandler sharedInstance] deleteModels:@[item] withPrimaryKey:@"pid"];
    }
}

+ (void)getCartState:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetProductsDetail];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}

+ (void)getCartPayIpAddress:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetMineIPAddress];
    [[XBApi SharedXBApi] requestWithURL:url paras:nil type:XBHttpResponseType_Json success:success failure:failure];
}

#pragma mark - server
+ (void)getCartInServer:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
//    NSString* url = [oyBaseUrl stringByAppendingString:oyHotestProduct];
    [[XBApi SharedXBApi] requestWithURL:oyNewest paras:nil type:XBHttpResponseType_Common success:success failure:failure];
}

+ (void)postCartInServer:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
//    NSString* url = [oyBaseUrl stringByAppendingString:oyHotestProduct];
    [[XBApi SharedXBApi] requestWithURL2:oyNewest referer:oyNewest paras:nil type:XBHttpResponseType_JqueryJson success:success failure:failure];
}

+ (void)queryCartResultInServer:(NSString*)rid success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyHotestProduct];
    [[XBApi SharedXBApi] requestWithURL2:url referer:oyNewest paras:nil type:XBHttpResponseType_JqueryJson success:success failure:failure];
}
/**
 *  清除购物车，删除服务器端存储
 */
+ (BOOL)delCartInServer:(int)codeId
{
    NSString* url = [NSString stringWithFormat:oyNewest];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:kXBCookie] forHTTPHeaderField:@"Cookie"];
    NSURLResponse* reponse = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&reponse error:&error];
    if(error)
    {
        return false;
    }
    NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"delCartInServer:%@",result);
    return [[Jxb_Common_Common sharedInstance] containString:result cStr:@"code':0"];
}
/**
 *  添加到购物车，保存到服务器数据库
 */
+ (CartAddResult)addCartInServer:(CartItem*)item
{
    NSString* url = [NSString stringWithFormat:oyNewest];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:kXBCookie] forHTTPHeaderField:@"Cookie"];
    [request setValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];
    NSURLResponse* reponse = nil;
    NSError* error = nil;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&reponse error:&error];
    if(error)
    {
        return false;
    }
    NSString* result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if([[Jxb_Common_Common sharedInstance] containString:result cStr:@"code':0"])
        return CartAddResult_Success;
    if([[Jxb_Common_Common sharedInstance] containString:result cStr:@"code':2"])
        return CartAddResult_Full;
    return CartAddResult_Failed;
}

@end