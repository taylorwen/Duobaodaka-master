//
//  PersonModel.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/4.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "OneBaseParser.h"

@interface UsernameModel : OneBaseParser
@property (nonatomic,copy)NSString* uid;
@property (nonatomic,copy)NSString* username;
@end


@interface QianmingModel : OneBaseParser
@property (nonatomic,copy)NSString* uid;
@property (nonatomic,copy)NSString* qianming;
@end

@interface PasswordModel : OneBaseParser
@property (nonatomic,copy)NSString* password;
@end

@interface PersonModel : NSObject

+ (void)doEditUsername:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)doEditQianming:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)doChangePassword:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
