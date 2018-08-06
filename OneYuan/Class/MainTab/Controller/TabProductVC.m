//
//  TabProductVC.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "TabProductVC.h"
#import "AllProView.h"
#import "SearchVC.h"
#import "ProductDetailVC.h"
#import "QCheckBox.h"

typedef enum
{
    TbViewType_Type = 0,//全部商品
    TbViewType_Order = 1//所有订单
}TbViewType;

@interface TabProductVC ()<UITableViewDataSource,UITableViewDelegate,AllProViewDelegate,QCheckBoxDelegate>
{
    LMDropdownView  *dropdownView;
    
    QCheckBox        *btnType;
    UIButton        *btnOrder;
    AllProView      *allProView;
    
    UITableView     *tbViewType;
    
    
    TbViewType      tbType;//类型为订单或者商品
    NSArray         *arrOfType;
    NSArray         *arrOfTypeImage;
    NSArray         *arrOfOrder;
    NSArray         *arrOfOrderFlag;
    NSInteger       indexType;
    NSInteger       indexOrder;
}
@end

@implementation TabProductVC

- (id)init
{
    self = [super init];
    if(self)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNewPro:) name:kDidShowNewPro object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [[NSNotificationCenter defaultCenter] postNotificationName:kDidRefreshNewLottery object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"])
    {
        arrOfType = @[@"全部分类",@"手机数码",@"平板电脑",@"家用电器",@"美食天地",@"潮流新品"];
        arrOfTypeImage = @[@"sort0",@"sort5",@"sort13",@"sort6",@"sort22",@"sort28"];
    }else
    {
        arrOfType =         @[@"全部分类",@"家用电器",@"美食天地",@"潮流新品"];
        arrOfTypeImage =    @[@"sort0",@"sort6",@"sort22",@"sort28"];
    }
    
    //全部商品分类按钮
    btnType = [[QCheckBox alloc] initWithFrame:CGRectMake(100, 0, 100, 44)];
    [btnType setTitle:[arrOfType objectAtIndex:0] forState:UIControlStateNormal];
    btnType.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnType setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnType addTarget:self action:@selector(btnTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    [btnType setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [btnType setImageEdgeInsets:UIEdgeInsetsMake(4,72,4,-64)];
    self.navigationItem.titleView = btnType;
    [btnType setChecked:NO];
    
    btnOrder = [[UIButton alloc] initWithFrame:CGRectMake(mainWidth / 2+0.5, 0, mainWidth / 2 - 0.5, 43.5)];
    [btnOrder setTitle:[arrOfOrder objectAtIndex:indexOrder] forState:UIControlStateNormal];
    btnOrder.titleLabel.font = [UIFont systemFontOfSize:16];
    [btnOrder setBackgroundColor:[UIColor hexFloatColor:@"f8f8f8"]];
    [btnOrder setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [btnOrder setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [btnOrder setImageEdgeInsets:UIEdgeInsetsMake(0,0,8,8)];
    
    UIImageView *imgLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 43.5, mainWidth, 0.5)];
    imgLine2.backgroundColor = [UIColor hexFloatColor:@"dedede"];
    [self.view addSubview:imgLine2];
    
    //分类用的tableview
    tbViewType = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.view.frame.size.height-113) style:UITableViewStyleGrouped];
    tbViewType.delegate = self;
    tbViewType.dataSource = self;
    tbViewType.backgroundColor = [UIColor whiteColor];
    tbViewType.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    tbType = TbViewType_Type;
    
    dropdownView = [[LMDropdownView alloc] init];
    dropdownView.menuBackgroundColor = [UIColor whiteColor];
    dropdownView.menuContentView = tbViewType;
    
    allProView = [[AllProView alloc] initWithOrder:CGRectMake(0, 0, mainWidth, self.view.bounds.size.height - 49) indexOrder:[[arrOfOrderFlag objectAtIndex:indexOrder] intValue]];
    allProView.delegate = self;
    allProView.proType = [[[arrOfTypeImage objectAtIndex:0] stringByReplacingOccurrencesOfString:@"sort" withString:@""] intValue];
    [self.view addSubview:allProView];
}

- (void)doClickProduct:(NSString*)goodsId code:(NSString *)codeId
{
    ProductDetailVC* vc = [[ProductDetailVC alloc] initWithGoodsId:goodsId codeId:codeId];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
//点击按钮，弹出下滑菜单；
- (void)btnTypeAction:(id)sender
{
    
    if ([dropdownView isOpen] && tbType == TbViewType_Type)//类型为商品分类
    {
        btnType.selected = YES;
        tbType = TbViewType_Type;
        [dropdownView hide];
    }
    else
    {
        btnType.selected = NO;
        tbType = TbViewType_Type;//类型为订单
        [tbViewType reloadData];
        [dropdownView showInView:self.view withFrame:CGRectMake(0, 0, mainWidth, self.view.bounds.size.height)];
    }
}

//接收首页按钮传递来的值，刷新页面
#pragma mark - notify
- (void)showNewPro:(NSNotification*)obj
{
    indexOrder = [obj.object intValue];
        [allProView setTypeAndOrder:[[[arrOfTypeImage objectAtIndex:indexType] stringByReplacingOccurrencesOfString:@"sort" withString:@""] intValue] sort:[[arrOfOrderFlag objectAtIndex:indexOrder] intValue]];
    
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tbType == TbViewType_Type ? arrOfType.count : arrOfOrder.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
    //static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell =  nil;//(UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] init];
    }
    cell.textLabel.text = tbType == TbViewType_Type ? [NSString stringWithFormat:@"        %@", [arrOfType objectAtIndex:indexPath.row]] : [arrOfOrder objectAtIndex:indexPath.row];
    if(tbType == TbViewType_Type)
    {
        NSString* name = [arrOfTypeImage objectAtIndex:indexPath.row];
        if(indexPath.row == indexType)
        {
            name = [NSString stringWithFormat:@"%@_checked",name];
            cell.textLabel.textColor = mainColor;
            
            UIImageView* imgOK = [[UIImageView alloc] initWithFrame:CGRectMake(mainWidth - 32, 14, 16, 16)];
            imgOK.image = [UIImage imageNamed:@"screening_select"];
            [cell addSubview:imgOK];
        }
        else
        {
            name = [NSString stringWithFormat:@"%@_normal",name];
        }
        UIImageView* img = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 24, 24)];
        img.image = [UIImage imageNamed:name];
        [cell addSubview:img];
    }
    else
    {
        if(indexPath.row == indexOrder)
        {
            cell.textLabel.textColor = mainColor;
            
            UIImageView* imgOK = [[UIImageView alloc] initWithFrame:CGRectMake(mainWidth - 32, 14, 16, 16)];
            imgOK.image = [UIImage imageNamed:@"screening_select"];
            [cell addSubview:imgOK];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    tbType == TbViewType_Type ? (indexType = indexPath.row) : (indexOrder = indexPath.row);
    tbType == TbViewType_Type ? ([btnType setTitle:[arrOfType objectAtIndex:indexPath.row] forState:UIControlStateNormal]) : ([btnOrder setTitle:[arrOfOrder objectAtIndex:indexPath.row] forState:UIControlStateNormal]);
    [tbViewType reloadData];
    [dropdownView hide];
    
    //传值到allProView;
    [allProView setTypeAndOrder:[[[arrOfTypeImage objectAtIndex:indexType] stringByReplacingOccurrencesOfString:@"sort" withString:@""] intValue] sort:[[arrOfOrderFlag objectAtIndex:indexOrder] intValue]];
}
@end
