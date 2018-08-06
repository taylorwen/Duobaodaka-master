//
//  ShowOrderModel.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowOrderItem : OneBaseParser
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

@interface ShowOrderList : OneBaseParser
@property(nonatomic,copy)NSNumber   *count;
@property(nonatomic,copy)NSArray    *Rows;
@end

@interface ShowOrderSingleItem : OneBaseParser
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

@interface ShowOrderSingleItemList : OneBaseParser
@property(nonatomic,strong)ShowOrderSingleItem    *Rows;
@end

@interface ShowOrderDetail : OneBaseParser
@property(nonatomic,copy)NSString       *text;
@end

@interface ShowOrderReplyList : OneBaseParser
@property(nonatomic,copy)NSArray        *Rows;
@end

@interface ShowOrderModel : NSObject
+ (void)getShowGoodsList:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getPostDetail:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getPostSingleDetail:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getUploadPostContent:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
