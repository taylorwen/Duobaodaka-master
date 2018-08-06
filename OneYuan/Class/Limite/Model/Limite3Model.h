//
//  Limite3Model.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/6.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThreeProModel : OneBaseParser
@property (nonatomic,copy)NSString*         _id;
@property (nonatomic,copy)NSString*         canyurenshu;
@property (nonatomic,copy)NSString*         money;
@property (nonatomic,copy)NSString*         open_time;
@property (nonatomic,copy)NSString*         q_end_time;
@property (nonatomic,copy)NSString*         q_user_code;
@property (nonatomic,copy)NSString*         qishu;
@property (nonatomic,copy)NSString*         shenyurenshu;
@property (nonatomic,copy)NSString*         sid;
@property (nonatomic,copy)NSString*         thumb;
@property (nonatomic,copy)NSString*         title;
@property (nonatomic,copy)NSString*         xsjx_time;
@property (nonatomic,copy)NSString*         yunjiage;
@property (nonatomic,copy)NSString*         zongrenshu;
@property (nonatomic,copy)NSString*         username;
@end

@interface ThreeProStatus : NSObject
@property (nonatomic,copy)NSMutableArray*   proArr;
@property (nonatomic,copy)NSString*         resultCode;
@property (nonatomic,copy)NSString*         resultMessage;
@end

@interface HuaFeiModel : OneBaseParser
@property (nonatomic,copy)NSString*         brandid;
@property (nonatomic,copy)NSString*         canyurenshu;
@property (nonatomic,copy)NSString*         cateid;
@property (nonatomic,copy)NSString*         money;
@property (nonatomic,copy)NSString*         open_time;
@property (nonatomic,copy)NSString*         pid;
@property (nonatomic,copy)NSString*         q_end_time;
@property (nonatomic,copy)NSString*         q_uid;
@property (nonatomic,copy)NSString*         qishu;
@property (nonatomic,copy)NSString*         server_time;
@property (nonatomic,copy)NSString*         shenyurenshu;
@property (nonatomic,copy)NSString*         sid;
@property (nonatomic,copy)NSString*         status;
@property (nonatomic,copy)NSString*         thumb;
@property (nonatomic,copy)NSString*         title;
@property (nonatomic,copy)NSString*         xsjx_time;
@property (nonatomic,copy)NSString*         xsjx_time1;
@property (nonatomic,copy)NSString*         yunjiage;
@property (nonatomic,copy)NSString*         zongrenshu;
@end

@interface ProStatusModel : OneBaseParser
@property (nonatomic,copy)NSString*         canyurenshu;
@property (nonatomic,copy)NSString*         img;
@property (nonatomic,copy)NSString*         mobile;
@property (nonatomic,copy)NSString*         open_time;
@property (nonatomic,copy)NSString*         q_uid;
@property (nonatomic,copy)NSString*         q_user_code;
@property (nonatomic,copy)NSString*         qishu;
@property (nonatomic,copy)NSString*         server_time;
@property (nonatomic,copy)NSString*         shenyurenshu;
@property (nonatomic,copy)NSString*         sid;
@property (nonatomic,copy)NSString*         status;
@property (nonatomic,copy)NSString*         thumb;
@property (nonatomic,copy)NSString*         title;
@property (nonatomic,copy)NSString*         username;
@property (nonatomic,copy)NSString*         xsjx_time;
@property (nonatomic,copy)NSString*         zongrenshu;
@end

@interface AutoLotteryModel : OneBaseParser
@property (nonatomic,copy)NSString*         canyurenshu;
@property (nonatomic,copy)NSString*         img;
@property (nonatomic,copy)NSString*         mobile;
@property (nonatomic,copy)NSString*         open_time;
@property (nonatomic,copy)NSString*         q_uid;
@property (nonatomic,copy)NSString*         q_user_code;
@property (nonatomic,copy)NSString*         qishu;
@property (nonatomic,copy)NSString*         server_time;
@property (nonatomic,copy)NSString*         shenyurenshu;
@property (nonatomic,copy)NSString*         sid;
@property (nonatomic,copy)NSString*         thumb;
@property (nonatomic,copy)NSString*         title;
@property (nonatomic,copy)NSString*         username;
@property (nonatomic,copy)NSString*         xsjx_time;
@property (nonatomic,copy)NSString*         zongrenshu;
@end

@interface BuyRecordModel : OneBaseParser
@property (nonatomic,copy)NSString*         go_time;
@property (nonatomic,copy)NSString*         gonumber;
@property (nonatomic,copy)NSString*         huode;
@property (nonatomic,copy)NSString*         qishu;
@property (nonatomic,copy)NSString*         status;
@property (nonatomic,copy)NSString*         xsjx_time;
@end

@interface Limite3Model : NSObject
+ (void)getLimite3Products:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getLimiteTimePeriod:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getLimiteHuafei:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getSharedUser:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getautoBuy:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getautoLottery:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getBuyRecordList:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
