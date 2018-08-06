//
//  ShowOrderEditVC.m
//  MasterDuoBao
//
//  Created by zhan wen on 15/7/30.
//  Copyright (c) 2015年 wenzhan. All rights reserved.
//

#import "ShowOrderEditVC.h"
#import "UITableView+Improve.h"
#import "UIImage+ReSize.h"
#import "HeaderContent.h"
#import "ImagePickerChooseView.h"
#import "AGImagePickerController.h"
#import "ShowImageViewController.h"
#import "MineShowOrderModel.h"
#import "SettingCommonCell.h"
#import "AFNetworking.h"
#import "RequestPostUploadHelper.h"
#import "UploadImageControl.h"
#import "NSMutableURLRequest+Upload.h"
#import "UploadModel.h"
#import "ShowOrderModel.h"

#import "Reachability.h"

@interface ShowOrderEditVC ()<UITextViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource,UITableViewDelegate,NSURLSessionDelegate,NSURLConnectionDelegate,NSURLSessionTaskDelegate>
{
    UITableView* tbView;
    MineUnshowOrderItem* myItem;
    UITextField     *headTitleField;
    UILabel         *pLabel;
    __block UIImageView*  testImage;
    
    //上传图片
    NSURLSessionUploadTask*     uploadTask;
    UIImage*        uploadImage;
    NSDictionary*       PicDict;
    
    NSMutableArray      *pathArr;
    
    
}
@property (nonatomic,strong)UITextView *reportStateTextView;
@property (nonatomic,weak)UIButton *addPictureButton;
@property (nonatomic,weak)ImagePickerChooseView *IPCView;
@property (nonatomic,strong)AGImagePickerController *imagePicker;
@property (nonatomic,retain) UITableView *tbView;
@property (nonatomic,strong)NSMutableArray *imagePickerArray;   //imagePicker队列
@property (nonatomic, strong) NSURLSession *session;
@end

NSString *TMP_UPLOAD_IMG_PATH=@"";

