//
//  MineAdressEditVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/1.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "MineAdressEditVC.h"
#import "sqlService.h"
#import "MineMyAreaModel.h"

@interface MineAdressEditVC () <UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>
{
    __weak  id<MineMyAddressEditVCDelegate> delegate;
    UIPickerView *cityPicker;
    NSMutableArray *proviceArray,*cityArray,*regionArray;
    sqlService *service;
    NSString *proviceStr,*cityStr,*regionStr;
    
    __block MineMyAddressItem   *myAddressItem;
    __block UITextField         *txField;
    __block UITextField         *addressField;
    __block UITextField         *nameField;
    __block UITextField         *mobileField;
    
    __block UILabel* lblProvince;
    __block UILabel* lblCity;
    __block UILabel* lblRegion;
    
    __block NSString        *pid;
    __block NSString        *qq;
    __block NSString        *time;
    __block NSString        *uid;
    
    
}
@property(nonatomic,retain)NSMutableArray *proviceArray,*cityArray,*regionArray;
@end

@implementation MineAdressEditVC
@synthesize proviceArray,cityArray,regionArray,delegate;

- (id)initWithAddress:(MineMyAddressItem*)item
{
    self = [super init];
    if(self)
    {
        NSLog(@"%@",item);
        myAddressItem = item;
        if (myAddressItem) {
            pid = myAddressItem.pid;
            qq  = myAddressItem.qq;
            time= myAddressItem.time;
            uid = myAddressItem.uid;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BG_GRAY_COLOR;
    if(myAddressItem && [myAddressItem.uid intValue] > 0)
        self.title = @"更新地址";
    else
        self.title = @"新增地址";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    UIView* vvv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainWidth, 200)];
    vvv.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:vvv];
    
    UIImageView* imgPer = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16.5, 13, 16)];
    imgPer.image = [UIImage imageNamed:@"newAddicon1"];
    [vvv addSubview:imgPer];
    
    UILabel* lblPer = [[UILabel alloc]initWithFrame:CGRectMake(37, 0, 80, 49)];
    lblPer.text = @"收货人：";
    lblPer.textColor = [UIColor grayColor];
    lblPer.font = [UIFont systemFontOfSize:16];
    [vvv addSubview:lblPer];
    
    nameField = [[UITextField alloc]initWithFrame:CGRectMake(120, 0, mainWidth-110, 49)];
    [nameField setBorderStyle:UITextBorderStyleNone];
    nameField.placeholder = @"";
    nameField.delegate = self;
    nameField.font = [UIFont systemFontOfSize:14];
    nameField.returnKeyType = UIReturnKeyDone;
    nameField.textColor = [UIColor hexFloatColor:@"666666"];
    nameField.text = myAddressItem.shouhuoren;
    [vvv addSubview:nameField];
    
    UIImageView* line1 = [[UIImageView alloc]initWithFrame:CGRectMake(37, 48.5, mainWidth-37, 0.5)];
    line1.backgroundColor = myLineColor;
    [vvv addSubview:line1];
    
    UIImageView* imgMob = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16.5+49, 13, 16)];
    imgMob.image = [UIImage imageNamed:@"newAddicon2"];
    [vvv addSubview:imgMob];
    
    UILabel* lblMob = [[UILabel alloc]initWithFrame:CGRectMake(37, 49, 100, 49)];
    lblMob.text = @"联系方式：";
    lblMob.textColor = [UIColor grayColor];
    lblMob.font = [UIFont systemFontOfSize:16];
    [vvv addSubview:lblMob];
    
    mobileField = [[UITextField alloc]initWithFrame:CGRectMake(120, 49, mainWidth-110, 49)];
    [mobileField setBorderStyle:UITextBorderStyleNone];
    mobileField.placeholder = @"";
    mobileField.delegate = self;
    mobileField.font = [UIFont systemFontOfSize:14];
    mobileField.returnKeyType = UIReturnKeyDone;
    mobileField.keyboardType = UIKeyboardTypeNumberPad;
    mobileField.textColor = [UIColor hexFloatColor:@"666666"];
    mobileField.text = myAddressItem.mobile;
    [vvv addSubview:mobileField];
    
    UIImageView* line2 = [[UIImageView alloc]initWithFrame:CGRectMake(37, 48.5+49, mainWidth-37, 0.5)];
    line2.backgroundColor = myLineColor;
    [vvv addSubview:line2];
    
    cityPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height-250, mainWidth-20, 250)];
    cityPicker.dataSource = self;
    cityPicker.delegate = self;
    cityPicker.showsSelectionIndicator = YES;      // 这个弄成YES, picker中间就会有个条, 被选中的样子
    cityPicker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:cityPicker];
    
    service = [[sqlService alloc]init];
    self.proviceArray = [service getCityListByProvinceCode:@"0"];
    self.cityArray = [service getCityListByProvinceCode:[[proviceArray objectAtIndex:0] objectForKey:@"sCode"]];
    self.regionArray = [service getCityListByProvinceCode:[[cityArray objectAtIndex:0] objectForKey:@"sCode"]];
    proviceStr = [[proviceArray objectAtIndex:0]    objectForKey:@"sName"];
    cityStr = [[cityArray objectAtIndex:0]          objectForKey:@"sName"];
    regionStr = [[regionArray objectAtIndex:0]      objectForKey:@"sName"];
    
    UIImageView* imgRegion = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16.5+49+49, 13, 16)];
    imgRegion.image = [UIImage imageNamed:@"newAddicon3"];
    [vvv addSubview:imgRegion];
    
    UILabel* lblReg = [[UILabel alloc]initWithFrame:CGRectMake(37, 98, 100, 49)];
    lblReg.text = @"所在地区：";
    lblReg.textColor = [UIColor grayColor];
    lblReg.font = [UIFont systemFontOfSize:16];
    [vvv addSubview:lblReg];
    
    txField = [[UITextField alloc]initWithFrame:CGRectMake(120, 98, mainWidth-32, 40)];
    [txField setBorderStyle:UITextBorderStyleNone];
    txField.placeholder = @"";
    txField.delegate = self;
    txField.font = [UIFont systemFontOfSize:16];
    txField.textColor = [UIColor hexFloatColor:@"666666"];
    txField.userInteractionEnabled = NO;
    [self.view addSubview:txField];
    
    lblProvince = [[UILabel alloc]initWithFrame:CGRectMake(125, 98, 200, 49)];
    lblProvince.backgroundColor = [UIColor clearColor];
    lblProvince.textColor = [UIColor grayColor];
    lblProvince.font = [UIFont systemFontOfSize:13];
    if (myAddressItem)
    {
        lblProvince.text = myAddressItem.sheng;
    }else
    {
        lblProvince.text = @"北京市";
    }
    [self.view addSubview:lblProvince];
    
    lblCity = [[UILabel alloc]initWithFrame:CGRectMake(235, 98, 200, 49)];
    lblCity.backgroundColor = [UIColor clearColor];
    lblCity.textColor = [UIColor grayColor];
    lblCity.font = [UIFont systemFontOfSize:13];
    if (myAddressItem)
    {
        lblCity.text = myAddressItem.shi;
    }else
    {
        lblCity.text = @"北京市";
    }
    [self.view addSubview:lblCity];
    
    lblRegion = [[UILabel alloc]initWithFrame:CGRectMake(305, 98, 200, 49)];
    lblRegion.backgroundColor = [UIColor clearColor];
    lblRegion.textColor = [UIColor grayColor];
    lblRegion.font = [UIFont systemFontOfSize:13];
    if (myAddressItem)
    {
        lblRegion.text = myAddressItem.xian;
    }else
    {
        lblRegion.text = @"北京市";
    }
    [self.view addSubview:lblRegion];
    
    UIImageView* line3 = [[UIImageView alloc]initWithFrame:CGRectMake(37, 48.5+49+49, mainWidth-37, 0.5)];
    line3.backgroundColor = myLineColor;
    [vvv addSubview:line3];
    
    UIImageView* imgAdd = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16.5+49+49+49, 13, 16)];
    imgAdd.image = [UIImage imageNamed:@"newAddicon4"];
    [vvv addSubview:imgAdd];
    
    UILabel* lblAdd = [[UILabel alloc]initWithFrame:CGRectMake(37, 98+49, 100, 49)];
    lblAdd.text = @"详细地址：";
    lblAdd.textColor = [UIColor grayColor];
    lblAdd.font = [UIFont systemFontOfSize:16];
    [vvv addSubview:lblAdd];
    
    addressField = [[UITextField alloc]initWithFrame:CGRectMake(120, 98+49, mainWidth-32, 49)];
    [addressField setBorderStyle:UITextBorderStyleNone];
    addressField.placeholder = @"";
    addressField.delegate = self;
    addressField.font = [UIFont systemFontOfSize:14];
    addressField.returnKeyType = UIReturnKeyDone;
    addressField.textColor = [UIColor hexFloatColor:@"666666"];
    addressField.text = myAddressItem.jiedao;
    [self.view addSubview:addressField];
    
    UIImageView* line4 = [[UIImageView alloc]initWithFrame:CGRectMake(37, 48.5+49+49, mainWidth-37, 0.5)];
    line4.backgroundColor = myLineColor;
    [vvv addSubview:line4];
    
    UIButton* btnOK = [[UIButton alloc] initWithFrame:CGRectMake(16, 48.5+49+49+49+20, mainWidth - 32, 40)];
    [btnOK setTitle:@"提交" forState:UIControlStateNormal];
    [btnOK setBackgroundColor:mainColor];
    [btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btnOK.layer.cornerRadius = 20;
    [btnOK addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnOK];
    
}

