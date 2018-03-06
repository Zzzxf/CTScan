//
//  ViewController.m
//  AipOcrDemo
//
//  Created by chenxiaoyu on 17/2/7.
//  Copyright © 2017年 baidu. All rights reserved.
//

#import "TTViewController.h"
#import <objc/runtime.h>
#import <AipOcrSdk/AipOcrSdk.h>
#import "UploadConfirmView.h"
@interface TTViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate,ConfirmViewDelegate>
{
    UploadConfirmView *_uploadConfirmView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray<NSArray<NSString *> *> *actionList;

@end

@implementation TTViewController {
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor orangeColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //    #error 【必须！】请在 ai.baidu.com中新建App, 绑定BundleId后，在此填写授权信息
    //    #error 【必须！】上传至AppStore前，请使用lipo移除AipBase.framework、AipOcrSdk.framework的模拟器架构，参考FAQ：ai.baidu.com/docs#/OCR-iOS-SDK/top
    //     授权方法1：在此处填写App的Api Key/Secret Key
    [[AipOcrService shardService] authWithAK:@"YnGoBXWPQwoFzfHpBDGi24ad" andSK:@"eWKazwAlv6FMG4Avbxp6Uoy9LIyrAcvr"];

    if (!IS_TEST) {
        UIButton *pushBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [pushBtn addTarget:self action:@selector(pushInfo) forControlEvents:UIControlEventTouchUpInside];
        [pushBtn setTitle:@"Push" forState:UIControlStateNormal];
        UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithCustomView:pushBtn];
        self.navigationItem.rightBarButtonItem = rightBarItem;

        UIButton *testDemoBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 30, 30, 30)];
        [testDemoBtn addTarget:self action:@selector(testDemo) forControlEvents:UIControlEventTouchUpInside];
        [testDemoBtn setTitle:@"demoTest" forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:testDemoBtn];
    }


    // 授权方法2（更安全）： 下载授权文件，添加至资源
    //    NSString *licenseFile = [[NSBundle mainBundle] pathForResource:@"aip" ofType:@"license"];
    //    NSData *licenseFileData = [NSData dataWithContentsOfFile:licenseFile];
    //    if(!licenseFileData) {
    //        [[[UIAlertView alloc] initWithTitle:@"授权失败" message:@"授权文件不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    //    }
    //    [[AipOcrService shardService] authWithLicenseFileData:licenseFileData];

    [self configureView];
    [self configureData];
    [self configCallback];
}

-(void)testDemo{

    [self pushInfoWithVin:@"LSvgP4557E20280938"];
    return;
    //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"识别Vin错误" message:@"不是有效的Vin号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    //[alertView show];
    _uploadConfirmView = [UploadConfirmView getUploadCView];
    _uploadConfirmView.frame = CGRectMake(20, 180, SCREEN_WIDTH-40, 200);
    [self.view addSubview:_uploadConfirmView];
    _uploadConfirmView.confirmTextField.text = @"ASDFET89798700000";
    _uploadConfirmView.cvDelegate = self;
    //_uploadConfirmView.backgroundColor = [UIColor redColor];
    
    return;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateTableView];
}

-(void)pushInfo{
//    NSLog(@"pushInfo");
    NSDictionary *dict = [NSDictionary dictionaryWithObject:@"LSVGP4556D2045473" forKey:@"vin"];
//
//    [[JTNetworkManager sharedManager]requestServerAPI:@"ajax/panku" params:dict showHud:NO completionHandler:^(id task, id responseObject, NSError *error) {
//
//    }];
////
//    return;
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    //NSDictionary *dict = [NSDictionary dictionaryWithObject:@"LSVGP4556D2045473" forKey:@"vin"];
    [manager GET:@"http://data.chetuan.com.cn/direct_sale/app_huangniu/ajax/panku" parameters:dict progress:^(NSProgress * _Nonnull downloadProgress) {

    }
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

             //NSLog(@"这里打印请求成功要做的事");
             NSLog(@"%@",responseObject);
         }

         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {

             NSLog(@"%@",error);  //这里打印错误信息

         }];

//    作者：WangK_Dev
//    链接：https://www.jianshu.com/p/11bb0d4dc649
//    來源：简书
//    著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
}

