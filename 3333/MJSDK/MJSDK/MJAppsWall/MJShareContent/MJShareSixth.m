//
//  MJShareEnding.m
//  MJSDK-iOS
//
//  Created by WM on 16/7/12.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJShareSixth.h"

@interface MJShareSixth ()
{
    
}
@property(nonatomic, retain)UIView *accountView;
@property(nonatomic, retain)UIView *redPacketView;
@property (nonatomic,retain)UILabel * lab_content8;
@property (nonatomic,retain)UILabel * lab_content9;

@end

@implementation MJShareSixth

- (void)setUp {
    
    [self.accountView addSubview:self.lab_content1];
    [self.accountView addSubview:self.lab_content2];
    [self.accountView addSubview:self.btn_modify];
    [self.redPacketView addSubview:self.lab_content3];
    [self.redPacketView addSubview:self.lab_content8];
    [self.redPacketView addSubview:self.lab_content9];
    
    [self addSubview:self.accountView];
    [self addSubview:self.redPacketView];
    [self addSubview:self.lab_content0];
    
    [self addSubview:self.imgView_logoLeft];
    [self addSubview:self.imgView_logoRight];
    
    [self.imgView_logoLeft addSubview:self.imgView_content];
    [self.imgView_logoRight addSubview:self.imgView_icon];

    MASAttachKeys(self.lab_content1, self.lab_content2 ,self.lab_content3 , self.btn_modify, self.lab_content0,self.imgView_logoRight,self.imgView_logoLeft,self.imgView_icon,self.imgView_content, self.lab_content8, self.lab_content9, self.accountView, self.redPacketView);

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
    
    [self.lab_content8 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content8 setTextColor:[UIColor colorFromHexString:@"#ff005b"]];
    
    [self.lab_content9 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content9 setTextColor:[UIColor colorFromHexString:@"#7c7c7c"]];
    
}
- (void)fill:(NSDictionary *)params {
    
    [self.btn_modify setImage:[UIImage mj_imageNamed:@"修改@2x.png"] forState:UIControlStateNormal];
    NSDictionary *coupons_info = params[@"coupons_info"];
    NSString *redPacketURL = coupons_info[@"image_url"];
    NSString *logoUrl = coupons_info[@"logo_url"];
    NSInteger usableNumber = [params[@"usable_coupons_num"] integerValue];
    NSString * iphoneNumber = params[@"cellphone"];
    
    [self.imgView_content mjCoupon_setImageWithURLString:redPacketURL placeholderImage:nil impAds:nil retry_times:3 success:nil failure:nil];
    [self.imgView_icon mjCoupon_setImageWithURLString:logoUrl placeholderImage:nil impAds:nil retry_times:3 success:nil failure:nil];
    
    [self.lab_content0 setText:@"登录萌店APP即可使用!"];
    [self.lab_content1 setText:@"你的账户"];

    //手机号
    [self.lab_content2 setText:[NSString stringWithFormat:@" %@ ",iphoneNumber]];
    [self.lab_content3 setText:@"已有"];
    [self.lab_content8 setText:[NSString stringWithFormat:@"%ld",usableNumber]];
    [self.lab_content9 setText:@"个专享红包！"];
    
}
#pragma mark -
#pragma mark - Masonry Methods
- (void)masonry
{//[self masonry];
    
    UIView *superView = self;
    //你的账户
    [self.lab_content1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.accountView);
    }];
    //12345678910
    [self.lab_content2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.centerY.equalTo(self.lab_content1);
        make.left.equalTo(self.lab_content1.mas_right);
    }];
    
    //修改按钮
    [self.btn_modify mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.centerY.equalTo(self.lab_content1);
        make.left.equalTo(self.lab_content2.mas_right);
        make.right.equalTo(self.accountView);
    }];
    
    [self.accountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView).offset(15.f);
        make.centerX.equalTo(superView);
    }];
    
    //已有
    [self.lab_content3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.redPacketView);
    }];
    //5(红包个数）
    [self.lab_content8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_content3.mas_right);
        make.centerY.equalTo(self.lab_content3);
    }];
    //个专享红包！
    [self.lab_content9 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lab_content8.mas_right);
        make.centerY.equalTo(self.lab_content3);
        make.right.equalTo(self.redPacketView);
    }];
    
    [self.redPacketView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountView.mas_bottom);
        make.centerX.equalTo(superView);
    }];
    
    //登录萌店APP即可使用!
    [self.lab_content0 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(superView);
        make.top.equalTo(self.redPacketView.mas_bottom);
        
    }];
    
    [self.imgView_content mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.imgView_logoLeft.mas_top).offset(6.f);
        make.left.equalTo(self.imgView_logoLeft.mas_left).offset(7.f);
        make.bottom.equalTo(self.imgView_logoLeft.mas_bottom).offset(-6.f);
        make.right.equalTo(self.imgView_logoLeft.mas_right).offset(-7.f);
    }];
    
    [self.imgView_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(self.imgView_logoRight);
        make.edges.equalTo(self.imgView_logoRight).insets(UIEdgeInsetsMake(19, 8, 19, 8));
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

- (UIView *)accountView {
    if (!_accountView) {
        _accountView = [[UIView alloc]init];
    }
    return _accountView;
}

- (UIView *)redPacketView {
    if (!_redPacketView) {
        _redPacketView = [[UIView alloc]init];
    }
    return _redPacketView;
}

#pragma mark - lab_content8
-(UILabel *)lab_content8 {
    
    if(!_lab_content8){

        _lab_content8 = [[UILabel alloc]init];
        [_lab_content8 setFrame:CGRectZero];
        [_lab_content8 setText:@""];
        [_lab_content8 setTextAlignment:NSTextAlignmentCenter];
    }
    
    return _lab_content8;
    
}

#pragma mark - lab_content9
-(UILabel *)lab_content9 {
    
    if(!_lab_content9){
        
        _lab_content9 = [[UILabel alloc]init];
        [_lab_content9 setFrame:CGRectZero];
        [_lab_content9 setText:@""];
        [_lab_content9 setTextAlignment:NSTextAlignmentCenter];
    }
    
    return _lab_content9;
    
}


@end
