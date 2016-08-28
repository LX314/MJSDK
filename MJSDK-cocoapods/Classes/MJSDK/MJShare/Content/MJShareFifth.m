//
//  MJShareSuccessFinally.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/21.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJShareFifth.h"

@implementation MJShareFifth
- (void)setUp {
    [super setUp];
    
}
- (void)reset {
    
//    [super reset];
    
    //你的账号
    [self.lab_content0 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content0 setTextColor:[UIColor colorFromHexString:@"#7c7c7c"]];
    
    //18016466269
    [self.lab_content1 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content1 setTextColor:[UIColor colorFromHexString:@"#ff004b"]];
    
    //有
    [self.lab_content2 setFont:[UIFont systemFontOfSize:11.f]];
//    [self.lab_content2 setTextColor:[UIColor colorFromHexString:@"#7c7c7c"]];
    
//    //5
//    [self.lab_content3 setFont:[UIFont systemFontOfSize:11.f]];
//    [self.lab_content3 setTextColor:[UIColor colorFromHexString:@"#ff004b"]];
//    
//    //个专享红包！
//    [self.lab_content4 setFont:[UIFont systemFontOfSize:11.f]];
//    [self.lab_content4 setTextColor:[UIColor colorFromHexString:@"#7c7c7c"]];
//    
//    //还可再领取一个红包！
//    [self.lab_content5 setFont:[UIFont systemFontOfSize:11.f]];
//    [self.lab_content5 setTextColor:[UIColor colorFromHexString:@"#ff004b"]];
    
    //登录萌店APP即可使用!
    [self.lab_content6 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content6 setTextColor:[UIColor colorFromHexString:@"#7c7c7c"]];
    
    
    [self.btn_modify setImage:[UIImage imageNamed:@"修改"] forState:UIControlStateNormal];
    
    [self.btn_get setBackgroundImage:[UIImage imageNamed:@"提交按钮"] forState:UIControlStateNormal];
    
    [self.btn_get setBackgroundImage:[UIImage imageNamed:@"高亮"] forState:UIControlStateHighlighted];
    
    [self.btn_get setBackgroundImage:[UIImage imageNamed:@"置灰"] forState:UIControlStateDisabled];
    
    [self.lab_content2 setTextColor:[UIColor colorFromHexString:@"ff004b"]];
    
    
}
- (void)fill:(NSDictionary *)params {
//    [super fill:params];
    NSDictionary *coupons_info = params[@"coupons_info"];
    NSString *iphoneNumber = params[@"cellphone"];
    NSString *redPacketURL = coupons_info[@"image_url"];
    NSString *logoUrl = coupons_info[@"logo_url"];
//    NSAssert(iphoneNumber.length > 0, @"手机号不能为空");
    NSAssert(redPacketURL, @"优惠券不能为空");
    [self.lab_content0 setText:@"你的账户"];
    [self.lab_content1 setText:[NSString stringWithFormat:@" %@ ",iphoneNumber]];
    [self.lab_content2 setText:@"新获得一个红包"];
    [self.lab_content6 setText:@"登录萌店APP即可使用!"];
    
    [self.imgView_content mjCoupon_setImageWithURLString:redPacketURL placeholderImage:nil impAds:nil retry_times:3 success:nil failure:nil];
    [self.imgView_icon mjCoupon_setImageWithURLString:logoUrl placeholderImage:nil impAds:nil retry_times:3 success:nil failure:nil];
    
}
//- (void)btnGet:(id)sender {

//    NSLog(@"hello");
//    self.btn_get.enabled = NO;
    
    //    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
    //    dispatch_after(time, dispatch_get_main_queue(), ^{
    //
    //        self.btn_get.enabled = YES;
    //
    //    });
//    kGotoStepBlockBlock(KMJShareSixthStep);
    
//}
#pragma mark -
#pragma mark - Masonry Methods
- (void)masonry
{//[self masonry];
//    [super masonry];
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
        make.centerX.equalTo(superView);
        make.top.equalTo(self.lab_content0.mas_bottom);
        
    }];
//    [self.lab_content3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        //
//        make.left.equalTo(self.lab_content2.mas_right);
//        make.top.equalTo(self.lab_content2.mas_top);
//    }];
//    
//    [self.lab_content4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        //
//        make.left.equalTo(self.lab_content3.mas_right);
//        make.top.equalTo(self.lab_content2.mas_top);
//    }];
//    
//    
//    [self.lab_content5 mas_makeConstraints:^(MASConstraintMaker *make) {
//        //
//        make.left.equalTo(self.lab_content4.mas_right);
//        make.top.equalTo(self.lab_content2.mas_top);
//        
//    }];
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

    
    
    

//    [self.lab_content2 mas_updateConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerX.equalTo(superView);
//        make.top.equalTo(self.lab_content0.mas_bottom);
//    }];
    
//    [self.lab_content3 removeFromSuperview];
//    [self.lab_content4 removeFromSuperview];
//    [self.lab_content5 removeFromSuperview];

//    [self.lab_content6 mas_updateConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerX.equalTo(superView);
//        make.top.equalTo(self.lab_content2.mas_bottom);
//    }];

}

@end