- (void)submitAction
{
    if(addressField.text.length == 0)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入详细地址"];
        return;
    }
    if(nameField.text.length == 0)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入收货人"];
        return;
    }
    if(mobileField.text.length == 0)
    {
        [[XBToastManager ShardInstance] showtoast:@"请输入手机号"];
        return;
    }
    if (![[Jxb_Common_Common sharedInstance] validatePhone:mobileField.text])
    {
        [[XBToastManager ShardInstance] showtoast:@"输入的手机号不正确"];
        return;
    }
    __weak typeof (self) wSelf = self;
    
    //------------------------------------------------------------------------------------
    if (myAddressItem)
    {
        //需要上传的参数，时间戳(精确到毫秒)
        NSString* timestamp = [WenzhanTool getCurrentTime];
        NSString* auth_key = [WenzhanTool getaes256DecodeData];
        //MD5加密的token
        NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
        NSString* token = [NSString md5:strOrigin];
        
        //修改地址上传参数
        myAddressItem = [[MineMyAddressItem alloc]init];
        NSLog(@"%@",myAddressItem);
        NSDictionary* dict1 = @{
                                @"uid":uid,
                                @"sheng":lblProvince.text,
                                @"shi":lblCity.text,
                                @"xian":lblRegion.text,
                                @"jiedao":addressField.text,
                                @"youbian":@"0",
                                @"shouhuoren":nameField.text,
                                @"mobile":mobileField.text,
                                @"qq":qq,
                                @"pid":pid,
                                @"time":time
                                };
        
        NSDictionary* sendDict1 = @{@"memberAddressInfo":dict1,@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
        
        [MineMyAreaModel getEditAddress:sendDict1 success:^(AFHTTPRequestOperation* operation,NSObject* result){
            
            [[XBToastManager ShardInstance]hideprogress];
            NSError* error = nil;
            OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
            if ([parser.resultCode isEqualToString:@"200"])
            {
                [[XBToastManager ShardInstance] showtoast:@"地址修改成功"];
                [delegate refreshAddress];
                [wSelf.navigationController popViewControllerAnimated:YES];
            }else
            {
                [[XBToastManager ShardInstance] showtoast:@"地址修改失败"];
            }
        } failure:^(NSError* error){
            
            [[XBToastManager ShardInstance]hideprogress];
        }];
    }else
    {
        //需要上传的参数，时间戳(精确到毫秒)
        NSString* timestamp = [WenzhanTool getCurrentTime];
        NSString* auth_key = [WenzhanTool getaes256DecodeData];
        //MD5加密的token
        NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
        NSString* token = [NSString md5:strOrigin];
        
        //新增地址
        [[XBToastManager ShardInstance]showprogress];
        NSDictionary* dict = @{
                               @"uid":[UserInstance ShardInstnce].uid,
                               @"sheng":lblProvince.text,
                               @"shi":lblCity.text,
                               @"xian":lblRegion.text,
                               @"jiedao":addressField.text,
                               @"youbian":@"0",
                               @"shouhuoren":nameField.text,
                               @"mobile":mobileField.text,
                               @"qq":@"814821572"};
        NSDictionary* sendDict = @{@"memberAddressInfo":dict,@"auth_key":[UserInstance ShardInstnce].auth_key,@"timestamp":timestamp,@"token":token};
        
        [MineMyAreaModel getArea:sendDict success:^(AFHTTPRequestOperation* operation,NSObject* result){
        
            [[XBToastManager ShardInstance]hideprogress];
            NSError* error = nil;
            OneBaseParser* parser = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:&error];
            if ([parser.resultCode isEqualToString:@"200"])
            {
                [[XBToastManager ShardInstance] showtoast:@"地址添加成功"];
                [delegate refreshAddress];
                [wSelf.navigationController popViewControllerAnimated:YES];
            }else
            {
                [[XBToastManager ShardInstance] showtoast:@"地址添加失败"];
            }
        } failure:^(NSError* error){
        
            [[XBToastManager ShardInstance]hideprogress];
        }];
    }
}

