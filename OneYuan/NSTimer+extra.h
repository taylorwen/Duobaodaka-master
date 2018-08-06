

#import <Foundation/Foundation.h>

@interface NSTimer (extra)

// 停止计时器
- (void)pauseTimer;

// 开始计时器
- (void)resumeTimer;

// 在一个timeInterval之后开始计时器
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
