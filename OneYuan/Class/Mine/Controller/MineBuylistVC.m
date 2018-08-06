//
//  MineBuylistVC.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineBuylistVC.h"
#import "MineMyBuyModel.h"
#import "MineBuyCell.h"
#import "MineBuyingCell.h"
#import "ProductLotteryVC.h"
#import "ProductDetailVC.h"
#import "MineLotteryCell.h"
#import "CartModel.h"
#import "CartInstance.h"
#import "ShopCartVC.h"

@interface MineBuylistVC ()<UITableViewDataSource,UITableViewDelegate,MineBuyingViewDelegate,MineBuyViewDelegate>
{
    __block UITableView     *tbView;
    __block NSMutableArray       *arrData;
    __block NSMutableArray      *arrMember;
    
    __block int             curPage;
    __block int             curState;
    __block MineMyBuyList   *code;
    __block MineMyBuyItem*  listItem;
    __block MineBuyedItem*  memberitem;
}
@end

@implementation MineBuylistVC

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我的夺宝记录";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UISegmentedControl* seg = [[UISegmentedControl alloc] initWithItems:@[@"全部",@"进行中",@"已揭晓"]];
    seg.frame = CGRectMake(30, 10, mainWidth - 60, 32);
    [seg setTintColor:mainColor];
    [seg setSelectedSegmentIndex:0];
    [seg addTarget:self action:@selector(setSelectChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seg];
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 52, mainWidth, self.view.bounds.size.height) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor whiteColor];
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    [tbView addInfiniteScrollingWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->curPage ++;
        [wSelf getData];
    }];
    
    curPage = 1;
    curState = 0;
    [self getData];
}

#pragma mark - seg action
- (void)setSelectChange:(UISegmentedControl*)_seg
{
    [[XBToastManager ShardInstance] showprogress];
    arrData = nil;
    curPage = 1;
    if (_seg.selectedSegmentIndex == 1)
    {
        curState = 1;
        [self getData];
    }
    else if (_seg.selectedSegmentIndex == 2)
    {
        curState = 2;
        [self getData];
    }
    else
    {
        curState = 0;
        [self getData];
    }
    
}

#pragma mark - getdata
- (void)getData
{
    [[XBToastManager ShardInstance]showprogress];
    
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    //请求的参数
    NSString* type = [NSString stringWithFormat:@"%d",curState];
    NSString* currentPage = [NSString stringWithFormat:@"%d",curPage];
    NSDictionary* dict = @{@"type":type,
                           @"uid":[UserInstance ShardInstnce].uid,
                           @"other_uid":@"0",
                           @"currentPage":currentPage,
                           @"maxShowPage":@"10",
                           @"auth_key":[UserInstance ShardInstnce].auth_key,
                           @"timestamp":timestamp,
                           @"token":token};
    [MineMyBuyModel getUserBuylist:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        [[XBToastManager ShardInstance]hideprogress];
        NSError* error = nil;
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        
        NSArray* list = [MineMyBuyItem arrayOfModelsFromDictionaries:@[dataDict] error:&error];
        if(!arrData)
            arrData = [NSMutableArray arrayWithArray:list];
        else
            [arrData addObjectsFromArray:list];
        
        if(arrData.count == 0)
        {
            [self showEmpty:CGRectMake(0, 52, mainWidth, self.view.bounds.size.height - 52)];
        }
        else
            [self hideEmpty];
        [tbView setShowsInfiniteScrolling:YES];
        [tbView reloadData];
        
    } failure:^(NSError* error){
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        [[XBToastManager ShardInstance]hideprogress];
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
    MineMyBuyItem* item = [arrData objectAtIndex:indexPath.row];
    if ([item.shengyutime intValue] < 0) {
        return 200;
    }
    if ([item.shengyutime intValue] == 0) {
        return 130;
    }
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
    MineMyBuyItem* item = [arrData objectAtIndex:indexPath.row];
    NSError* error = nil;
    //json多层数据的解析 - 第二层；
    memberitem = [[MineBuyedItem alloc]initWithDictionary:item.memberGoRecord_obejct error:&error];
    if([item.shengyutime intValue] < 0)
    {
        static NSString *CellIdentifier = @"mineBuyCell";
        MineBuyCell *cell =  (MineBuyCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[MineBuyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setBuyed:memberitem recode:item];
        cell.delegate = self;
        return cell;
    }
    else if ([item.shengyutime intValue] == 0)
    {
        
        static NSString *CellIdentifier = @"mineBuyingCell";
        MineBuyingCell *cell =  (MineBuyingCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[MineBuyingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.delegate = self;
        [cell setBuying:item];
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"mineLotteryCell";
        MineLotteryCell *cell =  (MineLotteryCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[MineLotteryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setLottery:item];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MineMyBuyItem* item = [arrData objectAtIndex:indexPath.row];
    if(!item.memberGoRecord_obejct)
    {
        ProductDetailVC* vc = [[ProductDetailVC alloc] initWithGoodsId:item.pid codeId:item.sid];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else
    {
        ProductLotteryVC* vc = [[ProductLotteryVC alloc] initWithGoods:item.pid codeId:item.sid userId:item.q_uid];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)addGotoCartAction:(MineMyBuyItem*)_item
{
    UIImageView* img = [[UIImageView alloc]init];
    [img setImage_oy:oyImageBaseUrl image:_item.thumb];
    
    CartItem* item = [[CartItem alloc] init];
    item.pid = [NSString stringWithFormat:@"%@",_item.pid];
    item.title = _item.title;
    item.qishu = _item.qishu;
    item.yunjiage = _item.yunjiage;
    item.gonumber = [NSString stringWithFormat:@"%d",10];
    item.sid = _item.sid;
    item.money = _item.money;
    item.thumb = [NSString stringWithFormat:@"%@%@",oyImageBaseUrl,_item.thumb];
    [[CartInstance ShartInstance] addToCart:item imgPro:img type:addCartType_Opt];
    
    
    ShopCartVC* vc = [[ShopCartVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)seeCodeDetailAction:(NSString *)mycodes
{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"我的夺宝码" message:mycodes delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
@end
