//
//  HomeModel.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol  HomeAd <NSObject>
@end

//解析广告的第二层
@interface HomeAd : OneBaseParser
@property (nonatomic,copy)NSString* pid;   //广告图的id，不是商品id；
@property (nonatomic,copy)NSString* img;
@property (nonatomic,copy)NSString* link;
@property (nonatomic,copy)NSString* title;
@property (nonatomic,copy)NSString* color;
@property (nonatomic,copy)NSString* _type;
@end

@interface HomeTenModel : OneBaseParser
@property (nonatomic,copy)NSString* pid;
@property (nonatomic,copy)NSString* sid;
@property (nonatomic,copy)NSString* cateid;
@property (nonatomic,copy)NSString* brandid;
@property (nonatomic,copy)NSString* title;
@property (nonatomic,copy)NSString* money;
@property (nonatomic,copy)NSString* yunjiage;
@property (nonatomic,copy)NSString* zongrenshu;
@property (nonatomic,copy)NSString* canyurenshu;
@property (nonatomic,copy)NSString* shenyurenshu;
@property (nonatomic,copy)NSString* qishu;
@property (nonatomic,copy)NSString* thumb;
@property (nonatomic,copy)NSString* time;
@end

//解析广告的第一层
@interface HomeAdList : OneBaseParser
@end

@protocol  HomeNewing <NSObject>
@end
//最新揭晓
@interface HomeNewing : OneBaseParser
@property (nonatomic,copy)NSString* brandid;
@property (nonatomic,copy)NSString* canyurenshu;
@property (nonatomic,copy)NSString* cateid;
@property (nonatomic,copy)NSString* gonumber;
@property (nonatomic,copy)NSString* huode;
@property (nonatomic,copy)NSString* ip;
@property (nonatomic,copy)NSString* pid;
@property (nonatomic,copy)NSString* q_end_time;
@property (nonatomic,copy)NSString* q_showtime;
@property (nonatomic,copy)NSString* q_uid;
@property (nonatomic,copy)NSString* q_user_code;
@property (nonatomic,copy)NSString* qishu;
@property (nonatomic,copy)NSString* shenyurenshu;
@property (nonatomic,copy)NSString* thumb;
@property (nonatomic,copy)NSString* title;
@property (nonatomic,copy)NSString* uphoto;
@property (nonatomic,copy)NSString* username;
@property (nonatomic,copy)NSString* zongrenshu;
@property (nonatomic,copy)NSString* sid;
@end

@protocol  HomeNewed <NSObject>
@end
@interface HomeNewed : OneBaseParser
@property (nonatomic,copy)NSNumber* codeGoodsID;
@property (nonatomic,copy)NSString* codeGoodsPic;
@property (nonatomic,copy)NSString* codeGoodsSName;
@property (nonatomic,copy)NSNumber* codeID;
@property (nonatomic,copy)NSNumber* codePeriod;
@property (nonatomic,copy)NSNumber* codeState;
@property (nonatomic,copy)NSString* userName;
@property (nonatomic,copy)NSString* userWeb;
@end

@protocol  HomeHotest <NSObject>
@end

@interface HomeHotest : OneBaseParser
@property (nonatomic,copy)NSString* pid;
@property (nonatomic,copy)NSString* sid;
@property (nonatomic,copy)NSString* cateid;
@property (nonatomic,copy)NSString* brandid;
@property (nonatomic,copy)NSString* title;
@property (nonatomic,copy)NSString* money;
@property (nonatomic,copy)NSString* yunjiage;
@property (nonatomic,copy)NSString* zongrenshu;
@property (nonatomic,copy)NSString* canyurenshu;
@property (nonatomic,copy)NSString* shenyurenshu;
@property (nonatomic,copy)NSString* qishu;
@property (nonatomic,copy)NSString* thumb;
@property (nonatomic,copy)NSString* time;
@property (nonatomic,copy)NSString* gonumber;
@end

@interface HomeLimitedProModel : OneBaseParser
@property (nonatomic,copy)NSString* _id;
@property (nonatomic,copy)NSString* height;
@property (nonatomic,copy)NSString* image;
@property (nonatomic,copy)NSString* url;
@property (nonatomic,copy)NSString* width;
@end

@interface HomeGuideProModel : OneBaseParser
@property (nonatomic,copy)NSString* click_url;
@property (nonatomic,copy)NSString* create_time;
@property (nonatomic,copy)NSString* end_time;
@property (nonatomic,copy)NSString* event;
@property (nonatomic,copy)NSString* _id;
@property (nonatomic,copy)NSString* image_height_hdpi;
@property (nonatomic,copy)NSString* image_height_xhdpi;
@property (nonatomic,copy)NSString* image_url_hdpi;
@property (nonatomic,copy)NSString* image_width_xhdpi;
@property (nonatomic,copy)NSString* start_time;
@property (nonatomic,copy)NSString* title;
@property (nonatomic,copy)NSString* update_time;
@end

@interface WinProModel : OneBaseParser
@property (nonatomic,copy)NSString* huode;
@property (nonatomic,copy)NSString* pid;
@property (nonatomic,copy)NSString* qishu;
@property (nonatomic,copy)NSString* time;
@property (nonatomic,copy)NSString* title;
@end

@interface HomeModel : NSObject
+ (void)getAds:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)getNewing:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)getHotest:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)getTenPro:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)getLimitedPro:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)getHomeGuide:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
+ (void)getWinProduct:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
