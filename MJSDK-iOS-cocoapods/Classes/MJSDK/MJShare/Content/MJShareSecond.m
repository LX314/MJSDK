//
//  MJShareContent2.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/20.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJShareSecond.h"

@interface MJShareSecond ()
{
    
}

@end
@implementation MJShareSecond
- (void)setUp {

    [self addSubview:self.lab_content1];
    [self addSubview:self.lab_content2];
    [self addSubview:self.lab_content3];
    [self addSubview:self.lab_content0];
    
    [self addSubview:self.imgView_logoLeft];
    [self addSubview:self.imgView_logoRight];
    
    [self.imgView_logoLeft addSubview:self.imgView_content];
    [self.imgView_logoRight addSubview:self.imgView_icon];
    
    [self addSubview:self.btn_modify];
    
    MASAttachKeys(self.lab_content1, self.lab_content2 ,self.lab_content3 , self.btn_modify, self.lab_content0,self.imgView_logoRight,self.imgView_logoLeft,self.imgView_icon,self.imgView_content);
}
- (void)reset {
    
    [self.lab_content1 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content1 setTextColor:[UIColor colorFromHexString:@"#7c7c7c"]];
    
    [self.lab_content2 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content2 setTextColor:[UIColor colorFromHexString:@"#ff005b"]];

    [self.lab_content3 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content3 setTextColor:[UIColor colorFromHexString:@"#7c7c7c"]];
    
    [self.lab_content0 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content0 setTextColor:[UIColor colorFromHexString:@"#7c7c7c"]];
    
}
- (void)fill:(NSDictionary *)params {
    
    NSDictionary *coupons_info = params[@"coupons_info"];
    NSString *redPacketURL = coupons_info[@"image_url"];
    NSString *logoUrl = coupons_info[@"logo_url"];
    
    [self.imgView_content mjCoupon_setImageWithURLString:redPacketURL placeholderImage:nil impAds:nil retry_times:3 success:nil failure:nil];
    [self.imgView_icon mjCoupon_setImageWithURLString:logoUrl placeholderImage:nil impAds:nil retry_times:3 success:nil failure:nil];

    [self.lab_content1 setText:@"你的账户"];
    [self.lab_content2 setText:[NSString stringWithFormat:@" %@ ",[MJTool getMJShareNewTel]]];
    [self.lab_content3 setText:@"已收到专享红包!"];
    [self.lab_content0 setText:@"登录萌店APP即可使用!"];
    
    [self.btn_modify setImage:[UIImage imageNamed:@"修改"] forState:UIControlStateNormal];
    
}
#pragma mark -
#pragma mark - Masonry Methods
- (void)masonry
{//[self masonry];
    UIView *superView = self;
    //
    [self.lab_content1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(superView).offset(30.f);
        make.centerX.equalTo(superView).offset(-45.f);
    }];
    
    [self.lab_content2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.lab_content1.mas_top);
        make.left.equalTo(self.lab_content1.mas_right);
    }];
    
    [self.btn_modify mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.left.equalTo(self.lab_content2.mas_right);
        make.centerY.equalTo(self.lab_content1);
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
    
    [self.lab_content3 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.centerX.equalTo(superView);
        make.top.equalTo(self.lab_content1.mas_bottom);
    }];
    
    [self.lab_content0 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(superView);
        make.top.equalTo(self.lab_content3.mas_bottom);
        
    }];
    
    [self.imgView_logoLeft mas_remakeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.lab_content0.mas_bottom).offset(13.f);
        make.centerX.equalTo(superView).offset(-35.f);
        make.size.mas_equalTo(CGSizeMake(128, 60));
    }];
    
    [self.imgView_logoRight mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.imgView_logoLeft.mas_right);
        make.top.equalTo(self.imgView_logoLeft.mas_top);
        
    }];

}

@end
