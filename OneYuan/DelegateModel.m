//
//  DelegateModel.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/5.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "DelegateModel.h"

@implementation UpdateModel
@synthesize force_update,version;
@end

@implementation DelegateModel
+ (void)checkUpdate:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    [[XBApi SharedXBApi] requestWithURL:oyNewCheckUpdates paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}
@end
