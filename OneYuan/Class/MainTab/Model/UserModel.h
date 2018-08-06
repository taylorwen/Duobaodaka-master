//
//  UserModel.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : OneBaseParser
@property(nonatomic,copy)NSString* addgroup;
@property(nonatomic,copy)NSString* band;
@property(nonatomic,copy)NSString* email;
@property(nonatomic,copy)NSString* emailcode;
@property(nonatomic,copy)NSString* groupName;
@property(nonatomic,copy)NSString* groupid;
@property(nonatomic,copy)NSString* img;
@property(nonatomic,copy)NSString* jingyan;
@property(nonatomic,copy)NSString* login_time;
@property(nonatomic,copy)NSString* mobile;
@property(nonatomic,copy)NSString* mobilecode;
@property(nonatomic,copy)NSString* money;
@property(nonatomic,copy)NSString* passcode;
@property(nonatomic,copy)NSString* password;
@property(nonatomic,copy)NSString* qianming;
@property(nonatomic,copy)NSString* reg_key;
@property(nonatomic,copy)NSString* score;
@property(nonatomic,copy)NSString* time;
@property(nonatomic,copy)NSString* uid;
@property(nonatomic,copy)NSString* user_ip;
@property(nonatomic,copy)NSString* username;
@property(nonatomic,copy)NSString* yaoqing;
@end


@interface OYUser : OneBaseParser
@property(nonatomic,copy)NSString* username;
@property(nonatomic,copy)NSString* ip;
@end

@interface StartAdsModel : OneBaseParser
@property(nonatomic,copy)NSString* _id;
@property(nonatomic,copy)NSString* click_url;
@property(nonatomic,copy)NSString* end_time;
@property(nonatomic,copy)NSString* start_time;
@property(nonatomic,copy)NSString* image_url;
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* update_time;
@end

@interface UserPublishStatus : OneBaseParser
@property(nonatomic,copy)NSString* versionStatus;
@end

@interface UserModel : NSObject

+ (void)getUserInfo:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getUserIp:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getUserAvatar:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getStartAds:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getPublishStatus:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
