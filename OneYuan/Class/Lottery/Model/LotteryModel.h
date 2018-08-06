//
//  LotteryModel.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/12.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "OneBaseParser.h"

@interface HistoryLotteryModel : OneBaseParser
@property(nonatomic,copy)NSString* gonumber;
@property(nonatomic,copy)NSString* huode;
@property(nonatomic,copy)NSString* pid;
@property(nonatomic,copy)NSString* ip;
@property(nonatomic,copy)NSString* q_end_time;
@property(nonatomic,copy)NSString* q_uid;
@property(nonatomic,copy)NSString* q_user_code;
@property(nonatomic,copy)NSString* qishu;
@property(nonatomic,copy)NSString* shopid;
@property(nonatomic,copy)NSString* shopqishu;
@property(nonatomic,copy)NSString* sid;
@property(nonatomic,copy)NSString* status;
@property(nonatomic,copy)NSString* uid;
@property(nonatomic,copy)NSString* uphoto;
@property(nonatomic,copy)NSString* username;
@property(nonatomic,copy)NSString* shengyutime;
@end

@interface LotteryModel : NSObject
+ (void)getHistoryLotterylist:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
