//
//  ProductDetailVC.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ProductDetailVC.h"
#import "ProductModel.h"
#import "ProductDetailTopCell.h"
#import "ProductDetailGetCell.h"
#import "AllProModel.h"
#import "ShowOrderListVC.h"
#import "ProductDetailOptView.h"
#import "CartModel.h"
#import "CartInstance.h"
#import "ProductLotteryVC.h"
#import "ProductImgDetailVC.h"
#import "ShowOrderDetailVC.h"
#import "TabShopCartVC.h"
#import "ProdcutBuyModel.h"
#import "ProductBuyCell.h"
#import "ProductStatusCell.h"
#import "HistoryLotteryVC.h"
#import "ShopCartVC.h"
#import "RegisterVC.h"
#import "LotteryPersonVC.h"
#import "RegisterVC.h"

#import "AddToCartView.h"

@interface ProductDetailVC ()<UITableViewDataSource,UITableViewDelegate,ProductDetailOptViewDelegate,ProductBuyCellDelegate>
{
    NSString*       _goodsId;
    NSString*       _codeId;
    
    
    __block UITableView         *tbView;
    __block ProductInfo         *proDetail;
    __block ProductInfoChild    *proChild;
    __block ProductNextPeriod   *proNext;
    
    UIImageView     *imgPro;
    __block ProductDetailOptView    *optView;
    __block NSMutableArray          *arrData;
    __block int                     curPage;
    __block ProductCodeBuy          *allCodes;
    __block NSArray                 *codeCount;
    __block NSString*               recordPid;
    __block NSString*               imageSid;
}

@property(nonatomic, strong)AddToCartView *addCartView;

@end

@implementation ProductDetailVC

- (id)initWithGoodsId:(NSString*)goodsId codeId:(NSString*)codeId
{
    self = [super init];
    if(self)
    {
        _goodsId = goodsId;
        _codeId = codeId;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tbView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"奖品详情";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    CGFloat margin = 0;
    if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"])
    {
        margin = 40;
        optView = [[ProductDetailOptView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 103, mainWidth, 40)];
        optView.delegate = self;
        [self.view addSubview:optView];
    }
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.view.bounds.size.height - margin) style:UITableViewStyleGrouped];
    tbView.separatorStyle=UITableViewCellSeparatorStyleNone;
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
        
    }];
    
    [tbView addInfiniteScrollingWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->curPage ++;
        [wSelf getBuyList:nil];
    }];
    
    if(_goodsId)
    {
        [self getData];
    }
    else
    {
        [self getGoodsId];
    }
    
    [tbView.pullToRefreshView setOYStyle];
    [tbView triggerPullToRefresh];
    [self showLoad];
    
}

