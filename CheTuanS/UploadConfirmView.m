//
//  UploadConfirmView.m
//  CheTuanS
//
//  Created by  Zzzxf on 05/03/2018.
//  Copyright © 2018 goodDay. All rights reserved.
//

#import "UploadConfirmView.h"

@interface UploadConfirmView()<UITextFieldDelegate>

@end

@implementation UploadConfirmView

+(instancetype)getUploadCView{
    UploadConfirmView *ucView = [[[NSBundle mainBundle]loadNibNamed:@"UploadConfirmView" owner:nil options:nil]firstObject];
    return ucView;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    _confirmTextField.delegate = self;
    NSLog(@"UploadConfirmView...%s",__FUNCTION__);
    self.backgroundColor = [UIColor redColor];
    [_confirmTextField becomeFirstResponder];
    self.layer.cornerRadius = 12;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{

}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)confirmBtnClicked:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    [self.cvDelegate pushInfoWithConfirmedStr:self.confirmTextField.text];
}

- (IBAction)cancelBtnClicked:(id)sender {
    NSLog(@"%s",__FUNCTION__);
    [self.cvDelegate removeSelf];
}

@end
