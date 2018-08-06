//
//  MineShowOrderVC.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineShowOrderVC.h"
#import "MineShowOrderCell.h"
#import "MineShowOrderModel.h"
#import "ShowOrderDetailVC.h"
#import "mineUnshowOrderCell.h"
#import "ShowOrderEditVC.h"

@interface MineShowOrderVC ()<UITableViewDataSource,UITableViewDelegate,MineShowOrderDelegate>
{
    __block UITableView             *tbView;
    __block NSMutableArray          *arrData;
    __block NSMutableArray          *arrUnPro;
    __block int                     allCount;
    __block int                     curPage;
    __block  UISegmentedControl*    seg;
    __block  int                    indexSeg;
}

@end

@implementation MineShowOrderVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"我的晒单";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    seg = [[UISegmentedControl alloc] initWithItems:@[@"已晒单",@"未晒单"]];
    seg.frame = CGRectMake(50, 10, mainWidth - 100, 32);
    [seg setTintColor:mainColor];
    [seg setSelectedSegmentIndex:0];
    [seg addTarget:self action:@selector(setSelectChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seg];
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 52, mainWidth, self.view.bounds.size.height - 35) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = self.view.backgroundColor;
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    [tbView addInfiniteScrollingWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->curPage ++;
        if (indexSeg == 0) {
            [wSelf getData];
        }else
        {
            [wSelf getUnshowData];
        }
    }];
    curPage = 1;
    indexSeg = 0;
    [self getData];
}

#pragma mark - seg action
- (void)setSelectChange:(UISegmentedControl*)_seg
{
    [[XBToastManager ShardInstance] showprogress];
    curPage = 1;
    if (_seg.selectedSegmentIndex == 0)
    {
        arrData = nil;
        indexSeg = 0;
        [self getData];
    }
    else {
        arrUnPro = nil;
        indexSeg = 1;
        [self getUnshowData];
    }
    
}

#pragma mark - getdata
- (void)getData
{
    __weak typeof(self) wSelf = self;
    
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    
    NSString* _uid = [UserInstance ShardInstnce].uid;
    NSDictionary* dict = @{@"sid":@"0",@"uid":_uid,@"currentPage":[NSString stringWithFormat:@"%d",curPage],@"maxShowPage":@"10",@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
    [MineShowOrderModel getShowOrderlist:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
       
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        NSArray* list = [MineShowOrderItem arrayOfModelsFromDictionaries:@[dataDict] error:&error];
        if(!arrData)
            arrData = [NSMutableArray arrayWithArray:list];
        else
            [arrData addObjectsFromArray:list];
        
        [tbView setShowsInfiniteScrolling:YES];
        [tbView reloadData];
        
        if(arrData.count == 0)
        {
            [wSelf showEmpty:CGRectMake(0, self.view.bounds.size.height/2-150, 100, 100)];
        }
        else
        {
            [wSelf hideEmpty];
        }
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取我的晒单异常：%@",error]];
    }];
}

- (void)getUnshowData
{
    __weak typeof(self) wSelf = self;
    
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    
    NSString* _uid = [UserInstance ShardInstnce].uid;
    NSDictionary* dict = @{@"uid":_uid,@"currentPage":[NSString stringWithFormat:@"%d",curPage],@"maxShowPage":@"10",@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
    [MineShowOrderModel getUnShowOrderlist:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        NSArray* list = [MineUnshowOrderItem arrayOfModelsFromDictionaries:@[dataDict] error:&error];
        if (!arrUnPro) {
            arrUnPro = [NSMutableArray arrayWithArray:list];
        }else
        {
            [arrUnPro addObjectsFromArray:list];
        }
        [tbView setShowsInfiniteScrolling:YES];
        [tbView reloadData];
        if(arrUnPro.count == 0)
        {
            [wSelf showEmpty:CGRectMake(0, self.view.bounds.size.height/2-150, 100, 100)];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (indexSeg == 0) {
        return arrData.count;
    }
    else{
        return arrUnPro.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexSeg == 1) {
        return 120;
    }
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexSeg == 0)
    {
        MineShowOrderItem* item = [arrData objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"mineShowOrderCell";
        MineShowOrderCell *cell =  (MineShowOrderCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[MineShowOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setMyPost:item];
        return cell;
    }
    else
    {
        MineUnshowOrderItem* item = [arrUnPro objectAtIndex:indexPath.row];
        static NSString *cellIdentifier = @"mineUnshowOrderCell";
        MineUnshowOrderCell *cell =  (MineUnshowOrderCell*)[tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell == nil)
        {
            cell = [[MineUnshowOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.delegate = self;
        [cell setMyOrder:item];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexSeg == 0) {
        MineShowOrderItem* item = [arrData objectAtIndex:indexPath.row];
        ShowOrderDetailVC* vc = [[ShowOrderDetailVC alloc] initWithPostId:item.sd_id Content:@""];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)goToShowOrderAction:(MineUnshowOrderItem *)myItem
{
    ShowOrderEditVC* vc = [[ShowOrderEditVC alloc]initWithOrder:myItem];
    vc.hidesBottomBarWhenPushed = YES;
    __weak typeof(self) wSelf = self;
    vc.myBlock = ^{
        [arrUnPro removeAllObjects];
        [wSelf getUnshowData];
    };
    [self.navigationController pushViewController:vc animated:YES];
    
//    IWComposeViewController* vc = [[IWComposeViewController alloc]initWithOrder:myItem];
//    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
//    [self.tabBarController presentViewController:nav animated:YES completion:nil];
    
}

@end

