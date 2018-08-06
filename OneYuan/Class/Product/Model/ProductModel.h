//
//  ProductModel.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductPics : OneBaseParser
@property(nonatomic,copy)NSString* picName;
@property(nonatomic,copy)NSString* picRemark;
@end

@interface ProductInfo : OneBaseParser
@property(nonatomic,copy)NSString* brandid;
@property(nonatomic,copy)NSString* canyurenshu;
@property(nonatomic,copy)NSString* cateid;
@property(nonatomic,copy)NSString* codes_table;
@property(nonatomic,copy)NSString* content;
@property(nonatomic,copy)NSString* def_renshu;
@property(nonatomic,copy)NSString* description;
@property(nonatomic,copy)NSString* gonumber;
@property(nonatomic,copy)NSString* pid;
@property(nonatomic,copy)NSString* keywords;
@property(nonatomic,copy)NSString* maxqishu;
@property(nonatomic,copy)NSString* money;
@property(nonatomic,copy)NSString* order;
@property(nonatomic,copy)NSString* picarr;              //商品图片列表
@property(nonatomic,copy)NSString* pos;
@property(nonatomic,copy)NSString* q_content;
@property(nonatomic,copy)NSString* q_counttime;
@property(nonatomic,copy)NSString* q_end_time;          //揭晓时间
@property(nonatomic,copy)NSString* q_showtime;          //揭晓动画
@property(nonatomic,copy)NSString* q_uid;
@property(nonatomic,copy)NSString* q_user;
@property(nonatomic,copy)NSString* q_user_code;         //中奖码
@property(nonatomic,copy)NSString* qishu;
@property(nonatomic,copy)NSString* renqi;
@property(nonatomic,copy)NSString* shenyurenshu;
@property(nonatomic,copy)NSString* sid;
@property(nonatomic,copy)NSString* thumb; //商品图片
@property(nonatomic,copy)NSString* time;
@property(nonatomic,copy)NSString* title;
@property(nonatomic,copy)NSString* title2;
@property(nonatomic,copy)NSString* title_style;
@property(nonatomic,copy)NSString* xsjx_time;
@property(nonatomic,copy)NSString* yunjiage;
@property(nonatomic,copy)NSString* zongrenshu;
@property(nonatomic,copy)NSString* shopcodes_1;
@property(nonatomic,copy)NSString* shengyutime;   //剩余时间为正数，则正在揭晓，剩余时间为负数，则已揭晓；
@property(nonatomic,copy)NSString* lottery_code;
@property(nonatomic,copy)NSString* lottery_no;
@property(nonatomic,copy)NSString* lottery_time;
@end

//中奖者信息
@interface ProductInfoChild : OneBaseParser
@property(nonatomic,copy)NSString* addgroup;
@property(nonatomic,copy)NSString* band;
@property(nonatomic,copy)NSString* email;
@property(nonatomic,copy)NSString* emailcode;
@property(nonatomic,copy)NSString* groupid;
@property(nonatomic,copy)NSString* img;
@property(nonatomic,copy)NSString* jingyan;
@property(nonatomic,copy)NSString* login;
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

@interface ProductNextPeriod : OneBaseParser
@property(nonatomic,copy)NSString* pid;
@property(nonatomic,copy)NSString* qishu;
@property(nonatomic,copy)NSString* sid;
@end

@interface ProductTopic : OneBaseParser
@property(nonatomic,copy)NSNumber* Topic;
@property(nonatomic,copy)NSNumber* Reply;
@end

@interface ProductDetail : OneBaseParser
@property(nonatomic,copy)NSArray* Rows1;
@property(nonatomic,strong)ProductInfo* Rows2;
@property(nonatomic,strong)ProductTopic* Rows3;
@end

@interface ProductLottery : OneBaseParser
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
@property (nonatomic,copy)NSString* money;
@end

@interface ProductCodeBuy : OneBaseParser
@property(nonatomic,copy)NSString* codes;
@end

@interface ProductLotteryDetail : OneBaseParser
@property(nonatomic,copy)NSArray* Rows1;
@property(nonatomic,strong)ProductLottery* Rows2;
@property(nonatomic,strong)ProductTopic* Rows3;
@property(nonatomic,strong)NSArray* Rows4;
@end

@interface ProductModel : NSObject
+ (void)getGoodDetail:  (NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getGoodLottery: (NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getCodesBuy:    (NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

@end
