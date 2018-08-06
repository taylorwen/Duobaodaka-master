//
//  CartInstance.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CartModel.h"

typedef enum
{
    addCartType_Tab,
    addCartType_Search,
    addCartType_Opt
}addCartType;

@interface CartInstance : NSObject

+(CartInstance*)ShartInstance;

- (void)addToCart:(CartItem*)item imgPro:(UIImageView*)imgPro type:(addCartType)type;
@end
