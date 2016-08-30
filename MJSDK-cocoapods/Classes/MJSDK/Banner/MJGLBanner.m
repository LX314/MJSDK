//
//  MJGLBanner.m
//  sdk-ADView
//
//  Created by John LXThyme on 16/5/19.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#import "MJGLBanner.h"

@interface MJGLBanner ()
{
    
}
/** <#注释#>*/
@property (nonatomic,retain)UIImageView *imgView_logo;
/** <#注释#>*/
//@property (nonatomic,retain)UIButton *btn_dl;
/** <#注释#>*/
@property (nonatomic,retain)UILabel *lab_title;
/** <#注释#>*/
@property (nonatomic,retain)UILabel *lab_detail;

@end
@implementation MJGLBanner
#pragma mark -
#pragma mark - Common Component
- (void)setUp{
    [super setUp];
    //
    [self setBackgroundColor:[UIColor colorFromHexString:@"#fffffa"]];
    //
    [self.contentView addSubview:self.imgView_logo];
    [self.contentView addSubview:self.lab_title];
    [self.contentView addSubview:self.lab_detail];
    [self.contentView addSubview:self.mjLabADLogo];
    [self.contentView addSubview:self.btnClose];
    MASAttachKeys(self.imgView_logo,self.lab_title,self.lab_detail, self.mjLabADLogo, self.btnClose);
}
- (void)clear {
    [self.imgView_logo setImage:[UIImage imageNamed:@"墙类APP75x75"]];
    [self.lab_title setText:@"萌店"];
    [self.lab_detail setText:@"新生活 · 新买卖"];
}
- (void)fill:(MJImpAds *)impAds {
    MJElement *mjelement = impAds.bannerAds.mjElement;
    NSString *title = mjelement.title;
    NSString *detail = mjelement.desc;
    NSString *logUrl = mjelement.icon;
    [self.imgView_logo mj_setImageWithURLString:logUrl placeholderImage:[UIImage imageNamed:kMJSDKBannerGLPlaceholderImageName] impAds:impAds success:nil failure:nil];
//    [self.imgView_logo setImageWithURL:[NSURL URLWithString:logUrl] placeholderImage:];
    [self.lab_title setText:title];
    [self.lab_detail setText:detail];
}
#pragma mark -
#pragma mark - Masonry Methods
- (void)updateConstraints {
    [super updateConstraints];
    //
    [self masonry];
}
- (void)masonry
{//[self masonry];
    [super masonry];
    UIView *superView = self.contentView;
        [self.imgView_logo mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.left.equalTo(superView).offset(10);
            make.centerY.equalTo(superView);
            make.size.mas_equalTo(CGSizeMake(38, 38));
        }];
        [self.lab_title mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.top.equalTo(self.imgView_logo);
            make.left.equalTo(self.imgView_logo.mas_right).offset(8);
        }];
    
        [self.lab_detail mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.top.equalTo(self.lab_title.mas_bottom).offset(5);
            make.left.equalTo(self.lab_title);
        }];
//        [self.btn_dl mas_makeConstraints:^(MASConstraintMaker *make) {
//            //
//            make.right.equalTo(superView).offset(-10);
//            make.centerY.equalTo(superView);
//        }];
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
#pragma mark - imgView_logo
- (UIImageView *)imgView_logo
{
    if(!_imgView_logo){
        _imgView_logo = [[UIImageView alloc]init];
//        [_imgView_logo setImage:[UIImage imageNamed:@"墙类APP75x75"]];
        _imgView_logo.layer.masksToBounds = YES;
    }
    
    return _imgView_logo;
}
//#pragma mark - btn_dl
//- (UIButton *)btn_dl
//{
//    if(!_btn_dl){
//        
//        //初始化一个 Button
//        _btn_dl = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_btn_dl setFrame:CGRectZero];
//        
//        //背景图片
//        [_btn_dl setBackgroundImage:[UIImage imageNamed:@"下载按钮"] forState:UIControlStateNormal];
//        
//        //绑定事件
//        [_btn_dl addTarget:self action:@selector(btn_dlClick:) forControlEvents:UIControlEventTouchUpInside];
//        [_btn_dl setTag:123456];
//    }
//    
//    return _btn_dl;
//}
//
//- (void)btn_dlClick:(id)sender
//{
////    UIButton *btn = (UIButton *)sender;
//    //
//    
//}
#pragma mark - lab_title
- (UILabel *)lab_title
{
    if(!_lab_title){
        //初始化一个 Label
        _lab_title = [[UILabel alloc]init];
        [_lab_title setFrame:CGRectZero];
//        [_lab_title setText:@"萌店"];
//        [_lab_title setAdjustsFontSizeToFitWidth:<#YES#>];
        [_lab_title setTextColor:[UIColor colorFromHexString:@"#000000"]];
        [_lab_title setFont:[UIFont systemFontOfSize:18.f]];
        [_lab_title setTextAlignment:NSTextAlignmentLeft];
    }
    
    return _lab_title;
}
#pragma mark - lab_detail
- (UILabel *)lab_detail
{
    if(!_lab_detail){
        //初始化一个 Label
        _lab_detail = [[UILabel alloc]init];
        [_lab_detail setFrame:CGRectZero];
//        [_lab_detail setText:@"新生活 · 新买卖"];
        //        [_lab_detail setAdjustsFontSizeToFitWidth:<#YES#>];
        [_lab_detail setTextColor:[UIColor  colorFromHexString:@"#878787"]];
        [_lab_detail setFont:[UIFont systemFontOfSize:10.f]];
        [_lab_detail setTextAlignment:NSTextAlignmentLeft];
        
    }
    
    return _lab_detail;
}

@end
