//
//  MineMyAddressModel.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineMyAddressItem : OneBaseParser
@property(nonatomic,copy)NSString   *isdefault;
@property(nonatomic,copy)NSString   *jiedao;
@property(nonatomic,copy)NSString   *mobile;
@property(nonatomic,copy)NSString   *pid;
@property(nonatomic,copy)NSString   *qq;
@property(nonatomic,copy)NSString   *sheng;
@property(nonatomic,copy)NSString   *shi;
@property(nonatomic,copy)NSString   *shouhuoren;
@property(nonatomic,copy)NSString   *tell;
@property(nonatomic,copy)NSString   *time;
@property(nonatomic,copy)NSString   *uid;
@property(nonatomic,copy)NSString   *xian;
@property(nonatomic,copy)NSString   *youbian;

@end

@interface MineMyAddressModel : NSObject

+ (void)getMyAddress:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)addMyAddress:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)delMyAddress:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)setDefault:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)editAddress:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
