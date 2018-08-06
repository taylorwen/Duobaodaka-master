//
//  ProductLotteryVC.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ProductLotteryVC.h"
#import "ProductModel.h"
#import "ProductLotteryTopCell.h"
#import "ProductLotteryCodeCell.h"
#import "ShowOrderListVC.h"
#import "ProductLotteryOptView.h"
#import "ProductDetailVC.h"
#import "AllProModel.h"
#import "ProductLotteryCell.h"
#import "ProductCalculateVC.h"
#import "ProductUncalculateVC.h"
#import "ProductImgDetailVC.h"
#import "LotteryPersonVC.h"
#import "HistoryLotteryVC.h"
#import "ProdcutBuyModel.h"
#import "ProductBuyCell.h"
#import "PersonBuyRecordCell.h"
#import "LotteryBuyRecordCell.h"

@interface ProductLotteryVC ()<UITableViewDataSource,UITableViewDelegate,ProductLotteryOptViewDelegate,goLotteryDetail,LotteryBuyRecordCellDelegate>
{
    NSString*   _goodsId;
    NSString*   _codeId;
    NSString*   _userId;
    
    __block ProductLotteryOptView   *optView;
    __block UITableView             *tbView;
    __block NSMutableArray          *listNew;
    
    __block ProductInfo             *_detail;
    __block ProductInfoChild        *infoChild;
    __block ProductNextPeriod       *nextPeriod;
    __block AllProPeriodList        *_allCodePeriod;
    __block ProductCodeBuy          *allCodes;
    __block NSArray                 *codeCount;
    
    __block int                 curPage;
    __block NSMutableArray          *arrData;
}
@end

@implementation ProductLotteryVC

- (id)initWithGoods:(NSString*)goodsId codeId:(NSString*)codeId userId:(NSString*)uid
{
    self = [super init];
    if(self)
    {
        _goodsId = goodsId;
        _codeId = codeId;
        _userId = uid;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"揭晓结果";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    __weak typeof(self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    CGFloat margin = 0;
    if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"])
    {
        margin = 49;
        optView = [[ProductLotteryOptView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 112, mainWidth, 49)];
        optView.delegate = self;
        
        [self.view addSubview:optView];
    }
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.view.bounds.size.height - margin) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    [tbView addPullToRefreshWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->curPage = 1;
        [wSelf getData];
        [wSelf getBuyList:nil];
    }];
    [tbView addInfiniteScrollingWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->curPage ++;
        [wSelf getBuyList:nil];
    }];
    [tbView.pullToRefreshView setOYStyle];
    [tbView triggerPullToRefresh];
    
    [self getData];
    [self showLoad];
}

- (void)getData
{
    __weak typeof(self) wSelf = self;
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"pid":_goodsId,@"timestamp":timestamp,@"token":token};
    [ProductModel getGoodLottery:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSDictionary* objectDict = [dataDict objectForKey:@"member_object"];
        NSDictionary* nextDict = [dataDict objectForKey:@"shopGoing_object"];

        [[XBToastManager ShardInstance] hideprogress];
        [wSelf hideLoad];
        [tbView.pullToRefreshView stopAnimating];
        
        NSError* error = nil;
        _detail = [[ProductInfo alloc] initWithDictionary:dataDict error:&error];
        infoChild = [[ProductInfoChild alloc]initWithDictionary:objectDict error:&error];
        nextPeriod = [[ProductNextPeriod alloc]initWithDictionary:nextDict error:&error];
        [optView setBtnPeriod:nextPeriod];
        [tbView reloadData];
    } failure:^(NSError* error){
        [wSelf hideLoad];
        [tbView.pullToRefreshView stopAnimating];
    }];
    
    //获取用户的所有夺宝码；
    NSDictionary* dict1 = @{@"uid":_userId,@"pid":_goodsId,@"token":token,@"timestamp":timestamp};
    [ProductModel getCodesBuy:dict1 success:^(AFHTTPRequestOperation* operation, NSObject* result){
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        allCodes = [[ProductCodeBuy alloc]initWithDictionary:dataDict error:&error];
        codeCount = [[Jxb_Common_Common sharedInstance] getSpiltString:allCodes.codes split:@","];
        [tbView reloadData];
    } failure:^(NSError* error){
        
    }];
    
}

