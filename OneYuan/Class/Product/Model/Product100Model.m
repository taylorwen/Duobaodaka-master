//
//  Product100Model.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/11.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "Product100Model.h"

@implementation RecodeListModel
@synthesize time,username,uid,shopid,shopname,shopqishu,gonumber,time_add;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation Product100Model
+ (void)getRecodelist:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBasePHPUrl stringByAppendingString:oyNewGet100Recode];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}
@end
