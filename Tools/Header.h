//
//  Header.h
//  黄牛之家
//
//  Created by 严佳文 on 2017/8/2.
//  Copyright © 2017年 严佳文. All rights reserved.
//

#ifndef Header_h
#define Header_h

#ifdef DEBUG
#define CTPLog(...) NSLog(__VA_ARGS__)
#else
#define CTPLog(...)
#endif

#define CTPLogFunc CTPLog(@"%s",__func__)
#define CTPLogA(A) NSLog(@"返回数据：---->%@",A)
#define CTPLogP NSLog(@"执行了。。。")

#define MBPROGRESSHUD_SHOW_SERVER_REQUEST_FAILED [MBProgressHUD hudWithMessage:msg image:nil inView:self.view afterDelay:DEFAULT_DELAY]
#define MBPROGRESSHUD_SHOW_SERVER_REQUEST_ERROR [MBProgressHUD hudWithMessage:kServerRequestFailed image:nil inView:self.view afterDelay:DEFAULT_DELAY]

#define WeakSelf(weakSelf)      __weak __typeof(&*self)    weakSelf  = self;
#define StrongSelf(strongSelf)  __strong __typeof(&*self) strongSelf = weakSelf;

//版本号
#define APP_VERSION             [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]
#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//请求头相关信息
#define IS_USER_LOGGED_IN   @"IS_USER_LOGGED_IN"
#define IS_FIRST_LOGIN      @"IS_FIRST_LOGIN"
#define X_TOKEN             @"M-TOKEN"//改了一改X_TOKEN为黄牛
#define X_USERID            @"X-USERID"
#define OUT_TRADE_NO        @"OUT_TRADE_NO"
#define SECURED_TRAN_ID     @"SECURED_TRAN_ID"
#define USERDEFAULT [NSUserDefaults standardUserDefaults]
#define SKIP_BUTTON_CLICKED @"SKIP_BUTTON_CLICKED"
#define PayOutTradeNum @"PayOutTradeNum"
#define ISCHECK             @"ISCHECK"
#define COMCHECK            @"COMCHECK"
#define VIPCHECK            @"VIPCHECK"
#define NOTIFICATION_PAY_SUCCESS @"NOTIFICATION_PAY_SUCCESS"
#define NOTIFICATION_PAY_FAILURE  @"NOTIFICATION_PAY_FAILURE"
#define NOTIFICATION_PAY_CANCEL  @"NOTIFICATION_PAY_CANCEL"

#define NOTIFICATION_REFUND_SUCCESS @"NOTIFICATION_REFUND_SUCCESS"
#define CTPRGBColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0] 
#define CTPRGBColorR(r,g,b,R) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:R]

//0为真实环境  1为测试环境
#define IS_TEST     0

//开心车还是阳光车市   0为开心车 1为阳光车市
#define IS_HAPPY_OR_SUNNY   1

//全局色
#define CTPGlobalColor  CTPRGBColor(243,243,243)
#define CTPSelectedTextColor  CTPRGBColor(252,97,44)
#define CTPOrangeColor  CTPRGBColor(255,68,51)
#define CTPLineGrayColor  CTPRGBColor(177, 178, 177)
#define CTPDarkTitleColor  CTPRGBColor(21, 21, 21)

#define CTPBtnDisabledTitleColor [UIColor colorWithWhite:1. alpha:0.5]

/** 屏幕尺寸 */
#define SCREEN_BOUNDS           [UIScreen mainScreen].bounds
#define SCREEN_WIDTH            SCREEN_BOUNDS.size.width
#define SCREEN_HEIGHT           SCREEN_BOUNDS.size.height
#define NAVIGATIONBAR_WIDTH  self.navigationController.navigationBar.frame.size.width
#define NAVIGATIONBAR_HEIGHT  self.navigationController.navigationBar.frame.size.height

//=======================================
// U Share
//=======================================

//#define UMENG_KEY           @"58a4293d310c931a0b00110e"
//#define UMENG_SHARE_URL     @"http://www.315che.com"
//#define UMENG_REDIRECT_URL  @"http://mobile.umeng.com/social"
//#define WECHAT_AppID        @"wx48a638ec885849d9"
//#define WECHAT_AppSecret    @"3af2825c187b437939e6ae34774e417a"
//#define WeiBo_AppKey        @"2740586532"
//#define WeiBo_AppSecret     @"0d45f01cd88fb6c6ae2fbdfa069810d7"
//#define QQ_AppID            @"1105926546"   // 对应HEX 41eb1992
//#define QQ_AppKey           @"ruTTRyxUfO4qUmWu"

#endif /* Header_h */
