//
//  AddressInfoCell.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/8/25.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "AddressInfoCell.h"

@interface AddressInfoCell ()
{
    UIImageView* personimg;
    UIImageView* mobileimg;
    UIImageView* addressimg;
    
    UILabel*    lblperson;
    UILabel*    lblmobile;
    UILabel*    lbladdress;
    
}
@end
@implementation AddressInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        personimg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 19, 12, 13)];
        personimg.image = [UIImage imageNamed:@"person"];
        [self addSubview:personimg];
        
        lblperson = [[UILabel alloc]initWithFrame:CGRectMake(55, 15, mainWidth-100, 20)];
        lblperson.textColor = [UIColor grayColor];
        lblperson.font = [UIFont systemFontOfSize:14];
        [self addSubview:lblperson];
        
        mobileimg = [[UIImageView alloc]initWithFrame:CGRectMake(mainWidth/2, 19.5, 9, 13)];
        mobileimg.image = [UIImage imageNamed:@"addMobile"];
        [self addSubview:mobileimg];
        
        lblmobile = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth/2+35, 15, mainWidth-100, 20)];
        lblmobile.textColor = [UIColor grayColor];
        lblmobile.font = [UIFont systemFontOfSize:14];
        [self addSubview:lblmobile];
        
        addressimg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 65, 9.5, 12.5)];
        addressimg.image = [UIImage imageNamed:@"addressD"];
        [self addSubview:addressimg];
        
        lbladdress = [[UILabel alloc]initWithFrame:CGRectMake(55, 50, mainWidth-75, 44)];
        lbladdress.textColor = [UIColor grayColor];
        lbladdress.font = [UIFont systemFontOfSize:14];
        lbladdress.lineBreakMode = NSLineBreakByWordWrapping;
        lbladdress.numberOfLines = 2;
        [self addSubview:lbladdress];
        
    }
    return self;
}

- (void)setAddress:(NSString*)str
{
    if ([str isEqualToString:@""]) {
        [personimg removeFromSuperview];
        [mobileimg removeFromSuperview];
        [addressimg removeFromSuperview];
        return;
    }

    NSArray* list = [str componentsSeparatedByString:@"|"];
    if (list.count == 4) {
        lblperson.text = [list objectAtIndex:2];
        lblmobile.text = [list objectAtIndex:3];
        lbladdress.text = [list objectAtIndex:0];
    }else
    {
        lblperson.text = [list objectAtIndex:1];
        lblmobile.text = [list objectAtIndex:2];
        lbladdress.text = [list objectAtIndex:0];
    }
    
}
@end