- (void)getData
{
    __weak typeof (self) wSelf = self;
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    NSDictionary* dict = @{@"sid":_codeId,@"timestamp":timestamp,@"token":token};
    [ProductModel getGoodDetail:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [tbView.pullToRefreshView stopAnimating];
        [wSelf hideLoad];
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSDictionary* memberDict = [dataDict objectForKey:@"member_object"];
        NSDictionary* nextDict = [dataDict objectForKey:@"shopGoing_object"];
        NSError* error = nil;
        proDetail = [[ProductInfo alloc] initWithDictionary:dataDict error:&error];
        proChild = [[ProductInfoChild alloc]initWithDictionary:memberDict error:&error];
        proNext = [[ProductNextPeriod alloc]initWithDictionary:nextDict error:&error];
        [tbView reloadData];
        imageSid = proDetail.sid;
        recordPid = proDetail.pid;
        [wSelf getBuyList:^{
            arrData = nil;
        }];
        if ([UserInstance ShardInstnce].uid) {
            [self getMyBuyCodes];
        }
    } failure:^(NSError* error){
        [tbView.pullToRefreshView stopAnimating];
    }];
}
//所有夺宝记录
#pragma mark - getdata
- (void)getBuyList:(void (^)(void))block
{
//    __weak typeof(self) wSelf = self;
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    
    NSString* page = [NSString stringWithFormat:@"%d",curPage];
    NSDictionary* dict = @{@"pid":recordPid,@"currentPage":page,@"maxShowPage":@"10",@"timestamp":timestamp,@"token":token};
    [ProdcutBuyModel getGoodBuyList:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
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

- (void)getMyBuyCodes
{
    //获取用户的所有夺宝码;
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict1 = @{@"uid":[UserInstance ShardInstnce].uid,@"pid":recordPid,@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
    [ProductModel getCodesBuy:dict1 success:^(AFHTTPRequestOperation* operation, NSObject* result){
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        allCodes = [[ProductCodeBuy alloc]initWithDictionary:dataDict error:&error];
        codeCount = [[Jxb_Common_Common sharedInstance] getSpiltString:allCodes.codes split:@","];
        [tbView reloadData];
    } failure:^(NSError* error){
        
    }];

}

- (void)getGoodsId
{
    __weak typeof (self) wSelf = self;
    [AllProModel getGoodsPeriodByCodeId:_codeId success:^(AFHTTPRequestOperation* operation, NSObject* result){
        AllProPeriodList* list = [[AllProPeriodList alloc] initWithDictionary:(NSDictionary*)result error:NULL];
        _goodsId = [[list.Rows objectAtIndex:0] goodsID];
        [wSelf getData];
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
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
    {
        return 3;
    }
   
    if (section ==3)
    {
        return arrData.count;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
        return mainWidth-40;
    if (indexPath.section == 1) {
        return 64;
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
    if (section == 3) {
        return 30;
    }
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
        UIView* vvv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 44)];
        UILabel* lblCode = [[UILabel alloc] initWithFrame:CGRectMake(14,5, mainWidth-32, 24)];
        lblCode.text = [NSString stringWithFormat:@" 所有夺宝记录"];
        lblCode.font = [UIFont systemFontOfSize:17];
        lblCode.textColor = [UIColor grayColor];
        [vvv addSubview:lblCode];
        
        return vvv;
    }
    return nil;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"productTopCell";
        ProductDetailTopCell *cell =  (ProductDetailTopCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[ProductDetailTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        UIImageView* img = nil;
        [cell setProDetail:proDetail img:&img array:codeCount];
        imgPro = img;
        return cell;
    }
    else if (indexPath.section == 1)
    {
        
        static NSString *CellIdentifier = @"proBuyCell";
        ProductStatusCell *cell =  (ProductStatusCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[ProductStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setStatus:codeCount];
        return cell;
        
    }
    else if(indexPath.section == 2)
    {
        static NSString *CellIdentifier = @"proCommonCell";
        UITableViewCell *cell =  (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"图文详情";
            cell.detailTextLabel.text = @"建议在WiFi下查看";
            cell.imageView.image = [UIImage imageNamed:@"img"];
            UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, mainWidth, 0.5)];
            line.backgroundColor = myLineColor;
            [cell addSubview:line];
        }
        else if(indexPath.row == 1)
        {
            cell.textLabel.text = @"奖品晒单";
            cell.imageView.image = [UIImage imageNamed:@"share"];
            UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, mainWidth, 0.5)];
            line.backgroundColor = myLineColor;
            [cell addSubview:line];
        }
        else if (indexPath.row == 2)
        {
            cell.textLabel.text = @"往期揭晓";
            cell.imageView.image = [UIImage imageNamed:@"Record"];
        }
        
        return cell;
    }

    else if (indexPath.section == 3)
    {
        static NSString *CellIdentifier = @"proStatusCell";
        ProductBuyCell *cell =  (ProductBuyCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[ProductBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.delegate = self;
        [cell setBuy:[arrData objectAtIndex:indexPath.row]];
        return cell;
    }
    static NSString *CellIdentifier = @"productCommoneCell";
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
    if (indexPath.section == 1) {
        if (codeCount.count > 0)
        {
            
            [[[UIAlertView alloc] initWithTitle:@"我的夺宝码"
                                        message:allCodes.codes
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
            }], nil] show];

        }
        if (![UserInstance ShardInstnce].uid) {
            RegisterVC* vc = [[RegisterVC alloc]init];
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.tabBarController presentViewController:nav animated:YES completion:nil];
        }
    }
    
    if (indexPath.section == 2)
    {
        if(indexPath.row ==0)
        {
            ProductImgDetailVC* vc = [[ProductImgDetailVC alloc]initWithGoodsId:imageSid goodTitle:proDetail.title];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == 1)
        {
            ShowOrderListVC* vc = [[ShowOrderListVC alloc] initWithGoodsId:proDetail.sid userid:@"0"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if (indexPath.row == 2)
        {
            //进入往期揭晓中心
            HistoryLotteryVC* vc = [[HistoryLotteryVC alloc]initWithGoodsId:proDetail.sid];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    
}

#pragma mark - delegate

//加入清单
- (void)addToCartAction
{
    UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
    view.backgroundColor = [UIColor grayColor];
    view.alpha = 0.5;
    view.tag = 10000;
    [self.view addSubview:view];
    _addCartView = [[AddToCartView alloc] initWithFrame:CGRectMake(0, mainHeight - 64, mainWidth, 234)];
    __weak typeof(self) weakSelf = self;
    _addCartView.closeBlock = ^{
        [weakSelf closeWithdetermineAction];
    };
    _addCartView.productInfo = proDetail;
    [_addCartView.closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_addCartView];
    [UIView animateWithDuration:.5 animations:^{
        CGRect rect = _addCartView.frame;
        rect.origin.y -= 234;
        _addCartView.frame = rect;
    }];
}

//立即夺宝
- (void)addGotoCartAction
{
    CartItem* item = [[CartItem alloc] init];
    item.pid = proDetail.pid;
    item.title = proDetail.title;
    item.qishu = proDetail.qishu;
    item.yunjiage = proDetail.yunjiage;
    item.gonumber = [NSString stringWithFormat:@"%d",10];
    item.sid = proDetail.sid;
    item.money = proDetail.money;
    item.thumb = [NSString stringWithFormat:@"%@%@",oyImageBaseUrl,proDetail.thumb];
    [[CartInstance ShartInstance] addToCart:item imgPro:imgPro type:addCartType_Opt];
    ShopCartVC* vc = [[ShopCartVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)closeWithdetermineAction
{
    [UIView animateWithDuration:.5 animations:^{
        CGRect rect = _addCartView.frame;
        rect.origin.y = mainHeight - 64;
        _addCartView.frame = rect;
    } completion:^(BOOL finished) {
        [self closeAction];
        [self setCartNum];
    }];
}

- (void)closeAction
{
    [_addCartView removeFromSuperview];
    self.addCartView = nil;
    
    UIView *view = [self.view viewWithTag:10000];
    [view removeFromSuperview];
}


- (void)setCartNum
{
    [CartModel quertCart:nil value:nil block:^(NSArray* result){
        [optView setCartNum:(int)result.count];
    }];
}

- (void)gotoCartAction
{
    self.tabBarController.selectedIndex = 3;
    [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.2];
}


- (void)tapUsername:(NSString*)userId
{
    if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"]) {
        LotteryPersonVC* vc = [[LotteryPersonVC alloc]initWithGoodsId:userId];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

@end
