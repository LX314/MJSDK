//
//  MJGLInterstitial.m
//  sdk-ADView
//
//  Created by John LXThyme on 16/5/20.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#import "MJGLInterstitial.h"

@interface MJGLInterstitial ()
{
    
}
/** <#注释#>*/
@property (nonatomic,retain)UIImageView *imgView_logo;
/** <#注释#>*/
@property (nonatomic,retain)UILabel *lab_title;
/** <#注释#>*/
@property (nonatomic,retain)UILabel *lab_detail;
/** <#注释#>*/
@property (nonatomic,retain)UIView *bgView;
/** <#注释#>*/
@property (nonatomic,retain)UILabel *lab_content;
/** <#注释#>*/
@property (nonatomic,retain)UIButton *btn_dl;

@end
@implementation MJGLInterstitial
- (void)setUp{
    [super setUp];
    //
    [self setBackgroundColor:[UIColor whiteColor]];
    [self.bgView addSubview:self.imgView_logo];
    [self.bgView addSubview:self.lab_title];
    [self.bgView addSubview:self.lab_detail];
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.lab_content];
    [self.contentView addSubview:self.btn_dl];
    [self.contentView addSubview:self.mjLabADLogo];
    [self.contentView addSubview:self.btnClose];
    MASAttachKeys(self.imgView_logo,self.lab_title,self.lab_detail,self.lab_content,self.bgView,self.btn_dl, self.mjLabADLogo, self.btnClose);
}
- (void)fill:(MJImpAds *)impAds{
    MJElement *mjelement = impAds.bannerAds.mjElement;
    NSString *title = mjelement.title;
    NSString *detail = mjelement.desc;
    NSString *logUrl = mjelement.icon;
    NSString *content = mjelement.content;
    [self.imgView_logo mj_setImageWithURLString:logUrl placeholderImage:[UIImage imageNamed:kMJSDKInterstitialGLPlaceholderImageName] impAds:impAds success:nil failure:nil];
//    [self.imgView_logo setImageWithURL:[NSURL URLWithString:logUrl] placeholderImage:[UIImage imageNamed:kMJSDKInterstitialGLPlaceholderImageName]];
    [self.lab_title setText:title];
    [self.lab_detail setText:detail];
    
    [self.bgView setBackgroundColor:[UIColor colorFromHexString:@"#f17144"]];
    [self.lab_content setText:content];
//    [self.imgView_logo setImage:[UIImage imageNamed:@"插屏APP80x80"]];
//   
//    [self.lab_title setText:@"萌店萌店"];
// 
//    [self.lab_detail setText:@"新生活,新买卖"];
//  
    
//    [self.lab_content setText:@"萌店是基于人与人的信任关系，以消费者为中心，注重产品口碑和品质的社会化电商平台。"];
    
    [self.btn_dl setTitle:@"立即下载" forState:UIControlStateNormal];
}
#pragma mark -
#pragma mark - Masonry Methods
- (void)masonry
{//[self masonry];
    [super masonry];
    //
    UIView *superView = self.contentView;
//    CGFloat padding = 8;
    [self.imgView_logo mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.left.equalTo(self.bgView).offset(25.f);
        make.size.mas_equalTo(CGSizeMake(40.f, 40.f));
        make.centerY.equalTo(self.bgView);
    }];
    [self.lab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.imgView_logo);
        make.left.equalTo(self.imgView_logo.mas_right).offset(5);
    }];
    [self.lab_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.bottom.equalTo(self.imgView_logo);
        make.left.equalTo(self.lab_title);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.left.right.equalTo(superView);
        make.height.equalTo(@80.f);
    }];
    [self.lab_content mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.bgView.mas_bottom).offset(20.f);
        make.left.equalTo(superView).offset(25.f);
        make.right.equalTo(superView).offset(-25.f);
    }];
    [self.btn_dl mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.bottom.equalTo(superView).offset(-20.f);
        make.centerX.equalTo(superView);
        make.size.mas_equalTo(CGSizeMake(150.f, 25.f));
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


#pragma mark - imgView_logo
- (UIImageView *)imgView_logo
{
    if(!_imgView_logo){
        _imgView_logo = [[UIImageView alloc]init];
        
    }
    
    return _imgView_logo;
}

#pragma mark - lab_title
- (UILabel *)lab_title
{
    if(!_lab_title){
        _lab_title = [[UILabel alloc]init];
        [_lab_title setTextColor:[UIColor whiteColor]];
        [_lab_title setFont:[UIFont boldSystemFontOfSize:20.f]];
    }
    
    return _lab_title;
}

#pragma mark - lab_detail
- (UILabel *)lab_detail
{
    if(!_lab_detail){
        _lab_detail = [[UILabel alloc]init];
        [_lab_detail setTextColor:[UIColor whiteColor]];
        [_lab_detail setFont:[UIFont systemFontOfSize:10.f]];
        
    }
    
    return _lab_detail;
}

#pragma mark - bgView
- (UIView *)bgView
{
    if(!_bgView){
        _bgView = [[UIView alloc]init];
        
    }
    
    return _bgView;
}

#pragma mark - lab_content
- (UILabel *)lab_content
{
    if(!_lab_content){
        _lab_content = [[UILabel alloc]init];
        [_lab_content setNumberOfLines:0];
        //        [_lab_content setPreferredMaxLayoutWidth:300.f];
        [_lab_content setTextColor:[UIColor colorFromHexString:@"#878787"]];
        [_lab_content setFont:[UIFont systemFontOfSize:15.f]];
    }
    
    return _lab_content;
}

#pragma mark - btn_dl
- (UIButton *)btn_dl
{
    if(!_btn_dl){
        
        //初始化一个 Button
        _btn_dl = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_dl setFrame:CGRectZero];
        
        [_btn_dl setBackgroundColor:[UIColor colorFromHexString:@"#f17144"]];
        [_btn_dl.layer setCornerRadius:3.f];
        
        //标题
        [_btn_dl setTitle:@"立即下载" forState:UIControlStateNormal];
        
        //标题颜色
        [_btn_dl setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        //绑定事件
        [_btn_dl addTarget:self action:@selector(btn_dlClick:) forControlEvents:UIControlEventTouchUpInside];
        [_btn_dl setTag:123456];

        
    }
    
    return _btn_dl;
}

- (void)btn_dlClick:(id)sender
{
//    UIButton *btn = (UIButton *)sender;
    //
    
}

@end
