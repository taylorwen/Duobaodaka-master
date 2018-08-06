//
//  DelegateModel.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/5.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UpdateModel : NSObject
@property (nonatomic,copy)NSString* version;
@property (nonatomic,copy)NSString* force_update;
@end

@interface DelegateModel : NSObject
+ (void)checkUpdate:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end