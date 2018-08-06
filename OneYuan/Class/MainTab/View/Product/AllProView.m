//
//  AllProView.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "AllProView.h"
#import "AllProModel.h"
#import "AllProItemCell.h"
#import "HomeModel.h"
#import "HomeInstance.h"
#import "AllProCollectionCell.h"

#define pageSize    10

@interface AllProView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>
{
    __weak id<AllProViewDelegate> delegate;
    
    __block UITableView     *tbView;
    __block NSMutableArray  *arrPros;
    
    __block int       curPage;
    __block int       proType;
    __block int       proSort;
    UICollectionView    *ctView;
}

@end

@implementation AllProView
@synthesize delegate,proType;

- (id)initWithOrder:(CGRect)frame indexOrder:(int)indexOrder
{
    proSort = indexOrder;
    self = [self initWithFrame:frame];
    if(self)
    {
    
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        __weak typeof (self) wSelf = self;
        
        self.backgroundColor = [UIColor redColor];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NewLottery) name:kDidRefreshNewLottery object:nil];
        proType = 0;
        //顶部画线
        UIImageView* topline = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, 0.5)];
        topline.backgroundColor = myLineColor;
        [self addSubview:topline];
        
        UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        ctView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.frame.size.height)collectionViewLayout:flowLayout];
        //注册单元格
        [ctView registerClass:[AllProCollectionCell class]forCellWithReuseIdentifier:@"cell"];
        //设置代理
        ctView.delegate = self;
        ctView.dataSource = self;
        ctView.backgroundColor = BG_COLOR;;
        [self addSubview:ctView];
        
        [ctView addPullToRefreshWithActionHandler:^{
            __strong typeof (wSelf) sSelf = wSelf;
            sSelf->curPage = 1;
            [wSelf getDatas:^{
                sSelf->arrPros = nil;
            }];
        }];
        
        [ctView addInfiniteScrollingWithActionHandler:^{
            __strong typeof (wSelf) sSelf = wSelf;
            sSelf->curPage ++;
            [wSelf getDatas:nil];
        }];
        
        [ctView.pullToRefreshView setOYStyle];
        [ctView triggerPullToRefresh];

    }
    return self;
}

- (void)NewLottery
{
    [ctView triggerPullToRefresh];
}

#pragma mark - set data
- (void)setTypeAndOrder:(int)type sort:(int)sort
{
    proType = type;
    proSort = sort;
    curPage = 1;
    __weak typeof (self) wSelf = self;
    [self getDatas:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->arrPros = nil;
    }];
}

#pragma mark - get data
- (void)getDatas:(void (^)(void))block
{
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"order":@"1",@"cateid":[NSString stringWithFormat:@"%d",proType],@"currentPage":[NSString stringWithFormat:@"%d",curPage],@"maxShowPage":@"10",@"timestamp":timestamp,@"token":token};
    [AllProModel getAllProduct:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [ctView.pullToRefreshView stopAnimating];
        [ctView.infiniteScrollingView stopAnimating];
        if(block!=NULL)
            block();
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        NSArray *list=[AllProItme  arrayOfModelsFromDictionaries:
                            @[dataDict] error:&error];
        if(!arrPros)
            arrPros = [NSMutableArray arrayWithArray:list];
        else
            [arrPros addObjectsFromArray:list];
        [ctView setShowsInfiniteScrolling:YES];
        [ctView reloadData];
        
    }   failure:^(NSError* error){
        [ctView.pullToRefreshView stopAnimating];
        [ctView.infiniteScrollingView stopAnimating];
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
    return arrPros.count;
}
//设置元素内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AllProCollectionCell * cell =[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell sizeToFit];
    cell.backgroundColor =[UIColor whiteColor];
    [cell setProItem:[arrPros objectAtIndex:indexPath.row] type:ProCollectionType_All];
    return cell;
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* propid = [[arrPros objectAtIndex:indexPath.row] pid];
    NSString* prosid = [[arrPros objectAtIndex:indexPath.row]sid];
    if(delegate)
    {
        [delegate doClickProduct:propid code:prosid];
    }
}

@end
