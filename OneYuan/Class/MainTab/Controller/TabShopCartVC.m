//
//  TabShopCartVC.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "TabShopCartVC.h"
#import "CartEmptyView.h"
#import "CartModel.h"
#import "CartCell.h"
#import "CartOptView.h"
#import "CartInstance.h"
#import "UserInstance.h"
#import "AppDelegate.h"
#import "ProductDetailVC.h"
#import "LoginVC.h"
#import "CartPayVC.h"
#import "CustomInfo.h"
#import <BeeCloud/BeeCloud.h>
#import <BCAliPay/BCAliPay.h>
#import <BCWXPay/BCWXPay.h>
#import "RegisterVC.h"
#import "TabHomeVC.h"


@interface TabShopCartVC ()<UITableViewDataSource,UITableViewDelegate,CartCellDelegate,CartOptViewDelegate,CartEmptyViewDelegate>
{
    __block CartEmptyView   *viewEmpty;
    
    __block CartOptView     *viewOpt;
    
    __block NSArray         *arrData;
    
    __block UITableView     *tbView;
    
    __block NSTimer         *timerResult;
    
    __block SCLAlertView    *alertWait ;
    
    __block NSString        *totalMoney;
}
@end

@implementation TabShopCartVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (viewOpt)
    {
        [viewOpt setOpt];
    }
    
    [[UserInstance ShardInstnce] isUserStillOnline];
    if (viewEmpty)
    {
        [viewEmpty setEmpty];
        [viewEmpty setNeedsDisplay];        //强制UIView刷新
        [viewEmpty setNeedsLayout];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"清单";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginOk) name:kDidLoginOk object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginOk) name:kDidUserLogout object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCartItem) name:kDidAddCart object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCartItem) name:kDidAddCartSearch object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCartItem) name:kDidAddCartOpt object:nil];
    
    __weak typeof (self) wSelf = self;
    
    viewEmpty = [[CartEmptyView alloc] initWithFrame:self.view.bounds];
    [viewEmpty setDelegate:self];
    [viewEmpty setEmpty];
    
    viewOpt = [[CartOptView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 155, mainWidth, 44)];
    [viewOpt setDelegate:self];
    [viewOpt setOpt];
    [self.view addSubview:viewOpt];
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.view.bounds.size.height - 44) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    [tbView addPullToRefreshWithActionHandler:^{
        [wSelf reloadCartItem];
    }];
    
    [tbView.pullToRefreshView setOYStyle];
    
    [self reloadCartItem];
    
}

- (void)reloadCartItem
{
    __weak typeof (self) wSelf = self;
    [CartModel quertCart:nil value:nil block:^(NSArray* result){
        [tbView.pullToRefreshView stopAnimating];
        arrData = result;
        [viewOpt setHidden:arrData.count==0];
        [tbView setHidden:arrData.count==0];
        if(arrData.count > 0)
        {
            [viewEmpty removeFromSuperview];
        }
        else
        {
            [wSelf.view addSubview:viewEmpty];
        }
        [tbView reloadData];
    }];
}

- (void)didLoginOk
{
    [viewEmpty setNeedsDisplay];        //强制UIView刷新
    [viewEmpty setNeedsLayout];
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
    return 100;
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
    static NSString *CellIdentifier = @"cartCell";
    CartCell *cell =  (CartCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[CartCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setDelegate:self];
    [cell setCart:[arrData objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
/**
 *  tableview 可编辑模式
 */
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CartItem* item = [arrData objectAtIndex:indexPath.row];
    [CartModel removeCart:item];
    
    [(AppDelegate*)[[UIApplication sharedApplication] delegate] setCartNum];
    
    if (viewOpt)
    {
        [viewOpt setOpt];
    }
    
    [self reloadCartItem];
}

#pragma mark - delegate
- (void)setOpt
{
    if(viewOpt)
    {
        [viewOpt setOpt];
    }
}

- (void)setTxtFieldOpt
{
    if(viewOpt)
    {
        [viewOpt setOpt];
    }
}

/**
 *  购物车结算
 */
- (void)cartCalcAction:(NSString*)totalPrice
{
    totalMoney = totalPrice;
    if(![UserInstance ShardInstnce].uid)
    {
        RegisterVC* vc = [[RegisterVC alloc]init];
        UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        __block int count = 0;
        NSArray* arr = [CartModel quertCart2:nil value:nil];
        for (CartItem* item in arr) {
            count += [item.gonumber intValue];
        }
        if(count == 0)
        {
            [[XBToastManager ShardInstance]showtoast:@"您未选购任何奖品，请选择"];
            return;
        }
        __weak typeof (self) wSelf = self;
        [wSelf submitPros];
    }
}

- (void)submitPros
{
    [CartModel quertCart:nil value:nil block:^(NSArray* result){
        BOOL bAllAdd = YES;
        NSString* goodsName = nil;
        int goodPeriod = 0;
        CartAddResult   r = CartAddResult_Failed;
        for (CartItem* item in result) {
            
            if(r!=CartAddResult_Success)
            {
                goodsName = item.title;
                goodPeriod = [item.qishu intValue];
                bAllAdd = NO;
                break;
            }
        }
        if(!bAllAdd)
        {
            [alertWait hideView];
            if(r == CartAddResult_Full)
            {
                SCLAlertView  *alertView = [[SCLAlertView alloc] init];
                alertView.showAnimationType = FadeIn;
                [alertView showError:self.tabBarController title:@"异常" subTitle:[NSString stringWithFormat:@"[%d期]已满员：%@",goodPeriod,goodsName] closeButtonTitle:@"确定" duration:0];
            }
            else
            {
                CartPayVC* vc = [[CartPayVC alloc]initWithTotalMoney:totalMoney];
                
                CustomInfo* customInfo = [[CustomInfo alloc]init];
                customInfo.outTradeNo = [[BCUtil generateRandomUUID] stringByReplacingOccurrencesOfString:@"-" withString:@""];
                customInfo.body = [NSString stringWithFormat:@"%@",[[BCUtil generateRandomUUID] stringByReplacingOccurrencesOfString:@"-" withString:@""]];
                customInfo.traceID = @"ios_duobaodaka";
                customInfo.subject = customInfo.outTradeNo;
                customInfo.optional = nil;
                customInfo.aliScheme = @"DakaPayDemo";
                vc.customInfo = customInfo;
                
                [self.view endEditing:YES];
                
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            return ;
        }
    }];
}

- (void)doLogin
{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
@end