#pragma mark - getdata
- (void)getBuyList:(void (^)(void))block
{
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    
    NSString* page = [NSString stringWithFormat:@"%d",curPage];
    NSDictionary* dict = @{@"pid":_goodsId,@"currentPage":page,@"maxShowPage":@"10",@"timestamp":timestamp,@"token":token};
    [ProdcutBuyModel getGoodBuyList:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        if(block!=NULL)
            block();
        NSArray* list = [ProdcutBuyItem arrayOfModelsFromDictionaries:@[dataDict] error:&error];
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
    } failure:^(NSError* error){
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
    }];
}

//获取中奖者的所有夺宝码
- (void)getProductAllCodes
{
    __weak typeof(self) wSelf = self;
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    NSDictionary* dict = @{@"uid":infoChild.uid,@"pid":_detail.pid,@"timestamp":timestamp,@"token":token};
    [ProductModel getCodesBuy:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        _allCodePeriod = [[AllProPeriodList alloc] initWithDictionary:dataDict error:&error];
        AllProPeriod* p = nil;
        int index = -1;
        for (AllProPeriod* period in _allCodePeriod.Rows) {
            index ++;
            if([period.codeState intValue] == 3)
            {
                p = period;
                break;
            }
        }
        [optView setBtnPeriod:[_allCodePeriod.Rows objectAtIndex:0]];
        if(index > 0)
        {
            NSMutableArray* tmp = [NSMutableArray arrayWithArray:_allCodePeriod.Rows];
            for(int i =0;i<index;i++)
            {
                [tmp removeObjectAtIndex:0];
            }
            _allCodePeriod.Rows = tmp;
        }
        if(p.codeID != _codeId)
        {
            _codeId = p.codeID ;
            [wSelf getData];
        }
        else
            [tbView reloadData];
    } failure:^(NSError* error){
        
    }];
    
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 2)
        return 3;
    if (section == 3) {
        return  arrData.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return mainWidth -50-80;
    }
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            int a = [_detail.shengyutime intValue];
            if (a <= 0)
            {
                return 170;
            }else
            {
                return 49;
            }
        }
    }
    if(indexPath.section == 3)
    {
        return 90;
    }
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 0.1;
    if(section == 3)
        return 50;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 3)
    {
        UIView* vvv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 40)];
        
        UILabel* lblState = [[UILabel alloc]initWithFrame:CGRectMake(16, 3, mainWidth-32, 25)];
        lblState.text = @"重要说明: 本应用所有活动和奖品都与苹果公司(Apple Inc.)无关，且中奖者拥有该商品的十年免费使用权。";
        lblState.font = [UIFont systemFontOfSize:10];
        lblState.textColor = [UIColor redColor];
        lblState.lineBreakMode = NSLineBreakByWordWrapping;
        lblState.numberOfLines = 2;
        [vvv addSubview:lblState];
        
        UILabel* lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(16, 32, mainWidth-32, 16)];
        lblTitle.text = @"所有参与记录";
        lblTitle.font = [UIFont systemFontOfSize:15];
        lblTitle.textColor = [UIColor grayColor];
        [vvv addSubview:lblTitle];
        
        return vvv;
    }
    return nil;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"lotteryTopCell";
        ProductLotteryTopCell *cell =  (ProductLotteryTopCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[ProductLotteryTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setLottery:_detail child:infoChild];
        return cell;
    }
    else if (indexPath.section == 1)
    {
        static NSString *CellIdentifier = @"lotteryCell";
        ProductLotteryCell *cell =  (ProductLotteryCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[ProductLotteryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.delegate = self;
        [cell setMyLottery:_detail myChild:infoChild];
        return cell;
        
    }
    else if(indexPath.section == 2)
    {
        static NSString *CellIdentifier = @"lotterybotCell";
        UITableViewCell *cell =  (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (indexPath.row == 0) {
            cell.textLabel.text = @"图文详情";
            cell.detailTextLabel.text = @"建议在WiFi下查看";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
            cell.imageView.image = [UIImage imageNamed:@"img"];
            UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, mainWidth, 0.5)];
            line.backgroundColor = myLineColor;
            [cell addSubview:line];
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = @"往期揭晓";
            cell.imageView.image = [UIImage imageNamed:@"Record"];
            UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, mainWidth, 0.5)];
            line.backgroundColor = myLineColor;
            [cell addSubview:line];
        }
        if (indexPath.row == 2) {
            cell.textLabel.text = @"奖品晒单";
            cell.imageView.image = [UIImage imageNamed:@"share"];
        }

        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor grayColor];
        return cell;
    }
    else if(indexPath.section == 3)
    {
        static NSString *CellIdentifier = @"proStatusCell";
        LotteryBuyRecordCell *cell =  (LotteryBuyRecordCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[LotteryBuyRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setDelegate:self];
        [cell setLotteryRecord:[arrData objectAtIndex:indexPath.row]];
        return cell;
    }
    static NSString *CellIdentifier = @"productTopCell";
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
    
    if (indexPath.section == 1)
    {
        if ([_detail.shengyutime intValue] < 0)
        {
            if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"]) {
            LotteryPersonVC* vc = [[LotteryPersonVC alloc]initWithGoodsId:infoChild.uid];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }
    if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
                ProductImgDetailVC* vc = [[ProductImgDetailVC alloc]initWithGoodsId:_goodsId goodTitle:_detail.title];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == 1)
        {
            HistoryLotteryVC* vc = [[HistoryLotteryVC alloc]initWithGoodsId:_codeId];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }
        else if (indexPath.row == 2)
        {
            //晒单详情
            ShowOrderListVC* vc = [[ShowOrderListVC alloc] initWithGoodsId:_codeId userid:@"0"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    }
}

- (void)btnNextAction
{
    if(_allCodePeriod)
    {
        int cur = 0;
        for (int i = 0;i<_allCodePeriod.Rows.count;i++) {
            AllProPeriod* period = [_allCodePeriod.Rows objectAtIndex:i];
            if(period.codeID  == _codeId)
            {
                cur = i;
                break;
            }
        }
        if(cur+1 >= _allCodePeriod.Rows.count)
            return;
        NSString* nextCode = [[_allCodePeriod.Rows objectAtIndex:cur+1] codeID];
        if(nextCode > 0)
        {
            [[XBToastManager ShardInstance] showprogress];
            _codeId = nextCode;
            [self getData];
        }
    }
}

- (void)btnPrevAction
{
    if(_allCodePeriod)
    {
        int cur = 0;
        for (int i = 0;i<_allCodePeriod.Rows.count;i++) {
            AllProPeriod* period = [_allCodePeriod.Rows objectAtIndex:i];
            if(period.codeID == _codeId)
            {
                cur = i;
                break;
            }
        }
        if(cur<=1)
        {
            return;
        }
        else
        {
            NSString* nextCode = [[_allCodePeriod.Rows objectAtIndex:cur-1] codeID];
            if(nextCode > 0)
            {
                [[XBToastManager ShardInstance] showprogress];
                _codeId = nextCode;
                [self getData];
            }
        }
    }
}

#pragma mark - delegate
- (void)gotoCartAction
{
    self.tabBarController.selectedIndex = 3;
    [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.2];
}

//去查看下一期商品
- (void)gotoDetailAction
{
    ProductDetailVC* vc = [[ProductDetailVC alloc] initWithGoodsId:nextPeriod.pid codeId:nextPeriod.sid];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)lotteryDetailClicked
{
    if ([_detail.shengyutime intValue] > 0)
    {
        ProductUncalculateVC* vc = [[ProductUncalculateVC alloc]init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        ProductCalculateVC* vc = [[ProductCalculateVC alloc]initWithGoodsId:_detail codeId:infoChild];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tapLotteryUsername:(NSString*)item
{
    if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"])
    {
        LotteryPersonVC* vc = [[LotteryPersonVC alloc]initWithGoodsId:item];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
