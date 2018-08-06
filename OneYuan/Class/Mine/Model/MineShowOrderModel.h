//
//  MineShowOrderModel.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  MineShowOrderItem <NSObject>
@end

@interface MineShowOrderItem : OneBaseParser
@property(nonatomic,copy)NSString   *gonumber;
@property(nonatomic,copy)NSString   *huode;
@property(nonatomic,copy)NSString   *q_end_time;
@property(nonatomic,copy)NSString   *sd_content;
@property(nonatomic,copy)NSString   *sd_email;
@property(nonatomic,copy)NSString   *sd_id;
@property(nonatomic,copy)NSString   *sd_ip;
@property(nonatomic,copy)NSString   *sd_mobile;
@property(nonatomic,copy)NSString   *sd_photolist;
@property(nonatomic,copy)NSString   *sd_photo;
@property(nonatomic,copy)NSString   *title;
@property(nonatomic,copy)NSString   *sd_ping;
@property(nonatomic,copy)NSString   *sd_qishu;
@property(nonatomic,copy)NSString   *sd_shopid;
@property(nonatomic,copy)NSString   *sd_shopsid;
@property(nonatomic,copy)NSString   *sd_thumbs;
@property(nonatomic,copy)NSString   *sd_time;
@property(nonatomic,copy)NSString   *sd_title;
@property(nonatomic,copy)NSString   *sd_userid;
@property(nonatomic,copy)NSString   *sd_username;
@property(nonatomic,copy)NSString   *sd_zhan;
@end

@interface MineUnshowOrderItem : OneBaseParser
@property(nonatomic,copy)NSString   *sid;
@property(nonatomic,copy)NSString   *shop_id;
@property(nonatomic,copy)NSString   *thumb;
@property(nonatomic,copy)NSString   *title;
@property(nonatomic,copy)NSString   *ip;
@property(nonatomic,copy)NSString   *qishu;
@property(nonatomic,copy)NSString   *gonumber;
@property(nonatomic,copy)NSString   *q_end_time;
@property(nonatomic,copy)NSString   *q_user_code;
@property(nonatomic,copy)NSString   *zongrenshu;
@end

@interface MineShowOrderList : OneBaseParser
@property (nonatomic,copy)NSNumber  *postCount;
@property (nonatomic,copy)NSNumber  *unPostCount;
@property (nonatomic,copy)NSArray   *listItems;
@end

@interface MineShowOrderModel : NSObject
+ (void)getShowOrderlist:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getUnShowOrderlist:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)postShowOrderImage:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)postShowOrderContent:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
