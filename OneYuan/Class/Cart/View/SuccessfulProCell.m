//
//  SuccessfulProCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/15.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "SuccessfulProCell.h"

@interface SuccessfulProCell ()
{
    __weak id<successfulProCellDelegate> delegate;
    UIImageView* proImage;
    UILabel*    title;
    UIButton*    code;
    UILabel*    count;
    
    BuyRequestModel* myCodes;
}
@end

@implementation SuccessfulProCell
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        proImage = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 50, 50)];
        proImage.layer.masksToBounds = YES;
        proImage.layer.borderColor = [UIColor grayColor].CGColor;
        proImage.layer.borderWidth = 0.5;
        proImage.layer.cornerRadius = 5;
        [self addSubview:proImage];
        
        title = [[UILabel alloc]initWithFrame:CGRectMake(70, 10, mainWidth-80, 30)];
        title.textColor = [UIColor grayColor];
        title.font = [UIFont systemFontOfSize:14];
        [self addSubview:title];
        
        code = [[UIButton alloc]initWithFrame:CGRectMake(70, 40, 70, 30)];
        [code setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        code.titleLabel.font = [UIFont systemFontOfSize:14];
        [code setTitle:@"查看夺宝码" forState:UIControlStateNormal];
        [code addTarget:self action:@selector(checkMyNumbers) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:code];
        
        count = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth-165, 40, 150, 30)];
        count.textColor = [UIColor redColor];
        count.font = [UIFont systemFontOfSize:14];
        count.textAlignment = NSTextAlignmentRight;
        [self addSubview:count];
        
        UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 79.5, mainWidth, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
    }
    return self;
}

- (void)setSuccess:(CartItem*)item Codes:(BuyRequestModel*)codeItem
{
    myCodes = codeItem;
    [proImage setImage_oy:nil image:item.thumb];
    title.text = item.title;
    count.text = [NSString stringWithFormat:@"%@人次",item.gonumber];
    
}


- (void)checkMyNumbers
{
    if (delegate) {
        [delegate myCodesClicked:myCodes.codes];
    }
}
@end
