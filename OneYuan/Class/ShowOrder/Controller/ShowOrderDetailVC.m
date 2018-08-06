//
//  ShowOrderDetailVC.M
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ShowOrderDetailVC.H"
#import "ShowOrderModel.h"
#import "ShowOrderPostTopCell.h"
#import "LotteryPersonVC.h"

@interface ShowOrderDetailVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString                    *_postId;
    NSString                    *_postContent;
    __block UITableView         *tbView;
    __block ShowOrderSingleItem       *_item;
    __block ShowOrderDetail *_detail;
    __block ShowOrderReplyList  *_reply;
}
@end

@implementation ShowOrderDetailVC

- (id)initWithPostId:(NSString*)postId Content:(NSString *)sd_content
{
    self = [super init];
    if(self)
    {
        _postId = postId;
        _postContent = sd_content;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"晒单详情";
    __weak typeof (self) wSelf = self;
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
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
    
    [self getData];
    
//    [self showLoad];
}

- (void)getData
{
    [[XBToastManager ShardInstance]showprogress];
    __weak typeof (self) wSelf = self;
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    NSDictionary* dict1 = @{@"sd_id":_postId,@"token":token,@"timestamp":timestamp};
    [ShowOrderModel getPostSingleDetail:dict1 success:^(AFHTTPRequestOperation* opretaion, NSObject* result){
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        [wSelf hideLoad];
        _item = [[ShowOrderSingleItem alloc] initWithDictionary:dataDict error:&error];
        [[XBToastManager ShardInstance]hideprogress];
        [tbView reloadData];
    } failure:^(NSError* error){
        [wSelf hideLoad];
        // [[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取晒单详情异常：%@",error]];
    }];

}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    return !_item ? 0 : (!_reply ? 1 : 2);
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if(section == 1)
//    {
//        return _reply.Rows.count;
//    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        //获取文字的高度
        CGSize s = [_item.sd_content textSizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(mainWidth - 20, 999) lineBreakMode:NSLineBreakByCharWrapping];
        //获取图片的高度
//        int count = (int)[[Jxb_Common_Common sharedInstance] getSpiltString:_item.sd_photolist split:@";" ].count;
//        CGFloat height = 120 + s.height + ((count > 9 ? 9 : count)-1) * mainWidth*1.4 +50;
        NSString* imageString = [_item.sd_photolist substringToIndex:[_item.sd_photolist length]-1];
        NSArray* arrImg = [[Jxb_Common_Common sharedInstance] getSpiltString:imageString split:@";"];
        
        
        
        
        
        CGFloat height;
        if      (arrImg.count == 1) {
            NSURL *url = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:0]]];
            UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            double rate = image.size.height/image.size.width;
            height = 145 + s.height + (mainWidth-20)*rate ;
            return height;
        }
        else if (arrImg.count == 2)
        {
            NSURL *url = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:0]]];
            UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            double rate = image.size.height/image.size.width;
            NSURL *url1 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:1]]];
            UIImage* image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url1]];
            double rate1 = image1.size.height/image1.size.width;
            height = 145 + s.height + (mainWidth-20)*(rate+rate1) +5*1;
            return height;
        }
        else if (arrImg.count == 3)
        {
            NSURL *url = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:0]]];
            UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            double rate = image.size.height/image.size.width;
            NSURL *url1 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:1]]];
            UIImage* image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url1]];
            double rate1 = image1.size.height/image1.size.width;
            NSURL *url2 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:2]]];
            UIImage* image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url2]];
            double rate2 = image2.size.height/image2.size.width;
            height = 145 + s.height + (mainWidth-20)*(rate+rate1+rate2) +5*2;
            return height;
        }
        else if (arrImg.count == 4)
        {
            NSURL *url = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:0]]];
            UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            double rate = image.size.height/image.size.width;
            NSURL *url1 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:1]]];
            UIImage* image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url1]];
            double rate1 = image1.size.height/image1.size.width;
            NSURL *url2 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:2]]];
            UIImage* image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url2]];
            double rate2 = image2.size.height/image2.size.width;
            NSURL *url3 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:3]]];
            UIImage* image3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url3]];
            double rate3 = image3.size.height/image3.size.width;
            height = 145 + s.height + (mainWidth-20)*(rate+rate1+rate2+rate3) +5*3;
            return height;
        }
        else if (arrImg.count == 5)
        {
            NSURL *url = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:0]]];
            UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            double rate = image.size.height/image.size.width;
            NSURL *url1 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:1]]];
            UIImage* image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url1]];
            double rate1 = image1.size.height/image1.size.width;
            NSURL *url2 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:2]]];
            UIImage* image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url2]];
            double rate2 = image2.size.height/image2.size.width;
            NSURL *url3 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:3]]];
            UIImage* image3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url3]];
            double rate3 = image3.size.height/image3.size.width;
            NSURL *url4 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:4]]];
            UIImage* image4 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url4]];
            double rate4 = image4.size.height/image4.size.width;
            height = 145 + s.height + (mainWidth-20)*(rate+rate1+rate2+rate3+rate4) +5*4;
            return height;
        }
        else if (arrImg.count == 6)
        {
            NSURL *url = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:0]]];
            UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            double rate = image.size.height/image.size.width;
            NSURL *url1 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:1]]];
            UIImage* image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url1]];
            double rate1 = image1.size.height/image1.size.width;
            NSURL *url2 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:2]]];
            UIImage* image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url2]];
            double rate2 = image2.size.height/image2.size.width;
            NSURL *url3 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:3]]];
            UIImage* image3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url3]];
            double rate3 = image3.size.height/image3.size.width;
            NSURL *url4 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:4]]];
            UIImage* image4 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url4]];
            double rate4 = image4.size.height/image4.size.width;
            NSURL *url5 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:5]]];
            UIImage* image5 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url5]];
            double rate5 = image5.size.height/image5.size.width;
            height = 145 + s.height + (mainWidth-20)*(rate+rate1+rate2+rate3+rate4+rate5) +5*5;
            return height;
        }
        else if (arrImg.count == 7)
        {
            NSURL *url = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:0]]];
            UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            double rate = image.size.height/image.size.width;
            NSURL *url1 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:1]]];
            UIImage* image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url1]];
            double rate1 = image1.size.height/image1.size.width;
            NSURL *url2 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:2]]];
            UIImage* image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url2]];
            double rate2 = image2.size.height/image2.size.width;
            NSURL *url3 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:3]]];
            UIImage* image3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url3]];
            double rate3 = image3.size.height/image3.size.width;
            NSURL *url4 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:4]]];
            UIImage* image4 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url4]];
            double rate4 = image4.size.height/image4.size.width;
            NSURL *url5 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:5]]];
            UIImage* image5 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url5]];
            double rate5 = image5.size.height/image5.size.width;
            NSURL *url6 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:6]]];
            UIImage* image6 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url6]];
            double rate6 = image6.size.height/image6.size.width;
            height = 145 + s.height + (mainWidth-20)*(rate+rate1+rate2+rate3+rate4+rate5+rate6) +5*6;
            return height;
        }
        else if (arrImg.count == 8)
        {
            NSURL *url = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:0]]];
            UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            double rate = image.size.height/image.size.width;
            NSURL *url1 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:1]]];
            UIImage* image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url1]];
            double rate1 = image1.size.height/image1.size.width;
            NSURL *url2 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:2]]];
            UIImage* image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url2]];
            double rate2 = image2.size.height/image2.size.width;
            NSURL *url3 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:3]]];
            UIImage* image3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url3]];
            double rate3 = image3.size.height/image3.size.width;
            NSURL *url4 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:4]]];
            UIImage* image4 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url4]];
            double rate4 = image4.size.height/image4.size.width;
            NSURL *url5 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:5]]];
            UIImage* image5 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url5]];
            double rate5 = image5.size.height/image5.size.width;
            NSURL *url6 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:6]]];
            UIImage* image6 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url6]];
            double rate6 = image6.size.height/image6.size.width;
            NSURL *url7 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:7]]];
            UIImage* image7 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url7]];
            double rate7 = image7.size.height/image7.size.width;
            height = 145 + s.height + (mainWidth-20)*(rate+rate1+rate2+rate3+rate4+rate5+rate6+rate7) +5*7;
            return height;
        }
        else if (arrImg.count == 9)
        {
            NSURL *url = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:0]]];
            UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            double rate = image.size.height/image.size.width;
            NSURL *url1 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:1]]];
            UIImage* image1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url1]];
            double rate1 = image1.size.height/image1.size.width;
            NSURL *url2 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:2]]];
            UIImage* image2 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url2]];
            double rate2 = image2.size.height/image2.size.width;
            NSURL *url3 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:3]]];
            UIImage* image3 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url3]];
            double rate3 = image3.size.height/image3.size.width;
            NSURL *url4 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:4]]];
            UIImage* image4 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url4]];
            double rate4 = image4.size.height/image4.size.width;
            NSURL *url5 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:5]]];
            UIImage* image5 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url5]];
            double rate5 = image5.size.height/image5.size.width;
            NSURL *url6 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:6]]];
            UIImage* image6 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url6]];
            double rate6 = image6.size.height/image6.size.width;
            NSURL *url7 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:7]]];
            UIImage* image7 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url7]];
            double rate7 = image7.size.height/image7.size.width;
            NSURL *url8 = [NSURL URLWithString:[oyImageBaseUrl stringByAppendingString:[arrImg objectAtIndex:8]]];
            UIImage* image8 = [UIImage imageWithData:[NSData dataWithContentsOfURL:url8]];
            double rate8 = image8.size.height/image8.size.width;
            height = 145 + s.height + (mainWidth-20)*(rate+rate1+rate2+rate3+rate4+rate5+rate6+rate7+rate8) +5*8;
            return height;
        }
    }
    return 33;
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
    if(indexPath.section == 0)
    {
        static NSString *CellIdentifier = @"showPostTopCell";
        ShowOrderPostTopCell *cell = (ShowOrderPostTopCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[ShowOrderPostTopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [cell setPost:_item Content:_postContent];
        return cell;
    }
    
    static NSString *CellIdentifier = @"newedCell";
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)doUsernameClicked
{
    LotteryPersonVC* vc = [[LotteryPersonVC alloc]initWithGoodsId:_item.sd_userid];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
