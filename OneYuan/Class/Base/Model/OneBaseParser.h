//
//  OneBaseParser.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface OneBaseParser : JSONModel
@property (nonatomic,copy)NSString  *resultCode;
@property (nonatomic,copy)NSString  *resultMessage;
@property (nonatomic,copy)NSString  *currentPage;
@property (nonatomic,copy)NSString  *maxShowPage;
@property (nonatomic,copy)NSString  *totalRow;
@property (nonatomic,copy)NSString  *totalPage;

@end
