//
//  SettingFeedCell.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "SettingFeedCell.h"
#import "UserInstance.h"


@interface SettingFeedCell ()
{
    UIImageView* imgHead;
    UIImageView* bubble;
    UILabel     *lblContent;
}
@end

@implementation SettingFeedCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        imgHead = [[UIImageView alloc] init];
        imgHead.layer.cornerRadius = headWidth / 2;
        imgHead.layer.borderWidth = 2;
        imgHead.layer.borderColor = [[UIColor whiteColor] CGColor];
        imgHead.layer.masksToBounds = YES;
        [self addSubview:imgHead];
        
        bubble = [[UIImageView alloc] init];
        [self addSubview:bubble];
        
        lblContent = [[UILabel alloc] init];
        lblContent.textColor = [UIColor blackColor];
        lblContent.font = [UIFont systemFontOfSize:13];
        lblContent.numberOfLines = 0;
        lblContent.lineBreakMode = NSLineBreakByWordWrapping;
        [bubble addSubview:lblContent];
        
    }
    return self;
}

- (void)setFeed:(NSDictionary*)dic
{
    lblContent.text = [dic objectForKey:@"content"];
    CGSize s = [lblContent.text textSizeWithFont:lblContent.font constrainedToSize:CGSizeMake(mainWidth - headWidth - 50, 999) lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat sH = s.height+40;
    
    if ([[dic objectForKey:@"type"] isEqualToString:@"dev_reply"]){
        imgHead.image = [UIImage imageNamed:@"kefu"];
        imgHead.frame = CGRectMake(10, sH - headWidth, headWidth, headWidth);

        bubble.image = [[UIImage imageNamed:@"bubbleSomeone"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        bubble.frame = CGRectMake(headWidth +10, 10, s.width + 30, s.height + 20);
        
        lblContent.frame = CGRectMake((bubble.frame.size.width - s.width) / 2 + 2, (bubble.frame.size.height - s.height) / 2 - 3 , s.width, s.height);
        
    }else{
        if([[UserInstance ShardInstnce] uid])
            [imgHead setImage_oy:oyImageBaseUrl image:[[UserInstance ShardInstnce] img]];
        else
            [imgHead setImage:[UIImage imageNamed:@"defaulthead"]];
        imgHead.frame = CGRectMake(mainWidth - headWidth - 10, sH - headWidth, headWidth, headWidth);
        
        bubble.image = [[UIImage imageNamed:@"bubbleMine"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
        bubble.frame = CGRectMake(mainWidth - headWidth - s.width - 40 , 10, s.width + 30, s.height + 20);
        
        lblContent.frame = CGRectMake((bubble.frame.size.width - s.width) / 2 - 5, (bubble.frame.size.height - s.height) / 2 - 3 , s.width, s.height);
    }
}
@end
