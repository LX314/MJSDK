//
//  MJBaseShareContent.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/20.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJBaseShareContent.h"

#import "MJCouponManager.h"
#import "MJExceptionReportManager.h"
#import "MJShare.h"
#import "MJToast.h"
#import "MJTool.h"

@interface MJBaseShareContent (){

    NSString * _transmitPhone;
}
@property(nonatomic, copy)NSString * phoneNumber;
@end

@implementation MJBaseShareContent
- (instancetype)init {
    if (self = [super init]) {
        
        [self setFrame:CGRectMake(0, 40.f, 275.f, 188.f)];
        [self baseSetUp];
    }
    return self;
}
- (void)baseSetUp {
    //
    [self setUp];
    [self suit];
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}
- (void)setUp {
}
- (void)updateConstraints {
    [super updateConstraints];
    //
    [self masonry];
}
- (void)suit {
    [self reset];
//    [self fill];
}
- (void)reset {
}
- (void)fill:(NSDictionary *)params {

}
- (void)masonry {
    
}

/**
 *  领券
 */
-(void)claimCouponsInfo {
    
    MJCouponManager * manager = [MJCouponManager manager];
    NSString * code = _mjShare.params[@"coupons_info"][@"coupons_code"];
    
    if ([_mjShare.params[@"cellphone"] length] > 0 && [_mjShare.params[@"registered"] boolValue] == YES) {
        
        _transmitPhone = _mjShare.params[@"cellphone"];
        
    } else {
    
        if([MJTool judgePhoneNumber:self.textField.text]) {
            _transmitPhone = self.textField.text;
        
        } else {
            [MJToast toast:@"手机号输入错误，请重新输入" in:self];
            return;
        }
    }
    
    [manager loadClaim:^(NSDictionary *params) {
        
        NSLog(@"params:%@",params);
        
        if (!params){
            
            [MJToast toast:@"发生了一个错误，领取红包失败" in:self];
            
        } else if ([params[@"registered"] boolValue] == YES) {
            
            [self.mjShare fill:params];
            [MJTool saveMJShareNewTel:params[@"cellphone"]];
            NSDictionary * coupons_info = params[@"coupons_info"];
            if ([params[@"usable_coupons_num"] integerValue] > 0 && [coupons_info[@"coupons_status"] boolValue] == YES) {
                
                self.mjShare.mjGotoStepBlockBlock(KMJShareFourthStep);

            } else if ([params[@"usable_coupons_num"] integerValue] > 0 && [coupons_info[@"coupons_status"] boolValue] == NO) {
                
                self.mjShare.mjGotoStepBlockBlock(KMJShareSixthStep);
                
            } else if ([params[@"usable_coupons_num"] integerValue] == 0 && [coupons_info[@"coupons_status"] boolValue] == YES) {
                
                self.mjShare.mjGotoStepBlockBlock(KMJShareFifthStep);
                
            } else {
                
                self.mjShare.mjGotoStepBlockBlock(KMJShareSecondStep);
                
            }
    
        } else if([params[@"claim_status"] boolValue] == YES) {
            
            if (_currentStep == KMJShareFourthStep) {
                
                self.mjShare.mjGotoStepBlockBlock(KMJShareSixthStep);
                
            } else if (_currentStep == KMJShareFirstStep) {
         
                [MJTool saveMJShareNewTel:self.textField.text];
                self.mjShare.mjGotoStepBlockBlock(KMJShareSecondStep);
                
            }else if (_currentStep == KMJShareFifthStep)  {
            
                self.mjShare.mjGotoStepBlockBlock(KMJShareSecondStep);
            }
            
        } else if ([params[@"claim_status"] boolValue] == NO){
            
            NSString * failCode = params[@"failure_msg"];
            NSString *key = [NSString stringWithFormat:@"Loc_Copous_Status_%@", failCode];
            NSString *toastString = NSLocalizedString(key, "");
            [MJToast toast:toastString in:self];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        [MJToast toast:@"发生了一个错误，领取红包失败" in:self];
        MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORCouponClaimFailure description:[NSString stringWithFormat:@"[优惠券][领取]失败:%@",error]];
        [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
    } couponCode:code telNumber:_transmitPhone];
}

/**
 *  button延时操作
 */
- (void)delayClickOperation:(id)sender {

    UIButton * button = (UIButton *)sender;
    button.enabled = NO;
    
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        
        button.enabled = YES;
        
    });

}

#pragma mark - imgView_content
- (UIImageView *)imgView_content {

    if(!_imgView_content){
        
        _imgView_content = [[UIImageView alloc]init];
    }
    return _imgView_content;

}

#pragma mark - imgView_icon
- (UIImageView *)imgView_icon {

    if(!_imgView_icon){
        _imgView_icon = [[UIImageView alloc]init];
    }
    
    return _imgView_icon;
}

