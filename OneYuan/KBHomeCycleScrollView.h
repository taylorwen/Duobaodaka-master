

#import <UIKit/UIKit.h>

@interface KBHomeCycleScrollView : UIScrollView

// 提供给外界的初始化方法，包含初始化滚动时间间隔
- (instancetype)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

// 设置总的轮播图页数
@property (nonatomic, copy) NSInteger (^totalPagesCount)(void);

// 数据源：获取第pageIndex个位置的contentView
@property (nonatomic , copy) UIView *(^fetchContentViewAtIndex)(NSInteger pageIndex);

// 点击图片执行的方法
@property (nonatomic, copy) void (^tapPictureAction)(NSInteger pageIndex);

@end