#pragma mark UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *str = @"";
    if (component == 0) {
        return [[proviceArray objectAtIndex:row] objectForKey:@"sName"];
    }
    if (component == 1) {
        return [[cityArray objectAtIndex:row]objectForKey:@"sName"];
    }
    if (component == 2) {
        if ([regionArray count]>0) {
            return regionStr = [[regionArray objectAtIndex:row] objectForKey:@"sName"];
        }
        else{
            return @"";
        }
    }
    return str;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0)
    {
        self.cityArray = [service getCityListByProvinceCode:[[proviceArray objectAtIndex:row] objectForKey:@"sCode"]];
        [cityPicker reloadComponent:1];
        self.regionArray = [service getCityListByProvinceCode:[[cityArray objectAtIndex:0] objectForKey:@"sCode"]];
        [cityPicker reloadComponent:2];
        
        proviceStr = [[proviceArray objectAtIndex:row] objectForKey:@"sName"];
        cityStr = [[cityArray objectAtIndex:0] objectForKey:@"sName"];
        
        [cityPicker selectRow:0 inComponent:1 animated:YES];
        if ([cityArray count]>1) {
            [cityPicker selectRow:0 inComponent:2 animated:YES];
        }
        if ([regionArray count]>0) {
            regionStr = [[regionArray objectAtIndex:0] objectForKey:@"sName"];
        }
        else{
            regionStr = @"";
        }
        lblProvince.text = proviceStr;
        lblCity.text = cityStr;
        lblRegion.text = regionStr;
        
    }
    else if (component == 1)
    {
        self.regionArray = [service getCityListByProvinceCode:[[cityArray objectAtIndex:row] objectForKey:@"sCode"]];
        [cityPicker reloadComponent:2];
        cityStr = [[cityArray objectAtIndex:row] objectForKey:@"sName"];
        if ([cityArray count]>1) {
            [cityPicker selectRow:0 inComponent:2 animated:YES];
        }
        if ([regionArray count]>0) {
            regionStr = [[regionArray objectAtIndex:0] objectForKey:@"sName"];
        }
        lblProvince.text = proviceStr;
        lblCity.text = cityStr;
        lblRegion.text = regionStr;
    }
    else
    {
        if ([regionArray count]>0)
        {
            regionStr = [[regionArray objectAtIndex:row] objectForKey:@"sName"];
        }
        lblProvince.text = proviceStr;
        lblCity.text = cityStr;
        lblRegion.text = regionStr;
    }
    
}

#pragma mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return [proviceArray count];
    }
    if (component == 1) {
        return [cityArray count];
    }
    if (component == 2) {
        return [regionArray count];
    }
    return 0;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES; 
}

@end