@implementation ShowOrderEditVC
@synthesize tbView;
- (instancetype)initWithOrder:(MineUnshowOrderItem *)order
{
    self = [super init];
    if (self) {
        myItem = order;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor hexFloatColor:@"f8f8f8"];
    self.title = @"我的晒单";
    __weak typeof (self) wSelf = self;
    [self actionCustomLeftBtnWithNrlImage:@"btnback" htlImage:@"btnback" title:@"" action:^{
        [wSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    [self actionCustomRightBtnWithNrlImage:@"" htlImage:@"" title:@"发布" action:^{
        //        [wSelf.navigationController popViewControllerAnimated:YES];
        [wSelf sendShowPost];
    }];
    
    self.navigationController.navigationBar.barTintColor = mainColor;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    tbView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    tbView.delegate = self;
    tbView.dataSource = self;
    tbView.backgroundColor = [UIColor whiteColor];
    tbView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tbView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tbView];
    [tbView improveTableView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(keyboardDismiss:)];
    tap.delegate = self;
    [tbView addGestureRecognizer:tap];
    
    PicDict = [[NSDictionary alloc]init];
    
    [self initHeaderView];
}

#define textViewHeight 100
#define pictureHW (screenWidth - 5*padding)/4
#define MaxImageCount 9
#define deleImageWH 25 // 删除按钮的宽高
//大图特别耗内存，不能把大图存在数组里，存类型或者小图
-(void)initHeaderView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectZero];
    if (!headTitleField) {
        headTitleField = [[UITextField alloc]initWithFrame:CGRectMake(padding, padding, mainWidth-2*padding, 30)];
        headTitleField.placeholder = @" 晒单的标题...";
        headTitleField.font = [UIFont systemFontOfSize:14];
        headTitleField.textColor = [UIColor grayColor];
    }
    [headView addSubview:headTitleField];
    
    UIImageView* line = [[UIImageView alloc]initWithFrame:CGRectMake(10, 45, mainWidth, 0.5)];
    line.backgroundColor = [UIColor lightGrayColor];
    [headView addSubview:line];
    
//    UITextView *reportStateTextView = [[UITextView alloc]initWithFrame:CGRectMake(padding, padding+40, screenWidth - 2*padding, textViewHeight)];
//    reportStateTextView.text = self.reportStateTextView.text;  //防止用户已经输入了文字状态
//    reportStateTextView.returnKeyType = UIReturnKeyDone;
//    reportStateTextView.font = [UIFont systemFontOfSize:15];
//    self.reportStateTextView = reportStateTextView;
//    self.reportStateTextView.delegate = self;
//    [headView addSubview:reportStateTextView];
    
    if(!_reportStateTextView){
        _reportStateTextView = [[UITextView alloc]initWithFrame:CGRectMake(padding, padding+40, screenWidth - 2*padding, textViewHeight)];
        //reportStateTextView.text = self.reportStateTextView.text;  //防止用户已经输入了文字状态
        _reportStateTextView.returnKeyType = UIReturnKeyDone;
        _reportStateTextView.font = [UIFont systemFontOfSize:15];
        //self.reportStateTextView = reportStateTextView;
        self.reportStateTextView.delegate = self;
    }
    [headView addSubview:_reportStateTextView];
    
    if (!pLabel) {
        pLabel = [[UILabel alloc]initWithFrame:CGRectMake(padding+5, 2 * padding+32, screenWidth, 30)];
        pLabel.text = @"晒单的内容...";
        pLabel.hidden = [self.reportStateTextView.text length];
        pLabel.font = [UIFont systemFontOfSize:15];
        pLabel.textColor = [UIColor lightGrayColor];
    }
    [headView addSubview:pLabel];
    
    NSInteger imageCount = [self.imagePickerArray count];
    for (NSInteger i = 0; i < imageCount; i++) {
        UIImageView *pictureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(padding + (i%4)*(pictureHW+padding), CGRectGetMaxY(_reportStateTextView.frame) + padding +(i/4)*(pictureHW+padding), pictureHW, pictureHW)];
        //用作放大图片
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [pictureImageView addGestureRecognizer:tap];
        
        //添加删除按钮
        UIButton *dele = [UIButton buttonWithType:UIButtonTypeCustom];
        dele.frame = CGRectMake(pictureHW - deleImageWH + 5, -10, deleImageWH, deleImageWH);
        [dele setImage:[UIImage imageNamed:@"deletePhoto"] forState:UIControlStateNormal];
        [dele addTarget:self action:@selector(deletePic:) forControlEvents:UIControlEventTouchUpInside];
        [pictureImageView addSubview:dele];
        
        pictureImageView.tag = imageTag + i;
        pictureImageView.userInteractionEnabled = YES;
        pictureImageView.image = [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray objectAtIndex:i]).thumbnail];   //一句话，将ALAsset 的URL转换成了UIImage
        [headView addSubview:pictureImageView];
    }
    if (imageCount < MaxImageCount) {
        UIButton *addPictureButton = [[UIButton alloc]initWithFrame:CGRectMake(padding + (imageCount%4)*(pictureHW+padding), CGRectGetMaxY(_reportStateTextView.frame) + padding +(imageCount/4)*(pictureHW+padding), pictureHW, pictureHW)];
        [addPictureButton setBackgroundImage:[UIImage imageNamed:@"addPictures"] forState:UIControlStateNormal];
        [addPictureButton addTarget:self action:@selector(addPicture) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:addPictureButton];
        self.addPictureButton = addPictureButton;
    }
    
    NSInteger headViewHeight = 120 + (10 + pictureHW)*([self.imagePickerArray count]/4 + 1);
    headView.frame = CGRectMake(0, 0, screenWidth, headViewHeight);
    self.tbView.tableHeaderView = headView;
}

#pragma mark - addPicture
//添加图片
-(void)addPicture
{
    if ([self.reportStateTextView isFirstResponder]) {
        [self.reportStateTextView resignFirstResponder];
    }
    self.tbView.scrollEnabled = NO;
    [self initImagePickerChooseView];
}

