//
//  JTBaseMethod.m
//  jtCar
//
//  Created by zhiRong on 2017/12/12.
//  Copyright © 2017年 严佳文. All rights reserved.
//

#import "JTBaseMethod.h"

@implementation JTBaseMethod

//获取图片完整路径
+(NSString*)getFullImageUrl:(NSString*)url{
    //http://www.jtcar.com.cn/admin/jt_img
    NSString *fullUrl = [NSString stringWithFormat:@"https://www.suncars.com.cn/admin/jt_img/%@",url?:@""];
    return  fullUrl;
}

+(NSString*)getFullImageUrlNew:(NSString*)url{
    //http://www.jtcar.com.cn/admin/jt_img
    NSString *fullUrl = [NSString stringWithFormat:@"https://www.suncars.com.cn/%@",url?:@""];
    return  fullUrl;
}

//获取父viewcontroller
+ (UIViewController *)topVC:(UIViewController *)rootViewController{
    
    if (!rootViewController) {
        rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)rootViewController;
        return [self topVC:tab.selectedViewController];
    }else if ([rootViewController isKindOfClass:[UINavigationController class]]){
        UINavigationController *navc = (UINavigationController *)rootViewController;
        return [self topVC:navc.visibleViewController];
    }else if (rootViewController.presentedViewController){
        UIViewController *pre = (UIViewController *)rootViewController.presentedViewController;
        return [self topVC:pre];
    }else{
        return rootViewController;
    }
}

//打电话
+(void)phonecall:(NSString*)tel
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@",tel]];
    [[UIApplication sharedApplication] openURL:url];
}

//获取label高度
+ (int)getLabHeight:(NSString *)text FontSize:(int)size Width:(int)width{
    
    CGRect strRect = [text boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:size]} context:nil];
    
    return strRect.size.height+2;
}

//计算富文本(NSMutableAttributedString)高度
+ (NSInteger)hideLabelLayoutHeight:(NSMutableAttributedString *)attributes width:(NSInteger)width
{
    CGSize attSize = [attributes boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine context:nil].size;
    return attSize.height;
}

//行间距
+(NSMutableAttributedString*)lineParagraph:(int)distance content:(NSString*)content fontSize:(int)fontSize{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:distance];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:NSMakeRange(0, content.length)];
    return attributedString;
}

//延迟调用
+ (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay
{
    int64_t delta = (int64_t)(1.0e9 * delay);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), block);
}

//隐藏键盘
+(void)hideKeyboard{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

//去掉小数点后面的0
+(NSString*)removeFloatAllZero:(NSString*)string
{
    NSString * testNumber = string;
    NSString * outNumber = [NSString stringWithFormat:@"%@",@(testNumber.floatValue)];
    return outNumber;
}

//时间戳转换时间的方法
+(NSString*)timeFormatter:(NSString*)timeFormatter{
    long long time = [timeFormatter longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timeStr = [formatter stringFromDate:d];
    return timeStr;
}

//获取现在日期
+(NSString*)getNowDate{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *date= [dateFormatter stringFromDate:[NSDate date]];
    return date;
}

@end
