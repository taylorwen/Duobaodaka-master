//
//  MineMoneyModel.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MineMoneyInItem <NSObject>
@end
@interface MineMoneyInItem : OneBaseParser
@property(nonatomic,copy)NSString*  content;
@property(nonatomic,copy)NSString*  money;
@property(nonatomic,copy)NSString*  pay;
@property(nonatomic,copy)NSString*  time;
@property(nonatomic,copy)NSString*  type;
@property(nonatomic,copy)NSString*  uid;
@end

@protocol MineMoneyOutItem <NSObject>
@end
@interface MineMoneyOutItem : MineMoneyInItem
@property(nonatomic,copy)NSString* typeName;
@end

@interface MineMoneyList : OneBaseParser
@property(nonatomic,copy)NSNumber   *count;
@property(nonatomic,copy)NSArray    *listItems;
@end

@interface MineMoneyModel : NSObject
+ (void)getMyMoneylist:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
//+ (void)getMyMoneyAll:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
