//
//  MJShareSuccess.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/21.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJShareFourth.h"

@interface MJShareFourth ()
{
    
}
//@property (nonatomic,retain)UIButton *btn_modify2;

@end
@implementation MJShareFourth
- (void)setUp {
    
    [self addSubview:self.lab_content0];
    [self addSubview:self.lab_content1];
    [self addSubview:self.lab_content2];
    [self addSubview:self.lab_content3];
    [self addSubview:self.lab_content4];
    [self addSubview:self.lab_content5];
    [self addSubview:self.lab_content6];
    
    
    [self addSubview:self.btn_modify];
    [self addSubview:self.btn_get];
    
    
    [self addSubview:self.imgView_logoLeft];
    [self addSubview:self.imgView_logoRight];
    
    [self.imgView_logoLeft addSubview:self.imgView_content];
    [self.imgView_logoRight addSubview:self.imgView_icon];
    
    
}
- (void)reset {
    //你的账号
    [self.lab_content0 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content0 setTextColor:[UIColor colorFromHexString:@"#7c7c7c"]];
    
    //18016466269
    [self.lab_content1 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content1 setTextColor:[UIColor colorFromHexString:@"#ff004b"]];
    
    //有
    [self.lab_content2 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content2 setTextColor:[UIColor colorFromHexString:@"#7c7c7c"]];
    
    //5
    [self.lab_content3 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content3 setTextColor:[UIColor colorFromHexString:@"#ff004b"]];
    
    //个专享红包！
    [self.lab_content4 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content4 setTextColor:[UIColor colorFromHexString:@"#7c7c7c"]];
    
    //还可再领取一个红包！
    [self.lab_content5 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content5 setTextColor:[UIColor colorFromHexString:@"#ff004b"]];
    
    //登录萌店APP即可使用!
    [self.lab_content6 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content6 setTextColor:[UIColor colorFromHexString:@"#7c7c7c"]];
    
    
    [self.btn_modify setImage:[UIImage imageNamed:@"修改"] forState:UIControlStateNormal];
    
    [self.btn_get setBackgroundImage:[UIImage imageNamed:@"提交按钮"] forState:UIControlStateNormal];
    
    [self.btn_get setBackgroundImage:[UIImage imageNamed:@"高亮"] forState:UIControlStateHighlighted];
    
    [self.btn_get setBackgroundImage:[UIImage imageNamed:@"置灰"] forState:UIControlStateDisabled];
//    [self.btn_get setAttributedTitle:[[NSAttributedString alloc]initWithString:@"立即领取" attributes:@{
//                                                                                                        NSForegroundColorAttributeName:[UIColor whiteColor],
//                                                                                                        NSFontAttributeName:[UIFont systemFontOfSize:12.f]
//                                                                                                        }] forState:UIControlStateNormal];
//    
}
- (void)fill:(NSDictionary *)params {
    
    NSDictionary *coupons_info = params[@"coupons_info"];
    NSString *redPacketURL = coupons_info[@"image_url"];
    NSString *logoUrl = coupons_info[@"logo_url"];
    NSInteger usableNumber = [params[@"usable_coupons_num"] integerValue];
    NSString * iphoneNumber = params[@"cellphone"];
    
    [self.imgView_content mjCoupon_setImageWithURLString:redPacketURL placeholderImage:nil impAds:nil retry_times:3 success:nil failure:nil];
    [self.imgView_icon mjCoupon_setImageWithURLString:logoUrl placeholderImage:nil impAds:nil retry_times:3 success:nil failure:nil];
    
    [self.lab_content0 setText:@"你的账户"];
    [self.lab_content1 setText:[NSString stringWithFormat:@" %@ ",iphoneNumber]];
    [self.lab_content2 setText:@"有"];
    [self.lab_content3 setText:[NSString stringWithFormat:@"%ld",usableNumber]];
    [self.lab_content4 setText:@"个专享红包!"];
    [self.lab_content5 setText:@"还可再领取一个红包"];
    [self.lab_content6 setText:@"登录萌店APP即可使用!"];

}
#pragma mark -
#pragma mark - Masonry Methods
- (void)masonry
{//[self masonry];
    UIView *superView = self;
    //
    [self.lab_content0 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.centerX.equalTo(superView.mas_centerX).offset(-45.f);
        make.top.equalTo(superView.mas_top).offset(15.f);
    }];
    [self.lab_content1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.left.equalTo(self.lab_content0.mas_right);
        make.top.equalTo(self.lab_content0);
    }];
    [self.btn_modify mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.lab_content1.mas_right);
        make.centerY.equalTo(self.lab_content1.mas_centerY);
    }];
    
    [self.lab_content2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.lab_content0.mas_bottom);
        make.centerX.equalTo(superView.mas_centerX).offset(-80.f);
      
    }];
    [self.lab_content3 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.left.equalTo(self.lab_content2.mas_right);
        make.top.equalTo(self.lab_content2.mas_top);
    }];
    
    [self.lab_content4 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.left.equalTo(self.lab_content3.mas_right);
        make.top.equalTo(self.lab_content2.mas_top);
    }];


    [self.lab_content5 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.left.equalTo(self.lab_content4.mas_right);
        make.top.equalTo(self.lab_content2.mas_top);
        
    }];
    [self.lab_content6 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.centerX.equalTo(superView);
        make.top.equalTo(self.lab_content2.mas_bottom);
    }];
    
    [self.imgView_logoLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.lab_content6.mas_bottom).offset(15.f);
        make.centerX.equalTo(superView).offset(-35.f);
        make.size.mas_equalTo(CGSizeMake(128, 60));
    }];
    [self.imgView_logoRight mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.imgView_logoLeft.mas_right);
        make.top.equalTo(self.imgView_logoLeft.mas_top);
        
    }];
    [self.imgView_content mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.imgView_logoLeft.mas_top).offset(6.f);
        make.left.equalTo(self.imgView_logoLeft.mas_left).offset(7.f);
         make.bottom.equalTo(self.imgView_logoLeft.mas_bottom).offset(-6.f);
    }];
    [self.imgView_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.imgView_logoRight.mas_centerY);
        make.right.equalTo(self.imgView_logoRight).offset(-8.f);

    }];
    
    [self.btn_get mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.imgView_logoLeft.mas_bottom).offset(8.f);
        make.centerX.equalTo(superView);
        make.size.mas_equalTo(CGSizeMake(200.f, 25.f));
        
    }];
    
    
}