#pragma mark - imgView_logoLeft
- (UIImageView *)imgView_logoLeft
{
    if(!_imgView_logoLeft){
        _imgView_logoLeft = [[UIImageView alloc]init];
        [_imgView_logoLeft setImage:[UIImage imageNamed:@"券_01"]];
    }
    
    return _imgView_logoLeft;
}
#pragma mark - imgView_logoRight
- (UIImageView *)imgView_logoRight
{
    if(!_imgView_logoRight){
        _imgView_logoRight = [[UIImageView alloc]init];
        [_imgView_logoRight setImage:[UIImage imageNamed:@"券_02"]];
    }
    
    return _imgView_logoRight;
}


#pragma mark - textField
- (UITextField *)textField
{
    if(!_textField){
        //初始化一个TextField<UITextFieldDelegate>
        _textField = [[UITextField alloc]init];
        [_textField setFrame: CGRectZero];
        
        [_textField setBorderStyle:UITextBorderStyleRoundedRect];
        [_textField setPlaceholder:@""];
        
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        // return 健的样式
        [_textField setReturnKeyType:UIReturnKeyDone];
        //键盘类型
        [_textField setKeyboardType:UIKeyboardTypePhonePad];
        [_textField setTextAlignment:NSTextAlignmentCenter];
    }
    
    return _textField;
}
#pragma mark - btn_modify -- 修改手机号
- (UIButton *)btn_modify
{
    if(!_btn_modify){
        
        //初始化一个 Button
        _btn_modify = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_modify setFrame:CGRectZero];
        //标题颜色
        [_btn_modify setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        //绑定事件
        [_btn_modify addTarget:self action:@selector(btnModify:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btn_modify;
}

- (void)btnModify:(id)sender
{
    [self delayClickOperation:sender];
    [[NSUserDefaults standardUserDefaults]setObject:@(_currentStep) forKey:@"lastStep"];
    self.mjShare.mjGotoStepBlockBlock(KMJShareThirdStep);
}
#pragma mark - btn_get -- 立即领取
- (UIButton *)btn_get {

    if (!_btn_get) {

        _btn_get = [UIButton buttonWithType:UIButtonTypeCustom];

        [_btn_get setFrame:CGRectZero];
        //绑定事件
        [_btn_get addTarget:self action:@selector(btnGetClick:) forControlEvents:UIControlEventTouchUpInside];

    }

    return _btn_get;
}

- (void)btnGetClick:(id)sender {
    
    [self delayClickOperation:sender];
    [self claimCouponsInfo];
}

#pragma mark - lab_content1
- (UILabel *)lab_title
{
    if(!_lab_title){
        //初始化一个 Label
        _lab_title = [[UILabel alloc]init];
        [_lab_title setFrame:CGRectZero];
        [_lab_title setText:@""];
        [_lab_title setTextAlignment:NSTextAlignmentCenter];
       
    }
    
    return _lab_title;
}
#pragma mark - lab_description
- (UILabel *)lab_description
{
    if(!_lab_description){
        //初始化一个 Label
        _lab_description = [[UILabel alloc]init];
        [_lab_description setFrame:CGRectZero];
        [_lab_description setText:@""];
        [_lab_description setTextAlignment:NSTextAlignmentCenter];
        
    }
    
    return _lab_description;
}


#pragma mark - lab_content1
- (UILabel *)lab_content1
{
    if(!_lab_content1){
        //初始化一个 Label
        _lab_content1 = [[UILabel alloc]init];
        [_lab_content1 setFrame:CGRectZero];
        [_lab_content1 setText:@""];
        [_lab_content1 setTextColor:[UIColor colorFromHexString:@""]];

    }
    
    return _lab_content1;
}
#pragma mark - lab_content2
- (UILabel *)lab_content2
{
    if(!_lab_content2){
        //初始化一个 Label
        _lab_content2 = [[UILabel alloc]init];
        [_lab_content2 setFrame:CGRectZero];
        [_lab_content2 setText:@""];
        [_lab_content2 setTextColor:[UIColor colorFromHexString:@""]];

    }
    
    return _lab_content2;
}


#pragma mark - lab_content3
- (UILabel *)lab_content3
{
    if(!_lab_content3){
        //初始化一个 Label
        _lab_content3 = [[UILabel alloc]init];
        [_lab_content3 setFrame:CGRectZero];
        [_lab_content3 setText:@""];
      
    }
    
    return _lab_content3;
}

#pragma mark - lab_content0
- (UILabel *)lab_content0
{
    if(!_lab_content0){
        //初始化一个 Label
        _lab_content0 = [[UILabel alloc]init];
        [_lab_content0 setFrame:CGRectZero];
        [_lab_content0 setText:@""];
        //        [_lab_content3 setTextColor:[UIColor blackColor]];
        [_lab_content0 setTextAlignment:NSTextAlignmentCenter];
    }
    
    return _lab_content0;
}


@end
