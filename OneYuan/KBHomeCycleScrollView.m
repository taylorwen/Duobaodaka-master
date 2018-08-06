

#import "KBHomeCycleScrollView.h"
#import "NSTimer+extra.h"

@interface KBHomeCycleScrollView ()<UIScrollViewDelegate>
// 子滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;

// 子滚动视图的内容视图
@property (nonatomic, strong) NSMutableArray *contentViewsArr;

// 子滚动视图的内同视图的当前页
@property (nonatomic, assign) NSInteger currentPageIndex;

// 子滚动视图的内容视图的页数
@property (nonatomic, assign) NSInteger pageCount;

// 定时器
@property (nonatomic, strong) NSTimer *timer;

// 定时器滚动时间间隔
@property (nonatomic, assign) NSTimeInterval animationDuration;

// 添加pageControl
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation KBHomeCycleScrollView

// 设置总的轮播图页数
- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount {
    self.pageCount = totalPagesCount();
    self.pageControl.numberOfPages = self.pageCount; // 设置pageControl的页数
    if (self.pageCount > 0) {
        [self configContentViews];
        
        // 启动时间间隔
        [self.timer resumeTimerAfterTimeInterval:0];
    }
}

// 提供给外界的初始化方法，包含初始化滚动时间间隔
- (instancetype)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration; {
    self = [self initWithFrame:frame];
//    self.animationDuration = animationDuration;
    if (animationDuration > 0) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.animationDuration = animationDuration target:self selector:@selector(animationTimerDidFired:) userInfo:nil repeats:YES];
        [self .timer pauseTimer];
    }
    return self;
}

// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES; // 打开自动布局子视图
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.autoresizingMask = 0xFF; // 自动调整子控件和父控件中间的位置，宽高
        self.scrollView.contentMode = UIViewContentModeCenter; // 设置内容视图的位置为居中
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        [self addSubview:self.scrollView];
        
        self.currentPageIndex = 0;
        
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((self.bounds.size.width-100)/2, self.bounds.size.height-20, 100, 20)];
//        self.pageControl.backgroundColor = RGB(13, 13, 13, 0.3);
        self.pageControl.currentPageIndicatorTintColor = [UIColor orangeColor];
        [self addSubview:self.pageControl];
    }
    return self;
}


#pragma mark - 私有方法
// 布局子滚动视图上的内容视图
- (void)configContentViews {
    
    // 将子滚动视图上的内容视图全部移除
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 设置子滚动视图上的内容视图的数据
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    // 设置子滚动视图上的内容
    for (UIView *contentView in self.contentViewsArr) {
        
        // 打开内容视图的交互
        contentView.userInteractionEnabled = YES;
        
        // 添加内容视图的点击手势
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(contentViewTapAction:)];
        [contentView addGestureRecognizer:tapGesture];
        
        // 设置frame
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
        contentView.frame = rightRect;
        
        [self.scrollView addSubview:contentView];
    }
    
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
}

// 设置ScrollView的内容视图的数据源
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViewsArr == nil) {
        self.contentViewsArr = [@[] mutableCopy];
    }
    [self.contentViewsArr removeAllObjects];
    
    if (self.fetchContentViewAtIndex) {
        [self.contentViewsArr addObject:self.fetchContentViewAtIndex(previousPageIndex)];
        [self.contentViewsArr addObject:self.fetchContentViewAtIndex(_currentPageIndex)];
        [self.contentViewsArr addObject:self.fetchContentViewAtIndex(rearPageIndex)];
    }
}

// 设置子滚动视图的内容视图的轮播下下标
- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1) {
        return self.pageCount - 1;
    } else if (currentPageIndex == self.pageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.timer pauseTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.timer resumeTimerAfterTimeInterval:self.animationDuration];
    self.pageControl.currentPage = self.currentPageIndex;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    int contentOffsetX = scrollView.contentOffset.x;
    if(contentOffsetX >= (2 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
//        NSLog(@"next，当前页:%ld",self.currentPageIndex);
        [self configContentViews];
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
//        NSLog(@"previous，当前页:%ld",self.currentPageIndex);
        [self configContentViews];
    }
}


#pragma mark - 响应事件
- (void)animationTimerDidFired:(NSTimer *)timer {
    
//    if (_pageCount > 1)
    {
        //self.pageControl.hidden = NO;
        CGFloat xx = self.scrollView.contentOffset.x;
        xx += self.scrollView.frame.size.width / 2;
        int index = (int)(xx / self.scrollView.frame.size.width);
        CGPoint newOffset = CGPointMake(index * self.scrollView.frame.size.width + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
        //    CGPoint newOffset = CGPointMake(self.scrollView.contentOffset.x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
        self.pageControl.currentPage = self.currentPageIndex;
        [self.scrollView setContentOffset:newOffset animated:YES];
    }
//    else if (_pageCount == 1) {
//        for (UIView *view0 in self.subviews) {
//            [view0 removeFromSuperview];
//        }
//        UIView *view = self.contentViewsArr[0];
//        view.frame = self.bounds;
//        [self addSubview:view];
//        // 打开内容视图的交互
//        view.userInteractionEnabled = YES;
//        // 添加内容视图的点击手势
//        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapAction)];
//        [view addGestureRecognizer:tapGesture];
//    }
}

- (void)contentViewTapAction:(UITapGestureRecognizer *)tapGuesture {
    if (self.tapPictureAction) {
        self.tapPictureAction(self.currentPageIndex);
    }
}

//- (void)viewTapAction
//{
//    if (self.tapPictureAction) {
//        self.tapPictureAction(0);
//        //NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
//    }
//}


@end
