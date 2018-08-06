//
//  ExpressCheckVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/26.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ExpressCheckVC.h"
#import "MineMyOrderTransModel.h"

@interface ExpressCheckVC ()
{
    MineMyOrderTrans*   tranItem;
    NSString* expressS;
    ExpressModel*       expressItem;
    NSArray*            list;
}
@end

@implementation ExpressCheckVC
- (id)initWithNo:(MineMyOrderTrans*)item
{
    self = [super init];
    if(self)
    {
        tranItem = item;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"物流查询";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self getData];
    
}

- (void)getData
{
    [[XBToastManager ShardInstance]showprogress];
    
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"kuaidi_jianxie":tranItem.kuaidi_jianxie,@"kuaidi_hao":tranItem.kuaidi_hao,@"timestamp":timestamp,@"token":token};
    [MineMyOrderTransModel getUserExpressInfo:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        
        [[XBToastManager ShardInstance]hideprogress];
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        list = [ExpressModel arrayOfModelsFromDictionaries:@[dataDict] error:&error];
        NSLog(@"%@",list);
        
        [self initExpressUI];
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance]hideprogress];
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取商品物流异常：%@",error]];
    }];
}

- (void)initExpressUI
{
    UIScrollView* background = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, self.view.frame.size.height)];
    background.backgroundColor = myLineColor;
    background.contentSize = CGSizeMake(mainWidth, 600);
    [self.view addSubview:background];
    
    UILabel* company = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 200, 44)];
    company.textColor = [UIColor grayColor];
    company.font = [UIFont systemFontOfSize:13];
    if ([tranItem.kuaidi_jianxie       isEqualToString:@"jd"]) {
        expressS = @"京东快递";
    }
    else if ([tranItem.kuaidi_jianxie  isEqualToString:@"shunfeng"])
    {
        expressS = @"顺丰快递";
    }
    else if ([tranItem.kuaidi_jianxie  isEqualToString:@"shentong"])
    {
        expressS = @"顺丰快递";
    }
    else if ([tranItem.kuaidi_jianxie  isEqualToString:@"tiantian"])
    {
        expressS = @"天天快递";
    }
    else if ([tranItem.kuaidi_jianxie  isEqualToString:@"zhongtong"])
    {
        expressS = @"中通快递";
    }
    else if ([tranItem.kuaidi_jianxie  isEqualToString:@"zhaijisong"])
    {
        expressS = @"宅急送";
    }
    else if ([tranItem.kuaidi_jianxie  isEqualToString:@"debangwuliu"])
    {
        expressS = @"德邦物流";
    }
    else if ([tranItem.kuaidi_jianxie  isEqualToString:@"yuantong"])
    {
        expressS = @"圆通快递";
    }
    else if ([tranItem.kuaidi_jianxie  isEqualToString:@"yunda"])
    {
        expressS = @"韵达快递";
    }
    else if ([tranItem.kuaidi_jianxie  isEqualToString:@"youzhengguonei"])
    {
        expressS = @"中国邮政";
    }else if ([tranItem.kuaidi_jianxie  isEqualToString:@"shentong"])
    {
        expressS = @"申通快递";
    }else
    {
        expressS = @"暂无物流信息";
    }
    company.text = [NSString stringWithFormat:@"物流公司:%@", expressS];
    [background addSubview:company];
    
    UILabel* companyCode = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, mainWidth-40, 44)];
    companyCode.textColor = [UIColor grayColor];
    companyCode.font = [UIFont systemFontOfSize:13];
    companyCode.text = [NSString stringWithFormat:@"运单号码:%@", tranItem.kuaidi_hao];
    companyCode.textAlignment = NSTextAlignmentRight;
    [background addSubview:companyCode];
    
    UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, mainWidth, 0.3)];
    line.backgroundColor = [UIColor lightGrayColor];
    [background addSubview:line];
    
    UIImageView* lineH = [[UIImageView alloc]initWithFrame:CGRectMake(24.5, 17+44, 0.5, self.view.frame.size.height-17-44)];
    lineH.backgroundColor = [UIColor lightGrayColor];
    [background addSubview:lineH];
    if (list.count == 1)
    {
        ExpressModel* item = [list objectAtIndex:0];
        UIImageView* corner0 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12+44, 20, 20)];
        corner0.backgroundColor = [UIColor hexFloatColor:@"ebae29"];
        corner0.layer.masksToBounds = YES;
        corner0.layer.cornerRadius = 10;
        [background addSubview:corner0];
        
        UILabel* lblGood = [[UILabel alloc]initWithFrame:CGRectMake(60, 44, mainWidth-220, 44)];
        lblGood.textColor = [UIColor grayColor];
        lblGood.font = [UIFont systemFontOfSize:14];
        lblGood.text = item.context;
        lblGood.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood.numberOfLines = 2;
        [background addSubview:lblGood];
        
        UILabel* lblGoodTime = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44, 140, 44)];
        lblGoodTime.textColor = [UIColor grayColor];
        lblGoodTime.font = [UIFont systemFontOfSize:14];
        lblGoodTime.textAlignment = NSTextAlignmentRight;
        lblGoodTime.text = [WenzhanTool formateDateStr:item.time];
        [background addSubview:lblGoodTime];
    }
    else if (list.count == 2)
    {
        ExpressModel* item = [list objectAtIndex:0];
        UIImageView* corner0 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12+44, 20, 20)];
        corner0.backgroundColor = [UIColor hexFloatColor:@"ebae29"];
        corner0.layer.masksToBounds = YES;
        corner0.layer.cornerRadius = 10;
        [background addSubview:corner0];
        
        UILabel* lblGood = [[UILabel alloc]initWithFrame:CGRectMake(60, 44, mainWidth-220, 44)];
        lblGood.textColor = [UIColor grayColor];
        lblGood.font = [UIFont systemFontOfSize:14];
        lblGood.text = item.context;
        lblGood.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood.numberOfLines = 2;
        [background addSubview:lblGood];
        
        UILabel* lblGoodTime = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44, 140, 44)];
        lblGoodTime.textColor = [UIColor grayColor];
        lblGoodTime.font = [UIFont systemFontOfSize:14];
        lblGoodTime.textAlignment = NSTextAlignmentRight;
        lblGoodTime.text = [WenzhanTool formateDateStr:item.time];
        [background addSubview:lblGoodTime];
        
        ExpressModel* item1 = [list objectAtIndex:1];
        UIImageView* corner1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*2, 10, 10)];
        corner1.backgroundColor = [UIColor lightGrayColor];
        corner1.layer.masksToBounds = YES;
        corner1.layer.cornerRadius = 5;
        [background addSubview:corner1];
        
        UILabel* lblGood1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*2, mainWidth-220, 44)];
        lblGood1.textColor = [UIColor grayColor];
        lblGood1.font = [UIFont systemFontOfSize:14];
        lblGood1.text = item1.context;
        lblGood1.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood1.numberOfLines = 2;
        [background addSubview:lblGood1];
        
        UILabel* lblGoodTime1 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*2, 140, 44)];
        lblGoodTime1.textColor = [UIColor grayColor];
        lblGoodTime1.font = [UIFont systemFontOfSize:14];
        lblGoodTime1.textAlignment = NSTextAlignmentRight;
        lblGoodTime1.text = [WenzhanTool formateDateStr:item1.time];
        [background addSubview:lblGoodTime1];
    }
    else if (list.count == 3)
    {
        ExpressModel* item = [list objectAtIndex:0];
        UIImageView* corner0 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12+44, 20, 20)];
        corner0.backgroundColor = [UIColor hexFloatColor:@"ebae29"];
        corner0.layer.masksToBounds = YES;
        corner0.layer.cornerRadius = 10;
        [background addSubview:corner0];
        
        UILabel* lblGood = [[UILabel alloc]initWithFrame:CGRectMake(60, 44, mainWidth-220, 44)];
        lblGood.textColor = [UIColor grayColor];
        lblGood.font = [UIFont systemFontOfSize:14];
        lblGood.text = item.context;
        lblGood.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood.numberOfLines = 2;
        [background addSubview:lblGood];
        
        UILabel* lblGoodTime = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44, 140, 44)];
        lblGoodTime.textColor = [UIColor grayColor];
        lblGoodTime.font = [UIFont systemFontOfSize:14];
        lblGoodTime.textAlignment = NSTextAlignmentRight;
        lblGoodTime.text = [WenzhanTool formateDateStr:item.time];
        [background addSubview:lblGoodTime];
        
        ExpressModel* item1 = [list objectAtIndex:1];
        UIImageView* corner1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*2, 10, 10)];
        corner1.backgroundColor = [UIColor lightGrayColor];
        corner1.layer.masksToBounds = YES;
        corner1.layer.cornerRadius = 5;
        [background addSubview:corner1];
        
        UILabel* lblGood1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*2, mainWidth-220, 44)];
        lblGood1.textColor = [UIColor grayColor];
        lblGood1.font = [UIFont systemFontOfSize:14];
        lblGood1.text = item1.context;
        lblGood1.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood1.numberOfLines = 2;
        [background addSubview:lblGood1];
        
        UILabel* lblGoodTime1 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*2, 140, 44)];
        lblGoodTime1.textColor = [UIColor grayColor];
        lblGoodTime1.font = [UIFont systemFontOfSize:14];
        lblGoodTime1.textAlignment = NSTextAlignmentRight;
        lblGoodTime1.text = [WenzhanTool formateDateStr:item1.time];
        [background addSubview:lblGoodTime1];
        
        ExpressModel* item2 = [list objectAtIndex:2];
        UIImageView* corner2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*3, 10, 10)];
        corner2.backgroundColor = [UIColor lightGrayColor];
        corner2.layer.masksToBounds = YES;
        corner2.layer.cornerRadius = 5;
        [background addSubview:corner2];
        
        UILabel* lblGood2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*3, mainWidth-220, 44)];
        lblGood2.textColor = [UIColor grayColor];
        lblGood2.font = [UIFont systemFontOfSize:14];
        lblGood2.text = item2.context;
        lblGood2.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood2.numberOfLines = 2;
        [background addSubview:lblGood2];
        
        UILabel* lblGoodTime2 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*3, 140, 44)];
        lblGoodTime2.textColor = [UIColor grayColor];
        lblGoodTime2.font = [UIFont systemFontOfSize:14];
        lblGoodTime2.textAlignment = NSTextAlignmentRight;
        lblGoodTime2.text = [WenzhanTool formateDateStr:item2.time];
        [background addSubview:lblGoodTime2];
    }
    else if (list.count == 4)
    {
        ExpressModel* item = [list objectAtIndex:0];
        UIImageView* corner0 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12+44, 20, 20)];
        corner0.backgroundColor = [UIColor hexFloatColor:@"ebae29"];
        corner0.layer.masksToBounds = YES;
        corner0.layer.cornerRadius = 10;
        [background addSubview:corner0];
        
        UILabel* lblGood = [[UILabel alloc]initWithFrame:CGRectMake(60, 44, mainWidth-220, 44)];
        lblGood.textColor = [UIColor grayColor];
        lblGood.font = [UIFont systemFontOfSize:14];
        lblGood.text = item.context;
        lblGood.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood.numberOfLines = 2;
        [background addSubview:lblGood];
        
        UILabel* lblGoodTime = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44, 140, 44)];
        lblGoodTime.textColor = [UIColor grayColor];
        lblGoodTime.font = [UIFont systemFontOfSize:14];
        lblGoodTime.textAlignment = NSTextAlignmentRight;
        lblGoodTime.text = [WenzhanTool formateDateStr:item.time];
        [background addSubview:lblGoodTime];
        
        ExpressModel* item1 = [list objectAtIndex:1];
        UIImageView* corner1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*2, 10, 10)];
        corner1.backgroundColor = [UIColor lightGrayColor];
        corner1.layer.masksToBounds = YES;
        corner1.layer.cornerRadius = 5;
        [background addSubview:corner1];
        
        UILabel* lblGood1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*2, mainWidth-220, 44)];
        lblGood1.textColor = [UIColor grayColor];
        lblGood1.font = [UIFont systemFontOfSize:14];
        lblGood1.text = item1.context;
        lblGood1.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood1.numberOfLines = 2;
        [background addSubview:lblGood1];
        
        UILabel* lblGoodTime1 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*2, 140, 44)];
        lblGoodTime1.textColor = [UIColor grayColor];
        lblGoodTime1.font = [UIFont systemFontOfSize:14];
        lblGoodTime1.textAlignment = NSTextAlignmentRight;
        lblGoodTime1.text = [WenzhanTool formateDateStr:item1.time];
        [background addSubview:lblGoodTime1];
        
        ExpressModel* item2 = [list objectAtIndex:2];
        UIImageView* corner2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*3, 10, 10)];
        corner2.backgroundColor = [UIColor lightGrayColor];
        corner2.layer.masksToBounds = YES;
        corner2.layer.cornerRadius = 5;
        [background addSubview:corner2];
        
        UILabel* lblGood2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*3, mainWidth-220, 44)];
        lblGood2.textColor = [UIColor grayColor];
        lblGood2.font = [UIFont systemFontOfSize:14];
        lblGood2.text = item2.context;
        lblGood2.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood2.numberOfLines = 2;
        [background addSubview:lblGood2];
        
        UILabel* lblGoodTime2 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*3, 140, 44)];
        lblGoodTime2.textColor = [UIColor grayColor];
        lblGoodTime2.font = [UIFont systemFontOfSize:14];
        lblGoodTime2.textAlignment = NSTextAlignmentRight;
        lblGoodTime2.text = [WenzhanTool formateDateStr:item2.time];
        [background addSubview:lblGoodTime2];
        
        ExpressModel* item3 = [list objectAtIndex:3];
        UIImageView* corner3 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*4, 10, 10)];
        corner3.backgroundColor = [UIColor lightGrayColor];
        corner3.layer.masksToBounds = YES;
        corner3.layer.cornerRadius = 5;
        [background addSubview:corner3];
        
        UILabel* lblGood3 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*4, mainWidth-220, 44)];
        lblGood3.textColor = [UIColor grayColor];
        lblGood3.font = [UIFont systemFontOfSize:14];
        lblGood3.text = item3.context;
        lblGood3.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood3.numberOfLines = 2;
        [background addSubview:lblGood3];
        
        UILabel* lblGoodTime3 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*4, 140, 44)];
        lblGoodTime3.textColor = [UIColor grayColor];
        lblGoodTime3.font = [UIFont systemFontOfSize:14];
        lblGoodTime3.textAlignment = NSTextAlignmentRight;
        lblGoodTime3.text = [WenzhanTool formateDateStr:item3.time];
        [background addSubview:lblGoodTime3];
    }
    else if (list.count == 5)
    {
        ExpressModel* item = [list objectAtIndex:0];
        UIImageView* corner0 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12+44, 20, 20)];
        corner0.backgroundColor = [UIColor hexFloatColor:@"ebae29"];
        corner0.layer.masksToBounds = YES;
        corner0.layer.cornerRadius = 10;
        [background addSubview:corner0];
        
        UILabel* lblGood = [[UILabel alloc]initWithFrame:CGRectMake(60, 44, mainWidth-220, 44)];
        lblGood.textColor = [UIColor grayColor];
        lblGood.font = [UIFont systemFontOfSize:14];
        lblGood.text = item.context;
        lblGood.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood.numberOfLines = 2;
        [background addSubview:lblGood];
        
        UILabel* lblGoodTime = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44, 140, 44)];
        lblGoodTime.textColor = [UIColor grayColor];
        lblGoodTime.font = [UIFont systemFontOfSize:14];
        lblGoodTime.textAlignment = NSTextAlignmentRight;
        lblGoodTime.text = [WenzhanTool formateDateStr:item.time];
        [background addSubview:lblGoodTime];
        
        ExpressModel* item1 = [list objectAtIndex:1];
        UIImageView* corner1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*2, 10, 10)];
        corner1.backgroundColor = [UIColor lightGrayColor];
        corner1.layer.masksToBounds = YES;
        corner1.layer.cornerRadius = 5;
        [background addSubview:corner1];
        
        UILabel* lblGood1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*2, mainWidth-220, 44)];
        lblGood1.textColor = [UIColor grayColor];
        lblGood1.font = [UIFont systemFontOfSize:14];
        lblGood1.text = item1.context;
        lblGood1.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood1.numberOfLines = 2;
        [background addSubview:lblGood1];
        
        UILabel* lblGoodTime1 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*2, 140, 44)];
        lblGoodTime1.textColor = [UIColor grayColor];
        lblGoodTime1.font = [UIFont systemFontOfSize:14];
        lblGoodTime1.textAlignment = NSTextAlignmentRight;
        lblGoodTime1.text = [WenzhanTool formateDateStr:item1.time];
        [background addSubview:lblGoodTime1];
        
        ExpressModel* item2 = [list objectAtIndex:2];
        UIImageView* corner2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*3, 10, 10)];
        corner2.backgroundColor = [UIColor lightGrayColor];
        corner2.layer.masksToBounds = YES;
        corner2.layer.cornerRadius = 5;
        [background addSubview:corner2];
        
        UILabel* lblGood2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*3, mainWidth-220, 44)];
        lblGood2.textColor = [UIColor grayColor];
        lblGood2.font = [UIFont systemFontOfSize:14];
        lblGood2.text = item2.context;
        lblGood2.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood2.numberOfLines = 2;
        [background addSubview:lblGood2];
        
        UILabel* lblGoodTime2 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*3, 140, 44)];
        lblGoodTime2.textColor = [UIColor grayColor];
        lblGoodTime2.font = [UIFont systemFontOfSize:14];
        lblGoodTime2.textAlignment = NSTextAlignmentRight;
        lblGoodTime2.text = [WenzhanTool formateDateStr:item2.time];
        [background addSubview:lblGoodTime2];
        
        ExpressModel* item3 = [list objectAtIndex:3];
        UIImageView* corner3 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*4, 10, 10)];
        corner3.backgroundColor = [UIColor lightGrayColor];
        corner3.layer.masksToBounds = YES;
        corner3.layer.cornerRadius = 5;
        [background addSubview:corner3];
        
        UILabel* lblGood3 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*4, mainWidth-220, 44)];
        lblGood3.textColor = [UIColor grayColor];
        lblGood3.font = [UIFont systemFontOfSize:14];
        lblGood3.text = item3.context;
        lblGood3.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood3.numberOfLines = 2;
        [background addSubview:lblGood3];
        
        UILabel* lblGoodTime3 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*4, 140, 44)];
        lblGoodTime3.textColor = [UIColor grayColor];
        lblGoodTime3.font = [UIFont systemFontOfSize:14];
        lblGoodTime3.textAlignment = NSTextAlignmentRight;
        lblGoodTime3.text = [WenzhanTool formateDateStr:item3.time];
        [background addSubview:lblGoodTime3];
        
        ExpressModel* item4 = [list objectAtIndex:4];
        UIImageView* corner4 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*5, 10, 10)];
        corner4.backgroundColor = [UIColor lightGrayColor];
        corner4.layer.masksToBounds = YES;
        corner4.layer.cornerRadius = 5;
        [background addSubview:corner4];
        
        UILabel* lblGood4 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*5, mainWidth-220, 44)];
        lblGood4.textColor = [UIColor grayColor];
        lblGood4.font = [UIFont systemFontOfSize:14];
        lblGood4.text = item4.context;
        lblGood4.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood4.numberOfLines = 2;
        [background addSubview:lblGood4];
        
        UILabel* lblGoodTime4 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*5, 140, 44)];
        lblGoodTime4.textColor = [UIColor grayColor];
        lblGoodTime4.font = [UIFont systemFontOfSize:14];
        lblGoodTime4.textAlignment = NSTextAlignmentRight;
        lblGoodTime4.text = [WenzhanTool formateDateStr:item4.time];
        [background addSubview:lblGoodTime4];
    }
    else if (list.count == 6)
    {
        ExpressModel* item = [list objectAtIndex:0];
        UIImageView* corner0 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12+44, 20, 20)];
        corner0.backgroundColor = [UIColor hexFloatColor:@"ebae29"];
        corner0.layer.masksToBounds = YES;
        corner0.layer.cornerRadius = 10;
        [background addSubview:corner0];
        
        UILabel* lblGood = [[UILabel alloc]initWithFrame:CGRectMake(60, 44, mainWidth-220, 44)];
        lblGood.textColor = [UIColor grayColor];
        lblGood.font = [UIFont systemFontOfSize:14];
        lblGood.text = item.context;
        lblGood.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood.numberOfLines = 2;
        [background addSubview:lblGood];
        
        UILabel* lblGoodTime = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44, 140, 44)];
        lblGoodTime.textColor = [UIColor grayColor];
        lblGoodTime.font = [UIFont systemFontOfSize:14];
        lblGoodTime.textAlignment = NSTextAlignmentRight;
        lblGoodTime.text = [WenzhanTool formateDateStr:item.time];
        [background addSubview:lblGoodTime];
        
        ExpressModel* item1 = [list objectAtIndex:1];
        UIImageView* corner1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*2, 10, 10)];
        corner1.backgroundColor = [UIColor lightGrayColor];
        corner1.layer.masksToBounds = YES;
        corner1.layer.cornerRadius = 5;
        [background addSubview:corner1];
        
        UILabel* lblGood1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*2, mainWidth-220, 44)];
        lblGood1.textColor = [UIColor grayColor];
        lblGood1.font = [UIFont systemFontOfSize:14];
        lblGood1.text = item1.context;
        lblGood1.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood1.numberOfLines = 2;
        [background addSubview:lblGood1];
        
        UILabel* lblGoodTime1 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*2, 140, 44)];
        lblGoodTime1.textColor = [UIColor grayColor];
        lblGoodTime1.font = [UIFont systemFontOfSize:14];
        lblGoodTime1.textAlignment = NSTextAlignmentRight;
        lblGoodTime1.text = [WenzhanTool formateDateStr:item1.time];
        [background addSubview:lblGoodTime1];
        
        ExpressModel* item2 = [list objectAtIndex:2];
        UIImageView* corner2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*3, 10, 10)];
        corner2.backgroundColor = [UIColor lightGrayColor];
        corner2.layer.masksToBounds = YES;
        corner2.layer.cornerRadius = 5;
        [background addSubview:corner2];
        
        UILabel* lblGood2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*3, mainWidth-220, 44)];
        lblGood2.textColor = [UIColor grayColor];
        lblGood2.font = [UIFont systemFontOfSize:14];
        lblGood2.text = item2.context;
        lblGood2.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood2.numberOfLines = 2;
        [background addSubview:lblGood2];
        
        UILabel* lblGoodTime2 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*3, 140, 44)];
        lblGoodTime2.textColor = [UIColor grayColor];
        lblGoodTime2.font = [UIFont systemFontOfSize:14];
        lblGoodTime2.textAlignment = NSTextAlignmentRight;
        lblGoodTime2.text = [WenzhanTool formateDateStr:item2.time];
        [background addSubview:lblGoodTime2];
        
        ExpressModel* item3 = [list objectAtIndex:3];
        UIImageView* corner3 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*4, 10, 10)];
        corner3.backgroundColor = [UIColor lightGrayColor];
        corner3.layer.masksToBounds = YES;
        corner3.layer.cornerRadius = 5;
        [background addSubview:corner3];
        
        UILabel* lblGood3 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*4, mainWidth-220, 44)];
        lblGood3.textColor = [UIColor grayColor];
        lblGood3.font = [UIFont systemFontOfSize:14];
        lblGood3.text = item3.context;
        lblGood3.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood3.numberOfLines = 2;
        [background addSubview:lblGood3];
        
        UILabel* lblGoodTime3 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*4, 140, 44)];
        lblGoodTime3.textColor = [UIColor grayColor];
        lblGoodTime3.font = [UIFont systemFontOfSize:14];
        lblGoodTime3.textAlignment = NSTextAlignmentRight;
        lblGoodTime3.text = [WenzhanTool formateDateStr:item3.time];
        [background addSubview:lblGoodTime3];
        
        ExpressModel* item4 = [list objectAtIndex:4];
        UIImageView* corner4 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*5, 10, 10)];
        corner4.backgroundColor = [UIColor lightGrayColor];
        corner4.layer.masksToBounds = YES;
        corner4.layer.cornerRadius = 5;
        [background addSubview:corner4];
        
        UILabel* lblGood4 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*5, mainWidth-220, 44)];
        lblGood4.textColor = [UIColor grayColor];
        lblGood4.font = [UIFont systemFontOfSize:14];
        lblGood4.text = item4.context;
        lblGood4.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood4.numberOfLines = 2;
        [background addSubview:lblGood4];
        
        UILabel* lblGoodTime4 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*5, 140, 44)];
        lblGoodTime4.textColor = [UIColor grayColor];
        lblGoodTime4.font = [UIFont systemFontOfSize:14];
        lblGoodTime4.textAlignment = NSTextAlignmentRight;
        lblGoodTime4.text = [WenzhanTool formateDateStr:item4.time];
        [background addSubview:lblGoodTime4];
        
        ExpressModel* item5 = [list objectAtIndex:5];
        UIImageView* corner5 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*6, 10, 10)];
        corner5.backgroundColor = [UIColor lightGrayColor];
        corner5.layer.masksToBounds = YES;
        corner5.layer.cornerRadius = 5;
        [background addSubview:corner5];
        
        UILabel* lblGood5 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*6, mainWidth-220, 44)];
        lblGood5.textColor = [UIColor grayColor];
        lblGood5.font = [UIFont systemFontOfSize:14];
        lblGood5.text = item5.context;
        lblGood5.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood5.numberOfLines = 2;
        [background addSubview:lblGood5];
        
        UILabel* lblGoodTime5 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*6, 140, 44)];
        lblGoodTime5.textColor = [UIColor grayColor];
        lblGoodTime5.font = [UIFont systemFontOfSize:14];
        lblGoodTime5.textAlignment = NSTextAlignmentRight;
        lblGoodTime5.text = [WenzhanTool formateDateStr:item5.time];
        [background addSubview:lblGoodTime5];
    }
    else if (list.count == 7)
    {
        ExpressModel* item = [list objectAtIndex:0];
        UIImageView* corner0 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12+44, 20, 20)];
        corner0.backgroundColor = [UIColor hexFloatColor:@"ebae29"];
        corner0.layer.masksToBounds = YES;
        corner0.layer.cornerRadius = 10;
        [background addSubview:corner0];
        
        UILabel* lblGood = [[UILabel alloc]initWithFrame:CGRectMake(60, 44, mainWidth-220, 44)];
        lblGood.textColor = [UIColor grayColor];
        lblGood.font = [UIFont systemFontOfSize:14];
        lblGood.text = item.context;
        lblGood.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood.numberOfLines = 2;
        [background addSubview:lblGood];
        
        UILabel* lblGoodTime = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44, 140, 44)];
        lblGoodTime.textColor = [UIColor grayColor];
        lblGoodTime.font = [UIFont systemFontOfSize:14];
        lblGoodTime.textAlignment = NSTextAlignmentRight;
        lblGoodTime.text = [WenzhanTool formateDateStr:item.time];
        [background addSubview:lblGoodTime];
        
        ExpressModel* item1 = [list objectAtIndex:1];
        UIImageView* corner1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*2, 10, 10)];
        corner1.backgroundColor = [UIColor lightGrayColor];
        corner1.layer.masksToBounds = YES;
        corner1.layer.cornerRadius = 5;
        [background addSubview:corner1];
        
        UILabel* lblGood1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*2, mainWidth-220, 44)];
        lblGood1.textColor = [UIColor grayColor];
        lblGood1.font = [UIFont systemFontOfSize:14];
        lblGood1.text = item1.context;
        lblGood1.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood1.numberOfLines = 2;
        [background addSubview:lblGood1];
        
        UILabel* lblGoodTime1 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*2, 140, 44)];
        lblGoodTime1.textColor = [UIColor grayColor];
        lblGoodTime1.font = [UIFont systemFontOfSize:14];
        lblGoodTime1.textAlignment = NSTextAlignmentRight;
        lblGoodTime1.text = [WenzhanTool formateDateStr:item1.time];
        [background addSubview:lblGoodTime1];
        
        ExpressModel* item2 = [list objectAtIndex:2];
        UIImageView* corner2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*3, 10, 10)];
        corner2.backgroundColor = [UIColor lightGrayColor];
        corner2.layer.masksToBounds = YES;
        corner2.layer.cornerRadius = 5;
        [background addSubview:corner2];
        
        UILabel* lblGood2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*3, mainWidth-220, 44)];
        lblGood2.textColor = [UIColor grayColor];
        lblGood2.font = [UIFont systemFontOfSize:14];
        lblGood2.text = item2.context;
        lblGood2.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood2.numberOfLines = 2;
        [background addSubview:lblGood2];
        
        UILabel* lblGoodTime2 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*3, 140, 44)];
        lblGoodTime2.textColor = [UIColor grayColor];
        lblGoodTime2.font = [UIFont systemFontOfSize:14];
        lblGoodTime2.textAlignment = NSTextAlignmentRight;
        lblGoodTime2.text = [WenzhanTool formateDateStr:item2.time];
        [background addSubview:lblGoodTime2];
        
        ExpressModel* item3 = [list objectAtIndex:3];
        UIImageView* corner3 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*4, 10, 10)];
        corner3.backgroundColor = [UIColor lightGrayColor];
        corner3.layer.masksToBounds = YES;
        corner3.layer.cornerRadius = 5;
        [background addSubview:corner3];
        
        UILabel* lblGood3 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*4, mainWidth-220, 44)];
        lblGood3.textColor = [UIColor grayColor];
        lblGood3.font = [UIFont systemFontOfSize:14];
        lblGood3.text = item3.context;
        lblGood3.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood3.numberOfLines = 2;
        [background addSubview:lblGood3];
        
        UILabel* lblGoodTime3 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*4, 140, 44)];
        lblGoodTime3.textColor = [UIColor grayColor];
        lblGoodTime3.font = [UIFont systemFontOfSize:14];
        lblGoodTime3.textAlignment = NSTextAlignmentRight;
        lblGoodTime3.text = [WenzhanTool formateDateStr:item3.time];
        [background addSubview:lblGoodTime3];
        
        ExpressModel* item4 = [list objectAtIndex:4];
        UIImageView* corner4 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*5, 10, 10)];
        corner4.backgroundColor = [UIColor lightGrayColor];
        corner4.layer.masksToBounds = YES;
        corner4.layer.cornerRadius = 5;
        [background addSubview:corner4];
        
        UILabel* lblGood4 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*5, mainWidth-220, 44)];
        lblGood4.textColor = [UIColor grayColor];
        lblGood4.font = [UIFont systemFontOfSize:14];
        lblGood4.text = item4.context;
        lblGood4.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood4.numberOfLines = 2;
        [background addSubview:lblGood4];
        
        UILabel* lblGoodTime4 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*5, 140, 44)];
        lblGoodTime4.textColor = [UIColor grayColor];
        lblGoodTime4.font = [UIFont systemFontOfSize:14];
        lblGoodTime4.textAlignment = NSTextAlignmentRight;
        lblGoodTime4.text = [WenzhanTool formateDateStr:item4.time];
        [background addSubview:lblGoodTime4];
        
        ExpressModel* item5 = [list objectAtIndex:5];
        UIImageView* corner5 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*6, 10, 10)];
        corner5.backgroundColor = [UIColor lightGrayColor];
        corner5.layer.masksToBounds = YES;
        corner5.layer.cornerRadius = 5;
        [background addSubview:corner5];
        
        UILabel* lblGood5 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*6, mainWidth-220, 44)];
        lblGood5.textColor = [UIColor grayColor];
        lblGood5.font = [UIFont systemFontOfSize:14];
        lblGood5.text = item5.context;
        lblGood5.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood5.numberOfLines = 2;
        [background addSubview:lblGood5];
        
        UILabel* lblGoodTime5 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*6, 140, 44)];
        lblGoodTime5.textColor = [UIColor grayColor];
        lblGoodTime5.font = [UIFont systemFontOfSize:14];
        lblGoodTime5.textAlignment = NSTextAlignmentRight;
        lblGoodTime5.text = [WenzhanTool formateDateStr:item5.time];
        [background addSubview:lblGoodTime5];
        
        ExpressModel* item6 = [list objectAtIndex:6];
        UIImageView* corner6 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*7, 10, 10)];
        corner6.backgroundColor = [UIColor lightGrayColor];
        corner6.layer.masksToBounds = YES;
        corner6.layer.cornerRadius = 5;
        [background addSubview:corner6];
        
        UILabel* lblGood6 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*7, mainWidth-220, 44)];
        lblGood6.textColor = [UIColor grayColor];
        lblGood6.font = [UIFont systemFontOfSize:14];
        lblGood6.text = item6.context;
        lblGood6.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood6.numberOfLines = 2;
        [background addSubview:lblGood6];
        
        UILabel* lblGoodTime6 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*7, 140, 44)];
        lblGoodTime6.textColor = [UIColor grayColor];
        lblGoodTime6.font = [UIFont systemFontOfSize:14];
        lblGoodTime6.textAlignment = NSTextAlignmentRight;
        lblGoodTime6.text = [WenzhanTool formateDateStr:item6.time];
        [background addSubview:lblGoodTime6];
    }
    else if (list.count == 8)
    {
        ExpressModel* item = [list objectAtIndex:0];
        UIImageView* corner0 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12+44, 20, 20)];
        corner0.backgroundColor = [UIColor hexFloatColor:@"ebae29"];
        corner0.layer.masksToBounds = YES;
        corner0.layer.cornerRadius = 10;
        [background addSubview:corner0];
        
        UILabel* lblGood = [[UILabel alloc]initWithFrame:CGRectMake(60, 44, mainWidth-220, 44)];
        lblGood.textColor = [UIColor grayColor];
        lblGood.font = [UIFont systemFontOfSize:14];
        lblGood.text = item.context;
        lblGood.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood.numberOfLines = 2;
        [background addSubview:lblGood];
        
        UILabel* lblGoodTime = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44, 140, 44)];
        lblGoodTime.textColor = [UIColor grayColor];
        lblGoodTime.font = [UIFont systemFontOfSize:14];
        lblGoodTime.textAlignment = NSTextAlignmentRight;
        lblGoodTime.text = [WenzhanTool formateDateStr:item.time];
        [background addSubview:lblGoodTime];
        
        ExpressModel* item1 = [list objectAtIndex:1];
        UIImageView* corner1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*2, 10, 10)];
        corner1.backgroundColor = [UIColor lightGrayColor];
        corner1.layer.masksToBounds = YES;
        corner1.layer.cornerRadius = 5;
        [background addSubview:corner1];
        
        UILabel* lblGood1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*2, mainWidth-220, 44)];
        lblGood1.textColor = [UIColor grayColor];
        lblGood1.font = [UIFont systemFontOfSize:14];
        lblGood1.text = item1.context;
        lblGood1.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood1.numberOfLines = 2;
        [background addSubview:lblGood1];
        
        UILabel* lblGoodTime1 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*2, 140, 44)];
        lblGoodTime1.textColor = [UIColor grayColor];
        lblGoodTime1.font = [UIFont systemFontOfSize:14];
        lblGoodTime1.textAlignment = NSTextAlignmentRight;
        lblGoodTime1.text = [WenzhanTool formateDateStr:item1.time];
        [background addSubview:lblGoodTime1];
        
        ExpressModel* item2 = [list objectAtIndex:2];
        UIImageView* corner2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*3, 10, 10)];
        corner2.backgroundColor = [UIColor lightGrayColor];
        corner2.layer.masksToBounds = YES;
        corner2.layer.cornerRadius = 5;
        [background addSubview:corner2];
        
        UILabel* lblGood2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*3, mainWidth-220, 44)];
        lblGood2.textColor = [UIColor grayColor];
        lblGood2.font = [UIFont systemFontOfSize:14];
        lblGood2.text = item2.context;
        lblGood2.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood2.numberOfLines = 2;
        [background addSubview:lblGood2];
        
        UILabel* lblGoodTime2 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*3, 140, 44)];
        lblGoodTime2.textColor = [UIColor grayColor];
        lblGoodTime2.font = [UIFont systemFontOfSize:14];
        lblGoodTime2.textAlignment = NSTextAlignmentRight;
        lblGoodTime2.text = [WenzhanTool formateDateStr:item2.time];
        [background addSubview:lblGoodTime2];
        
        ExpressModel* item3 = [list objectAtIndex:3];
        UIImageView* corner3 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*4, 10, 10)];
        corner3.backgroundColor = [UIColor lightGrayColor];
        corner3.layer.masksToBounds = YES;
        corner3.layer.cornerRadius = 5;
        [background addSubview:corner3];
        
        UILabel* lblGood3 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*4, mainWidth-220, 44)];
        lblGood3.textColor = [UIColor grayColor];
        lblGood3.font = [UIFont systemFontOfSize:14];
        lblGood3.text = item3.context;
        lblGood3.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood3.numberOfLines = 2;
        [background addSubview:lblGood3];
        
        UILabel* lblGoodTime3 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*4, 140, 44)];
        lblGoodTime3.textColor = [UIColor grayColor];
        lblGoodTime3.font = [UIFont systemFontOfSize:14];
        lblGoodTime3.textAlignment = NSTextAlignmentRight;
        lblGoodTime3.text = [WenzhanTool formateDateStr:item3.time];
        [background addSubview:lblGoodTime3];
        
        ExpressModel* item4 = [list objectAtIndex:4];
        UIImageView* corner4 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*5, 10, 10)];
        corner4.backgroundColor = [UIColor lightGrayColor];
        corner4.layer.masksToBounds = YES;
        corner4.layer.cornerRadius = 5;
        [background addSubview:corner4];
        
        UILabel* lblGood4 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*5, mainWidth-220, 44)];
        lblGood4.textColor = [UIColor grayColor];
        lblGood4.font = [UIFont systemFontOfSize:14];
        lblGood4.text = item4.context;
        lblGood4.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood4.numberOfLines = 2;
        [background addSubview:lblGood4];
        
        UILabel* lblGoodTime4 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*5, 140, 44)];
        lblGoodTime4.textColor = [UIColor grayColor];
        lblGoodTime4.font = [UIFont systemFontOfSize:14];
        lblGoodTime4.textAlignment = NSTextAlignmentRight;
        lblGoodTime4.text = [WenzhanTool formateDateStr:item4.time];
        [background addSubview:lblGoodTime4];
        
        ExpressModel* item5 = [list objectAtIndex:5];
        UIImageView* corner5 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*6, 10, 10)];
        corner5.backgroundColor = [UIColor lightGrayColor];
        corner5.layer.masksToBounds = YES;
        corner5.layer.cornerRadius = 5;
        [background addSubview:corner5];
        
        UILabel* lblGood5 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*6, mainWidth-220, 44)];
        lblGood5.textColor = [UIColor grayColor];
        lblGood5.font = [UIFont systemFontOfSize:14];
        lblGood5.text = item5.context;
        lblGood5.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood5.numberOfLines = 2;
        [background addSubview:lblGood5];
        
        UILabel* lblGoodTime5 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*6, 140, 44)];
        lblGoodTime5.textColor = [UIColor grayColor];
        lblGoodTime5.font = [UIFont systemFontOfSize:14];
        lblGoodTime5.textAlignment = NSTextAlignmentRight;
        lblGoodTime5.text = [WenzhanTool formateDateStr:item5.time];
        [background addSubview:lblGoodTime5];
        
        ExpressModel* item6 = [list objectAtIndex:6];
        UIImageView* corner6 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*7, 10, 10)];
        corner6.backgroundColor = [UIColor lightGrayColor];
        corner6.layer.masksToBounds = YES;
        corner6.layer.cornerRadius = 5;
        [background addSubview:corner6];
        
        UILabel* lblGood6 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*7, mainWidth-220, 44)];
        lblGood6.textColor = [UIColor grayColor];
        lblGood6.font = [UIFont systemFontOfSize:14];
        lblGood6.text = item6.context;
        lblGood6.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood6.numberOfLines = 2;
        [background addSubview:lblGood6];
        
        UILabel* lblGoodTime6 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*7, 140, 44)];
        lblGoodTime6.textColor = [UIColor grayColor];
        lblGoodTime6.font = [UIFont systemFontOfSize:14];
        lblGoodTime6.textAlignment = NSTextAlignmentRight;
        lblGoodTime6.text = [WenzhanTool formateDateStr:item6.time];
        [background addSubview:lblGoodTime6];
        
        ExpressModel* item7 = [list objectAtIndex:7];
        UIImageView* corner7 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*8, 10, 10)];
        corner7.backgroundColor = [UIColor lightGrayColor];
        corner7.layer.masksToBounds = YES;
        corner7.layer.cornerRadius = 5;
        [background addSubview:corner7];
        
        UILabel* lblGood7 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*8, mainWidth-220, 44)];
        lblGood7.textColor = [UIColor grayColor];
        lblGood7.font = [UIFont systemFontOfSize:14];
        lblGood7.text = item7.context;
        lblGood7.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood7.numberOfLines = 2;
        [background addSubview:lblGood7];
        
        UILabel* lblGoodTime7 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*8, 140, 44)];
        lblGoodTime7.textColor = [UIColor grayColor];
        lblGoodTime7.font = [UIFont systemFontOfSize:14];
        lblGoodTime7.textAlignment = NSTextAlignmentRight;
        lblGoodTime7.text = [WenzhanTool formateDateStr:item7.time];
        [background addSubview:lblGoodTime7];
    }
    else if (list.count == 9)
    {
        ExpressModel* item = [list objectAtIndex:0];
        UIImageView* corner0 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12+44, 20, 20)];
        corner0.backgroundColor = [UIColor hexFloatColor:@"ebae29"];
        corner0.layer.masksToBounds = YES;
        corner0.layer.cornerRadius = 10;
        [background addSubview:corner0];
        
        UILabel* lblGood = [[UILabel alloc]initWithFrame:CGRectMake(60, 44, mainWidth-220, 44)];
        lblGood.textColor = [UIColor grayColor];
        lblGood.font = [UIFont systemFontOfSize:14];
        lblGood.text = item.context;
        lblGood.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood.numberOfLines = 2;
        [background addSubview:lblGood];
        
        UILabel* lblGoodTime = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44, 140, 44)];
        lblGoodTime.textColor = [UIColor grayColor];
        lblGoodTime.font = [UIFont systemFontOfSize:14];
        lblGoodTime.textAlignment = NSTextAlignmentRight;
        lblGoodTime.text = [WenzhanTool formateDateStr:item.time];
        [background addSubview:lblGoodTime];
        
        ExpressModel* item1 = [list objectAtIndex:1];
        UIImageView* corner1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*2, 10, 10)];
        corner1.backgroundColor = [UIColor lightGrayColor];
        corner1.layer.masksToBounds = YES;
        corner1.layer.cornerRadius = 5;
        [background addSubview:corner1];
        
        UILabel* lblGood1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*2, mainWidth-220, 44)];
        lblGood1.textColor = [UIColor grayColor];
        lblGood1.font = [UIFont systemFontOfSize:14];
        lblGood1.text = item1.context;
        lblGood1.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood1.numberOfLines = 2;
        [background addSubview:lblGood1];
        
        UILabel* lblGoodTime1 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*2, 140, 44)];
        lblGoodTime1.textColor = [UIColor grayColor];
        lblGoodTime1.font = [UIFont systemFontOfSize:14];
        lblGoodTime1.textAlignment = NSTextAlignmentRight;
        lblGoodTime1.text = [WenzhanTool formateDateStr:item1.time];
        [background addSubview:lblGoodTime1];
        
        ExpressModel* item2 = [list objectAtIndex:2];
        UIImageView* corner2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*3, 10, 10)];
        corner2.backgroundColor = [UIColor lightGrayColor];
        corner2.layer.masksToBounds = YES;
        corner2.layer.cornerRadius = 5;
        [background addSubview:corner2];
        
        UILabel* lblGood2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*3, mainWidth-220, 44)];
        lblGood2.textColor = [UIColor grayColor];
        lblGood2.font = [UIFont systemFontOfSize:14];
        lblGood2.text = item2.context;
        lblGood2.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood2.numberOfLines = 2;
        [background addSubview:lblGood2];
        
        UILabel* lblGoodTime2 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*3, 140, 44)];
        lblGoodTime2.textColor = [UIColor grayColor];
        lblGoodTime2.font = [UIFont systemFontOfSize:14];
        lblGoodTime2.textAlignment = NSTextAlignmentRight;
        lblGoodTime2.text = [WenzhanTool formateDateStr:item2.time];
        [background addSubview:lblGoodTime2];
        
        ExpressModel* item3 = [list objectAtIndex:3];
        UIImageView* corner3 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*4, 10, 10)];
        corner3.backgroundColor = [UIColor lightGrayColor];
        corner3.layer.masksToBounds = YES;
        corner3.layer.cornerRadius = 5;
        [background addSubview:corner3];
        
        UILabel* lblGood3 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*4, mainWidth-220, 44)];
        lblGood3.textColor = [UIColor grayColor];
        lblGood3.font = [UIFont systemFontOfSize:14];
        lblGood3.text = item3.context;
        lblGood3.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood3.numberOfLines = 2;
        [background addSubview:lblGood3];
        
        UILabel* lblGoodTime3 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*4, 140, 44)];
        lblGoodTime3.textColor = [UIColor grayColor];
        lblGoodTime3.font = [UIFont systemFontOfSize:14];
        lblGoodTime3.textAlignment = NSTextAlignmentRight;
        lblGoodTime3.text = [WenzhanTool formateDateStr:item3.time];
        [background addSubview:lblGoodTime3];
        
        ExpressModel* item4 = [list objectAtIndex:4];
        UIImageView* corner4 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*5, 10, 10)];
        corner4.backgroundColor = [UIColor lightGrayColor];
        corner4.layer.masksToBounds = YES;
        corner4.layer.cornerRadius = 5;
        [background addSubview:corner4];
        
        UILabel* lblGood4 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*5, mainWidth-220, 44)];
        lblGood4.textColor = [UIColor grayColor];
        lblGood4.font = [UIFont systemFontOfSize:14];
        lblGood4.text = item4.context;
        lblGood4.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood4.numberOfLines = 2;
        [background addSubview:lblGood4];
        
        UILabel* lblGoodTime4 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*5, 140, 44)];
        lblGoodTime4.textColor = [UIColor grayColor];
        lblGoodTime4.font = [UIFont systemFontOfSize:14];
        lblGoodTime4.textAlignment = NSTextAlignmentRight;
        lblGoodTime4.text = [WenzhanTool formateDateStr:item4.time];
        [background addSubview:lblGoodTime4];
        
        ExpressModel* item5 = [list objectAtIndex:5];
        UIImageView* corner5 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*6, 10, 10)];
        corner5.backgroundColor = [UIColor lightGrayColor];
        corner5.layer.masksToBounds = YES;
        corner5.layer.cornerRadius = 5;
        [background addSubview:corner5];
        
        UILabel* lblGood5 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*6, mainWidth-220, 44)];
        lblGood5.textColor = [UIColor grayColor];
        lblGood5.font = [UIFont systemFontOfSize:14];
        lblGood5.text = item5.context;
        lblGood5.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood5.numberOfLines = 2;
        [background addSubview:lblGood5];
        
        UILabel* lblGoodTime5 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*6, 140, 44)];
        lblGoodTime5.textColor = [UIColor grayColor];
        lblGoodTime5.font = [UIFont systemFontOfSize:14];
        lblGoodTime5.textAlignment = NSTextAlignmentRight;
        lblGoodTime5.text = [WenzhanTool formateDateStr:item5.time];
        [background addSubview:lblGoodTime5];
        
        ExpressModel* item6 = [list objectAtIndex:6];
        UIImageView* corner6 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*7, 10, 10)];
        corner6.backgroundColor = [UIColor lightGrayColor];
        corner6.layer.masksToBounds = YES;
        corner6.layer.cornerRadius = 5;
        [background addSubview:corner6];
        
        UILabel* lblGood6 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*7, mainWidth-220, 44)];
        lblGood6.textColor = [UIColor grayColor];
        lblGood6.font = [UIFont systemFontOfSize:14];
        lblGood6.text = item6.context;
        lblGood6.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood6.numberOfLines = 2;
        [background addSubview:lblGood6];
        
        UILabel* lblGoodTime6 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*7, 140, 44)];
        lblGoodTime6.textColor = [UIColor grayColor];
        lblGoodTime6.font = [UIFont systemFontOfSize:14];
        lblGoodTime6.textAlignment = NSTextAlignmentRight;
        lblGoodTime6.text = [WenzhanTool formateDateStr:item6.time];
        [background addSubview:lblGoodTime6];
        
        ExpressModel* item7 = [list objectAtIndex:7];
        UIImageView* corner7 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*8, 10, 10)];
        corner7.backgroundColor = [UIColor lightGrayColor];
        corner7.layer.masksToBounds = YES;
        corner7.layer.cornerRadius = 5;
        [background addSubview:corner7];
        
        UILabel* lblGood7 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*8, mainWidth-220, 44)];
        lblGood7.textColor = [UIColor grayColor];
        lblGood7.font = [UIFont systemFontOfSize:14];
        lblGood7.text = item7.context;
        lblGood7.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood7.numberOfLines = 2;
        [background addSubview:lblGood7];
        
        UILabel* lblGoodTime7 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*8, 140, 44)];
        lblGoodTime7.textColor = [UIColor grayColor];
        lblGoodTime7.font = [UIFont systemFontOfSize:14];
        lblGoodTime7.textAlignment = NSTextAlignmentRight;
        lblGoodTime7.text = [WenzhanTool formateDateStr:item7.time];
        [background addSubview:lblGoodTime7];
        
        ExpressModel* item8 = [list objectAtIndex:8];
        UIImageView* corner8 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*9, 10, 10)];
        corner8.backgroundColor = [UIColor lightGrayColor];
        corner8.layer.masksToBounds = YES;
        corner8.layer.cornerRadius = 5;
        [background addSubview:corner8];
        
        UILabel* lblGood8 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*9, mainWidth-220, 44)];
        lblGood8.textColor = [UIColor grayColor];
        lblGood8.font = [UIFont systemFontOfSize:14];
        lblGood8.text = item8.context;
        lblGood8.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood8.numberOfLines = 2;
        [background addSubview:lblGood8];
        
        UILabel* lblGoodTime8 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*9, 140, 44)];
        lblGoodTime8.textColor = [UIColor grayColor];
        lblGoodTime8.font = [UIFont systemFontOfSize:14];
        lblGoodTime8.textAlignment = NSTextAlignmentRight;
        lblGoodTime8.text = [WenzhanTool formateDateStr:item8.time];
        [background addSubview:lblGoodTime8];
    }
    else
    {
        ExpressModel* item = [list objectAtIndex:0];
        UIImageView* corner0 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 12+44, 20, 20)];
        corner0.backgroundColor = [UIColor hexFloatColor:@"ebae29"];
        corner0.layer.masksToBounds = YES;
        corner0.layer.cornerRadius = 10;
        [background addSubview:corner0];
        
        UILabel* lblGood = [[UILabel alloc]initWithFrame:CGRectMake(60, 44, mainWidth-220, 44)];
        lblGood.textColor = [UIColor grayColor];
        lblGood.font = [UIFont systemFontOfSize:14];
        lblGood.text = item.context;
        lblGood.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood.numberOfLines = 2;
        [background addSubview:lblGood];
        
        UILabel* lblGoodTime = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44, 140, 44)];
        lblGoodTime.textColor = [UIColor grayColor];
        lblGoodTime.font = [UIFont systemFontOfSize:14];
        lblGoodTime.textAlignment = NSTextAlignmentRight;
        lblGoodTime.text = [WenzhanTool formateDateStr:item.time];
        [background addSubview:lblGoodTime];
        
        ExpressModel* item1 = [list objectAtIndex:1];
        UIImageView* corner1 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*2, 10, 10)];
        corner1.backgroundColor = [UIColor lightGrayColor];
        corner1.layer.masksToBounds = YES;
        corner1.layer.cornerRadius = 5;
        [background addSubview:corner1];
        
        UILabel* lblGood1 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*2, mainWidth-220, 44)];
        lblGood1.textColor = [UIColor grayColor];
        lblGood1.font = [UIFont systemFontOfSize:14];
        lblGood1.text = item1.context;
        lblGood1.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood1.numberOfLines = 2;
        [background addSubview:lblGood1];
        
        UILabel* lblGoodTime1 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*2, 140, 44)];
        lblGoodTime1.textColor = [UIColor grayColor];
        lblGoodTime1.font = [UIFont systemFontOfSize:14];
        lblGoodTime1.textAlignment = NSTextAlignmentRight;
        lblGoodTime1.text = [WenzhanTool formateDateStr:item1.time];
        [background addSubview:lblGoodTime1];
        
        ExpressModel* item2 = [list objectAtIndex:2];
        UIImageView* corner2 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*3, 10, 10)];
        corner2.backgroundColor = [UIColor lightGrayColor];
        corner2.layer.masksToBounds = YES;
        corner2.layer.cornerRadius = 5;
        [background addSubview:corner2];
        
        UILabel* lblGood2 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*3, mainWidth-220, 44)];
        lblGood2.textColor = [UIColor grayColor];
        lblGood2.font = [UIFont systemFontOfSize:14];
        lblGood2.text = item2.context;
        lblGood2.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood2.numberOfLines = 2;
        [background addSubview:lblGood2];
        
        UILabel* lblGoodTime2 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*3, 140, 44)];
        lblGoodTime2.textColor = [UIColor grayColor];
        lblGoodTime2.font = [UIFont systemFontOfSize:14];
        lblGoodTime2.textAlignment = NSTextAlignmentRight;
        lblGoodTime2.text = [WenzhanTool formateDateStr:item2.time];
        [background addSubview:lblGoodTime2];
        
        ExpressModel* item3 = [list objectAtIndex:3];
        UIImageView* corner3 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*4, 10, 10)];
        corner3.backgroundColor = [UIColor lightGrayColor];
        corner3.layer.masksToBounds = YES;
        corner3.layer.cornerRadius = 5;
        [background addSubview:corner3];
        
        UILabel* lblGood3 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*4, mainWidth-220, 44)];
        lblGood3.textColor = [UIColor grayColor];
        lblGood3.font = [UIFont systemFontOfSize:14];
        lblGood3.text = item3.context;
        lblGood3.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood3.numberOfLines = 2;
        [background addSubview:lblGood3];
        
        UILabel* lblGoodTime3 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*4, 140, 44)];
        lblGoodTime3.textColor = [UIColor grayColor];
        lblGoodTime3.font = [UIFont systemFontOfSize:14];
        lblGoodTime3.textAlignment = NSTextAlignmentRight;
        lblGoodTime3.text = [WenzhanTool formateDateStr:item3.time];
        [background addSubview:lblGoodTime3];
        
        ExpressModel* item4 = [list objectAtIndex:4];
        UIImageView* corner4 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*5, 10, 10)];
        corner4.backgroundColor = [UIColor lightGrayColor];
        corner4.layer.masksToBounds = YES;
        corner4.layer.cornerRadius = 5;
        [background addSubview:corner4];
        
        UILabel* lblGood4 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*5, mainWidth-220, 44)];
        lblGood4.textColor = [UIColor grayColor];
        lblGood4.font = [UIFont systemFontOfSize:14];
        lblGood4.text = item4.context;
        lblGood4.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood4.numberOfLines = 2;
        [background addSubview:lblGood4];
        
        UILabel* lblGoodTime4 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*5, 140, 44)];
        lblGoodTime4.textColor = [UIColor grayColor];
        lblGoodTime4.font = [UIFont systemFontOfSize:14];
        lblGoodTime4.textAlignment = NSTextAlignmentRight;
        lblGoodTime4.text = [WenzhanTool formateDateStr:item4.time];
        [background addSubview:lblGoodTime4];
        
        ExpressModel* item5 = [list objectAtIndex:5];
        UIImageView* corner5 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*6, 10, 10)];
        corner5.backgroundColor = [UIColor lightGrayColor];
        corner5.layer.masksToBounds = YES;
        corner5.layer.cornerRadius = 5;
        [background addSubview:corner5];
        
        UILabel* lblGood5 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*6, mainWidth-220, 44)];
        lblGood5.textColor = [UIColor grayColor];
        lblGood5.font = [UIFont systemFontOfSize:14];
        lblGood5.text = item5.context;
        lblGood5.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood5.numberOfLines = 2;
        [background addSubview:lblGood5];
        
        UILabel* lblGoodTime5 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*6, 140, 44)];
        lblGoodTime5.textColor = [UIColor grayColor];
        lblGoodTime5.font = [UIFont systemFontOfSize:14];
        lblGoodTime5.textAlignment = NSTextAlignmentRight;
        lblGoodTime5.text = [WenzhanTool formateDateStr:item5.time];
        [background addSubview:lblGoodTime5];
        
        ExpressModel* item6 = [list objectAtIndex:6];
        UIImageView* corner6 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*7, 10, 10)];
        corner6.backgroundColor = [UIColor lightGrayColor];
        corner6.layer.masksToBounds = YES;
        corner6.layer.cornerRadius = 5;
        [background addSubview:corner6];
        
        UILabel* lblGood6 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*7, mainWidth-220, 44)];
        lblGood6.textColor = [UIColor grayColor];
        lblGood6.font = [UIFont systemFontOfSize:14];
        lblGood6.text = item6.context;
        lblGood6.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood6.numberOfLines = 2;
        [background addSubview:lblGood6];
        
        UILabel* lblGoodTime6 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*7, 140, 44)];
        lblGoodTime6.textColor = [UIColor grayColor];
        lblGoodTime6.font = [UIFont systemFontOfSize:14];
        lblGoodTime6.textAlignment = NSTextAlignmentRight;
        lblGoodTime6.text = [WenzhanTool formateDateStr:item6.time];
        [background addSubview:lblGoodTime6];
        
        ExpressModel* item7 = [list objectAtIndex:7];
        UIImageView* corner7 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*8, 10, 10)];
        corner7.backgroundColor = [UIColor lightGrayColor];
        corner7.layer.masksToBounds = YES;
        corner7.layer.cornerRadius = 5;
        [background addSubview:corner7];
        
        UILabel* lblGood7 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*8, mainWidth-220, 44)];
        lblGood7.textColor = [UIColor grayColor];
        lblGood7.font = [UIFont systemFontOfSize:14];
        lblGood7.text = item7.context;
        lblGood7.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood7.numberOfLines = 2;
        [background addSubview:lblGood7];
        
        UILabel* lblGoodTime7 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*8, 140, 44)];
        lblGoodTime7.textColor = [UIColor grayColor];
        lblGoodTime7.font = [UIFont systemFontOfSize:14];
        lblGoodTime7.textAlignment = NSTextAlignmentRight;
        lblGoodTime7.text = [WenzhanTool formateDateStr:item7.time];
        [background addSubview:lblGoodTime7];
        
        ExpressModel* item8 = [list objectAtIndex:8];
        UIImageView* corner8 = [[UIImageView alloc]initWithFrame:CGRectMake(20, 17+44*9, 10, 10)];
        corner8.backgroundColor = [UIColor lightGrayColor];
        corner8.layer.masksToBounds = YES;
        corner8.layer.cornerRadius = 5;
        [background addSubview:corner8];
        
        UILabel* lblGood8 = [[UILabel alloc]initWithFrame:CGRectMake(60, 44*9, mainWidth-220, 44)];
        lblGood8.textColor = [UIColor grayColor];
        lblGood8.font = [UIFont systemFontOfSize:14];
        lblGood8.text = item8.context;
        lblGood8.lineBreakMode = NSLineBreakByWordWrapping;
        lblGood8.numberOfLines = 2;
        [background addSubview:lblGood8];
        
        UILabel* lblGoodTime8 = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-150, 44*9, 140, 44)];
        lblGoodTime8.textColor = [UIColor grayColor];
        lblGoodTime8.font = [UIFont systemFontOfSize:14];
        lblGoodTime8.textAlignment = NSTextAlignmentRight;
        lblGoodTime8.text = [WenzhanTool formateDateStr:item8.time];
        [background addSubview:lblGoodTime8];
    }
    
}

@end
