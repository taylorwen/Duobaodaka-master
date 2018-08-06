//
//  CartInstance.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "CartInstance.h"
#import "AppDelegate.h"

@implementation CartInstance

+(CartInstance*)ShartInstance
{
    static CartInstance* _cart = nil;
    static dispatch_once_t  once;
    dispatch_once(&once, ^{
        _cart = [[CartInstance alloc] init];
    });
    return _cart;
}

- (void)addToCart:(CartItem*)item imgPro:(UIImageView*)imgPro type:(addCartType)type
{
    __block CartItem* tmpItem = item;
    [CartModel quertCart:@"pid" value:item.pid block:^(NSArray* result)
     {
         if(result.count > 0)
         {
             tmpItem.gonumber = [NSString stringWithFormat:@"%d", [[[result objectAtIndex:0] gonumber] intValue] + 1 ];
         }
         [CartModel addorUpdateCart:tmpItem];
     }];
    
    if(type == addCartType_Tab)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidAddCart object:imgPro];
    }
    if(type == addCartType_Search)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidAddCartSearch object:imgPro];
    }
    else if(type == addCartType_Opt)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:kDidAddCartOpt object:imgPro];
    }
    
    [self performSelector:@selector(setCartNum) withObject:self afterDelay:1];
    
}


- (void)setCartNum
{
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setCartNum];
}
@end