//
//  TabHomeVC.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "TabHomeVC.h"
#import "HomeModel.h"
#import "HomeInstance.h"
#import "SearchVC.h"
#import "MineBuylistVC.h"
#import "UserInstance.h"
#import "LoginVC.h"
#import "TabNewestVC.h"
#import "ProductDetailVC.h"
#import "ProductLotteryVC.h"
#import "ShowOrderListVC.h"
#import "ShowOrderDetailVC.h"
#import "AllProView.h"
#import "MineChargeVC.h"
#import "HomeAdCollectionCell.h"
#import "HomeAdView.h"
#import "HomeHotCollectionCell.h"
#import "HomeBtnCollectionCell.h"
#import "AllProModel.h"
#import "ProductDetailVC.h"
#import "HomeCateCell.h"
#import "Product10Cell.h"
#import "Product10TopCell.h"
#import "HomeHotTopCell.h"
#import "RegisterVC.h"
#import "HomeLimitedCell.h"
#import "LimitedLotteryVC.h"
#import "HomePopOverVC.h"
#import "UIViewController+MJPopupViewController.h"
#import "HomeWebVC.h"
#import "LimitedLotteryWebVC.h"
#import "LimitedLotteryVC.h"
#import "UserModel.h"
#import "HomeWinProPopVC.h"
#import "MineMyOrderVC.h"
#import "HomeTenRmbVC.h"
#import "IntroPopVC.h"
#import "HeadAdCollectionViewCell.h"
#import "EGOImageView.h"
#import "ZWIntroductionViewController.h"
#import "sys/utsname.h"         //判断手机型号
#import "SingeAdCollectionViewCell.h"

@interface TabHomeVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,HomeAdCollCellDelegate,HomeBtnCellDelegate,HomeRankingCellDelegate,HomePopoverViewDelegate,HomeWinPopoverViewDelegate,IntroPopoverViewDelegate>
{
    NSTimer                 *timer;
    __block int             curPage;
    UICollectionView        *tbView;
    __block NSArray         *newingList;
    __block HomeNewing      *item;
    __block NSArray         *hotArr;
    __block NSMutableArray  *arrPros;
    __block HomeHotest      *hotitem;
    __block int             ranking;
    __block NSMutableArray* arrNames;
    __block NSArray         *adArr;
    __block TabHomeVC       *tabview;
    __block NSMutableArray  *arrTen;
    __block NSMutableArray  *arrLimitedPro;
    __block NSString        *limitedProStatus;
    
    HomePopOverVC           *popVC;
    HomeWinProPopVC         *winVC;
    IntroPopVC              *introVC;
    NSString                *deviceString;
    __block NSString        *cellHeight;
    __block CGFloat itemRate;
    
    UIScrollView               *backgroundScrollView;
    /** 用来装顶部的scrollView用的View */
    UIView                     *topView;
    /** 导航条的背景view */
    UIView                     *naviView;
    CGFloat                    scrollY;
    /** 记录scrollView上次偏移X的距离 */
    CGFloat                    scrollX;
    HomeAdView*                 adView;

}
@property(nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) ZWIntroductionViewController *introductionView;
@end

@implementation TabHomeVC

- (void)dealloc
{
    if(timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tbView triggerPullToRefresh];
    
    if ([UserInstance ShardInstnce].uid)
    {
        [self checkUserInfo];
        [self getWinProduct];
    }
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"iphonePopIntro"]) {
//        //        popVC = nil;
//        //        popVC = [[HomePopOverVC alloc]init];
//        //        popVC.delegate = self;
//        //        [self presentPopupViewController:popVC animationType:MJPopupViewAnimationFade];
//        
//        [self deviceString];
//        
//        if ([deviceString isEqualToString:@"iPhone4,1"])
//        {
//            NSArray *coverImageNames = @[@"img_index_01txt", @"img_index_02txt", @"img_index_03txt"];
//            self.introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:nil];
//        }
//        else
//        {
//            NSArray *backgroundImageNames = @[@"img_index_01bg", @"img_index_02bg", @"img_index_03bg"];
//            self.introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:backgroundImageNames backgroundImageNames:nil];
//        }
//        
//        [self.view addSubview:self.introductionView.view];
//        
//        __weak typeof (self) wSelf = self;
//        self.introductionView.didSelectedEnter = ^() {
//            [wSelf.introductionView.view removeFromSuperview];
//            wSelf.introductionView = nil;
//            
//        };
//        
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"iphonePopIntro"];//设置成yes以后再也不进入进入引导页;
//    }

