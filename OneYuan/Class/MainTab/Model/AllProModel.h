//
//  AllProModel.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AllProPeriod : OneBaseParser
@property (nonatomic,copy)NSString* goodsID;
@property (nonatomic,copy)NSString* codeID;
@property (nonatomic,copy)NSString* codeState;
@property (nonatomic,copy)NSString* codePeriod;
@end

@interface AllProPeriodList : OneBaseParser
@property (nonatomic,copy)NSArray* Rows;
@end

@interface AllProItme : OneBaseParser
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
@property (nonatomic,copy)NSString* time;           //购买时间

@end

@interface AllProList : OneBaseParser
@property (nonatomic,copy)NSNumber* count;
@property (nonatomic,copy)NSArray* Rows;
@end

@interface AllProModel : NSObject
+(void)getAllProduct:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+(void)getGoodsPeriodByCodeId:(NSString*)codeId success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
