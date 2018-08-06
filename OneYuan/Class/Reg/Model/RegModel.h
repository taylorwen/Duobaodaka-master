//
//  RegModel.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>
//请求验证码
@interface RegSms : OneBaseParser
@property(nonatomic,copy)NSString* mobile;
@property(nonatomic,copy)NSString* mobilecode;

@end
//用户注册
@interface RegResut : OneBaseParser
@property(nonatomic,copy)NSString* mobile;
@property(nonatomic,copy)NSString* password;
@property(nonatomic,copy)NSString* mobilecode;
@end

@interface regBGModel : OneBaseParser
@property(nonatomic,copy)NSString* _id;
@property(nonatomic,copy)NSString* height;
@property(nonatomic,copy)NSString* image;
@property(nonatomic,copy)NSString* url;
@property(nonatomic,copy)NSString* width;
@end


@interface RegModel : NSObject

+ (void)regPhoneSms:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)regPhoneCode:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)regBackgroundImage:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)regCompareSeverCode:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
