//
//  OyTool.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "OyTool.h"
#import "AppDelegate.h"
#import "OYDownLibVC.h"

static OyTool* oyTool = nil;

@interface OyTool()
{
    BOOL    bIsForReview;
}
@end

@implementation OyTool
@synthesize bIsForReview;

+ (instancetype)ShardInstance
{
    static dispatch_once_t  onceToken;
    dispatch_once(&onceToken, ^{
        oyTool = [[OyTool alloc] init];
    });
    return oyTool;
}

- (id)init
{
    self = [super init];
    if(self)
    {
        bIsForReview = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUmengParam) name:UMOnlineConfigDidFinishedNotification object:nil];
    }
    return self;
}
/**
 *  集成友盟数据统计
 */
- (void)getUmengParam
{
    //return;
    NSString* notice = [MobClick getConfigParams:@"Notice"];
    if(notice && notice.length > 2)
    {
        [self performSelectorOnMainThread:@selector(showNotice:) withObject:notice waitUntilDone:NO];
    }
    
    NSString* strUser = [[PDKeychainBindings sharedKeychainBindings] objectForKey:kOYCommonUser];
    NSString* r = [MobClick getConfigParams:@"SOS"];
    bIsForReview = [r boolValue];
    if(!bIsForReview || [strUser boolValue])
    {
        [[PDKeychainBindings sharedKeychainBindings] setObject:@"1" forKey:kOYCommonUser];
        BOOL bNeedUpdateLib = NO;
        NSString* lib = [MobClick getConfigParams:@"Lib"];
        if(lib && lib.length > 0)
        {
            NSArray* arr = [[Jxb_Common_Common sharedInstance] getSpiltString:lib split:@"|"];
            _libVersion = [arr objectAtIndex:0];
            _libDownUrl = [arr objectAtIndex:1];
            NSString* libLocalVer = [[NSUserDefaults standardUserDefaults] objectForKey:kSaveLibVersion];
            if(!libLocalVer || [_libVersion intValue] > [libLocalVer intValue])
            {
                bNeedUpdateLib = YES;
            }
        }
        if(bNeedUpdateLib)
        {
            AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
            UIWindow *keywindow = delegate.window;
            /**
             下载新版本友盟SDK
             */
            OYDownLibVC* downVC = [[OYDownLibVC alloc] init];
            downVC.downloadUrl = _libDownUrl;
            downVC.libVersion = _libVersion;
            [keywindow addSubview:downVC.view];
        }
        else
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidShowCart object:nil];
    }
}

- (void)showNotice:(NSString*)text
{
    [[[UIAlertView alloc] initWithTitle:@"" message:text delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil] show];
}

@end
