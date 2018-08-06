//
//  BuyRecordPopVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/23.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "BuyRecordPopVC.h"
#import "Limite3Model.h"

@interface BuyRecordPopVC ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* tbView;
    HuaFeiModel* huaModel;
    
    NSMutableArray* arrData;
}
@end

@implementation BuyRecordPopVC
- (id)initWithUserID:(HuaFeiModel*)item
{
    self = [super init];
    if(self)
    {
        huaModel = item;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    
    tbView = [[UITableView alloc] initWithFrame:CGRectMake(32, 74, mainWidth-64, self.view.bounds.size.height-132) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor whiteColor];
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    tbView.layer.cornerRadius = 5;
    [self.view addSubview:tbView];
    
    UIButton* close = [[UIButton alloc]initWithFrame:CGRectMake(tbView.frame.size.width+32-19, 74-19, 38, 38)];
    [close setImage:[UIImage imageNamed:@"btn1Home"] forState:UIControlStateNormal];
    [close addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:close];
    
    [self loadBuyRecord];
}

- (void)loadBuyRecord
{
    [[XBToastManager ShardInstance]showprogress];
    NSDictionary* dict = @{@"uid":[UserInstance ShardInstnce].uid,@"sid":huaModel.sid};
    [Limite3Model getBuyRecordList:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [[XBToastManager ShardInstance]hideprogress];
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        if (dataDict == nil) {
            return ;
        }
        NSError* error = nil;
        OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
        if ([parser.resultCode isEqualToString:@"200"])
        {
            NSArray* list = [BuyRecordModel arrayOfModelsFromDictionaries:@[dataDict] error:&error];
            arrData = [NSMutableArray arrayWithArray:list];
            [tbView reloadData];
        }
        else
        {
            [[XBToastManager ShardInstance]showtoast:parser.resultMessage wait:2.0f];
        }
        
        
    } failure:^(NSError* error){
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
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* vvv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth-64, 60)];
    UILabel* lblCode = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, mainWidth-64, 60)];
    lblCode.text = @"参与记录";
    lblCode.font = [UIFont systemFontOfSize:20];
    lblCode.textColor = [UIColor grayColor];
    lblCode.textAlignment = NSTextAlignmentCenter;
    [vvv addSubview:lblCode];
    return vvv;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuyRecordModel* item = [arrData objectAtIndex:indexPath.row];
    if (!item) {
        return nil;
    }
    static NSString *CellIdentifier = @"LimiteProItemCell";
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel* lblQishu = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 100, 60)];
    lblQishu.textColor = [UIColor grayColor];
    lblQishu.font = [UIFont systemFontOfSize:12];
    lblQishu.text = [NSString stringWithFormat:@"第%@期",item.qishu];
    [cell addSubview:lblQishu];
    
    UILabel* lblTime = [[UILabel alloc]initWithFrame:CGRectMake(80, 0, 100, 60)];
    lblTime.textColor = [UIColor grayColor];
    lblTime.font = [UIFont systemFontOfSize:12];
    NSString* str = [WenzhanTool formateDateStr:item.qishu];
    NSString* strShort = [str substringFromIndex:11];
    lblTime.text = [NSString stringWithFormat:@"%@",strShort];
    [cell addSubview:lblTime];
    
    UILabel* lblPati = [[UILabel alloc]initWithFrame:CGRectMake(150, 0, 100, 60)];
    lblPati.textColor = [UIColor grayColor];
    lblPati.font = [UIFont systemFontOfSize:12];
    lblPati.text = [NSString stringWithFormat:@"参与%@次",item.gonumber];
    [cell addSubview:lblPati];
    
    UILabel* lblStatus = [[UILabel alloc]initWithFrame:CGRectMake((mainWidth-64-110), 0, 100, 60)];
    lblStatus.font = [UIFont systemFontOfSize:12];
    if ([item.status intValue] == 2)
    {
        //已揭晓
        if ([item.huode isEqualToString:@"0"]) {
            lblStatus.text = @"未中奖";
            lblStatus.textColor = mainColor;
        }else
        {
            lblStatus.text = @"已中奖";
            lblStatus.textColor = [UIColor redColor];
        }
    }else
    {
        lblStatus.text = @"未揭晓";
        lblStatus.textColor = mainColor;
    }
    lblStatus.textAlignment = NSTextAlignmentRight;
    [cell addSubview:lblStatus];
    
    UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 59.5, mainWidth-64, 0.5)];
    line.backgroundColor = myLineColor;
    [cell addSubview:line];
    
    return cell;
}






















- (void)closePopup
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelLimiteButtonClicked:)]) {
        [self.delegate cancelLimiteButtonClicked:self];
    }
}
@end