-(void)pushInfoWithVin:(NSString *)vinString{
    NSString *vin = [vinString stringByReplacingOccurrencesOfString:@" " withString:@""];
    vin = [vin stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    vin = [vin stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    NSInteger vinLength = vin.length;

    if (vinLength == 17) {
        //很可能是正确的vin号码
    }else{
        //不正确的vin号码
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"识别Vin错误" message:@"不是有效的Vin号码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        //[self pushInfoWithVin:message];

        [alertView show];

        _uploadConfirmView = [UploadConfirmView getUploadCView];
        _uploadConfirmView.frame = CGRectMake(20, 120, SCREEN_WIDTH-40, 200);
        //_uploadConfirmView = [[UploadConfirmView alloc]initWithFrame:CGRectMake(20, 20, SCREEN_WIDTH-40, 200)];
        [self.view addSubview:_uploadConfirmView];
        _uploadConfirmView.confirmTextField.text = vin;
        _uploadConfirmView.cvDelegate = self;
        return;
    }

    NSDictionary *dict = [NSDictionary dictionaryWithObject:vin forKey:@"vin"];

    [[JTNetworkManager sharedManager]requestServerAPI:@"ajax/panku" params:dict showHud:NO completionHandler:^(id task, id responseObject, NSError *error) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {

            NSNumber* statusNum = responseObject[@"status"];

            if (statusNum.integerValue == 1) {
                //成功！
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"vin码已成功入库" message:@"成功写入" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
                [self removeSelf];

            }
            else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"vin码写入失败" message:@"请填写正确的vin码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                [alertView show];
            }
        }

    }];
}

- (void)configureView {

    self.title = @"VIN识别&查询";
}

- (void)configureData {

    self.actionList = [NSMutableArray array];

    //[self.actionList addObject:@[@"通用文字识别", @"generalBasicOCR"]];
    [self.actionList addObject:@[@"点击进入VIN识别", @"generalAccurateBasicOCR"]];
    //[self.actionList addObject:@[@"通用文字识别(含位置信息版)", @"generalOCR"]];
    //[self.actionList addObject:@[@"通用文字识别(高精度含位置版)", @"generalAccurateOCR"]];
    //[self.actionList addObject:@[@"通用文字识别(含生僻字版)", @"generalEnchancedOCR"]];
    //[self.actionList addObject:@[@"网络图片文字识别", @"webImageOCR"]];
//    [self.actionList addObject:@[@"身份证正面拍照识别", @"idcardOCROnlineFront"]];
//    [self.actionList addObject:@[@"身份证反面拍照识别", @"idcardOCROnlineBack"]];
//    [self.actionList addObject:@[@"身份证正面(嵌入式质量控制+云端识别)", @"localIdcardOCROnlineFront"]];
//    [self.actionList addObject:@[@"身份证反面(嵌入式质量控制+云端识别)", @"localIdcardOCROnlineBack"]];
//    [self.actionList addObject:@[@"银行卡正面拍照识别", @"bankCardOCROnline"]];
//    [self.actionList addObject:@[@"驾驶证识别", @"drivingLicenseOCR"]];
//    [self.actionList addObject:@[@"行驶证识别", @"vehicleLicenseOCR"]];
//    [self.actionList addObject:@[@"车牌识别", @"plateLicenseOCR"]];
//    [self.actionList addObject:@[@"营业执照识别", @"businessLicenseOCR"]];
//    [self.actionList addObject:@[@"票据识别", @"receiptOCR"]];
}

- (void)configCallback {
    __weak typeof(self) weakSelf = self;

    // 这是默认的识别成功的回调
    _successHandler = ^(id result){
        NSLog(@"%@", result);
        NSString *title = @"识别结果";
        NSMutableString *message = [NSMutableString string];

        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@: %@\n", key, obj];
                    }

                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@\n", obj];
                    }

                }
            }

        }else{
            [message appendFormat:@"%@", result];
        }

        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [weakSelf pushInfoWithVin:message];
            [alertView show];
        }];
    };

    _failHandler = ^(NSError *error){
        NSLog(@"%@", error);
        NSString *msg = [NSString stringWithFormat:@"%li:%@", (long)[error code], [error localizedDescription]];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [[[UIAlertView alloc] initWithTitle:@"识别失败" message:msg delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
        }];
    };
}

- (void)updateTableView {

    [self.tableView reloadData];
}

#pragma mark - Action
- (void)generalOCR{

    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        // 在这个block里，image即为切好的图片，可自行选择如何处理
        NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
        [[AipOcrService shardService] detectTextFromImage:image
                                              withOptions:options
                                           successHandler:_successHandler
                                              failHandler:_failHandler];

    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)generalEnchancedOCR{

    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
        [[AipOcrService shardService] detectTextEnhancedFromImage:image
                                                      withOptions:options
                                                   successHandler:_successHandler
                                                      failHandler:_failHandler];

    }];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)generalBasicOCR{

    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
        [[AipOcrService shardService] detectTextBasicFromImage:image
                                                   withOptions:options
                                                successHandler:_successHandler
                                                   failHandler:_failHandler];

    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)generalAccurateOCR{

    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
        [[AipOcrService shardService] detectTextAccurateFromImage:image
                                                      withOptions:options
                                                   successHandler:_successHandler
                                                      failHandler:_failHandler];

    }];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)generalAccurateBasicOCR{

    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
        [[AipOcrService shardService] detectTextAccurateBasicFromImage:image
                                                           withOptions:options
                                                        successHandler:_successHandler
                                                           failHandler:_failHandler];

    }];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)webImageOCR{

    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {

        [[AipOcrService shardService] detectWebImageFromImage:image
                                                  withOptions:nil
                                               successHandler:_successHandler
                                                  failHandler:_failHandler];
    }];
    [self presentViewController:vc animated:YES completion:nil];
}


