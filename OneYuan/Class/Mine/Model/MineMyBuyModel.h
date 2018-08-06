//
//  MineMyBuyModel.h
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  MineMyBuyItem <NSObject>
@end

@interface MineMyBuyItem : OneBaseParser
@property (nonatomic,copy)NSString  *brandid;
@property (nonatomic,copy)NSString  *canyurenshu;       //参与人次
@property (nonatomic,copy)NSString  *cateid;            //商品分类id
@property (nonatomic,copy)NSString  *codes_table;
@property (nonatomic,copy)NSString  *content;
@property (nonatomic,copy)NSString  *def_renshu;
@property (nonatomic,copy)NSString  *description;
@property (nonatomic,copy)NSString  *gonumber;          //夺宝次数
@property (nonatomic,copy)NSString  *pid;
@property (nonatomic,copy)NSString  *keywords;
@property (nonatomic,copy)NSString  *maxqishu;
@property (nonatomic,copy)NSDictionary  *memberGoRecord_obejct;
@property (nonatomic,copy)NSString  *member_object;
@property (nonatomic,copy)NSString  *money;
@property (nonatomic,copy)NSString  *order;             //排序
@property (nonatomic,copy)NSString  *picarr;            //商品图片列表
@property (nonatomic,copy)NSString  *pos;               //是否推荐，1为推荐
@property (nonatomic,copy)NSString  *q_content;         //揭晓内容
@property (nonatomic,copy)NSString  *q_counttime;       //总时间相加
@property (nonatomic,copy)NSString  *q_end_time;        //揭晓时间
@property (nonatomic,copy)NSString  *q_showtime;        //Y/N揭晓动画倒计时
@property (nonatomic,copy)NSString  *q_uid;             //中奖人ID
@property (nonatomic,copy)NSString  *q_user;            //中奖人信息
@property (nonatomic,copy)NSString  *q_user_code;       //幸运夺宝码
@property (nonatomic,copy)NSString  *qishu;
@property (nonatomic,copy)NSString  *renqi;
@property (nonatomic,copy)NSString  *shenyurenshu;      //剩余人次
@property (nonatomic,copy)NSString  *sid;
@property (nonatomic,copy)NSString  *thumb;             //商品图片
@property (nonatomic,copy)NSString  *time;
@property (nonatomic,copy)NSString  *title;
@property (nonatomic,copy)NSString  *title2;
@property (nonatomic,copy)NSString  *title_style;
@property (nonatomic,copy)NSString  *xsjx_time;         //时间，需要转化
@property (nonatomic,copy)NSString  *yunjiage;
@property (nonatomic,copy)NSString  *zongrenshu;
@property (nonatomic,copy)NSString  *shengyutime;
@end

//已揭晓商品的数据
@interface MineBuyedItem : OneBaseParser
@property (nonatomic,copy)NSString  *code;
@property (nonatomic,copy)NSString  *code_tmp;
@property (nonatomic,copy)NSString  *company;
@property (nonatomic,copy)NSString  *company_code;
@property (nonatomic,copy)NSString  *company_money;
@property (nonatomic,copy)NSString  *email;
@property (nonatomic,copy)NSString  *gonumber;
@property (nonatomic,copy)NSString  *goucode;
@property (nonatomic,copy)NSString  *huode;
@property (nonatomic,copy)NSString  *ip;
@property (nonatomic,copy)NSString  *mobile;
@property (nonatomic,copy)NSString  *moneycount;
@property (nonatomic,copy)NSString  *pay_type;
@property (nonatomic,copy)NSString  *pid;
@property (nonatomic,copy)NSString  *q_end_time;
@property (nonatomic,copy)NSString  *shopid;
@property (nonatomic,copy)NSString  *shopname;
@property (nonatomic,copy)NSString  *shopqishu;
@property (nonatomic,copy)NSString  *status;
@property (nonatomic,copy)NSString  *time;
@property (nonatomic,copy)NSString  *uid;
@property (nonatomic,copy)NSString  *uphoto;
@property (nonatomic,copy)NSString  *username;
@end

@interface MineMyBuyList : OneBaseParser
@property (nonatomic,copy)NSString  *resultCode;
@property (nonatomic,copy)NSString  *resultMessage;
@end

@interface MineMyBuyModel : NSObject

+ (void)getUserBuylist:(NSDictionary*)dict success:(void(^)(AFHTTPRequestOperation* operation, NSObject* result))success failure:(void(^)(NSError* error))failure;
@end