//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstPopIntro"]) {
//        introVC = nil;
//        introVC = [[IntroPopVC alloc]init];
//        introVC.delegate = self;
//        [self presentPopupViewController:introVC animationType:MJPopupViewAnimationFade];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstPopIntro"];
//    }
//    
//    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstAlert"])
//    {
//        if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"0"])
//        {
//            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"特别声明" message:@"本应用所有活动和奖品都与苹果公司(Apple Inc.)无关" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstAlert"];//设置成yes以后再也不进入进入引导页;
//    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *img = [UIImage imageNamed:@"logo_t1"];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:img];
    imageView.frame = CGRectMake((mainWidth-66.5)/2, 9.5, 66.5, 25);
    self.navigationItem.titleView = imageView;
    __weak typeof (self) wSelf = self;
    
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    tbView =[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, mainWidth, self.view.frame.size.height-49) collectionViewLayout:flowLayout];
    [tbView registerClass:[HeadAdCollectionViewCell class]  forCellWithReuseIdentifier:@"homeAdCell"];
    [tbView registerClass:[HomeBtnCollectionCell class] forCellWithReuseIdentifier:@"homeBtnCell"];
    [tbView registerClass:[HomeLimitedCell class]       forCellWithReuseIdentifier:@"homeLimitedCell"];
    [tbView registerClass:[Product10TopCell class]      forCellWithReuseIdentifier:@"hometenTopCell"];
    [tbView registerClass:[Product10Cell class]         forCellWithReuseIdentifier:@"hometenCell"];
    [tbView registerClass:[HomeCateCell class]          forCellWithReuseIdentifier:@"homeCateCell"];
    [tbView registerClass:[HomeHotTopCell class]        forCellWithReuseIdentifier:@"homeHotTopCell"];
    [tbView registerClass:[HomeHotCollectionCell class] forCellWithReuseIdentifier:@"homeHotCell"];
    
    [tbView registerClass:[SingeAdCollectionViewCell class] forCellWithReuseIdentifier:@"SingeAdCollectionViewCell"];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = BG_GRAY_COLOR;
    tbView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.view addSubview:tbView];
    
    [self loadHeadImage];
    [self loadLimitedPro:nil];
    
    curPage = 1;
    ranking = 0;
    [tbView addPullToRefreshWithActionHandler:^{
        curPage = 1;
        self->curPage = 1;
        [wSelf getHotest:^{
            arrPros = nil;        //每次刷新前将数据中的数据清零;
        }];
        [wSelf performSelector:@selector(stopRefreshAnimation) withObject:nil afterDelay:10];
    }];
    
    [tbView addInfiniteScrollingWithActionHandler:^{
        __strong typeof (wSelf) sSelf = wSelf;
        sSelf->curPage ++;
        [wSelf getHotest:nil];
        
    }];
    
    [tbView.pullToRefreshView setOYStyle];
    [tbView triggerPullToRefresh];
    
}

- (void)loadHeadImage
{
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{@"timestamp":timestamp,@"token":token};
    [HomeModel getAds:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [[XBToastManager ShardInstance]hideprogress];
        
        NSDictionary* datadict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        adArr = [HomeAd arrayOfModelsFromDictionaries:@[datadict] error:&error];
        arrNames = [NSMutableArray array];
        for (HomeAd *ad in adArr)
        {
            [arrNames addObject:ad.img];
        }
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance]hideprogress];
    }];
}

