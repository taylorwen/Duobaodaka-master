//
//  ProductImgDetailModel.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/17.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "OneBaseParser.h"
@interface ProductImage : OneBaseParser
@property (nonatomic, copy)NSString* url;


@end

@interface ProductImgDetailModel : NSObject

+ (void)getGoodImage:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;

@end
