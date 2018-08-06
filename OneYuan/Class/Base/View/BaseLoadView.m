//
//  BaseLoadView.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "BaseLoadView.h"

@interface BaseLoadView ()
{
    UIActivityIndicatorView *loadView;
}

@end

@implementation BaseLoadView

- (void)removeFromSuperview
{
    [super removeFromSuperview];
    
    if(loadView)
    {
        [loadView stopAnimating];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
  
        loadView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadView.frame = CGRectMake((frame.size.width - 32) / 2, frame.size.height / 2 - 100, 32, 32);
        [loadView startAnimating];
        [self addSubview:loadView];
        
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width - 100) / 2, loadView.frame.origin.y + 40, 100, 100)];
        img.image = [UIImage imageNamed:@" "];
        [self addSubview:img];
    }
    return self;
}

@end
