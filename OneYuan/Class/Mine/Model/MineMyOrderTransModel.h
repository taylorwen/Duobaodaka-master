//
//  MineMyOrderTransModel.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MineMyOrderTransInfo : OneBaseParser
@property(nonatomic,copy)NSString* create_time;
@property(nonatomic,copy)NSString* go_comments;
@property(nonatomic,copy)NSString* go_status;
@end

@interface MineMyOrderTrans : OneBaseParser
@property(nonatomic,copy)NSArray*       zhongjiang_status_list;
@property(nonatomic,copy)NSString*      kuaidi_jianxie;
@property(nonatomic,copy)NSString*      kuaidi_hao;
@property(nonatomic,copy)NSString*      kuaidi_zhongwen;
@property(nonatomic,copy)NSString*      shouhuo_address;
@property(nonatomic,copy)NSString*      go_status;
@end

@interface ExpressModel : OneBaseParser
@property(nonatomic,copy)NSString*      time;
@property(nonatomic,copy)NSString*      context;
@property(nonatomic,copy)NSString*      ftime;
@end

@interface MineMyOrderTransModel : NSObject

+ (void)getUserOrderTrans:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getUserExpressInfo:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getUserConfirmGood:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
