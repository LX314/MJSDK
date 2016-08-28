//
//  MJShareContent.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/20.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJShareFirst.h"

@interface MJShareFirst ()
{
    
}

@end
@implementation MJShareFirst
- (void)setUp {
    
    [self addSubview:self.textField];
    [self addSubview:self.btn_get];
    [self addSubview:self.imgView_logoLeft];
    [self addSubview:self.imgView_logoRight];
    [self addSubview:self.lab_title];
    [self addSubview:self.lab_description];

    [self.imgView_logoLeft addSubview:self.imgView_content];
    [self.imgView_logoRight addSubview:self.imgView_icon];
 

}
- (void)reset {
    
    [self.textField setBackgroundColor:[UIColor colorFromHexString:@"#ededed"]];
    [self.textField setTextColor:[UIColor colorFromHexString:@"#6d6d6d"]];
    [self.textField setFont:[UIFont systemFontOfSize:12.f]];
    
    [self.lab_description setTextColor:[UIColor colorFromHexString:@"#7c7c7c"]];
    [self.lab_description setFont:[UIFont systemFontOfSize:11.f]];
    
    [self.lab_title setTextColor:[UIColor colorFromHexString:@"#7c7c7c"]];
    [self.lab_title setFont:[UIFont systemFontOfSize:17.f]];

    [self.btn_get setBackgroundImage:[UIImage imageNamed:@"提交按钮"] forState:UIControlStateNormal];
    [self.btn_get setBackgroundImage:[UIImage imageNamed:@"高亮"] forState:UIControlStateHighlighted];
    [self.btn_get setBackgroundImage:[UIImage imageNamed:@"置灰"] forState:UIControlStateDisabled];
    
//    [self.btn_get setAttributedTitle:[[NSAttributedString alloc]initWithString:@"立即领取" attributes:@{
//                                                                                                       NSForegroundColorAttributeName:[UIColor whiteColor],
//                                                                              NSFontAttributeName:[UIFont systemFontOfSize:12.f],
//                                                                                                       }] forState:UIControlStateNormal];
}
- (void)fill:(NSDictionary *)params {
    
    NSDictionary *coupons_info = params[@"coupons_info"];
    NSString *redPacketURL = coupons_info[@"image_url"];
    NSString *logoUrl = coupons_info[@"logo_url"];
    [self.imgView_content mjCoupon_setImageWithURLString:redPacketURL placeholderImage:nil impAds:nil retry_times:3 success:nil failure:nil];
    [self.imgView_icon mjCoupon_setImageWithURLString:logoUrl placeholderImage:nil impAds:nil retry_times:3 success:nil failure:nil];
    [self.textField setAttributedPlaceholder:[[NSAttributedString alloc]initWithString:@"填写手机号领取专享红包" attributes:@{
                                                                                                                       NSFontAttributeName:[UIFont systemFontOfSize:12.f],
                                                                                                                       NSForegroundColorAttributeName:[UIColor colorFromHexString:@"#6d6d6d"]}]];


    [self.imgView_content.image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 100, 0, 100) resizingMode:UIImageResizingModeStretch];
    [self.imgView_logoLeft.image resizableImageWithCapInsets:UIEdgeInsetsMake(0, 100, 0, 100) resizingMode:UIImageResizingModeStretch];
    
    [self.lab_description setText:@"登录萌店APP即可使用"];
    [self.lab_title setText:@"恭喜获得萌店红包"];
    
}
//- (void)btnGet:(id)sender
//{
//    self.btn_get.userInteractionEnabled = NO;
    
//    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC);
//    dispatch_after(time, dispatch_get_main_queue(), ^{
//        
//        self.btn_get.enabled = YES;
//        
//    });
    
    
//    kGotoStepBlockBlock(KMJShareSecondStep);
//}
#pragma mark -
#pragma mark - Masonry Methods
- (void)masonry
{//
    UIView *superView = self;
    //
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.imgView_logoLeft.mas_bottom).offset(5.f);
        make.centerX.equalTo(superView);
        make.size.mas_equalTo(CGSizeMake(200.f, 25.f));
    }];
    
    [self.btn_get mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.textField.mas_bottom).offset(5.f);
        make.right.equalTo(self.textField.mas_right);
        make.size.mas_equalTo(CGSizeMake(200.f, 25.f));
    }];
    
    [self.imgView_logoLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.lab_description.mas_bottom).offset(10.f);
        make.left.equalTo(self.textField);
        make.size.mas_equalTo(CGSizeMake(128, 60));
    }];
    
    [self.imgView_logoRight mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.imgView_logoLeft.mas_right);
        make.top.equalTo(self.imgView_logoLeft.mas_top);
        
    }];
    
    [self.lab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(superView).offset(15.f);
        make.centerX.equalTo(superView);
    }];
    
    [self.lab_description mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lab_title.mas_bottom);
        make.centerX.equalTo(superView);
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
    
}

@end
