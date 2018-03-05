//
//  JTNetworkManager.m
//  jtCar
//
//  Created by chetuan003 on 4/15/16.
//  Copyright © 2016 严佳文. All rights reserved.
//

#import "JTNetworkManager.h"
#import "AFNetworking.h"
#import "NSString+MD5.h"
#include <sys/utsname.h>
#import "NSData+Encryption.h"

#if IS_TEST
NSString * const kServerCodeSuccess = @"0000";
NSString * const kServerCodeFailure = @"1111";
NSString * const kServerRequestFailed = @"网络请求失败，请稍后重试。";

NSString * const kServerResponseSuccess = @"0000";
NSString * const kServerResponseFailure = @"1111";
NSString * const kErrorURL = @"http://115.159.90.216/err";
//NSString * const kBaseURL = @"http://192.168.1.80:8081/suncars/app/";
NSString * const kBaseURL = @"http://192.168.1.174:8080/suncars/app/";
#else
NSString * const kServerCodeSuccess = @"0000";
NSString * const kServerCodeFailure = @"1111";
NSString * const kServerRequestFailed = @"网络请求失败，请稍后重试。";

NSString * const kServerResponseSuccess = @"0000";
NSString * const kServerResponseFailure = @"1111";
NSString * const kErrorURL = @"https://115.159.90.216/err";

    #if IS_HAPPY_OR_SUNNY
        NSString * const kBaseURL = @"https://www.suncars.com.cn/suncars/app/";
    #else
        NSString * const kBaseURL = @"https://www.kaixinche.com/suncars/app/";
    #endif

#endif

//NSString * const kServerCodeSuccess = @"0000";
//NSString * const kServerCodeFailure = @"1111";
//NSString * const kServerRequestFailed = @"网络请求失败，请稍后重试。";
//
//NSString * const kServerResponseSuccess = @"0000";
//NSString * const kServerResponseFailure = @"1111";
//NSString * const kErrorURL = @"http://115.159.90.216/err";
//NSString * const kBaseURL = @"http://192.168.1.80:8081/suncars/app/";

@interface JTNetworkManager ()

@property (copy, nonatomic) NSString *encodedString;

@end

@implementation JTNetworkManager

