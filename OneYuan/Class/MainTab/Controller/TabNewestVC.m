//
//  TabNewestVC.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "TabNewestVC.h"
#import "HomeInstance.h"
#import "NewestModel.h"
#import "AllProTypeView.h"
#import "ProductLotteryVC.h"
#import "ProductDetailVC.h"
#import "AllProView.h"
#import "NewestedCollCell.h"
#import "NewestingCollCell.h"

@interface TabNewestVC () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NewestProRefreshDelegate>
{
    LMDropdownView  *dropdownView;
    
    __block UICollectionView    *tbView;
    __block int             curPage;
    __block int             iCodeType;
    __block NSMutableArray  *listNew;
    
    NSArray                 *arrOfTypeImage;
    UIButton                *btnRigth;
    
    NSDictionary            *dicTypeName;
    __weak id               <AllProViewDelegate> delegate;
    NSString                *goodsid;
    NSString                *codeid;
    NSString                *userid;
    
    NSTimer                 *timer;
}
@end

@implementation TabNewestVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tbView triggerPullToRefresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"最新揭晓";
    __weak typeof (self) wSelf = self;
    
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    tbView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, mainWidth,self.view.frame.size.height-49)collectionViewLayout:flowLayout];
    //注册单元格
    [tbView registerClass:[NewestedCollCell class]forCellWithReuseIdentifier:@"newCell"];
    [tbView registerClass:[NewestingCollCell class]forCellWithReuseIdentifier:@"newingCell"];
    //设置代理
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = BG_COLOR;
    [self.view addSubview:tbView];
    
    [tbView addPullToRefreshWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->curPage = 1;
        [wSelf getData:^{
            sSelf->listNew = nil;
        
        }];
        
    }];
    
    [tbView addInfiniteScrollingWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->curPage ++;
        [wSelf getData:nil];
    }];
    
    [tbView.pullToRefreshView setOYStyle];
    [tbView triggerPullToRefresh];
    
}

#pragma mark - getdata
- (void)getData:(void (^)(void))block
{
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    
    NSString* showPage = [NSString stringWithFormat:@"%d",curPage];
    NSDictionary* dict = @{@"currentPage":showPage,
                           @"maxShowPage":@"10",
                           @"timestamp":timestamp,
                           @"token":token};
    [NewestModel getAllNewest:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        if(block!=NULL)
            block();
        NSArray *list=[NewestProItme  arrayOfModelsFromDictionaries:
                       @[dataDict]];
        if (!listNew)
        {
            listNew = [NSMutableArray arrayWithArray:list];
        }
        else
        {
            [listNew addObjectsFromArray:list];
        }
        [tbView reloadData];
        [tbView setShowsInfiniteScrolling:YES];
    } failure:^(NSError* error){
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
    }];
}

#pragma mark - notify
- (void)reloadNewest
{
    [tbView reloadData];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets top = {0,0,0,0};
    return top;
}
//每个分区上得元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return listNew.count;
}
//设置单元格宽度
//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(mainWidth/2,mainWidth/2+50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

//设置元素内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewestProItme* itemNew = [listNew objectAtIndex:indexPath.item];
    if ([itemNew.shengyutime intValue] > 0)
    {
        NewestingCollCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"newingCell" forIndexPath:indexPath];
        [cell sizeToFit];
        cell.backgroundColor = [UIColor whiteColor];
        cell.delegate = self;
        [cell setNewesting:itemNew];
        return cell;
    }
    if([itemNew.shengyutime intValue] <= 0)
    {
        NewestedCollCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"newCell" forIndexPath:indexPath];
        [cell sizeToFit];
        cell.backgroundColor =[UIColor whiteColor];
        [cell setNewed:itemNew];
        return cell;
    }
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    goodsid = [[listNew objectAtIndex:indexPath.item]pid];
    codeid = [[listNew objectAtIndex:indexPath.item]sid];
    userid = [[listNew objectAtIndex:indexPath.item]q_uid];
    
    ProductLotteryVC* vc = [[ProductLotteryVC alloc] initWithGoods:goodsid codeId:codeid userId:userid ];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)NewestingTriggerRefresh
{
    [tbView triggerPullToRefresh];
}

@end
