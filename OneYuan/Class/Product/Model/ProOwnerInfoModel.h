//
//  ProOwnerInfoModel.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/21.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OwnerInfo : OneBaseParser

@property (nonatomic, copy)NSString* code;
@property (nonatomic, copy)NSString* code_tmp;
@property (nonatomic, copy)NSString* company;
@property (nonatomic, copy)NSString* company_code;
@property (nonatomic, copy)NSString* company_money;
@property (nonatomic, copy)NSString* email;
@property (nonatomic, copy)NSString* gonumber;
@property (nonatomic, copy)NSString* goucode;
@property (nonatomic, copy)NSString* huode;
@property (nonatomic, copy)NSString* pid;
@property (nonatomic, copy)NSString* ip;
@property (nonatomic, copy)NSString* mobile;
@property (nonatomic, copy)NSString* moneycount;
@property (nonatomic, copy)NSString* pay_type;
@property (nonatomic, copy)NSString* q_end_time;
@property (nonatomic, copy)NSString* shopid;
@property (nonatomic, copy)NSString* shopname;
@property (nonatomic, copy)NSString* shopqishu;
@property (nonatomic, copy)NSString* uphoto;
@property (nonatomic, copy)NSString* username;

@end

@interface OwnerInfoStatus : OneBaseParser

@property (nonatomic, copy)NSString* resultCode;
@property (nonatomic, copy)NSString* resultMessage;



@end


@interface ProOwnerInfoModel : NSObject

+ (void)getOwnerInfo:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;



@end