//获取超级限时商品
- (void)loadLimitedPro:(void (^)(void))block
{
    [HomeModel getLimitedPro:nil success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [[XBToastManager ShardInstance]hideprogress];
        if (block!= NULL)
            block();
        NSDictionary* datadict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        NSArray* list = [HomeLimitedProModel arrayOfModelsFromDictionaries:@[datadict] error:&error];
        arrLimitedPro = [NSMutableArray arrayWithArray:list];
        HomeLimitedProModel* itemHeight = [arrLimitedPro objectAtIndex:0];
//        NSLog(@"%@",itemHeight.height);
        itemRate = [itemHeight.height doubleValue]/[itemHeight.width doubleValue];
//        NSLog(@"%f",itemRate);
        cellHeight = [NSString stringWithFormat:@"%f",itemRate];

    } failure:^(NSError* error){
        [[XBToastManager ShardInstance]hideprogress];
    }];
}

//获取热门商品
- (void)getHotest:(void (^)(void))block
{
    NSString* order;
    order = [NSString stringWithFormat:@"%d", ranking];
    NSString* currrent = [NSString stringWithFormat:@"%d",curPage];
    
    NSString* timestamp = [WenzhanTool getCurrentTime];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@02254412559616338026L",timestamp];
    NSString* token = [NSString md5:strOrigin];
    [[XBToastManager ShardInstance]showprogress];
    NSDictionary* dict = @{@"order":order,@"cateid":@"0",@"currentPage":currrent,@"maxShowPage":@"10",@"timestamp":timestamp,@"token":token};
    [HomeModel getHotest:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        [[XBToastManager ShardInstance]hideprogress];
        if (block!= NULL)
            block();
        NSDictionary* dataDict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        NSArray *list=[HomeHotest  arrayOfModelsFromDictionaries:
                       @[dataDict] error:&error];
        if(!arrPros)
        {
            arrPros = [NSMutableArray arrayWithArray:list];
        }
        else
        {
            [arrPros addObjectsFromArray:list];
        }
        [tbView reloadData];
        [tbView setShowsInfiniteScrolling:YES];
        
    }   failure:^(NSError* error){
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        [[XBToastManager ShardInstance]hideprogress];
    }];
}

//检查中奖信息，如果中奖，则弹出中奖页面
- (void)getWinProduct
{
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    NSDictionary* dict = @{@"uid":[UserInstance ShardInstnce].uid,@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
    [HomeModel getWinProduct:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        [[XBToastManager ShardInstance]hideprogress];
        NSDictionary* datadict = [(NSDictionary*)result objectForKey:@"data"];
        NSError* error = nil;
        WinProModel* proItem = [[WinProModel alloc]initWithDictionary:datadict error:&error];
        OneBaseParser* p = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
        if ([p.resultCode isEqualToString:@"200"]) {
            if (proItem == nil)
            {
                return ;
            }else
            {
                winVC = nil;
                winVC = [[HomeWinProPopVC alloc]initWithWinProInfo:proItem];
                winVC.delegate = self;
                [self presentPopupViewController:winVC animationType:MJPopupViewAnimationFade];
            }
        }
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance]hideprogress];
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
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
    if (section == 3)
    {
        return arrPros.count;
    }
    if (section == 1) {
        if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"])
        {
            return 1;
        }else
        {
            return 2;
        }
    }
    return 1;
}

//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0)
    {
        return CGSizeMake(mainWidth, mainWidth*0.46);
    }
    if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            return CGSizeMake(mainWidth, 70);
        }
        return CGSizeMake(mainWidth, mainWidth*0.17);
    }
    if (indexPath.section == 2)
    {
        return CGSizeMake(mainWidth, 37);
    }
    if (indexPath.section == 3)
    {
        return CGSizeMake(mainWidth/2,mainWidth/2+50);
    }
    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(mainWidth, 0.01);
    }
    if (section ==1) {
        return CGSizeMake(mainWidth, 0.01);
    }
    if (section ==3) {
        return CGSizeMake(mainWidth, 0.01);
    }
    return CGSizeMake(mainWidth, 5);
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(mainWidth, 0.01);
}

