//
//  ProdcutBuyModel.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProdcutBuyItem : OneBaseParser
@property(nonatomic,copy)NSString* code;
@property(nonatomic,copy)NSString* code_tmp;
@property(nonatomic,copy)NSString* company;
@property(nonatomic,copy)NSString* company_code;
@property(nonatomic,copy)NSString* company_money;
@property(nonatomic,copy)NSString* email;
@property(nonatomic,copy)NSString* gonumber;
@property(nonatomic,copy)NSString* goucode;
@property(nonatomic,copy)NSString* huode;
@property(nonatomic,copy)NSString* pid;
@property(nonatomic,copy)NSString* ip;
@property(nonatomic,copy)NSString* mobile;
@property(nonatomic,copy)NSString* moneycount;
@property(nonatomic,copy)NSString* pay_type;
@property(nonatomic,copy)NSString* shopid;
@property(nonatomic,copy)NSString* shopname;
@property(nonatomic,copy)NSString* shopqishu;
@property(nonatomic,copy)NSString* status;
@property(nonatomic,copy)NSString* time;
@property(nonatomic,copy)NSString* uid;
@property(nonatomic,copy)NSString* uphoto;
@property(nonatomic,copy)NSString* username;
@end

@interface ProdcutBuyCode : OneBaseParser
@property(nonatomic,copy)NSString* codes;

@end

@interface ProdcutBuyList : OneBaseParser
@property(nonatomic,copy)NSNumber* Count;
@property(nonatomic,copy)NSArray*  Rows;
@end

@interface ProdcutBuyModel : NSObject
+ (void)getGoodBuyList:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

+ (void)getGoodBuyCode:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
