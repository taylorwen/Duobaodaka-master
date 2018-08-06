//
//  NSString_MD5.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/28.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "NSString_MD5.h"
#import "CommonCrypto/CommonDigest.h"

@implementation NSString_MD5
//经测试可行
+(NSString *)stringToMD5:(NSString *)inputStr
{
    const char *cStr = [inputStr UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    NSString *resultStr = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return [resultStr lowercaseString];
}
@end
