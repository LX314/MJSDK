//
//  MJMDInterstitial.m
//  sdk-ADView
//
//  Created by WM on 16/5/23.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#import "MJMDInterstitial.h"

@interface MJMDInterstitial() {


}

//注释
@property(nonatomic,retain)UIView * view_top;
//注释
@property(nonatomic,retain)UILabel * lab_title;
//注释
@property(nonatomic,retain)UILabel * lab_num;
//注释
@property(nonatomic,retain)UILabel * lab_content;
//注释
@property(nonatomic,retain)UIButton * btn_detail;
//注释
@property(nonatomic,retain)UIButton * btn_share;

@end

@implementation MJMDInterstitial
-(void)setUp {
    [super setUp];
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:self.view_top];
    [self.contentView addSubview:self.lab_title];
    [self.contentView addSubview:self.lab_num];
    [self.contentView addSubview:self.lab_content];
    [self.contentView addSubview:self.btn_detail];
    [self.contentView addSubview:self.btn_share];
    [self.contentView addSubview:self.mjLabADLogo];
    [self.contentView addSubview:self.btnClose];
    MASAttachKeys(self.view_top,self.lab_title,self.lab_num,self.lab_content,self.btn_detail,self.btn_share, self.mjLabADLogo, self.btnClose);
}

-(void)fill:(MJImpAds *)impAds {
//    MJElement *mjelement = impAds.bannerAds.mjElement;
//    [super fill:params];
    //
//    [self.view_top setImage:[UIImage imageNamed:@""]];
    
    [self.view_top setBackgroundColor:[UIColor colorFromHexString:@"#f17144"]];
    
    [self.lab_title setText:@"科学选择宝宝室内游乐玩具！"];
    
    [self.lab_num setText:@"20%"];
    
    [self.lab_content setText:@"最高\n返佣"];
    
    [self.btn_detail setTitle:@"了解\n详情" forState:UIControlStateNormal];
    
    [self.btn_share setTitle:@"我要\n分享" forState:UIControlStateNormal];

}

#pragma mark -
#pragma mark - Masonry Methods
- (void)masonry
{//[self masonry];
    [super masonry];
    UIView *superView = self.contentView;
    
    [self.view_top mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        
        make.top.left.right.equalTo(superView);
        make.height.equalTo(@100.f);
    
    }];
    [self.lab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view_top.mas_bottom).offset(10.f);
        make.centerX.equalTo(self.view_top);
        
        
    }];
    
    [self.lab_content mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.lab_num.mas_right).offset(5.f);
        make.top.equalTo(self.lab_title.mas_bottom).offset(5.f);
    }];
    [self.lab_num mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.lab_title.mas_left);
        make.top.equalTo(self.lab_title.mas_bottom);
        
    }];
    [self.btn_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.lab_content.mas_bottom).offset(13.f);
        make.right.equalTo(superView.mas_centerX).offset(-3.f);
        make.height.equalTo(@60.f);
        make.width.equalTo(@60.f);
       
    
    }];
    [self.btn_share mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(superView.mas_centerX).offset(3.f);
        make.height.equalTo(@60.f);
        make.width.equalTo(@60.f);
        make.top.equalTo(self.lab_content.mas_bottom).offset(13.f);
        
    }];
    [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(superView).offset(5);
        make.right.equalTo(superView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];

    [self.mjLabADLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.right.equalTo(superView);
        make.bottom.equalTo(superView);
    }];
}

#pragma mark - imageView_top
-(UIView *)view_top {

    if (!_view_top) {
        
        _view_top = [[UIView alloc]init];
        
    }

    return _view_top;
}
#pragma mark - lab_title
-(UILabel *)lab_title {

    if (!_lab_title) {
        
        _lab_title = [[UILabel alloc]init];
        
        [_lab_title setFont:[UIFont systemFontOfSize:15.f]];
    }
    
    return _lab_title;
    
}

#pragma mark - lab_num
-(UILabel *)lab_num {

    if (!_lab_num) {
        
        _lab_num = [[UILabel alloc]init];
        [_lab_num setTextColor:[UIColor colorFromHexString:@"#e95539"]];
        [_lab_num setFont:[UIFont systemFontOfSize:35.f]];
        
        
    }

    return _lab_num;
}
#pragma - lab_content
-(UILabel *)lab_content {

    if (!_lab_content) {
        
        _lab_content = [[UILabel alloc]init];
        [_lab_content setTextColor:[UIColor colorFromHexString:@"#878787"]];
        _lab_content.numberOfLines = 2;
        [_lab_content setFont:[UIFont systemFontOfSize:13.f]];
    }
    return _lab_content;
}

#pragma - btn_detail
-(UIButton *)btn_detail {

    if (!_btn_detail) {
        _btn_detail = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_btn_detail setFrame:CGRectZero];
        
        [_btn_detail setBackgroundColor:[UIColor colorFromHexString:@"#e95539"]];
        
        [_btn_detail.layer setCornerRadius:3.f];
        
        //标题
        [_btn_detail setTitle:@"了解详情" forState:UIControlStateNormal];
        
        _btn_detail.titleLabel.font = [UIFont systemFontOfSize:18.f];
        
        _btn_detail.titleLabel.numberOfLines = 2;
        
        [_btn_detail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_btn_detail addTarget:self action:@selector(btn_detailClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_btn_detail setTag:11111];
        
    }

    return _btn_detail;
}

-(void)btn_detailClick:(id)sender {

    NSLog(@"了解更多");

}

#pragma - btn_share
-(UIButton *)btn_share {
    
    if (!_btn_share) {
        _btn_share = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_btn_share setFrame:CGRectZero];
        
        [_btn_share setBackgroundColor:[UIColor colorFromHexString:@"62d39d"]];
        
        [_btn_share.layer setCornerRadius:3.f];
        
        //标题
        [_btn_share setTitle:@"我要分享" forState:UIControlStateNormal];
        
        _btn_share.titleLabel.font = [UIFont systemFontOfSize:18.f];
        
        _btn_share.titleLabel.numberOfLines = 2;
        
        [_btn_share setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [_btn_share addTarget:self action:@selector(btn_shareClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [_btn_share setTag:22222];
        
    }
    
    return _btn_share;
}

-(void)btn_shareClick:(id)sender {
    
    NSLog(@"我要分享");
    
}

@end
