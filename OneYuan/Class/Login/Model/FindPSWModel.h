//
//  FindPSWModel.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/22.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

//请求验证码
@interface FindRegSms : OneBaseParser
@property(nonatomic,copy)NSString* mobile;
@property(nonatomic,copy)NSString* mobilecode;

@end
//用户注册
@interface FindRegResut : OneBaseParser
@property(nonatomic,copy)NSString* mobile;
@property(nonatomic,copy)NSString* password;
@property(nonatomic,copy)NSString* mobilecode;
@end


@interface FindPSWModel : NSObject
+ (void)findPhoneSms:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)reSetPassword:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)findCompareSeverCode:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
