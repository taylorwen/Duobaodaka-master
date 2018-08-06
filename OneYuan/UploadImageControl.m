//
//  UploadImageControl.m
//  test
//
//  Created by NEO on 15/8/12.
//  Copyright (c) 2015年 NEO. All rights reserved.
//

#import "UploadImageControl.h"
#import <AFNetworking/AFNetworking.h>

@implementation UploadImageControl

+ (void)uploadImageWithURL:(NSString *)url imageArray:(NSArray *)imageArray uploadProgressBlock:(UploadProgressBlock)pblock success:(UploadSuccessBlock)sblock failure:(UploadFailureBlock)fblock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/html", @"text/plain", @"application/plain", @"image/png", nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    AFHTTPRequestOperation *operation = [manager POST:url parameters:nil
                            constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                if (imageArray.count > 0) {
                                    for(NSInteger i=0; i < imageArray.count; i++) {
                                        UIImage *eachImg = [imageArray objectAtIndex:i];
                                        NSData *imageData = UIImageJPEGRepresentation(eachImg, 1);
                                        
                                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                        formatter.dateFormat = @"yyyyMMddHHmmss";
                                        NSString *str = [formatter stringFromDate:[NSDate date]];
                                        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
                                        
                                        [formData appendPartWithFileData:imageData name:@"Filedata" fileName:fileName mimeType:@"image/png"];
                                    }
                                }
                            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                //成功后回调
                                if (sblock) {
                                    sblock(responseObject);
                                }
                            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                //失败后回调
                                if (fblock) {
                                    fblock(error);
                                }
                            }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if (pblock) {
            pblock(totalBytesWritten * 1.0 / totalBytesExpectedToWrite);
        }
    }];
}

@end
