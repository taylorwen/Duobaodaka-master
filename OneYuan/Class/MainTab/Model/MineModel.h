//
//  MineModel.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/9/14.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QQListModel : OneBaseParser
@property (nonatomic,copy)NSString* name;
@property (nonatomic,copy)NSString* qq;
@property (nonatomic,copy)NSString* full;
@end

@interface MineModel : NSObject
+(void)getServiceQQNumber:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
