//
//  UploadConfirmView.h
//  CheTuanS
//
//  Created by  Zzzxf on 05/03/2018.
//  Copyright © 2018 goodDay. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConfirmViewDelegate
-(void)removeSelf;
-(void)pushInfoWithConfirmedStr:(NSString *)confirmedVin;
@end

@interface UploadConfirmView : UIView

+(instancetype)getUploadCView;

@property(weak,nonatomic)id <ConfirmViewDelegate> cvDelegate;
@property (weak, nonatomic) IBOutlet UITextField *confirmTextField;
- (IBAction)confirmBtnClicked:(id)sender;
- (IBAction)cancelBtnClicked:(id)sender;

@end
