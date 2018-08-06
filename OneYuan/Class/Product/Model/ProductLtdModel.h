//
//  ProductLtdModel.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/23.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "OneBaseParser.h"

@interface ProductLtdItem : OneBaseParser
@property (nonatomic,copy)NSString* brandid;
@property (nonatomic,copy)NSString* canyurenshu;
@property (nonatomic,copy)NSString* cateid;
@property (nonatomic,copy)NSString* codes_table;
@property (nonatomic,copy)NSString* content;
@property (nonatomic,copy)NSString* def_renshu;
@property (nonatomic,copy)NSString* description;
@property (nonatomic,copy)NSString* gonumber;
@property (nonatomic,copy)NSString* keywords;
@property (nonatomic,copy)NSString* maxqishu;
@property (nonatomic,copy)NSString* member_object;
@property (nonatomic,copy)NSString* money;
@property (nonatomic,copy)NSString* order;
@property (nonatomic,copy)NSString* picarr;
@property (nonatomic,copy)NSString* pid;
@property (nonatomic,copy)NSString* pos;
@property (nonatomic,copy)NSString* q_content;
@property (nonatomic,copy)NSString* q_counttime;
@property (nonatomic,copy)NSString* q_eng_time;
@property (nonatomic,copy)NSString* q_showtime;
@property (nonatomic,copy)NSString* q_uid;
@property (nonatomic,copy)NSString* q_user;
@property (nonatomic,copy)NSString* q_user_code;
@property (nonatomic,copy)NSString* qishu;
@property (nonatomic,copy)NSString* renqi;
@property (nonatomic,copy)NSString* shenyurenshu;
@property (nonatomic,copy)NSString* sid;
@property (nonatomic,copy)NSString* thumb;
@property (nonatomic,copy)NSString* time;
@property (nonatomic,copy)NSString* title;
@property (nonatomic,copy)NSString* title2;
@property (nonatomic,copy)NSString* title_style;
@property (nonatomic,copy)NSString* xsjx_time;
@property (nonatomic,copy)NSString* yunjiage;
@property (nonatomic,copy)NSString* zongrenshu;
@end

@interface ProductLtdList : OneBaseParser
@property (nonatomic,copy)NSArray* rows;
@end

@interface ProductHistoryLtdItem : OneBaseParser
@property (nonatomic,copy)NSString* brandid;
@property (nonatomic,copy)NSString* canyurenshu;
@property (nonatomic,copy)NSString* cateid;
@property (nonatomic,copy)NSString* codes_table;
@property (nonatomic,copy)NSString* content;
@property (nonatomic,copy)NSString* def_renshu;
@property (nonatomic,copy)NSString* description;
@property (nonatomic,copy)NSString* gonumber;
@property (nonatomic,copy)NSString* keywords;
@property (nonatomic,copy)NSString* maxqishu;
@property (nonatomic,copy)NSString* member_object;
@property (nonatomic,copy)NSString* money;
@property (nonatomic,copy)NSString* order;
@property (nonatomic,copy)NSString* picarr;
@property (nonatomic,copy)NSString* pid;
@property (nonatomic,copy)NSString* pos;
@property (nonatomic,copy)NSString* q_content;
@property (nonatomic,copy)NSString* q_counttime;
@property (nonatomic,copy)NSString* q_eng_time;
@property (nonatomic,copy)NSString* q_showtime;
@property (nonatomic,copy)NSString* q_uid;
@property (nonatomic,copy)NSString* q_user;
@property (nonatomic,copy)NSString* q_user_code;
@property (nonatomic,copy)NSString* qishu;
@property (nonatomic,copy)NSString* renqi;
@property (nonatomic,copy)NSString* shenyurenshu;
@property (nonatomic,copy)NSString* sid;
@property (nonatomic,copy)NSString* thumb;
@property (nonatomic,copy)NSString* time;
@property (nonatomic,copy)NSString* title;
@property (nonatomic,copy)NSString* title2;
@property (nonatomic,copy)NSString* title_style;
@property (nonatomic,copy)NSString* xsjx_time;
@property (nonatomic,copy)NSString* yunjiage;
@property (nonatomic,copy)NSString* zongrenshu;
@end
//解析广告的第一层
@interface ProductHistoryLtdList : OneBaseParser
@property (nonatomic,copy)NSArray* rows;
@end

@interface ProductLtdModel : OneBaseParser
+ (void)getLtdProduct:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getHistoryLtdProduct:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

@end
