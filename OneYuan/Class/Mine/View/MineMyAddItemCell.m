//
//  MineMyAddItemCell.m
//  MasterDuoBao
//
//  Created by zhan wen(wenzhan2010@live.cn) on 15/6/9.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineMyAddItemCell.h"

@interface MineMyAddItemCell ()
{
    __weak id<MineMyAddItemCellDelegate> delegate;
    
    int     addressId;
    
    UIImageView* personimg;
    UIImageView* mobileimg;
    UIImageView* addressimg;
    
    UILabel*    lblperson;
    UILabel*    lblmobile;
    UILabel*    lbladdress;
    
    UILabel *lblDefault;
    UIButton *btnDefault;
    UIImageView* select;
    
    UIImageView*    editimg;
    UILabel*        lblEdit;
    
    UIImageView* deleteimg;
    UILabel*        lbldelete;
}
@end

@implementation MineMyAddItemCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.accessoryType = UITableViewCellAccessoryNone;

        //底部画线
        UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 119.5, mainWidth, 0.5)];
        line.backgroundColor = myLineColor;
        [self addSubview:line];

        personimg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 19, 12, 13)];
        personimg.image = [UIImage imageNamed:@"person"];
        [self addSubview:personimg];
        
        lblperson = [[UILabel alloc]initWithFrame:CGRectMake(45, 15, mainWidth-100, 20)];
        lblperson.textColor = [UIColor grayColor];
        lblperson.font = [UIFont systemFontOfSize:14];
        [self addSubview:lblperson];
        
        mobileimg = [[UIImageView alloc]initWithFrame:CGRectMake(mainWidth/2, 19.5, 9, 13)];
        mobileimg.image = [UIImage imageNamed:@"addMobile"];
        [self addSubview:mobileimg];
        
        lblmobile = [[UILabel alloc]initWithFrame:CGRectMake(mainWidth/2+25, 15, mainWidth-100, 20)];
        lblmobile.textColor = [UIColor grayColor];
        lblmobile.font = [UIFont systemFontOfSize:14];
        [self addSubview:lblmobile];
        
        addressimg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 45, 9.5, 12.5)];
        addressimg.image = [UIImage imageNamed:@"addressD"];
        [self addSubview:addressimg];
        
        lbladdress = [[UILabel alloc]initWithFrame:CGRectMake(45, 30, mainWidth-75, 44)];
        lbladdress.textColor = [UIColor grayColor];
        lbladdress.font = [UIFont systemFontOfSize:12.5];
        lbladdress.lineBreakMode = NSLineBreakByWordWrapping;
        lbladdress.numberOfLines = 2;
        [self addSubview:lbladdress];

        //分割线
        UIImageView* lineShort = [[UIImageView alloc]initWithFrame:CGRectMake(16, 70, mainWidth-16, 0.5)];
        lineShort.backgroundColor = myLineColor;
        [self addSubview:lineShort];
        
        //默认地址左边的图片
        select = [[UIImageView alloc]initWithFrame:CGRectMake(16, 85, 20, 20)];
        [self addSubview:select];
        
        lblDefault = [[UILabel alloc] initWithFrame:CGRectMake(16, 85, 90, 20)];
        lblDefault.textColor = [UIColor redColor];
        lblDefault.text = @"默认地址";
        lblDefault.font = [UIFont systemFontOfSize:14];
        lblDefault.textAlignment = NSTextAlignmentRight;
        [self addSubview:lblDefault];
        
        editimg = [[UIImageView alloc]initWithFrame:CGRectMake(mainWidth-180, 85, 20, 20)];
        editimg.image = [UIImage imageNamed:@"edit"];
//        [self addSubview:editimg];
        
        lblEdit = [[UILabel alloc] initWithFrame:CGRectMake(mainWidth-155, 85, 90, 20)];
        lblEdit.textColor = [UIColor grayColor];
        lblEdit.text = @"编辑";
        lblEdit.font = [UIFont systemFontOfSize:14];
        lblEdit.textAlignment = NSTextAlignmentLeft;
//        [self addSubview:lblEdit];
        
        editimg = [[UIImageView alloc]initWithFrame:CGRectMake(mainWidth-90, 85, 20, 20)];
        editimg.image = [UIImage imageNamed:@"delete"];
//        [self addSubview:editimg];
        
        lblEdit = [[UILabel alloc] initWithFrame:CGRectMake(mainWidth-65, 85, 90, 20)];
        lblEdit.textColor = [UIColor grayColor];
        lblEdit.text = @"删除";
        lblEdit.font = [UIFont systemFontOfSize:14];
        lblEdit.textAlignment = NSTextAlignmentLeft;
//        [self addSubview:lblEdit];
        
    }
    return self;
}

- (void)setAddress:(MineMyAddressItem *)item bShow:(BOOL)bShow
{
    lblDefault.hidden = !bShow;
    
    addressId = [item.pid intValue];
    
    lblperson.text = [NSString stringWithFormat:@"%@",item.shouhuoren];
    lblmobile.text = item.mobile;
    
    lbladdress.text = [NSString stringWithFormat:@"%@ %@ %@ %@",item.sheng,item.shi,item.xian,item.jiedao];
    
    if([item.isdefault isEqualToString:@"N"])
    {
        select.image = [UIImage imageNamed:@"addressicon7"];
        lblDefault.text = @"      设为默认";
        lblDefault.textColor = [UIColor lightGrayColor];
        lblDefault.userInteractionEnabled = YES;
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDefault)];
        [lblDefault addGestureRecognizer:tap];
        
    }else if([item.isdefault isEqualToString:@"Y"]){
        lblDefault.text = @"      默认地址";
        lblDefault.textColor = mainColor;
        select.image = [UIImage imageNamed:@"addressicon6"];
    }
}

- (void)tapDefault
{
    if(delegate)
    {
        [delegate setDefault:addressId];
    }
}
@end
