//
//  WenzhanTool.h
//  MasterDuoBao
//
//  Created by zhan wen on 15/6/30.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WenzhanTool : NSObject

+(NSString*)formateDateStr:(NSString*)time;
+(NSString*)formateHttpStr:(NSString*)htmlStr;
+(NSString*)getCurrentTime;
+(NSString*)getaes256DecodeData;
@end