- (void)dealloc {
    
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

+ (JTNetworkManager *)sharedManager {
    static JTNetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (NSString *)getFullAPIWithValue:(NSString *)value {
    return [kBaseURL stringByAppendingString:value];
}

#pragma mark - Request Methods

- (void)requestServerAPI:(NSString *)api
                  params:(NSDictionary *)params
                 showHud:(BOOL)showHud
       completionHandler:(void (^)(id task, id responseObject, NSError *error))completionHandler {
    
    NSDictionary *encodedParams = nil;
    NSDictionary *requestHeaders = nil;
//    
//   NSString *apiStr = [NSString stringWithFormat:@"%@%@", @"http://115.159.66.252:8980/jtcar/app/", api];
//   NSString *apiStr = [NSString stringWithFormat:@"%@%@", @"http://192.168.1.53:8080/jtcar/app/", api];
 //   NSString *apiStr = [NSString stringWithFormat:@"%@%@", @"http://www.jtcar.com.cn/jtcar/app/", api];
    NSString *apiStr = [NSString stringWithFormat:@"%@%@", kBaseURL, api];
    
 //   NSString *apiStr = [NSString stringWithFormat:@"%@%@", @"https://115.159.56.197:8081/suncars/app/", api];
    
//

    // 过滤api
    NSString *trimmedApi = [apiStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (trimmedApi.length) {
        if (params) {
            NSData *serializedParams = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
            self.encodedString = [serializedParams base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
            encodedParams = [NSDictionary dictionaryWithObjectsAndKeys:self.encodedString, @"data", nil];
        //    encodedParams = params;
        } else {
            
        }
        // 获取头部信息
        requestHeaders = [self getRequestHeaders];
        [self requestServerAPI:apiStr
                 encodedParams:encodedParams
                       headers:requestHeaders
                       showHud:showHud
                       timeout:10
                      filePath:nil
             completionHandler:completionHandler];
    } else {
        NSLog(@"%s\n>>>网络请求出错!!!", __FUNCTION__);
    }
}




- (void)requestServerAPI:(NSString *)api
           encodedParams:(NSDictionary *)encodedParams
                 headers:(NSDictionary *)headers
                 showHud:(BOOL)showHud
                 timeout:(NSTimeInterval)timeout
                filePath:(NSString *)filePath
       completionHandler:(void(^)(NSURLSessionTask *task, id responseObject, NSError *error))completionHandler {
    NSLog(@"%s\n>>>请求的API地址:%@", __FUNCTION__, api);
    NSLog(@"%s\n>>>请求头部信息:%@", __FUNCTION__, headers);
    if (encodedParams) {
        NSLog(@"%s\n>>>编码后的参数:%@", __FUNCTION__, encodedParams);
    } else {
        NSLog(@"%s\n>>>无请求参数。", __FUNCTION__);
    }
    
    //MBProgressHUD *hud = nil;
    UIViewController *parent = [JTBaseMethod topVC:nil];
    
    if (showHud) {
       // hud = [MBProgressHUD hudWithMessage:@"加载中..." inView:nil];
        [MBProgressHUD showHUDAddedTo:parent.view animated:YES];
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    if (IS_TEST) {
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //是否在证书域字段中验证域名
        [securityPolicy setValidatesDomainName:NO];
        manager.securityPolicy = securityPolicy;
    }else{

        NSString *cerpath = [[NSBundle mainBundle] pathForResource:IS_HAPPY_OR_SUNNY==1 ? @"suncars.com.cn_bundle":@"kaixinche.com_bundle" ofType:@"cer"];
        NSData *cerdata = [NSData dataWithContentsOfFile:cerpath];
        // 修改验证模式
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        [securityPolicy setValidatesDomainName:NO];
        //是否信任非法证书
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.pinnedCertificates = [[NSSet alloc] initWithObjects:cerdata, nil];
        manager.securityPolicy = securityPolicy;
    }
    
    
    // 设置请求头部信息
    if (headers) {
        [headers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    // 设置超时
    manager.requestSerializer.timeoutInterval = timeout;
    
    [manager POST:api parameters:encodedParams constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%s\n返回信息:%@", __FUNCTION__, responseObject);
        
        if (showHud) {
            //[hud hide:YES];
            [MBProgressHUD hideHUDForView:parent.view animated:YES];
        }
        
        responseObject = [self DecryptionData:responseObject];
        
        // 获取返回的头部信息
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)[task response];
        NSDictionary *responseHeaders = [response allHeaderFields];
        // 保存返回的token
        NSString *token = [responseHeaders objectForKey:@"M-TOKEN"];
        if (token.length) {
            [[NSUserDefaults standardUserDefaults] setValue:token forKey:TOKEN];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        NSString *code = responseObject[@"code"];
        if (code.intValue == 2222) {//重新登录
            [USERDEFAULT setValue:@""  forKey:TOKEN];
            [USERDEFAULT setValue:@"0"  forKey:USERSTATE];
            [USERDEFAULT setValue:@""  forKey:USERNAME];
            [USERDEFAULT setObject:nil forKey:myState];
            [USERDEFAULT synchronize];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"outLogin" object:nil];
        }
        
        // TODO: DES3解密返回的数据

        completionHandler(task, responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showHud) {
            //[hud hide:YES];
            [MBProgressHUD hideHUDForView:parent.view animated:YES];
        }
        if (error) {
            NSLog(@"%s\n>>>请求的API地址:%@\n>>>错误信息:%@", __FUNCTION__, api, [error localizedDescription]);
        }
        completionHandler(task, nil, error);
    }];
}

- (NSDictionary *)getRequestHeaders {
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithCapacity:0];
    
    // M-UUID 设备唯一识别码
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    [headers setObject:uuid forKey:@"M-UUID"];
    
    // M-RESOLUTION 设备分辨率
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    screenSize = CGSizeMake(screenSize.width * [UIScreen mainScreen].scale, screenSize.height * [UIScreen mainScreen].scale);
    NSString *resolution = [NSString stringWithFormat:@"%.lfx%.lf", screenSize.width, screenSize.height];
    [headers setObject:resolution forKey:@"M-RESOLUTION"];
    
    // M-TOKEN 用户唯一识别码
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:TOKEN];
    if (!token.length) { // 未登录为 0
        token = @"";
    }
    [headers setObject:token forKey:@"M-TOKEN"];
    
    // M-UA 设备UA
    NSString *ua = [self getUA];
    [headers setObject:ua forKey:@"M-UA"];
    
    // M-SYSTEM 设备系统及版本
    NSString *sysVer = [UIDevice currentDevice].systemVersion;
    [headers setObject:sysVer forKey:@"M-SYSTEM"];
    
    // M-CLIENT-TYPE 客户端类型
    NSString *clientType = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ? @"iPhone" : @"iPad";
    [headers setObject:clientType forKey:@"M-CLIENT-TYPE"];
    
    // M-VERSION-CODE 客户端版本号
    NSString *versionCode = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    [headers setObject:versionCode forKey:@"M-VERSION-CODE"];
    
    // M-VERSION-NAME 客户端版本名
    NSString *versionName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
    [headers setObject:versionName forKey:@"M-VERSION-NAME"];
    
    // M-TIME 时间戳(毫秒)
    NSString *time = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] * 1000];
    
    [headers setObject:time forKey:@"M-TIME"];
    
    // M-SIGN (时间戳 + key + data) MD5 加密
    NSString *key = @"69EFE76723DDC106183CAF4AD41B5CB1";
    NSString *beforeEncrypted;
    if (self.encodedString) {
        beforeEncrypted = [NSString stringWithFormat:@"%@%@%@", time, key, self.encodedString];
        self.encodedString = nil;
    } else {
        beforeEncrypted = [NSString stringWithFormat:@"%@%@", time, key];
    }
    NSString *afterEncrypted = [beforeEncrypted MD5];
    [headers setObject:afterEncrypted forKey:@"M-SIGN"];
    
    // M-GPS GPS定位
    NSString *gps = [[NSUserDefaults standardUserDefaults] objectForKey:GPS];
    if (!gps) {
        gps = @"";
    }
    [headers setObject:gps forKey:@"M-GPS"];
    
    return [headers copy];
}

- (NSString *)getUA {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 CDMA";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (Cellular)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (Cellular)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (Cellular)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (Cellular)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (Cellular)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (Cellular)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (Cellular)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (Cellular)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air (Cellular)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    return @"Unknown";
}


- (NSMutableDictionary *)DecryptionData:(NSMutableDictionary *)responseObject
{
    //如果本身就是字典类型的则不作处理 如果是加密字符串则解密
    if ([[responseObject objectForKey:@"data"] isKindOfClass:[NSString class]]) {
        NSString *string = [responseObject objectForKey:@"data"];
        if (string) {
            NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
            Byte keyByte[] = {
                0x2a, 0x6, 0x49, 0x23, 0xf1, 0x74, 0x14 ,0x99, 0xb4 ,0xe4 ,0xcc, 0xc7 ,0xe0 ,0xf8, 0xec, 0x6e
            };
            NSData *keyData = [[NSData alloc] initWithBytes:keyByte length:16];
            NSData *DecryptData = [data AES256DecryptWithKey:keyData];
            //            NSLog(@"解密信息是什么  %@------%@", DecryptData,[[NSString alloc]initWithData:DecryptData encoding:NSUTF8StringEncoding])   ;
            if (DecryptData) {
                NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:DecryptData options:NSJSONReadingAllowFragments error:nil];
                NSMutableDictionary *DecryptResponse = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
                if (dic) {
                    DecryptResponse[@"data"] = dic;
                    responseObject = DecryptResponse;
                }else{
                    if ([[NSString alloc]initWithData:DecryptData encoding:NSUTF8StringEncoding]) {
                        DecryptResponse[@"data"] = [[NSString alloc]initWithData:DecryptData encoding:NSUTF8StringEncoding];
                        responseObject = DecryptResponse;
                    }else{
                        NSMutableDictionary *DecryptResponse = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
                        DecryptResponse[@"data"] = @{};
                        responseObject = DecryptResponse;
                    }
                }
            }
        }else{
            NSMutableDictionary *DecryptResponse = [[NSMutableDictionary alloc] initWithDictionary:responseObject];
            DecryptResponse[@"data"] = @{};
            responseObject = DecryptResponse;
        }
    }
    return responseObject;
}


@end
