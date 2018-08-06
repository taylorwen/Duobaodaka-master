//
//  MineModel.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/9/14.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineModel.h"

@implementation QQListModel
@synthesize name,qq,full;

@end

@implementation MineModel
+(void)getServiceQQNumber:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBasePHPUrl stringByAppendingString:oyGetServiceQQNumber];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}
@end
