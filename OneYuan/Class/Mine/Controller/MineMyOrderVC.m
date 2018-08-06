//
//  MineMyOrderVC.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineMyOrderVC.h"
#import "MineMyOrderModel.h"
#import "MineOrderCell.h"
#import "MineOrderHeadView.h"
#import "MineMyOrderTransVC.h"
#import "MineMyAddressVC.h"
#import "ProductLotteryVC.h"
#import "MineShowOrderVC.h"

@interface MineMyOrderVC ()<UITableViewDataSource,UITableViewDelegate,MineMyOrderCellDelegate,MineMyAddressVCDelegate>
{
    __block UITableView     *tbView;
    __block NSMutableArray  *arrData;
    __block NSInteger             allCount;
    __block int             curPage;
    
    MineOrderHeadView       *vHead;
}

@end

@implementation MineMyOrderVC
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tbView triggerPullToRefresh];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"获得的奖品";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.view.bounds.size.height ) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = self.view.backgroundColor;
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    curPage = 1;
    [tbView addPullToRefreshWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->curPage = 1;
        [wSelf getData:^{
            sSelf->arrData = nil;
        }];
    }];
    
    [tbView addInfiniteScrollingWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->curPage ++;
        [wSelf getData:nil];
    }];
    [tbView.pullToRefreshView setOYStyle];
    [tbView triggerPullToRefresh];
    
//    [self getRecievedGoodStatus];
    
}

#pragma mark - getdata
- (void)getData:(void (^)(void))block
{
    [[XBToastManager ShardInstance] showprogress];
    __weak typeof (self) wSelf = self;
    
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    
    NSString* page = [NSString stringWithFormat:@"%d",curPage];
    NSString*uid   = [UserInstance ShardInstnce].uid;
    NSDictionary* dict = @{@"uid":uid,@"currentPage":page,@"maxShowPage":@"10",@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
    [MineMyOrderModel getUserOrderlist:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        if(block != NULL)
            block();
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        [wSelf hideLoad];
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        NSArray* list = [MineMyOrderItem arrayOfModelsFromDictionaries:@[dataDict] error:&error];
        if (!arrData)
        {
            arrData = [NSMutableArray arrayWithArray:list];
        }
        else
        {
            [arrData addObjectsFromArray:list];
        }
        allCount = arrData.count;
        
        if(arrData.count == 0)
        {
            [tbView setHidden:YES];
            [wSelf showEmpty];
        }
        else
        {
            [tbView setHidden:NO];
            [wSelf hideEmpty];
        }
        [tbView reloadData];
        [tbView setShowsInfiniteScrolling:YES];
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
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
    MineMyOrderItem* item = [arrData objectAtIndex:indexPath.row];
    if ([item.shengyutime intValue] > 0)
    {
        return 0;
    }else
    {
        return 120;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    vHead = [[MineOrderHeadView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 35)];
    if (arrData.count == 0) {
        [vHead setNum:0];
    }else
    {
        MineMyOrderItem* item = [arrData objectAtIndex:0];
        if ([item.shengyutime intValue] > 0) {
            [vHead setNum:allCount-1];
        }else{
            [vHead setNum:allCount];
        }
    }
    return vHead;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineMyOrderItem* item = [arrData objectAtIndex:indexPath.row];
    if ([item.shengyutime intValue] <= 0) {
        static NSString *CellIdentifier = @"mineOrderCell";
        MineOrderCell *cell =  (MineOrderCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[MineOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.delegate = self;
        [cell setMyOrder:item];
        return cell;

    }
    static NSString *CellIdentifier = @"mineNormalCell";
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
    
    MineMyOrderItem* item = [arrData objectAtIndex:indexPath.row];
    ProductLotteryVC* vc = [[ProductLotteryVC alloc]initWithGoods:item.pid codeId:item.sid userId:item.q_uid];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//确认收货地址
#pragma mark - delegate
- (void)confirmOrder:(MineMyOrderItem*)item
{
    //选择默认收获地址，跳转到地址页面；
    MineMyAddressVC* vc = [[MineMyAddressVC alloc] initWithType:MineAddressType_Select OrderId:item];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

//查询物流信息
- (void)confirmShip:(MineMyOrderItem*)item
{
    MineMyOrderTransVC* vc = [[MineMyOrderTransVC alloc]initWithNo:item];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//查看晒单详情
- (void)checkShowOrder:(MineMyOrderItem*)item
{
    MineShowOrderVC* vc = [[MineShowOrderVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)refreshMyOrder
{
    curPage = 1;
    __weak typeof (self) wSelf = self;
    [self getData:^{
        __strong typeof (self) sSelf = wSelf;
        sSelf->arrData = nil;
    }];
}
@end
