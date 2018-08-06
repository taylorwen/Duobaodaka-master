//
//  WenzhanTool.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/30.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "WenzhanTool.h"
#import "UserModel.h"
#import "UserInstance.h"
#import "RequestPostUploadHelper.h"

@interface WenzhanTool ()
{
    NSString*   ip;
}

@end
@implementation WenzhanTool
//时间戳转换为时间
+(NSString*)formateDateStr:(NSString*)time
{
    NSDate * dt = [NSDate dateWithTimeIntervalSince1970:[time floatValue]];
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *regStr = [df stringFromDate:dt];
    return regStr;
}

+(NSString*)formateHttpStr:(NSString*)htmlStr
{
    NSAttributedString * attrStr = [[NSAttributedString alloc]initWithData:[htmlStr dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    UILabel* myLabel = [[UILabel alloc]init];
    myLabel.attributedText = attrStr;
    return myLabel.text;
}

+(NSString*)getCurrentTime
{
    //需要上传的参数，时间戳(精确到毫秒)
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeZone * zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    NSDate* localDate = [date dateByAddingTimeInterval:interval];
    NSTimeInterval a = [localDate timeIntervalSince1970]*1000;
    NSString* timeString = [NSString stringWithFormat:@"%f",a];
    NSString* timestamp = [timeString substringToIndex:13];
    return timestamp;
}

+(NSString*)getaes256DecodeData
{
    //GTMBase64解码
    NSData* encodeData = [[UserInstance ShardInstnce].auth_key dataUsingEncoding:NSASCIIStringEncoding];
    NSData* decodeData = [GTMBase64 decodeData:encodeData];
    //AES256解码
    NSData* plainData = [decodeData AES256DecryptWithKey:AESDecodeKey];
    NSString* auth_key = [[NSString alloc]initWithData:plainData encoding:NSUTF8StringEncoding];
    return auth_key;
}


@end
