//
//  CartModel.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    CartAddResult_Success,
    CartAddResult_Full,
    CartAddResult_Failed
}CartAddResult;

@interface CartItem : OneBaseParser
@property (nonatomic,copy)NSString  *pid;
@property (nonatomic,copy)NSString  *title;
@property (nonatomic,copy)NSString  *qishu;
@property (nonatomic,copy)NSString  *money;
@property (nonatomic,copy)NSString  *thumb;
@property (nonatomic,copy)NSString  *yunjiage;
@property (nonatomic,copy)NSString  *sid;
@property (nonatomic,copy)NSString  *gonumber;
@end

@interface CartProduct : OneBaseParser
@property(nonatomic,copy)NSString* brandid;
@property(nonatomic,copy)NSString* canyurenshu;
@property(nonatomic,copy)NSString* cateid;
@property(nonatomic,copy)NSString* codes_table;
@property(nonatomic,copy)NSString* content;
@property(nonatomic,copy)NSString* def_renshu;
@property(nonatomic,copy)NSString* description;
@property(nonatomic,copy)NSString* gonumber;
@property(nonatomic,copy)NSString* pid;
@property(nonatomic,copy)NSString* keywords;
@property(nonatomic,copy)NSString* maxqishu;
@property(nonatomic,copy)NSString* money;
@property(nonatomic,copy)NSString* order;
@property(nonatomic,copy)NSString* picarr;              //商品图片列表
@property(nonatomic,copy)NSString* pos;
@property(nonatomic,copy)NSString* q_content;
@property(nonatomic,copy)NSString* q_counttime;
@property(nonatomic,copy)NSString* q_end_time;          //揭晓时间
@property(nonatomic,copy)NSString* q_showtime;          //揭晓动画
@property(nonatomic,copy)NSString* q_uid;
@property(nonatomic,copy)NSString* q_user;
@property(nonatomic,copy)NSString* q_user_code;         //中奖码
@property(nonatomic,copy)NSString* qishu;
@property(nonatomic,copy)NSString* renqi;
@property(nonatomic,copy)NSString* shenyurenshu;
@property(nonatomic,copy)NSString* sid;
@property(nonatomic,copy)NSString* thumb;
@property(nonatomic,copy)NSString* time;
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* title2;
@property(nonatomic,copy)NSString* title_style;
@property(nonatomic,copy)NSString* xsjx_time;
@property(nonatomic,copy)NSString* yunjiage;
@property(nonatomic,copy)NSString* zongrenshu;
@property(nonatomic,copy)NSString* shopcodes_1;
@end


@interface CartResult : OneBaseParser
@property (nonatomic,copy)NSNumber  *state;
@property (nonatomic,copy)NSString  *str;
@end

@interface CartResultAsnyc : OneBaseParser
@property (nonatomic,copy)NSNumber  *state;
@end

@interface CartModel : NSObject
+ (void)addorUpdateCart:(CartItem*)item;
+ (void)quertCart:(NSString*)key value:(NSObject*)value block:(void (^)(NSArray* result))block;
+ (NSArray*)quertCart2:(NSString*)key value:(NSObject*)value;
+ (void)removeCart:(CartItem*)item;
+ (void)removeAllCart;
+ (void)getCartState:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)getCartPayIpAddress:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

#pragma mark - server
+ (void)getCartInServer:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)postCartInServer:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)queryCartResultInServer:(NSString*)rid success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (BOOL)delCartInServer:(int)codeId;
+ (CartAddResult)addCartInServer:(CartItem*)item;

@end