- (void)getImageViewArr
{
    if (!_dataArr.count) {
        _dataArr = [NSMutableArray array];
        NSArray *arr;
        //            if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"])
        //            {
        //                arr = arrNames;
        //            }
        //            else
        //            {
        //                arr = @[@"http://121.41.101.108/statics/uploads/banner/20150728/shishicai.jpg",@"http://121.41.101.108/statics/uploads/banner/20150728/shaidan.jpg"];
        //            }
        arr = arrNames;
        if (arr.count) {
            for (NSInteger pageIndex = 0; pageIndex < arr.count; pageIndex ++) {
                EGOImageView *aImageView = [[EGOImageView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, mainWidth*0.46)];
                aImageView.imageURL = [NSURL URLWithString:arr[pageIndex]];
                [_dataArr addObject:aImageView];
            }
        }
    }
}

//设置元素内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if      (indexPath.section == 0)
    {
        [self getImageViewArr];
        if (_dataArr.count == 1) {
            SingeAdCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SingeAdCollectionViewCell" forIndexPath:indexPath];
            EGOImageView *view = _dataArr[0];
            [cell addEGOImageView:view tapAction:^{
                HomeAd *ad = adArr[0];
                [self adClick:ad];
            }];
            return cell;
        } else {
            HeadAdCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeAdCell" forIndexPath:indexPath];
            [cell sizeToFit];
            cell.backgroundColor =[UIColor whiteColor];
            cell.cycleScrollView.totalPagesCount =  ^NSInteger() {
                return _dataArr.count;
            };
            cell.cycleScrollView.fetchContentViewAtIndex = ^UIView *(NSInteger pageIndex) {
                if (_dataArr.count) {
                    EGOImageView *view = (EGOImageView *)_dataArr[pageIndex];
                    return view;
                }
                return nil;
            };
            // 点击轮播图执行的方法
            cell.cycleScrollView.tapPictureAction = ^(NSInteger pageIndex) {
                HomeAd *ad = adArr[pageIndex];
                [self adClick:ad];
            };
            return cell;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0) {
            HomeBtnCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeBtnCell" forIndexPath:indexPath];
            [cell sizeToFit];
            cell.backgroundColor =[UIColor whiteColor];
            cell.delegate = self;
            return cell;
        }
        else if (indexPath.row == 1)
        {
            HomeLimitedCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeLimitedCell" forIndexPath:indexPath];
            [cell sizeToFit];
            cell.backgroundColor = [UIColor whiteColor];

            HomeLimitedProModel* limiteItem = [arrLimitedPro objectAtIndex:0];
            [cell setLimited:limiteItem];
            return cell;
        }
    }
    else if (indexPath.section == 2)
    {
        HomeCateCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeCateCell" forIndexPath:indexPath];
        cell.delegate = self;
            [cell sizeToFit];
            cell.backgroundColor =[UIColor whiteColor];
            return cell;
    }
    else if (indexPath.section == 3)
    {
        HomeHotCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeHotCell" forIndexPath:indexPath];
        [cell sizeToFit];
        cell.backgroundColor =[UIColor whiteColor];
        [cell setHots:[arrPros objectAtIndex:indexPath.item]];
        return cell;
    }
    return nil;
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
    if (indexPath.section == 3) {
        ProductDetailVC* vc = [[ProductDetailVC alloc] initWithGoodsId:[[arrPros objectAtIndex:indexPath.item]pid] codeId:[[arrPros objectAtIndex:indexPath.item]sid]];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - delegate;
- (void)adClick:(HomeAd *)ad
{
    if ([ad._type isEqualToString:@"web"]) {
        HomeWebVC* vc = [[HomeWebVC alloc]initWithURL:ad];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([ad._type isEqualToString:@"product"]) {
        ProductDetailVC* vc = [[ProductDetailVC alloc] initWithGoodsId:ad.pid codeId:ad.link];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)btnHomeClick:(int)index
{
    if(index == 0)
    {
        if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"]) {
            HomeTenRmbVC* vc = [[HomeTenRmbVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            self.tabBarController.selectedIndex = 1;
            [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.2];
        }
    }
    else if(index == 1)
    {
        if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"])
        {
            //晒单列表
            ShowOrderListVC* vc = [[ShowOrderListVC alloc] initWithGoodsId:@"0" userid:@"0"];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            self.tabBarController.selectedIndex = 2;
            [self.navigationController performSelector:@selector(popToRootViewControllerAnimated:) withObject:[NSNumber numberWithBool:NO] afterDelay:0.2];
        }
    }
    else if(index == 2)
    {
        if(![UserInstance ShardInstnce].uid)
        {
            RegisterVC* vc = [[RegisterVC alloc]init];
            UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [self.navigationController presentViewController:nav animated:YES completion:nil];
        }
        else
        {
            MineBuylistVC* vc = [[MineBuylistVC alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if (index == 3)
    {
        if ([[UserInstance ShardInstnce].versionStatus isEqualToString:@"1"])
        {
            MineChargeVC* vc = [[MineChargeVC alloc]init];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else
        {
            SCLAlertView* alert = [[SCLAlertView alloc] init];
            alert.showAnimationType = FadeIn;
            [alert showWarning:self.tabBarController title:@"提示" subTitle:@"请前往官方网站完成充值" closeButtonTitle:@"好的" duration:0];
        }
    }
}

#pragma mark SVPullToRefresh
- (void)refreshAction
{
    [tbView reloadData];
}

-(void)stopRefreshAnimation
{
    [tbView.pullToRefreshView stopAnimating];
}

- (void)btnHomeRankingClick:(int)index
{
    if (index == 0) {
        ranking = 0;
        curPage = 1;
        [self getHotest:nil];
        [tbView triggerPullToRefresh];
    }
    if (index == 1) {
        ranking = 1;
        curPage = 1;
        [self getHotest:nil];
        [tbView triggerPullToRefresh];
        NSLog(@"%d",ranking);
    }
    if (index == 2) {
        ranking = 2;
        curPage = 1;
        [self getHotest:nil];
        [tbView triggerPullToRefresh];
    }
    if (index == 3) {
        ranking = 4;
        curPage = 1;
        [self getHotest:nil];
        [tbView triggerPullToRefresh];
    }
    if (index == 4) {
        ranking = 3;
        curPage = 1;
        [self getHotest:nil];
        [tbView triggerPullToRefresh];
    }
}

- (void)cancelButtonClicked:(HomePopOverVC *)aSecondDetailViewController
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    aSecondDetailViewController = nil;
}
//弹出层商品的点击事件
- (void)goNextButtonClicked:(NSString *)goodsID code:(NSString *)codeId VC:(HomePopOverVC *)homeOverVC
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    homeOverVC = nil;
    RegisterVC* vc = [[RegisterVC alloc]init];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)cancelWinButtonClicked:(HomeWinProPopVC*)homePopOverVC
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    homePopOverVC = nil;
}
- (void)goNextWinButtonClicked:(HomeWinProPopVC*)homeOverVC
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    homeOverVC = nil;
    MineMyOrderVC* vc = [[MineMyOrderVC alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//弹出引导页
- (void)cancelIntroButtonClicked:(IntroPopVC*)IntroPopVC
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    IntroPopVC = nil;
}

- (void)checkUserInfo
{
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

//获取设备型号
- (NSString*)deviceString
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceString isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceString isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceString isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([deviceString isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceString isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceString isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceString isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceString isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceString isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceString isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceString isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceString isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceString isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceString isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceString isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceString isEqualToString:@"x86_64"])       return @"Simulator";
    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return deviceString;
}
@end
