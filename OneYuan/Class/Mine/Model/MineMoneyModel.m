//
//  MineMoneyModel.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineMoneyModel.h"

@implementation MineMoneyInItem
@synthesize content,time,money,pay,type,uid;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation MineMoneyOutItem
@synthesize typeName;
@end

@implementation MineMoneyList
@synthesize count,listItems;
+ (Class)listItems_class {
    return [MineMoneyOutItem class];
}
@end

@implementation MineMoneyModel
+ (void)getMyMoneylist:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetMineAccountDetail];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}
@end
