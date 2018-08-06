//
//  NewestModel.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol  NewestProItme <NSObject>

@end

@interface NewestProItme : OneBaseParser
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
@property (nonatomic,copy)NSString* shengyutime;
@end

@interface NewestProList : OneBaseParser
@property (nonatomic,copy)NSNumber* count;
@property (nonatomic,copy)NSArray* Rows;
@end

@interface HistoryProItem : OneBaseParser
@property (nonatomic,copy)NSString* gonumber;
@property (nonatomic,copy)NSString* huode;
@property (nonatomic,copy)NSString* pid;
@property (nonatomic,copy)NSString* ip;
@property (nonatomic,copy)NSString* q_end_time;
@property (nonatomic,copy)NSString* q_uid;
@property (nonatomic,copy)NSString* q_user_code;
@property (nonatomic,copy)NSString* qishu;
@property (nonatomic,copy)NSString* shopqishu;
@property (nonatomic,copy)NSString* shopid;
@property (nonatomic,copy)NSString* sid;
@property (nonatomic,copy)NSString* status;
@property (nonatomic,copy)NSString* uid;
@property (nonatomic,copy)NSString* uphoto;
@property (nonatomic,copy)NSString* username;

@end

@interface NewestModel : NSObject
+(void)getAllNewest:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+(void)getAllHistory:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

@end
