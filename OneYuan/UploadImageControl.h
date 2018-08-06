//
//  UploadImageControl.h
//  test
//
//  Created by NEO on 15/8/12.
//  Copyright (c) 2015年 NEO. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^UploadProgressBlock)(float progress);
typedef void (^UploadSuccessBlock)(id object);
typedef void (^UploadFailureBlock)(NSError *error);

@interface UploadImageControl : NSObject

+ (void)uploadImageWithURL:(NSString *)url imageArray:(NSArray *)imageArray uploadProgressBlock:(UploadProgressBlock)pblock success:(UploadSuccessBlock)sblock failure:(UploadFailureBlock)fblock;

@end
