//
//  Product100Model.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/11.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "OneBaseParser.h"

@interface RecodeListModel : OneBaseParser
@property(nonatomic,copy)NSString* time;
@property(nonatomic,copy)NSString* username;
@property(nonatomic,copy)NSString* uid;
@property(nonatomic,copy)NSString* shopid;
@property(nonatomic,copy)NSString* shopname;
@property(nonatomic,copy)NSString* shopqishu;
@property(nonatomic,copy)NSString* gonumber;
@property(nonatomic,copy)NSString* time_add;

@end


@interface Product100Model : NSObject
+ (void)getRecodelist:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
