//
//  MineMoneyDetailVC.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineMoneyDetailVC.h"
#import "MineMoneyCell.h"
#import "MineMoneyModel.h"

@interface MineMoneyDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    __block UITableView     *tbView;
    __block NSMutableArray  *arrData;
    __block int             allCount;
    __block int             nowPage;
    __block int             curState;
    
    __block UIView          *viewHead;
    __block UILabel         *lblCount;
    __block UILabel         *lblTip;
    
    __block UILabel         *lbl1;
    
    __block NSString        *strIn;
    __block NSString        *strOut;
    __block MineMoneyInItem *myaccount;
}

@end

@implementation MineMoneyDetailVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"账户明细";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    UIImageView *background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, 126)];
    background.image = [UIImage imageNamed:@"顶部"];
    [self.view addSubview:background];
    
    UIImageView* leftImg = [[UIImageView alloc]initWithFrame:CGRectMake(mainWidth/2-110, 50, 23, 23)];
    leftImg.image = [UIImage imageNamed:@"leftIcon"];
    [background addSubview:leftImg];
    
    lblTip = [[UILabel alloc] initWithFrame:CGRectMake(mainWidth/2-110, 50, 100, 24.5)];
    lblTip.text = @"当前剩余";
    lblTip.textColor = [UIColor whiteColor];
    lblTip.font = [UIFont systemFontOfSize:17];
    lblTip.textAlignment = NSTextAlignmentRight;
    [background addSubview:lblTip];
    
    UIImageView* lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(mainWidth/2-1, 50, 1.5, 24.5)];
    lineImg.image = [UIImage imageNamed:@"分割线"];
    [background addSubview:lineImg];
    
    lblCount = [[UILabel alloc] initWithFrame:CGRectMake(mainWidth/2+10, 38, 200, 40)];
    lblCount.text = [NSString stringWithFormat:@"%@",[UserInstance ShardInstnce].money];
    lblCount.textColor = [UIColor whiteColor];
    lblCount.font = [UIFont systemFontOfSize:40];
    lblCount.textAlignment = NSTextAlignmentLeft;
    [background addSubview:lblCount];
    
    CGSize s = [lblCount.text textSizeWithFont:lblCount.font constrainedToSize:CGSizeMake(MAXFLOAT, 999) lineBreakMode:NSLineBreakByCharWrapping];
    
    lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(lblCount.frame.origin.x + s.width+10, 43, 100, 40)];
    lbl1.text = @"夺宝币";
    lbl1.textColor = [UIColor whiteColor];
    lbl1.font = [UIFont systemFontOfSize:17];
    lbl1.textAlignment = NSTextAlignmentLeft;
    [background addSubview:lbl1];
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 126, mainWidth, self.view.bounds.size.height-64) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = self.view.backgroundColor;
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    nowPage = 1;
    curState = 0;
    
    [tbView addPullToRefreshWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->nowPage = 1;
        [wSelf getData:^{
            sSelf->arrData = nil;
        }];
    }];
    
    [tbView addInfiniteScrollingWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->nowPage ++;
        [wSelf getData:nil];
    }];
    
    [tbView.pullToRefreshView setOYStyle];
    [tbView triggerPullToRefresh];
    
    strIn = @"￥0.00";
    strOut = @"￥0.00";
    
    [self getMoney];
}

#pragma mark - getdata
- (void)getMoney
{
//    __weak typeof (self) wSelf = self;
//    [MineMoneyModel getMyMoneyAll:^(AFHTTPRequestOperation* operation,NSObject* result){
//        NSString* body = (NSString*)result;
//        strIn = [[Jxb_Common_Common sharedInstance] getMidString:body front:@"(充值总金额：" end:@")"];
//        strOut = [[Jxb_Common_Common sharedInstance] getMidString:body front:@"(消费总金额：" end:@")"];
//        [wSelf setHeadMoney];
//    } failure:^(NSError* error){
//        
//    }];
    strIn = myaccount.money;
    strOut = myaccount.pay;
}

- (void)getData:(void (^)(void))block
{
    __weak typeof (self) wself = self;
    
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    
    NSString* page = [NSString stringWithFormat:@"%d",nowPage];
    NSDictionary* dict = @{@"uid":[UserInstance ShardInstnce].uid,@"currentPage":page,@"maxShowPage":@"10",@"pay":@"账户",@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
    [MineMoneyModel getMyMoneylist:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        if(block != NULL)
            block();
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        NSArray* list = [MineMoneyInItem arrayOfModelsFromDictionaries:@[dataDict] error:&error];
        
        if (!arrData) {
            arrData = [NSMutableArray arrayWithArray:list];
        }else
        {
            [arrData addObjectsFromArray:list];
        }
        
        [tbView setShowsInfiniteScrolling:arrData.count];
        [tbView reloadData];
        
        if(arrData.count == 0)
        {
            [wself showEmpty:CGRectMake(0, 150, mainWidth, tbView.frame.size.height)];
        }
        else
        {
            [wself hideEmpty];
        }
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance] hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取账户异常：%@",error]];
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
    return 90;
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
    MineMoneyInItem* item = [arrData objectAtIndex:indexPath.row];
    static NSString *CellIdentifier = @"mineOrderCell";
    MineMoneyCell *cell =  (MineMoneyCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[MineMoneyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setMoney:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
