//
//  SettingVC.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "SettingVC.h"
#import "UserInstance.h"
#import "SettingExitCell.h"
#import "SettingWifiCell.h"
#import "SettingCommonCell.h"
#import "SettingFeedListVC.h"
#import "SettingServiceVC.h"
#import "SettingHelpCenterVC.h"
#import "SettingAboutusVC.h"
#import "RegisterVC.h"

@interface SettingVC ()<UITableViewDataSource,UITableViewDelegate,SettingExitCellDelegate,UIAlertViewDelegate>
{
    __block UITableView *tbView;
    
    NSArray     *arrNames;
}
@end

@implementation SettingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设置";
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    __weak typeof (self) wSelf = self;
    
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    tbView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    tbView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    
    arrNames = @[@[@"帮助中心",@"意见反馈",@"客服热线"],@[@"清除缓存"],@[@"服务协议",@"关于我们"]];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return arrNames.count + ([UserInstance ShardInstnce].uid ? 1 : 0);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section>=arrNames.count)
        return 1;
    NSArray* arr = (NSArray*)[arrNames objectAtIndex:section];
    return  arr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section >= arrNames.count)
        return 60;
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return 0.1;
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section >= arrNames.count)
    {
        static NSString *CellIdentifier = @"setExitCell";
        SettingExitCell *cell = (SettingExitCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[SettingExitCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setDelegate:self];
        return cell;
    }
    if (indexPath.section == 0 && indexPath.row == 2)
    {
        static NSString *CellIdentifier = @"setWifiCell";
        SettingCommonCell *cell = (SettingCommonCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[SettingCommonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        NSArray* arr = (NSArray*)[arrNames objectAtIndex:indexPath.section];
        cell.textLabel.text = [arr objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
        cell.detailTextLabel.text = @"400-608-6666";
        return cell;
    }
    if(indexPath.section == 1 && indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"setWifiCell";
        SettingCommonCell *cell = (SettingCommonCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[SettingCommonCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        NSArray* arr = (NSArray*)[arrNames objectAtIndex:indexPath.section];
        cell.textLabel.text = [arr objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
        
        NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleId];
        CGFloat size = [self folderSizeAtPath:path];
        if(size > 10)
        {
            if(size < 1000)
            {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f B",size];
            }
            else if(size < 1000 * 1000)
            {
               cell.detailTextLabel.text = [NSString stringWithFormat:@"%.2f KB",size / 1000];
            }
            else
            {
                cell.detailTextLabel.text =[NSString stringWithFormat:@"%.2f MB",size / 1000 / 1000];
            }
        }
        else
            cell.detailTextLabel.text = @"";
        return cell;
    }
    
    static NSString *CellIdentifier = @"allProItemCell";
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if(indexPath.section >= arrNames.count)
    {
        return cell;
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSArray* arr = (NSArray*)[arrNames objectAtIndex:indexPath.section];
    cell.textLabel.text = [arr objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            SettingHelpCenterVC* vc = [[SettingHelpCenterVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else if(indexPath.row == 1)
        {
            if ([UserInstance ShardInstnce].uid)
            {
                SettingFeedListVC* vc = [[SettingFeedListVC alloc] init];
                vc.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
            else
            {
                RegisterVC* vc = [[RegisterVC alloc]init];//登录页面
                UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
                [self.tabBarController presentViewController:nav animated:YES completion:nil];
            }
            
        }
        else if (indexPath.row == 2)
        {
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"拨打客服电话"  message:@"24小时热线电话" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
            [alert show];
        }
    }
    else if (indexPath.section == 1)
    {
       if (indexPath.row == 0){
            NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:bundleId];
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            
            [[XBToastManager ShardInstance] showtoast:@"缓存清除成功"];
            
            [tbView reloadData];
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            SettingServiceVC* vc = [[SettingServiceVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            SettingAboutusVC* vc = [[SettingAboutusVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - delegate
- (void)btnExitClick
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *number = @"4006086666";
        NSString *phone = [[NSString alloc] initWithFormat:@"tel://%@",number];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phone]];
    }
}

#pragma mark - get file size
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize;
}
@end
