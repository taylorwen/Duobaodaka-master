//
//  SingeAdCollectionViewCell.h
//  MasterDuoBao
//
//  Created by 黄锋 on 15/9/25.
//  Copyright © 2015年 wenzhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"

typedef void(^tapAction)(void);

@interface SingeAdCollectionViewCell : UICollectionViewCell

- (void)addEGOImageView:(EGOImageView *)egoImg tapAction:(tapAction)tapBlock;

@end
