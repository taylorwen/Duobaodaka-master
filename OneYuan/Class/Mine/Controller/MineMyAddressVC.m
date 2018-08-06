//
//  MineMyAddressVC.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineMyAddressVC.h"
#import "MineMyAddressModel.h"
#import "MineMyAddItemCell.h"
#import "MineMyOrderModel.h"
#import "MineAdressEditVC.h"
#import "MineMyOrderModel.h"

@interface MineMyAddressVC ()<UITableViewDataSource,UITableViewDelegate,MineMyAddressEditVCDelegate,MineMyAddItemCellDelegate>
{
    __weak  id<MineMyAddressVCDelegate> delegate;
    __block MineAddressType         myType;
    __block int                     myOrderId;
//    __block MineMyAddressItemList   *myAddressData;
    
    __block UITableView             *tbView;
    __block NSMutableArray          *arrData;
    __block MineMyOrderItem         *myItem;
}
@end

@implementation MineMyAddressVC
@synthesize delegate;

- (id)initWithType:(MineAddressType)type OrderId:(MineMyOrderItem*)item
{
    self = [super init];
    if(self)
    {
        myType = type;
        myItem = item;
       
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = myType == MineAddressType_Common ? @"地址管理" : @"地址选择";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    if(myType == MineAddressType_Common)
    {
        [self actionCustomRightBtnWithNrlImage:@"btnAdd" htlImage:@"btnAdd" title:@"" action:^{
            MineAdressEditVC* vc  = [[MineAdressEditVC alloc] initWithAddress:nil];
            vc.delegate = self;
            vc.hidesBottomBarWhenPushed = YES;
            [wSelf.navigationController pushViewController:vc animated:YES];
        }];
    }

    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.view.bounds.size.height - 35) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = self.view.backgroundColor;
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    [tbView addPullToRefreshWithActionHandler:^{
        [wSelf getAddress];
    }];
    [tbView.pullToRefreshView setOYStyle];
    [tbView triggerPullToRefresh];
    
    [self showLoad];
}

- (void)getAddress
{
    __weak typeof (self) wSelf = self;
    
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"uid":[UserInstance ShardInstnce].uid, @"currentPage":@"1",@"maxShowPage":@"10",@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
    [MineMyAddressModel getMyAddress:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        [tbView.pullToRefreshView stopAnimating];
        [[XBToastManager ShardInstance] hideprogress];
        [wSelf hideLoad];
        arrData = [[NSMutableArray alloc]init];
        arrData = [MineMyAddressItem arrayOfModelsFromDictionaries:@[dataDict] error:&error];
        
        [tbView reloadData];
        
        if(arrData.count == 0)
            [wSelf showEmpty];
        else
            [wSelf hideEmpty];
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
    }];
}

#pragma mark - delegate
- (void)refreshAddress
{
    [tbView triggerPullToRefresh];
}

//设置默认地址
- (void)setDefault:(int)addressId
{
    __weak typeof (self) wSelf = self;
    
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    
    [[XBToastManager ShardInstance] showprogress];
    NSDictionary* dict = @{@"uid":[UserInstance ShardInstnce].uid, @"pid":[NSString stringWithFormat:@"%d",addressId],@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
    [MineMyAddressModel setDefault:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [[XBToastManager ShardInstance] showprogress];
        OneBaseParser* p = [[OneBaseParser alloc] initWithDictionary:(NSDictionary*)result error:NULL];
        if([p.resultCode isEqualToString:@"200"])
        {
            [wSelf getAddress];
        }
        else
        {
            [[XBToastManager ShardInstance] showprogress];
            [[XBToastManager ShardInstance] showtoast:@"设置失败，请重试"];
        }
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] showprogress];
    }];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineMyAddressItem* item = [arrData objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"mineAddressCell";
    MineMyAddItemCell *cell =  (MineMyAddItemCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[MineMyAddItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setDelegate:self];
    [cell setAddress:item bShow:myType == MineAddressType_Common];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MineMyAddressItem* item = [arrData objectAtIndex:indexPath.row];
    if(myType == MineAddressType_Common)
    {
        MineAdressEditVC* vc  = [[MineAdressEditVC alloc] initWithAddress:item];
        vc.delegate = self;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        //确认收货地址
        __weak typeof (self) wSelf = self;
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:[NSString stringWithFormat:@"是否确认使用此地址：%@ %@ %@ %@ %@ %@？",item.sheng,item.shi,item.xian,item.jiedao,item.shouhuoren,item.mobile]
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
            
            //需要上传的参数，时间戳(精确到毫秒)
            NSString* timestamp = [WenzhanTool getCurrentTime];
            NSString* auth_key = [WenzhanTool getaes256DecodeData];
            //MD5加密的token
            NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
            NSString* token = [NSString md5:strOrigin];
            
            NSDictionary* dict = @{@"pid":myItem.pid,@"uid":[UserInstance ShardInstnce].uid,@"address_id":item.pid,@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
            [MineMyOrderModel doConfirmOrder:dict success:^(AFHTTPRequestOperation* opreation, NSObject* result){
                OneBaseParser* p = [[OneBaseParser alloc] initWithDictionary:(NSDictionary*)result error:NULL];
                NSLog(@"%@",p);
                if([p.resultCode isEqualToString:@"200"])
                {
                    [[XBToastManager ShardInstance] showtoast:@"添加收货信息成功"];
                    if(delegate)
                    {
                        [delegate refreshMyOrder];
                        [wSelf.navigationController popViewControllerAnimated:YES];
                    }
                }
            } failure:^(NSError* error){

            }];

        }], nil] show];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = (int)indexPath.row;
    if(row >= arrData.count)
        return false;
    MineMyAddressItem* item = [arrData objectAtIndex:row];
    return ![item.isdefault boolValue];//默认地址不允许被修改
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除地址";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        MineMyAddressItem* item = [arrData objectAtIndex:indexPath.row];
        if([item.isdefault boolValue])
            return;
        
        [[[UIAlertView alloc] initWithTitle:nil
                                    message:@"是否确认删除该地址？"
                           cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                           otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
            
            [[XBToastManager ShardInstance] showprogress];
            
            NSString* timestamp = [WenzhanTool getCurrentTime];
            NSString* auth_key = [WenzhanTool getaes256DecodeData];
            //MD5加密的token
            NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
            NSString* token = [NSString md5:strOrigin];
            
            NSDictionary* dict = @{@"pid":item.pid,@"uid":[UserInstance ShardInstnce].uid,@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
            [MineMyAddressModel delMyAddress:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
                [[XBToastManager ShardInstance] hideprogress];
                
                OneBaseParser* p = [[OneBaseParser alloc] initWithDictionary:(NSDictionary*)result error:NULL];
                if([p.resultCode isEqualToString:@"200"])
                {
                    NSMutableArray* tmp = [NSMutableArray arrayWithArray:arrData];
                    [tmp removeObjectAtIndex:indexPath.row];
                    arrData = tmp;
                    [tbView reloadData];
                    [[XBToastManager ShardInstance] showtoast:@"删除地址成功"];
                }
                else
                {
                    [[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"删除地址异常：%d",[p.resultCode intValue]]];
                }
            } failure:^(NSError* error){
                [[XBToastManager ShardInstance] showprogress];
            }];
            
        }], nil] show];

    }
}

@end
