//
//  LotteryPersonVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/12.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "LotteryPersonVC.h"
#import "PersonBuyRecordCell.h"
#import "UserModel.h"
#import "MineMyBuyModel.h"
#import "MineBuyCell.h"
#import "MineBuyingCell.h"
#import "MineLotteryCell.h"
#import "MineMyOrderModel.h"
#import "MineOrderCell.h"
#import "MineShowOrderCell.h"
#import "MineShowOrderModel.h"
#import "ShowOrderDetailVC.h"

#import "PersonLotteryCell.h"
#import "PersonBuyingRecordCell.h"
#import "PersonBuyRecordCell.h"

#import "CartModel.h"
#import "CartInstance.h"
#import "ShopCartVC.h"
#import "ProductLotteryVC.h"
#import "ProductDetailVC.h"
#import "PersonOrderCell.h"

@interface LotteryPersonVC ()<UITableViewDataSource,UITableViewDelegate,PersonBuyingViewDelegate,PersonBuyRecordCellDelegate,PersonOrderCellDelegate>
{
    __block UITableView     *tbView;
    __block NSMutableArray       *arrData;
    __block NSMutableArray      *arrMember;
    __block NSMutableArray      *arrDataLottery;
    __block NSMutableArray      *arrShowOrder;
    
    __block NSString            *uid;
    __block int             curPage;
    __block int             curState;
    
    UIImageView* img;
    UILabel* lblName;
    UILabel* lblPhone;
    UILabel* jingyan;
    UILabel* lblLevel;
    
    __block MineBuyedItem*  memberitem;

}
@end

@implementation LotteryPersonVC
- (id)initWithGoodsId:(NSString*)goodsId
{
    self = [super init];
    if(self)
    {
        uid  = goodsId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BG_GRAY_COLOR;
    self.title = @"TA的个人中心";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    
    UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 90)];
    v.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v];
    
    //背景图
    UIImageView* bg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bgTA"]];
    bg.frame = CGRectMake(0, 0, mainWidth, 90);
    [v addSubview:bg];
    
    img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    img.layer.masksToBounds = YES;
    img.layer.cornerRadius = 30;
    img.image = [UIImage imageNamed:@"noimage"];
    [v addSubview:img];
    
    lblName = [[UILabel alloc] init];
    lblName.text = @"";
    lblName.textColor = [UIColor grayColor];
    lblName.font = [UIFont systemFontOfSize:15];
    [v addSubview:lblName];
    lblName.frame = CGRectMake(80, 10, mainWidth - 80 - 16, 15);
    
    lblPhone = [[UILabel alloc] init];
    lblPhone.text = [NSString stringWithFormat:@"咖豆: %d",0];
    lblPhone.textColor = [UIColor grayColor];
    lblPhone.font = [UIFont systemFontOfSize:13];
    lblPhone.frame = CGRectMake(80, 30, 200, 15) ;
    [v addSubview:lblPhone];
    
    jingyan = [[UILabel alloc] init];
    jingyan.text = [NSString stringWithFormat:@"咖豆: %d",0];
    jingyan.textColor = [UIColor grayColor];
    jingyan.font = [UIFont systemFontOfSize:13];
    jingyan.frame = CGRectMake(80, 50, 200, 15) ;
    [v addSubview:jingyan];
    
    lblLevel = [[UILabel alloc] initWithFrame:CGRectMake(97, 70, 200, 15)];
    lblLevel.textColor = [UIColor lightGrayColor];
    lblLevel.text = @"夺宝新手";
    lblLevel.font = [UIFont systemFontOfSize:12];
    [v addSubview:lblLevel];
    
    int num;
    if ([lblLevel.text isEqualToString:@"夺宝新手"])
    {
        num = 1;
    }else if ([lblLevel.text isEqualToString:@"夺宝中将"])
    {
        num = 2;
    }else if ([lblLevel.text isEqualToString:@"夺宝大将"])
    {
        num = 3;
    }
    
    UIImageView* imgLevel = [[UIImageView alloc] initWithFrame:CGRectMake(80, 71.5, 12, 12)];
    NSString* level = [NSString stringWithFormat:@"degree%d",num];
    imgLevel.image = [UIImage imageNamed:level];
    [v addSubview:imgLevel];
    
    [self UpdateUserInfo];
    
    UISegmentedControl* seg = [[UISegmentedControl alloc] initWithItems:@[@"夺宝记录",@"获得的商品",@"晒单"]];
    seg.frame = CGRectMake(16, 95, mainWidth-32, 32);
    [seg setTintColor:mainColor];
    [seg setSelectedSegmentIndex:0];
    [seg addTarget:self action:@selector(setSelectChange:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:seg];
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 132, mainWidth, self.view.bounds.size.height-132) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor whiteColor];
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    [tbView addInfiniteScrollingWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->curPage ++;
        if (curState == 0) {
            [wSelf getData];
        }else if (curState == 1)
        {
            [wSelf getLotteryGoods];
        }else
        {
            [wSelf getShowOrder];
        }
        
    }];
    
    curPage = 1;
    curState = 0;
    [self getData];

}

