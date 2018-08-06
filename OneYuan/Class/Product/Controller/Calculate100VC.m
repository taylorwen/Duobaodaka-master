//
//  Calculate100VC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/11.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "Calculate100VC.h"
#import "Product100Model.h"
#import "Product100RecodeCell.h"


@interface Calculate100VC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString* pid;
    __block UITableView     *tbView;
    __block NSArray  *arrData;
    __block int             allCount;
    __block int             curPage;
    __block int             curState;
    
    __block UIView          *viewHead;
    __block UILabel         *lblCount;
    __block UILabel         *lblTip;
    
    __block UILabel         *lbl1;
    __block UILabel         *lbl2;
    __block UILabel         *lbl3;
    
    __block NSString        *strIn;
    __block NSString        *strOut;
}
@end

@implementation Calculate100VC

- (id)initWithGoodsId:(NSString*)goodsId
{
    self = [super init];
    if(self)
    {
        pid = goodsId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"100条全站记录";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    __weak typeof(self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UILabel* calculate = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 150, 12)];
    calculate.text = @"计算公式";
    calculate.font = [UIFont systemFontOfSize:12];
    calculate.textColor = [UIColor lightGrayColor];
    [self.view addSubview:calculate];
    
    UIImageView* image = [[UIImageView alloc]initWithFrame:CGRectMake(10, 32, mainWidth-32, mainWidth*0.25)];
    image.image = [UIImage imageNamed:@"Calculate"];
    [self.view addSubview:image];
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(0, mainWidth*0.25+35, mainWidth, self.view.bounds.size.height-mainWidth*0.25-35) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = self.view.backgroundColor;
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    
    [self getData:nil];
    
}

- (void)getData:(void (^)(void))block
{
    [[XBToastManager ShardInstance]showprogress];
    __weak typeof (self) wself = self;
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    NSDictionary* dict = @{@"pid":pid,@"token":token,@"timestamp":timestamp};
    [Product100Model getRecodelist:dict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        if(block != NULL)
            block();
        [[XBToastManager ShardInstance] hideprogress];
        
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSLog(@"%@",dataDict);
        NSError* error = nil;
        arrData = [RecodeListModel arrayOfModelsFromDictionaries:@[dataDict] error:&error];
        
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
    if (indexPath.row == 0)
    {
        static NSString* cellIdentifier = @"CellIdentifier";
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell ==nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        UILabel* lblTime = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 24)];
        lblTime.textColor = [UIColor lightGrayColor];
        lblTime.font = [UIFont systemFontOfSize:12];
        lblTime.text = @"夺宝时间";
        [cell addSubview:lblTime];
        
        UILabel* lblCode = [[UILabel alloc] initWithFrame:CGRectMake(140, 10, mainWidth-140-100, 24)];
        lblCode.textColor = [UIColor lightGrayColor];
        lblCode.font = [UIFont systemFontOfSize:12];
        lblCode.lineBreakMode = NSLineBreakByTruncatingMiddle;
        lblCode.text = @"夺宝码";
        [cell addSubview:lblCode];
        
        UILabel* lblUsername = [[UILabel alloc] initWithFrame:CGRectMake(mainWidth - 80, 10, 80, 24)];
        lblUsername.textColor = [UIColor lightGrayColor];
        lblUsername.font = [UIFont systemFontOfSize:12];
        lblUsername.lineBreakMode = NSLineBreakByTruncatingMiddle;
        lblUsername.text = @"用户账户";
        [cell addSubview:lblUsername];
        return cell;
    }
    else
    {

        RecodeListModel* item = [arrData objectAtIndex:indexPath.row];
        static NSString *CellIdentifier = @"mineRecodeCell";
        Product100RecodeCell *cell =  (Product100RecodeCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[Product100RecodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setRecode:item];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