//放大图片
#pragma mark - gesture method
-(void)tapImageView:(UITapGestureRecognizer *)tap
{
    ShowImageViewController *vc = [[ShowImageViewController alloc]init];
    vc.clickTag = tap.view.tag;
    vc.imageViews = self.imagePickerArray;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - keyboard method
-(void)keyboardDismiss:(UITapGestureRecognizer *)tap
{
    [self.reportStateTextView resignFirstResponder];
}

// 删除图片
-(void)deletePic:(UIButton *)btn
{
    if ([(UIButton *)btn.superview isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView *)(UIButton *)btn.superview;
        [self.imagePickerArray removeObjectAtIndex:(imageView.tag - imageTag)];
        [imageView removeFromSuperview];
    }
    [self initHeaderView];
}

#define IPCViewHeight 120
-(void)initImagePickerChooseView
{
    ImagePickerChooseView *IPCView = [[ImagePickerChooseView alloc]initWithFrame:CGRectMake(0, screenHeight - 64, screenWidth, IPCViewHeight) andAboveView:self.view];
    //IPCView.frame = CGRectMake(0, screenHeight - IPCViewHeight - 64, screenWidth, IPCViewHeight);
    [IPCView setImagePickerBlock:^{
        self.imagePicker = [[AGImagePickerController alloc] initWithFailureBlock:^(NSError *error) {
            
            if (error == nil)
            {
                [self dismissViewControllerAnimated:YES completion:^{}];
                [self.IPCView disappear];
            } else
            {
                NSLog(@"Error: %@", error);
                
                // Wait for the view controller to show first and hide it after that
                double delayInSeconds = 0.5;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self dismissViewControllerAnimated:YES completion:^{}];
                });
            }
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
            
        } andSuccessBlock:^(NSArray *info) {
            
            
            [self.imagePickerArray addObjectsFromArray:info];
            
            
            [self dismissViewControllerAnimated:YES completion:^{}];
            [self.IPCView disappear];               //此处引起崩溃,已解决；
            
            [self uploadImages];
            
            [self initHeaderView];
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
        }];
        
        self.imagePicker.maximumNumberOfPhotosToBeSelected = 9 - [self.imagePickerArray count];
        
        [self presentViewController:self.imagePicker animated:YES completion:^{}];
    }];
    [UIView animateWithDuration:0.25f animations:^{
        IPCView.frame = CGRectMake(0, screenHeight - IPCViewHeight-64, screenWidth, IPCViewHeight);
    } completion:^(BOOL finished) {
    }];
    [self.view addSubview:IPCView];
    self.IPCView = IPCView;
    
    [self.IPCView addImagePickerChooseView];
}

-(NSMutableArray *)imagePickerArray
{
    if (!_imagePickerArray) {
        _imagePickerArray = [[NSMutableArray alloc]init];
    }
    return _imagePickerArray;
}
#pragma mark - UIGesture Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

#pragma mark - Text View Delegate
-(void)textViewDidChange:(UITextView *)textView
{
    pLabel.hidden = [textView.text length];
    //self.reportStateTextView.text = textView.text;
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([@"\n" isEqualToString:text])
    {
        if ([self.reportStateTextView.text length]) {
            [self.reportStateTextView resignFirstResponder];
        }
        else
        {
            return NO;
        }
    }
    return YES;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"aroItemCell";
    UITableViewCell *cell = (UITableViewCell*)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor hexFloatColor:@"666666"];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}


- (int)isWifi
{
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];  // 测试服务器状态
    switch([reachability currentReachabilityStatus]) {
        case NotReachable:
            return 0;
        case ReachableViaWWAN:
            return 1;
        case ReachableViaWiFi:
            return 2;
    }
}