- (void)idcardOCROnlineFront {

    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardFont
                                 andImageHandler:^(UIImage *image) {

                                     [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                                                  withOptions:nil
                                                                               successHandler:_successHandler
                                                                                  failHandler:_failHandler];
                                 }];

    [self presentViewController:vc animated:YES completion:nil];

}

- (void)localIdcardOCROnlineFront {

    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardFont
                                 andImageHandler:^(UIImage *image) {

                                     [[AipOcrService shardService] detectIdCardFrontFromImage:image
                                                                                  withOptions:nil
                                                                               successHandler:^(id result){
                                                                                   _successHandler(result);
                                                                                   // 这里可以存入相册
                                                                                   //UIImageWriteToSavedPhotosAlbum(image, nil, nil, (__bridge void *)self);
                                                                               }
                                                                                  failHandler:_failHandler];
                                 }];
    [self presentViewController:vc animated:YES completion:nil];


}



- (void)idcardOCROnlineBack{

    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeIdCardBack
                                 andImageHandler:^(UIImage *image) {

                                     [[AipOcrService shardService] detectIdCardBackFromImage:image
                                                                                 withOptions:nil
                                                                              successHandler:_successHandler
                                                                                 failHandler:_failHandler];
                                 }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)localIdcardOCROnlineBack{

    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeLocalIdCardBack
                                 andImageHandler:^(UIImage *image) {

                                     [[AipOcrService shardService] detectIdCardBackFromImage:image
                                                                                 withOptions:nil
                                                                              successHandler:^(id result){
                                                                                  _successHandler(result);
                                                                                  // 这里可以存入相册
                                                                                  // UIImageWriteToSavedPhotosAlbum(image, nil, nil, (__bridge void *)self);
                                                                              }
                                                                                 failHandler:_failHandler];
                                 }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)bankCardOCROnline{

    UIViewController * vc =
    [AipCaptureCardVC ViewControllerWithCardType:CardTypeBankCard
                                 andImageHandler:^(UIImage *image) {

                                     [[AipOcrService shardService] detectBankCardFromImage:image
                                                                            successHandler:_successHandler
                                                                               failHandler:_failHandler];

                                 }];
    [self presentViewController:vc animated:YES completion:nil];

}


- (void)drivingLicenseOCR{

    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {

        [[AipOcrService shardService] detectDrivingLicenseFromImage:image
                                                        withOptions:nil
                                                     successHandler:_successHandler
                                                        failHandler:_failHandler];

    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)vehicleLicenseOCR{

    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {

        [[AipOcrService shardService] detectVehicleLicenseFromImage:image
                                                        withOptions:nil
                                                     successHandler:_successHandler
                                                        failHandler:_failHandler];
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)plateLicenseOCR{

    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {

        [[AipOcrService shardService] detectPlateNumberFromImage:image
                                                     withOptions:nil
                                                  successHandler:_successHandler
                                                     failHandler:_failHandler];

    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)receiptOCR{

    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {

        [[AipOcrService shardService] detectReceiptFromImage:image
                                                 withOptions:nil
                                              successHandler:_successHandler
                                                 failHandler:_failHandler];

    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)businessLicenseOCR{

    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {

        [[AipOcrService shardService] detectBusinessLicenseFromImage:image
                                                         withOptions:nil
                                                      successHandler:_successHandler
                                                         failHandler:_failHandler];

    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)mockBundlerIdForTest {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    [self mockClass:[NSBundle class] originalFunction:@selector(bundleIdentifier) swizzledFunction:@selector(sapicamera_bundleIdentifier)];
#pragma clang diagnostic pop
}

- (void)mockClass:(Class)class originalFunction:(SEL)originalSelector swizzledFunction:(SEL)swizzledSelector {

    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }

}

#pragma mark - UITableViewDelegate & UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.actionList.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = nil;

    NSArray *actions = self.actionList[indexPath.row];
    cell = [tableView dequeueReusableCellWithIdentifier:@"DemoActionCell" forIndexPath:indexPath];
    cell.textLabel.text = actions[0];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 55;
    } else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SEL funSel = NSSelectorFromString(self.actionList[indexPath.row][1]);
    if (funSel) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:funSel];
#pragma clang diagnostic pop
    }
}

-(BOOL)shouldAutorotate{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma cvDelegate
-(void)removeSelf{
    for (UploadConfirmView *uView  in self.view.subviews) {
        if ([uView isKindOfClass:[UploadConfirmView class]]) {
            [uView removeFromSuperview];
                uView.cvDelegate = nil;
        }
    }

   // [_uploadConfirmView removeFromSuperview];
//    _uploadConfirmView.cvDelegate = nil;
//    _uploadConfirmView = nil;
}

-(void)pushInfoWithConfirmedStr:(NSString *)confirmedVin{
    [self pushInfoWithVin:confirmedVin];
}

@end


