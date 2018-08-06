//
//  MineMyOrderTransVC.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineMyOrderTransVC.h"
#import "MineMyOrderModel.h"
#import "MineMyOrderTransModel.h"
#import "MineOrderTranAddressCell.h"
#import "MineOrderTranMsgCell.h"
#import "GoodsInfoCell.h"
#import "GoodStatusCell.h"
#import "TransportInfoCell.h"
#import "AddressInfoCell.h"
#import "MineMyOrderModel.h"
#import "ExpressCheckVC.h"

@interface MineMyOrderTransVC()<UITableViewDataSource,UITableViewDelegate,TransportInfoCellDelegate,GoodStatusCellDelegate>
{
    NSString*     myPid;
    
    __block UITableView         *tbView;
     MineMyOrderTrans       *tranItem;
     MineMyOrderTransInfo   *tranInfoItem;
    MineMyOrderItem*        item;
    
    NSString* company_code;
    NSString* company;
    NSString* shouhuo_address;
    
    NSArray*    listArr;
    
}
@end

@implementation MineMyOrderTransVC

- (id)initWithNo:(MineMyOrderItem*)no
{
    self = [super init];
    if(self)
    {
        item = no;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"物流详情";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = self.view.backgroundColor;
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    [tbView addPullToRefreshWithActionHandler:^{
        [wSelf getData];
    }];
    [tbView.pullToRefreshView setOYStyle];
    [tbView triggerPullToRefresh];

}

- (void)getData
{
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"uid":[UserInstance ShardInstnce].uid,@"pid":item.pid,@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
    [MineMyOrderTransModel getUserOrderTrans:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        
        [tbView.pullToRefreshView stopAnimating];
        [[XBToastManager ShardInstance]hideprogress];
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSDictionary* StatusDict = [dataDict objectForKey:@"zhongjiang_status_list"];
        NSError* error = nil;
        tranItem = [[MineMyOrderTrans alloc] initWithDictionary:dataDict error:&error];
        listArr = [MineMyOrderTransInfo arrayOfModelsFromDictionaries:@[StatusDict] error:&error];
        NSLog(@"%@",listArr);
        
        [tbView reloadData];
        
    } failure:^(NSError* error){
        [tbView.pullToRefreshView stopAnimating];
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取商品物流异常：%@",error]];
    }];

}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
        return 1;
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 120;
    }
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        return 220;
    }
    if (indexPath.section == 2 && indexPath.row == 1)
    {
        return 60;
    }
    if (indexPath.section == 3 && indexPath.row == 1)
    {
        return 100;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 0.01;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"GoodsInfoCell";
        GoodsInfoCell *cell =  (GoodsInfoCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[GoodsInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setGoodsItem:item];
        return cell;
    }
    else if(indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"GoodsOrderCell";
            UITableViewCell *cell =  (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            UIImageView* goodimg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 16, 12, 11)];
            goodimg.image = [UIImage imageNamed:@"status"];
            [cell addSubview:goodimg];
            
            UILabel* lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, mainWidth-50, 44)];
            lblStatus.textColor = [UIColor grayColor];
            lblStatus.font = [UIFont systemFontOfSize:14];
            lblStatus.text = @"奖品状态";
            [cell addSubview:lblStatus];
            return cell;
        }else
        {
            static NSString *CellStatusIdentifier = @"GoodFuckStatusCell";
            GoodStatusCell *cell =  (GoodStatusCell*)[tableView  dequeueReusableCellWithIdentifier:CellStatusIdentifier];
            if(cell == nil)
            {
                cell = [[GoodStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellStatusIdentifier];
            }
            [cell setDelegate:self];
            [cell setStatus:listArr Model:tranItem];
            return cell;
        }
        
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"StatusOrderCell";
            UITableViewCell *cell =  (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            UIImageView* goodimg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 17, 15, 10)];
            goodimg.image = [UIImage imageNamed:@"transport"];
            [cell addSubview:goodimg];
            
            UILabel* lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, mainWidth-50, 44)];
            lblStatus.textColor = [UIColor grayColor];
            lblStatus.font = [UIFont systemFontOfSize:14];
            lblStatus.text = @"物流信息";
            [cell addSubview:lblStatus];
            return cell;
        }else
        {
            static NSString *CellIdentifier = @"TransportInfoCell";
            TransportInfoCell *cell =  (TransportInfoCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[TransportInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setTrans:tranItem];
            [cell setDelegate:self];
            return cell;
        }
        
    }
    else if (indexPath.section == 3)
    {
        if (indexPath.row == 0) {
            static NSString *CellIdentifier = @"AddressOrderCell";
            UITableViewCell *cell =  (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            UIImageView* goodimg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 12.5, 12.5)];
            goodimg.image = [UIImage imageNamed:@"address"];
            [cell addSubview:goodimg];
            
            UILabel* lblStatus = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, mainWidth-50, 44)];
            lblStatus.textColor = [UIColor grayColor];
            lblStatus.font = [UIFont systemFontOfSize:14];
            lblStatus.text = @"地址信息";
            [cell addSubview:lblStatus];
            return cell;
        }else
        {
            static NSString *CellIdentifier = @"TransportInfoCell";
            AddressInfoCell *cell =  (AddressInfoCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[AddressInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setAddress:tranItem.shouhuo_address];
            return cell;
        }
        
    }
    static NSString *CellIdentifier = @"mineOrderCell";
    UITableViewCell *cell =  (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)btnCheckTranAction:(MineMyOrderTrans*)itemTr
{
    ExpressCheckVC* vc = [[ExpressCheckVC alloc]initWithNo:itemTr];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//确认收货
- (void)btnStatusTranAction
{
    [[XBToastManager ShardInstance]showprogress];
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"pid":item.pid,@"uid":[UserInstance ShardInstnce].uid,@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
    [MineMyOrderTransModel getUserConfirmGood:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        
        [[XBToastManager ShardInstance]hideprogress];
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:NULL];
        if ([parser.resultCode isEqualToString:@"200"]) {
            //确认收货成功，返回上一层
            [[[UIAlertView alloc] initWithTitle:@"确认收货成功"
                                        message:@""
                               cancelButtonItem:nil
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
                [[XBToastManager ShardInstance]showtoast:[NSString stringWithFormat:@"%@",parser.resultMessage] wait:3.0f];
                [self.navigationController popViewControllerAnimated:YES];
            }], nil] show];
        }
        else
        {
            [[XBToastManager ShardInstance]showtoast:[NSString stringWithFormat:@"%@",parser.resultMessage] wait:3.0f];
        }
        
    } failure:^(NSError* error){
    }];
}
@end
