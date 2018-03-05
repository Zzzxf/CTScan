//
//  AppMacros.h
//  jtCar
//
//  Created by 严佳文 on 16/3/9.
//  Copyright © 2016年 严佳文. All rights reserved.
//

#ifndef AppMacros_h

#define AppMacros_h

//=================================================
// 设备尺寸
//=================================================
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenBounds [UIScreen mainScreen].bounds
#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavigationBarHeight self.navigationController.navigationBar.frame.size.height
#define kBackgroundColor [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1]
#define RGB(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1.0]
#define RGBA(a,b,c,d) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:d/1.0]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UIColorFromRGBA(rgbValue,num) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:num]

//=================================================
// UI相关
//=================================================
#define KColorTheme [UIColor colorWithRed:1.0 green:90/255.0 blue:55/255.0 alpha:1.0]

#define UITextColor [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]
#define UITextBlack [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0]
#define UITextGray [UIColor colorWithRed:153.0/255.0 green:153.0/255.0 blue:153.0/255.0 alpha:1.0]
#define UILineColor [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]
#define UIBackgroundColor [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1.0]

#define  kLeaseViewHeight kScreenWidth/2+40
#define kEnabledBtnBackgroundImg [UIImage imageNamed:@"红色按钮"]
#define kDisabledBtnBackgroundImg [UIImage imageNamed:@"按钮灰度"]

#define JTAppendString(str1,str2)     [NSString stringWithFormat:@"%@%@",str1,str2]
#define JTIntString(str) [NSString stringWithFormat:@"%d",(int)str]
#define JTString(str)    [NSString stringWithFormat:@"%@",str]
#define SCImageName(name) [UIImage imageNamed:name]

//=================================================
// 其他
//=================================================
#define TOKEN @"M-TOKEN"
#define USERSTATE  @"userState"
#define USERNAME   @"userName"
#define onceLogin  @"onceLogin"
#define myState    @"myState"    //我的额度状态
#define actionDesc @"actionDesc" //活动是否开放
#define businessState @"businessState" //用户是否买车

#define GPS   @"M-GPS"
#define kServiceNum   @"4008318318"
#define USERDEFAULT [NSUserDefaults standardUserDefaults]
//#define kUserState  [[USERDEFAULT valueForKey:USERSTATE] stringValue]
#define kUserName  [USERDEFAULT valueForKey:USERNAME]
#define JTWeakSelf(type)  __weak typeof(type) weak##type = type;

#define UMENG_KEY @"57319ce867e58ea65e001f00"
#define JTCAR_URL @"http://www.jtcar.com.cn"
#if IS_HAPPY_OR_SUNNY  //1 阳光车市
#define WeChatRedirectUrl @"http://www.suncars.com.cn"
#else
#define WeChatRedirectUrl @"http://www.jtcar.com.cn"

#endif

#define APPDOWNLOAD_URL @"http://115.159.66.252:8980/jtcar/app/m/download/ios"
//=================================================
// 分享
//=================================================

#define kShareUrl @"shareUrl"
#define kFilePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"shareUrl.archiver"]
//=================================================
// api
//=================================================
#define kGetAllUrls @"index/getAllUrls"
#define kGetIndexParam @"index/getIndexParam"
#define kGetCarDetail @"car/getCarDetail"
#define kInitChooseCar @"func/initChooseCar"
#define kSpCarToBeAMember @"car/jiameng"
#define kLRentService @"car/longcar"
#define kInitChangePlan @"func/getAllFuncs"
#define kQueryCarByFunc @"func/queryCarByFuncJson"
#define kQueryCarByBudget @"func/queryCarByBudgetJson"
#define kQueryCarByCarId @"func/queryFuncByCondition"
#define kGetApplyBuyCar @"apply/yzdg"
#define kGetAllRentCars @"car/getAllDgCars"
#define kGetAllLongRentCarsAndCities @"car/getAllLongRentCarsAndCities"
#define kGetApplyLongcar @"apply/longrent"
#define kGetApplyECooperate @"apply/qyhz"
#define kGetAllCities @"car/getAllCities"
#define kGetApplySPcar @"apply/zcjm"

//登录
#define kSendCode @"login/sendMsg"
#define kDoLogin @"login/doLogin"
//个人中心
#define kGetMyOrders @"user/getMyOrders"
#define kGetMyApplys @"user/getMyApplys"
#define kGetApplyFeedback @"toAddQues"
//根据车型首付 方案 查id
#define kFindRentByCarId @"car/findRentByCarId"

#endif /* AppMacros_h */
