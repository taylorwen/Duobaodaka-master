//
//  SuccessViewController.m
//  SPayUI
//
//  Created by RInz on 15/3/28.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import "SuccessViewController.h"
#import "MineBuylistVC.h"
#import "TabHomeVC.h"
#import "SuccessfulProCell.h"
#import "UserModel.h"

@interface SuccessViewController ()<UITableViewDataSource,UITableViewDelegate,successfulProCellDelegate>
{
    NSArray         * sucArr;
    NSArray         * codeArray;
    UITableView     * tbView;
}
@end

@implementation SuccessViewController

- (id)initWithGoodsId:(NSArray*)array buyCode:(NSArray*)codeArr
{
    self = [super init];
    if(self)
    {
        sucArr = array;
        codeArray =codeArr;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"付款成功";
    self.view.backgroundColor = BG_GRAY_COLOR;
    
    tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.dataSource   = self;
    tbView.delegate     = self;
    tbView.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    [self checkUserInfo];
    
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sucArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return mainWidth/2+49+49;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        UIView* vvv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, mainWidth/2+49+49)];
        UIImageView* background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, mainWidth/2)];
        background.image = [UIImage imageNamed:@"SuccessHeader"];
        [vvv addSubview:background];
        
        UIButton* btnContinus = [[UIButton alloc]initWithFrame:CGRectMake(0, mainWidth/2, mainWidth/2, 49)];
        [btnContinus setTitle:@"继续夺宝" forState:UIControlStateNormal];
        [btnContinus setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnContinus setBackgroundColor:[UIColor whiteColor]];
        [btnContinus setImage:[UIImage imageNamed:@"continueSuc"] forState:UIControlStateNormal];
        [btnContinus setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
        btnContinus.titleLabel.font = [UIFont systemFontOfSize:16];
        btnContinus.layer.borderColor = myLineColor.CGColor;
        btnContinus.layer.borderWidth = 0.5;
        [btnContinus addTarget:self action:@selector(keepShopping) forControlEvents:UIControlEventTouchUpInside];
        [vvv addSubview:btnContinus];
        
        UIButton* btnRecode = [[UIButton alloc]initWithFrame:CGRectMake(mainWidth/2, mainWidth/2, mainWidth/2, 49)];
        [btnRecode setTitle:@"夺宝记录" forState:UIControlStateNormal];
        [btnRecode setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [btnRecode setBackgroundColor:[UIColor whiteColor]];
        [btnRecode setImage:[UIImage imageNamed:@"recordSuc"] forState:UIControlStateNormal];
        [btnRecode setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 0)];
        btnRecode.titleLabel.font = [UIFont systemFontOfSize:16];
        btnRecode.layer.borderColor = myLineColor.CGColor;
        btnRecode.layer.borderWidth = 0.5;
        [btnRecode addTarget:self action:@selector(goToRecode) forControlEvents:UIControlEventTouchUpInside];
        [vvv addSubview:btnRecode];
        
        UILabel* duoDe = [[UILabel alloc]initWithFrame:CGRectMake(0, mainWidth/2+49, mainWidth, 49)];
        duoDe.textColor = [UIColor grayColor];
        duoDe.font = [UIFont systemFontOfSize:14];
        duoDe.textAlignment = NSTextAlignmentCenter;
        duoDe.text = [NSString stringWithFormat:@"您成功参与了%lu件奖品的夺宝",(unsigned long)sucArr.count];
        [vvv addSubview:duoDe];
        
        return vvv;
    }
    return nil;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"productSucCell";
    SuccessfulProCell *cell =  (SuccessfulProCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[SuccessfulProCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.backgroundColor = myLineColor;
    [cell setDelegate:self];
    [cell setSuccess:[sucArr objectAtIndex:indexPath.row] Codes:[codeArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)keepShopping {
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)goToRecode
{
    MineBuylistVC* vc = [[MineBuylistVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)myCodesClicked:(NSString*)codes
{
    [[[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"幸运夺宝码"]
                                message:[NSString stringWithFormat:@"%@",codes]
                       cancelButtonItem:[RIButtonItem itemWithLabel:@"取消" action:nil]
                       otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
        
    }], nil] show];
    
}

- (void)checkUserInfo
{
    [[XBToastManager ShardInstance]showprogress];
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"uid":[UserInstance ShardInstnce].uid,@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
    [UserModel getUserInfo:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        //JSON解析开始
        UserInfoModel* parser = [[UserInfoModel alloc] initWithDictionary:dataDict  error:NULL];
        OneBaseParser *status = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:NULL];
        if ([status.resultCode isEqualToString:@"200"])
        {
            [[XBToastManager ShardInstance] hideprogress];
            NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:parser.mobile forKey:@"mobile"];
            [userDefaults setObject:parser.mobilecode forKey:@"mobilecode"];
            [userDefaults setObject:parser.email forKey:@"email"];
            [userDefaults setObject:parser.emailcode forKey:@"emailcode"];
            [userDefaults setObject:parser.groupid forKey:@"groupid"];
            [userDefaults setObject:parser.jingyan forKey:@"jingyan"];
            [userDefaults setObject:parser.money forKey:@"money"];
            [userDefaults setObject:parser.passcode forKey:@"passcode"];
            [userDefaults setObject:parser.password forKey:@"password"];
            [userDefaults setObject:parser.qianming forKey:@"qianming"];
            [userDefaults setObject:parser.reg_key forKey:@"reg_key"];
            [userDefaults setObject:parser.score forKey:@"score"];
            [userDefaults setObject:parser.time forKey:@"time"];
            [userDefaults setObject:parser.uid forKey:@"uid"];
            [userDefaults setObject:parser.user_ip forKey:@"user_ip"];
            [userDefaults setObject:parser.username forKey:@"username"];
            [userDefaults setObject:parser.yaoqing forKey:@"yaoqing"];
            [userDefaults setObject:parser.addgroup forKey:@"addgroup"];
            [userDefaults setObject:parser.band forKey:@"band"];
            [userDefaults setObject:parser.img forKey:@"img"];
            [userDefaults setObject:parser.groupName forKey:@"groupName"];
            [userDefaults setObject:parser.login_time forKey:@"login_time"];        //新增
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[UserInstance ShardInstnce] isUserStillOnline];
            [[NSNotificationCenter defaultCenter] postNotificationName:kDidLoginOk object:nil];
            
            __weak typeof (self) wSelf = self;
            [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
                wSelf.tabBarController.selectedIndex = 0;
                [wSelf.navigationController popToRootViewControllerAnimated:YES];
                
            }];
        }
        else{
            [[XBToastManager ShardInstance] hideprogress];
            if ([status.resultCode isEqualToString:@"204"])
            {
                [[XBToastManager ShardInstance] showtoast:@""];
            }
            else
                [[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@""]];
        }
    } failure:^(NSError* error){
        
        [[XBToastManager ShardInstance] hideprogress];
        [[XBToastManager ShardInstance] showtoast:@""];
    }];
    
}
@end
