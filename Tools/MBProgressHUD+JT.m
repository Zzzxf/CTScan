//
//  MBProgressHUD+JT.m
//  jtCar
//
//  Created by chetuan003 on 4/15/16.
//  Copyright © 2016 严佳文. All rights reserved.
//

#import "MBProgressHUD+JT.h"

@implementation MBProgressHUD (JT)

+ (MBProgressHUD *)hudWithMessage:(NSString *)msg inView:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = msg;
    hud.labelFont = [UIFont systemFontOfSize:15];
    hud.removeFromSuperViewOnHide = YES;
    hud.dimBackground = YES;
    return hud;
}

+ (void)hudWithTip:(NSString *)tip inView:(UIView *)view {
    NSString *trimmedTip = [tip stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (!trimmedTip.length) {
        return;
    }
    
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = tip;
    hud.detailsLabelFont = [UIFont systemFontOfSize:15];
    
    hud.mode = MBProgressHUDModeText;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

@end
