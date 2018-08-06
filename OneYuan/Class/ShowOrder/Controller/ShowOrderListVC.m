//
//  ShowOrderListVC.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ShowOrderListVC.h"
#import "ShowOrderModel.h"
#import "ShowOrderItemCell.h"
#import "ShowOrderDetailVC.h"
#import "LotteryPersonVC.h"

@interface ShowOrderListVC ()<UITableViewDataSource,UITableViewDelegate,ShowOrderItemDelegate>
{
    __block UITableView     *tbView;
    __block int             curPage;
    __block NSMutableArray  *arrData;
    
    NSString*               _goodsId;
    NSString*               _uid;
}
@end

@implementation ShowOrderListVC

- (id)initWithGoodsId:(NSString*)goodsId userid:(NSString*)uid
{
    self = [super init];
    if(self)
    {
        _goodsId = goodsId;
        _uid     = uid;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"奖品晒单";
    __weak typeof (self) wSelf = self;
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    //下拉刷新
    [tbView addPullToRefreshWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->curPage = 1;
        [wSelf getData:^{
            sSelf->arrData = nil;
        }];
    }];
    //上拉加载
    [tbView addInfiniteScrollingWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->curPage ++;
        [wSelf getData:nil];
    }];
    
    [tbView.pullToRefreshView setOYStyle];
    [tbView triggerPullToRefresh];

}

- (void)getData:(void (^)(void))block
{
    __weak typeof (self) wSelf = self;
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"sid":_goodsId,@"uid":_uid,@"currentPage":[NSString stringWithFormat:@"%d",curPage],@"maxShowPage":@"10",@"token":token,@"timestamp":timestamp};
    [ShowOrderModel getShowGoodsList:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        if(block!=NULL)
            block();
        NSArray*    list = [ShowOrderItem arrayOfModelsFromDictionaries:@[dataDict] error:&error];
        if (!arrData)
        {
            arrData = [NSMutableArray arrayWithArray:list];
        }
        else
        {
            [arrData addObjectsFromArray:list];
        }
        [tbView reloadData];
        [tbView setShowsInfiniteScrolling:YES];
        if(arrData.count == 0)
        {
            [wSelf showEmpty];
        }
    } failure:^(NSError* error){
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取商品晒单页面数据异常:%@",error]];
    }];

}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (mainWidth-60)/3+130;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 0.1;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"newedCell";
    ShowOrderItemCell *cell = (ShowOrderItemCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[ShowOrderItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.delegate = self;
    [cell setShow:[arrData objectAtIndex:indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ShowOrderDetailVC* vc = [[ShowOrderDetailVC alloc] initWithPostId:[[arrData objectAtIndex:indexPath.section] sd_id] Content:[[arrData objectAtIndex:indexPath.section]sd_content]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)doUsernameClicked:(NSUInteger)index
{
    ShowOrderItem* item = [arrData objectAtIndex:index];
    LotteryPersonVC* vc = [[LotteryPersonVC alloc]initWithGoodsId:item.sd_userid];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