#pragma mark - seg action
- (void)setSelectChange:(UISegmentedControl*)_seg
{
    [[XBToastManager ShardInstance] showprogress];

    curPage = 1;
    if (_seg.selectedSegmentIndex == 1)
    {
        arrDataLottery = nil;
        curState = 1;
        [self getLotteryGoods];
    }
    else if (_seg.selectedSegmentIndex == 2)
    {
        arrShowOrder = nil;
        curState = 2;
        [self getShowOrder];
    }
    else
    {
        arrData = nil;
        curState = 0;
        [self getData];
    }
}

#pragma mark - getdata
//他人的夺宝记录
- (void)getData
{
    [[XBToastManager ShardInstance]showprogress];
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
//    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    //请求的参数
    NSString* currentPage = [NSString stringWithFormat:@"%d",curPage];
    NSDictionary* dict = @{@"type":@"0",
                           @"uid":@"0",
                           @"other_uid":uid,
                           @"currentPage":currentPage,
                           @"maxShowPage":@"10",
                           @"token":token,
                           @"timestamp":timestamp};
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
        
        [tbView setShowsInfiniteScrolling:YES];
        [tbView reloadData];
        
        if(arrData.count == 0)
        {
            [tbView setHidden:YES];
            [self showEmpty:CGRectMake(0, 52, mainWidth, self.view.bounds.size.height - 52)];
        }
        else
        {
            [tbView setHidden:NO];
            [self hideEmpty];
        }
        
    } failure:^(NSError* error){
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        [[XBToastManager ShardInstance]hideprogress];
    }];
}
//获得的奖品
- (void)getLotteryGoods
{
    [[XBToastManager ShardInstance] showprogress];
    __weak typeof (self) wSelf = self;
    NSString* timestamp = [WenzhanTool getCurrentTime];
//    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    
    NSString* page = [NSString stringWithFormat:@"%d",curPage];
    NSDictionary* dict = @{@"uid":@"0",
                           @"other_uid":uid,
                           @"currentPage":page,
                           @"maxShowPage":@"10",
                           @"token":token,
                           @"timestamp":timestamp};
    [MineMyOrderModel getUserOrderlist:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        NSArray* list = [MineMyOrderItem arrayOfModelsFromDictionaries:@[dataDict] error:&error];
        if (!arrDataLottery) {
            arrDataLottery = [NSMutableArray arrayWithArray:list];
        }else
        {
            [arrDataLottery addObjectsFromArray:list];
        }
        
        if(arrDataLottery.count == 0)
        {
            [tbView setHidden:YES];
            [wSelf showEmpty:CGRectMake(0, 180, mainWidth, self.view.bounds.size.height - 152)];
        }
        else
        {
            [tbView setHidden:NO];
            [wSelf hideEmpty];
        }
        [tbView reloadData];
        [tbView setShowsInfiniteScrolling:NO];
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
    }];
}
//晒单列
- (void)getShowOrder
{
    __weak typeof(self) wSelf = self;
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
//    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"sid":@"0",
                           @"uid":@"0",
                           @"other_uid":uid,
//                           @"auth_key":[UserInstance ShardInstnce].auth_key,
                           @"currentPage":[NSString stringWithFormat:@"%d",curPage],
                           @"maxShowPage":@"10",
                           @"token":token,
                           @"timestamp":timestamp};
    
    [MineShowOrderModel getShowOrderlist:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        NSArray* list = [MineShowOrderItem arrayOfModelsFromDictionaries:@[dataDict] error:&error];
        if(!arrShowOrder){
            arrShowOrder = [NSMutableArray arrayWithArray:list];
        }else{
            [arrShowOrder addObjectsFromArray:list];
        }
        if(arrShowOrder.count == 0)
        {
            [tbView setHidden:YES];
            [wSelf showEmpty:CGRectMake(0, 180, mainWidth, self.view.bounds.size.height - 152)];
        }
        else
        {
            [tbView setHidden:NO];
            [wSelf hideEmpty];
        }
        [tbView setShowsInfiniteScrolling:YES];
        [tbView reloadData];
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取我的晒单异常：%@",error]];
    }];
}