//图片上传
- (void)uploadImages
{
    int isWifi = [self isWifi];
    if (isWifi == 0) {
        [[XBToastManager ShardInstance]showtoast:@"请检查网络"];
        return;
    }
    
    [[XBToastManager ShardInstance]showprogress];
    
    __block int j = 0;
    
    pathArr = [[NSMutableArray alloc]init];
    for (int i = 0; i<self.imagePickerArray.count; i++)
    {
            NSString* strURL = [oyBasePHPUrl stringByAppendingString:@"index.php/member/home_client/singphotoup"];
            NSURL *url = [NSURL URLWithString:strURL];
            UIImage* image = [UIImage imageWithCGImage:((ALAsset *)[self.imagePickerArray objectAtIndex:i]).aspectRatioThumbnail];   //一句话，将ALAsset 的URL转换成了UIImage
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
            [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
            [request setHTTPShouldHandleCookies:NO];
            [request setTimeoutInterval:60];
            [request setHTTPMethod:@"POST"];
            NSString *boundary = @"unique-consistent-string";
            // set Content-Type in HTTP header
            NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
            [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
            // post body
            NSMutableData *body = [NSMutableData data];
            // add params (all params are strings)
            [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"imageCaption"] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"Some Caption"] dataUsingEncoding:NSUTF8StringEncoding]];
            // add image data
            if (imageData) {
                [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"Filedata"] dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
                [body appendData:imageData];
                [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            }
            [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            // setting the body of the post to the reqeust
            [request setHTTPBody:body];
            // set the content-length
            NSString *postLength = [NSString stringWithFormat:@"%ld", (unsigned long)[body length]];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            //        pathArr = [[NSMutableArray alloc]init];
            [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                if(data.length > 0)
                {
                    //success
                    NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
                    NSArray* array = [jsonString componentsSeparatedByString:@"file_path"];
                    NSString* string = [array objectAtIndex:1];
                    NSString* string1 = [string substringFromIndex:3];
                    NSString* str = [string1 stringByReplacingOccurrencesOfString:@"}}" withString:@""];
                    NSString* str1 = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
                    NSString* str2 = [str1 stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    NSDictionary* dict = @{@"file_path":str2};
                    [pathArr addObject:dict];//数组中添加的是字典元素
                }
                j++;
                if (j == self.imagePickerArray.count) {
                    [[XBToastManager ShardInstance]hideprogress];
                }
            }];
        }
//    [[XBToastManager ShardInstance]hideprogress];
}

//发送晒单内容
- (void)sendShowPost
{
    if (headTitleField.text.length == 0) {
        [[XBToastManager ShardInstance]showtoast:@"请输入晒单的标题"];
        return;
    }
    if (self.reportStateTextView.text.length == 0) {
        [[XBToastManager ShardInstance]showtoast:@"请输入晒单的内容"];
        return;
    }
    if (self.imagePickerArray.count == 0) {
        [[XBToastManager ShardInstance]showtoast:@"请添加晒单的图片"];
        return;
    }
    if (pathArr.count == 0) {
        [self.imagePickerArray removeAllObjects];
        [self initHeaderView];
        [[XBToastManager ShardInstance]showtoast:@"图片上传失败"];
        return;
    }
    

    [[XBToastManager ShardInstance]showprogress];
    //需要上传的参数，时间戳(精确到毫秒)
    NSString* timestamp = [WenzhanTool getCurrentTime];
    NSString* auth_key = [WenzhanTool getaes256DecodeData];
    //MD5加密的token
    NSString* strOrigin = [NSString stringWithFormat:@"%@%@%@",[UserInstance ShardInstnce].uid,timestamp,auth_key];
    NSString* token = [NSString md5:strOrigin];
    
    NSDictionary* dict = @{
                           @"uid":[UserInstance ShardInstnce].uid,
                           @"pid":myItem.shop_id,
                           @"ip":[UserInstance ShardInstnce].user_ip,
                           @"title":headTitleField.text,
                           @"content":self.reportStateTextView.text,
                           @"photoList":pathArr,
                           @"auth_key":[UserInstance ShardInstnce].auth_key,
                           @"timestamp":timestamp,
                           @"token":token
                           };
    [ShowOrderModel getUploadPostContent:dict success:^(AFHTTPRequestOperation* operation, NSObject* result){
        
        OneBaseParser* p = [[OneBaseParser alloc]initWithDictionary:(NSDictionary*)result error:NULL];
        if ([p.resultCode isEqualToString:@"200"]) {
            [[XBToastManager ShardInstance]hideprogress];
            [[[UIAlertView alloc] initWithTitle:@"发布成功"
                                        message:nil
                               cancelButtonItem:nil
                               otherButtonItems:[RIButtonItem itemWithLabel:@"确认" action:^{
                [self.navigationController popViewControllerAnimated:YES];
                if (_myBlock) {
                    _myBlock();
                }
            }], nil] show];
        }
        [tbView.pullToRefreshView stopAnimating];
        [tbView.infiniteScrollingView stopAnimating];
        
    } failure:^(NSError* error){
        [[XBToastManager ShardInstance]hideprogress];
        //[[XBToastManager ShardInstance] showtoast:[NSString stringWithFormat:@"获取商品晒单页面数据异常:%@",error]];
    }];
    
}
@end
