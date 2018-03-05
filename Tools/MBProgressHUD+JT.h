//
//  MBProgressHUD+JT.h
//  jtCar
//
//  Created by chetuan003 on 4/15/16.
//  Copyright © 2016 严佳文. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (JT)

+ (MBProgressHUD *)hudWithMessage:(NSString *)msg inView:(UIView *)view;

+ (void)hudWithTip:(NSString *)tip inView:(UIView *)view;

@end