#pragma mark - lab_content4
- (UILabel *)lab_content4
{
    if(!_lab_content4){
       
        _lab_content4 = [[UILabel alloc]init];
        [_lab_content4 setFrame:CGRectZero];
        [_lab_content4 setText:@""];

    }
    
    return _lab_content4;
}
#pragma mark - lab_content5
- (UILabel *)lab_content5
{
    if(!_lab_content5){
        
        //初始化一个 Label
        _lab_content5 = [[UILabel alloc]init];
        [_lab_content5 setFrame:CGRectZero];
        [_lab_content5 setText:@""];
//        [_lab_content5 setTextColor:[UIColor blackColor]];
//        [_lab_content5 setTextAlignment:<#NSTextAlignmentCenter#>];
    }
    
    return _lab_content5;
}
#pragma mark - lab_content6
- (UILabel *)lab_content6
{
    if(!_lab_content6){
        //初始化一个 Label
        _lab_content6 = [[UILabel alloc]init];
        [_lab_content6 setFrame:CGRectZero];
        [_lab_content6 setText:@""];
//        [_lab_content6 setTextColor:[UIColor blackColor]];
//        [_lab_content6 setTextAlignment:<#NSTextAlignmentCenter#>];
    }
    
    return _lab_content6;
}

//#pragma mark - btn_get
//- (UIButton *)btn_get {
//    
//    if (!_btn_get) {
//        
//        _btn_get = [UIButton buttonWithType:UIButtonTypeCustom];
//        
//        [_btn_get setFrame:CGRectZero];
//        
//        //绑定事件
//        [_btn_get addTarget:self action:@selector(btnGet:) forControlEvents:UIControlEventTouchUpInside];
//        
//    }
//    
//    return _btn_get;
//}

//- (void)btnGet:(id)sender {

//    self.btn_get.enabled = NO;
    
    //    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    //    dispatch_after(time, dispatch_get_main_queue(), ^{
    //
//            self.btn_get.enabled = YES;
    //
    //    });
//    kGotoStepBlockBlock(KMJShareSixthStep);

//}


@end
