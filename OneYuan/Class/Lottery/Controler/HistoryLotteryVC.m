//
//  HistoryLotteryVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/12.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "HistoryLotteryVC.h"
#import "LotteryHistoryCell.h"
#import "LotteryModel.h"
#import "ProductLotteryVC.h"

@interface HistoryLotteryVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __block UITableView     *tbView;
    __block NSMutableArray  *arrData;
    __block int             curPage;
    __block NSString        *sid;
}
@end

@implementation HistoryLotteryVC
- (id)initWithGoodsId:(NSString*)goodsId
{
    self = [super init];
    if(self)
    {
        sid  = goodsId;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"往期揭晓";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = self.view.backgroundColor;
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
}

#pragma mark - getdata
- (void)getData:(void (^)(void))block
{
    __weak typeof(self) wSelf = self;
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    NSDictionary* dict = @{@"sid":sid,@"currentPage":[NSString stringWithFormat:@"%d",curPage],@"maxShowPage":@"10",@"token":token,@"timestamp":timestamp};
    [LotteryModel getHistoryLotterylist:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        if(block != NULL)
            block();
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        NSArray* list = [HistoryLotteryModel arrayOfModelsFromDictionaries:@[dataDict] error:&error];
        if(!arrData)
            arrData = [NSMutableArray arrayWithArray:list];
        else
            [arrData addObjectsFromArray:list];
        [tbView setShowsInfiniteScrolling:YES];
        [tbView reloadData];
        if(arrData.count == 0)
        {
            [wSelf showEmpty];
        }
        else
        {
            [wSelf hideEmpty];
        }
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        
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
    HistoryLotteryModel* item = [arrData objectAtIndex:indexPath.section];
    if ([item.shengyutime intValue] > 0) {
        return 44;
    }
    return 122;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryLotteryModel* item = [arrData objectAtIndex:indexPath.section];
    
    if ([item.shengyutime intValue] > 0)
    {
        static NSString* cellIndetifier = @"lotteryHistoryCell";
        UITableViewCell* cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIndetifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndetifier];
        }
        UILabel* lblQishu = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, mainWidth-20, 44)];
        lblQishu.font = [UIFont systemFontOfSize:16];
        lblQishu.lineBreakMode = NSLineBreakByWordWrapping;
        lblQishu.numberOfLines = 1;
        lblQishu.textColor = [UIColor grayColor];
        lblQishu.text = [NSString stringWithFormat:@"(第%@期) 正在揭晓中...",item.qishu];
        [cell addSubview:lblQishu];
        UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, mainWidth, 0.5)];
        line.backgroundColor = myLineColor;
        [cell addSubview:line];
        return cell;
    }else
    {
        static NSString *CellIdentifier = @"mineShowOrderCell";
        LotteryHistoryCell *cell =  (LotteryHistoryCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[LotteryHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setMyLottery:item];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HistoryLotteryModel* item = [arrData objectAtIndex:indexPath.section];
    ProductLotteryVC* vc = [[ProductLotteryVC alloc]initWithGoods:item.pid codeId:item.sid userId:item.q_uid];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
@end
