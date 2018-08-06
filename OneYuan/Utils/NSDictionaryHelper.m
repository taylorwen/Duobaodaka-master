//
//  NSDictionaryHelper.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/13.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "NSDictionaryHelper.h"

@implementation NSDictionary(Helpers)
+ (NSDictionary *)dictionaryWithContentsOfData:(NSData *)data {
    CFPropertyListRef plist =  CFPropertyListCreateFromXMLData(kCFAllocatorDefault, (__bridge CFDataRef)data,
                                                               kCFPropertyListImmutable,
                                                               NULL);
    if(plist == nil) return nil;
    if ([(__bridge id)plist isKindOfClass:[NSDictionary class]]) {
        return (__bridge NSDictionary *)plist;
    }
    else {
        CFRelease(plist);
        return nil;
    }
}
@end
