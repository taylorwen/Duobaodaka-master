//
//  ProductImgDetailModel.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/17.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ProductImgDetailModel.h"

@implementation ProductImage
@synthesize url;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end


@implementation ProductImgDetailModel
+ (void)getGoodImage:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetShopContent];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}
@end
