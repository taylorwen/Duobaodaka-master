//
//  HomeTenRmbVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/9/14.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "HomeTenRmbVC.h"
#import "Product10Cell.h"
#import "HomeModel.h"
#import "ProductDetailVC.h"

@interface HomeTenRmbVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    __block UICollectionView    *tbView;
    __block int             curPage;
    __block NSMutableArray  *arrTen;
}
@end

@implementation HomeTenRmbVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"十元专区";
    __weak typeof (self) wSelf = self;
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    tbView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, mainWidth,self.view.frame.size.height)collectionViewLayout:flowLayout];
    //注册单元格
    [tbView registerClass:[Product10Cell class]forCellWithReuseIdentifier:@"hometenCell"];
    //设置代理
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = BG_COLOR;
    [self.view addSubview:tbView];
    
    [tbView addPullToRefreshWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->curPage = 1;
        [wSelf getData:^{
            sSelf->arrTen = nil;
            
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
    __weak typeof (tbView) wTb = tbView;
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"currentPage":@"1",@"maxShowPage":@"10",@"timestamp":timestamp,@"token":token};
    [HomeModel getTenPro:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [[XBToastManager ShardInstance]hideprogress];
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        if (block!= NULL)
            block();
        NSDictionary* datadict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        NSArray* list = [HomeTenModel arrayOfModelsFromDictionaries:@[datadict] error:&error];
        arrTen = [NSMutableArray arrayWithArray:list];
        [wTb reloadData];
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance]hideprogress];
    }];
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
    return arrTen.count;
}
//设置单元格宽度
//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(mainWidth/2,mainWidth/2+65);
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
    Product10Cell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hometenCell" forIndexPath:indexPath];
    [cell sizeToFit];
    cell.backgroundColor =[UIColor whiteColor];
    [cell setTenPros:[arrTen objectAtIndex:indexPath.item]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailVC* vc = [[ProductDetailVC alloc] initWithGoodsId:[[arrTen objectAtIndex:indexPath.item]pid] codeId:[[arrTen objectAtIndex:indexPath.item]sid]];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
