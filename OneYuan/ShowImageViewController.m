//
//  ShowImageViewController.m
//  MyFamily
//
//  Created by 陆洋 on 15/7/3.
//  Copyright (c) 2015年 maili. All rights reserved.
//

#import "ShowImageViewController.h"
#import "ShowImageView.h"
@interface ShowImageViewController ()
@end

@implementation ShowImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ShowImageView *showImageView = [[ShowImageView alloc]initWithFrame:self.view.bounds byClickTag:self.clickTag appendArray:self.imageViews];
    [self.view addSubview:showImageView];
    __weak ShowImageViewController *weak_self =self;
    showImageView.removeImg = ^(){
        weak_self.navigationController.navigationBarHidden = NO;
        [weak_self.navigationController popViewControllerAnimated:YES];
    };
}

-(void)dealloc
{
    
}

@end
