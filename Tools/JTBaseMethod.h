//
//  JTBaseMethod.h
//  jtCar
//
//  Created by zhiRong on 2017/12/12.
//  Copyright © 2017年 严佳文. All rights reserved.
//

#import <Foundation/Foundation.h>

//快速注册多种cellnib
UIKIT_STATIC_INLINE void SCRegisterNibsQuick(UITableView *tableView, NSArray *names){
    for (NSString *name in names) {
        UINib *nib=[UINib nibWithNibName:name bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:name];
    }
}

@interface JTBaseMethod : NSObject

//获取图片完整路径
+(NSString*)getFullImageUrl:(NSString*)url;
+(NSString*)getFullImageUrlNew:(NSString*)url;
//获取父viewcontroller
+ (UIViewController *)topVC:(UIViewController *)rootViewController;
//打电话
+(void)phonecall:(NSString*)tel;
//获取label高度
+ (int)getLabHeight:(NSString *)text FontSize:(int)size Width:(int)width;
//计算富文本(NSMutableAttributedString)高度
+ (NSInteger)hideLabelLayoutHeight:(NSMutableAttributedString *)attributes width:(NSInteger)width;
//行间距
+(NSMutableAttributedString*)lineParagraph:(int)distance content:(NSString*)content fontSize:(int)fontSize;
//延迟调用
+ (void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
//隐藏键盘
+(void)hideKeyboard;
//去掉小数点后面的0
+(NSString*)removeFloatAllZero:(NSString*)string;
//时间戳转换时间的方法
+(NSString*)timeFormatter:(NSString*)timeFormatter;
//获取现在日期
+(NSString*)getNowDate;
@end
