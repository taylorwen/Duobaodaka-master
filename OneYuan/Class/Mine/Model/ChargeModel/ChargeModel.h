//
//  ChargeModel.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/28.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>
//请求订单返回数据
@interface ChargeOrder : OneBaseParser
@property(nonatomic,copy)NSString*  code;
@property(nonatomic,copy)NSString*  money;
@property(nonatomic,copy)NSString*  pay_type;
@property(nonatomic,copy)NSString*  pid;
@property(nonatomic,copy)NSString*  scookies;
@property(nonatomic,copy)NSString*  score;
@property(nonatomic,copy)NSString*  status;
@property(nonatomic,copy)NSString*  time;
@property(nonatomic,copy)NSString*  uid;
@end
//充值成功返回数据
@interface ChargeResult : OneBaseParser
@property(nonatomic,copy)NSString*  code;
@property(nonatomic,copy)NSString*  money;
@property(nonatomic,copy)NSString*  pay_type;
@property(nonatomic,copy)NSString*  pid;
@property(nonatomic,copy)NSString*  scookies;
@property(nonatomic,copy)NSString*  score;
@property(nonatomic,copy)NSString*  status;
@property(nonatomic,copy)NSString*  time;
@property(nonatomic,copy)NSString*  uid;
@end

//支付传参model
@interface BuyRequestModel : OneBaseParser
@property(nonatomic,copy)NSString*  sid;
@property(nonatomic,copy)NSString*  gonumber;   //此处就是单个商品的购买份数；
@property(nonatomic,copy)NSString*  pid;
@property(nonatomic,copy)NSString*  qishu;
@property(nonatomic,copy)NSString*  yunjiage;
@property(nonatomic,copy)NSString*  codes;
@end

//购买成功返回的单个商品信息
@interface BuySuccessResult : OneBaseParser
@property(nonatomic,copy)NSString*  codes;
@property(nonatomic,copy)NSString*  gonumber;
@property(nonatomic,copy)NSString*  pid;
@property(nonatomic,copy)NSString*  qishu;
@property(nonatomic,copy)NSString*  sid;
@end

//支付宝验证
@interface paymentVerifyModel : OneBaseParser

@end

@interface ChargeModel : NSObject

+(void)getChargeOrder:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+(void)getChargeResult:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+(void)getBuyResult:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+(void)getVerifyResult:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

@end
