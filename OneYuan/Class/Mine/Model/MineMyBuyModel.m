//
//  MineMyBuyModel.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineMyBuyModel.h"

@implementation MineMyBuyItem
@synthesize brandid,canyurenshu,cateid,codes_table,content,def_renshu,description,gonumber,pid,keywords,maxqishu,memberGoRecord_obejct,money,order,picarr,pos,q_content,q_counttime,q_end_time,q_showtime,q_uid,q_user,q_user_code,qishu,renqi,shenyurenshu,sid,thumb,time,title,title2,title_style,xsjx_time,yunjiage,zongrenshu,member_object,shengyutime;

+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation MineBuyedItem
@synthesize code,code_tmp,company,company_code,company_money,email,gonumber,goucode,huode,ip,mobile,moneycount,pay_type,pid,q_end_time,shopid,shopname,shopqishu,status,time,uid,uphoto,username;
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end

@implementation MineMyBuyList
@synthesize resultCode,resultMessage;
+ (Class)listItems_class {
    return [MineMyBuyItem class];
}
@end

@implementation MineMyBuyModel

+ (void)getUserBuylist:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure
{
    NSString* url = [oyBaseNewUrl stringByAppendingString:oyGetUserBuyHistory];
    [[XBApi SharedXBApi] requestWithURL:url paras:dict type:XBHttpResponseType_Json success:success failure:failure];
}
@end