//获取他人的用户信息
- (void)UpdateUserInfo
{
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
//    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"uid":@"0",@"other_uid":uid,@"timestamp":timestamp,@"token":token};
    [UserModel getUserInfo:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        //JSON解析开始
        UserInfoModel* parser = [[UserInfoModel alloc] initWithDictionary:dataDict  error:NULL];
        OneBaseParser *status = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:NULL];
        if ([status.resultCode isEqualToString:@"200"])
        {
            [[XBToastManager ShardInstance] hideprogress];
            [img setImage_oy:oyImageBaseUrl image:parser.img];
            lblName.text = parser.username;
            lblPhone.text = [NSString stringWithFormat:@"用户ID:  %@ [用户终身不变ID]",parser.uid];
            lblLevel.text = parser.groupName;
            jingyan.text = [NSString stringWithFormat:@"经验值:%@",parser.jingyan];
        }
        else{
            [[XBToastManager ShardInstance] hideprogress];
            if ([status.resultCode isEqualToString:@"204"])
            {
                [[XBToastManager ShardInstance] showtoast:@"获取中奖者信息失败"];
            }
            else
                [[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取中奖者信息失败:%@", status.resultCode ]];
        }
    } failure:^(NSError* error){
        
        [[XBToastManager ShardInstance] hideprogress];
        [[XBToastManager ShardInstance] showtoast:@"获取中奖者信息失败"];
    }];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (curState == 0)
    {
        return arrData.count;
    }
    if (curState == 1)
    {
        if (arrDataLottery.count == 0) {
            return 0;
        }else{
            MineMyOrderItem* item = [arrDataLottery objectAtIndex:0];
            if ([item.shengyutime intValue]>0) {
                return arrDataLottery.count-1;
            }else{
                return  arrDataLottery.count;
            }
        }
    }
    if (curState == 2)
    {
        return  arrShowOrder.count;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     MineMyBuyItem* item = [arrData objectAtIndex:indexPath.row];
    if ([item.shengyutime intValue] == 0) {
        return 130;
    }
    return 110;
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
    if (curState == 0)
    {
        MineMyBuyItem* item = [arrData objectAtIndex:indexPath.row];
        NSError* error = nil;
        //json多层数据的解析 - 第二层；
        memberitem = [[MineBuyedItem alloc]initWithDictionary:item.memberGoRecord_obejct error:&error];
        //已揭晓
        if([item.shengyutime intValue] < 0)
        {
            static NSString *CellIdentifier = @"mineBuyCell";
            PersonBuyRecordCell *cell =  (PersonBuyRecordCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[PersonBuyRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setDelegate:self];
            [cell setBuyed:memberitem recode:item];
            return cell;
        }
        //进行中
        else if ([item.shengyutime intValue] == 0)
        {
            static NSString *CellIdentifier = @"mineBuyingCell";
            PersonBuyingRecordCell *cell =  (PersonBuyingRecordCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[PersonBuyingRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.delegate = self;
            [cell setBuying:item];
            return cell;
        }
        //正在揭晓
        else
        {
            static NSString *CellIdentifier = @"mineLotteryCell";
            PersonLotteryCell *cell =  (PersonLotteryCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[PersonLotteryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setLottery:item];
            return cell;
        }

    }
    if (curState == 1)
    {
        MineMyOrderItem* item = [arrDataLottery objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"minePersonOrderCell";
        PersonOrderCell *cell =  (PersonOrderCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[PersonOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.delegate = self;
        [cell setPersonOrder:item];
        return cell;
    }
    if (curState ==2)
    {
        MineShowOrderItem* item = [arrShowOrder objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"mineShowOrderCell";
        MineShowOrderCell *cell =  (MineShowOrderCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[MineShowOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setMyPost:item];
        return cell;
    }
    
    static NSString *CellIdentifier = @"allProItemCell";
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor hexFloatColor:@"666666"];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MineMyBuyItem* item = [arrData objectAtIndex:indexPath.row];
    NSError* error = nil;
    //json多层数据的解析 - 第二层；
    memberitem = [[MineBuyedItem alloc]initWithDictionary:item.memberGoRecord_obejct error:&error];
    
    if (curState == 0)
    {
        if ([item.shengyutime intValue] == 0)
        {
            ProductDetailVC* vc = [[ProductDetailVC alloc]initWithGoodsId:item.pid codeId:item.sid];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            ProductLotteryVC* vc = [[ProductLotteryVC alloc]initWithGoods:item.pid codeId:item.sid userId:memberitem.uid];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (curState == 1)
    {
        MineMyOrderItem* item = [arrDataLottery objectAtIndex:indexPath.row];
        ProductLotteryVC* vc = [[ProductLotteryVC alloc]initWithGoods:item.pid codeId:item.sid userId:item.q_uid];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        MineShowOrderItem* showItem = [arrShowOrder objectAtIndex:indexPath.row];
        ShowOrderDetailVC* vc = [[ShowOrderDetailVC alloc] initWithPostId:showItem.sd_id Content:showItem.sd_content];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)addPersonGotoCartAction:(MineMyBuyItem*)_item
{
    UIImageView* imgP = [[UIImageView alloc]init];
    [imgP setImage_oy:oyImageBaseUrl image:_item.thumb];
    
    CartItem* item = [[CartItem alloc] init];
    item.pid = [NSString stringWithFormat:@"%@",_item.pid];
    item.title = _item.title;
    item.qishu = _item.qishu;
    item.yunjiage = _item.yunjiage;
    item.gonumber = [NSString stringWithFormat:@"%d",10];
    item.sid = _item.sid;
    item.money = _item.money;
    item.thumb = [NSString stringWithFormat:@"%@%@",oyImageBaseUrl,_item.thumb];
    [[CartInstance ShartInstance] addToCart:item imgPro:imgP type:addCartType_Opt];
    
    
    ShopCartVC* vc = [[ShopCartVC alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)tapTALotteryUsername:(NSString*)item
{
    LotteryPersonVC* vc = [[LotteryPersonVC alloc]initWithGoodsId:item];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
