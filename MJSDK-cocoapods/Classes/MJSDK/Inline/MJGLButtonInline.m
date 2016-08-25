//
//  MJGLButtonInlineBanner.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/8.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJGLButtonInline.h"

@interface MJGLButtonInline ()
{
    
}
/** <#注释#>*/
@property (nonatomic,retain)UIButton *btn_action;

@end
@implementation MJGLButtonInline
- (void)setUp {
    [super setUp];
    [self.contentView addSubview:self.btn_action];
    [self.contentView addSubview:self.mjLabADLogo];
    MASAttachKeys(self.btn_action, self.mjLabADLogo);
}

- (void)fill:(MJImpAds *)impAds {
    MJElement *mjelement = impAds.bannerAds.mjElement;
    self.mjElement = mjelement;
    [self.btnClose removeFromSuperview];
    
    NSString *title = mjelement.title;
    NSString *detail = mjelement.desc;
    NSString *logUrl = mjelement.icon;

    [self.imgView_logo mj_setImageWithURLString:logUrl placeholderImage:[UIImage imageNamed:kMJSDKInlineGLPlaceholderImageName] impAds:impAds success:nil failure:nil];
//    [self.imgView_logo setImageWithURL:[NSURL URLWithString:logUrl] placeholderImage:[UIImage imageNamed:kMJSDKInlineGLPlaceholderImageName]];
    [self.lab_title setText:title];
    [self.lab_detail setText:detail];
    
    [self.lab_title setFont:[UIFont systemFontOfSize:16]];
    [self.lab_detail setFont:[UIFont systemFontOfSize:14]];
    
}
#pragma mark -
#pragma mark - Masonry Methods
- (void)masonry
{//[self masonry];
    [super masonry];
    //
    UIView *superView = self.contentView;
    //
    [self.imgView_logo mas_remakeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(superView).offset(5.f);
        make.bottom.equalTo(superView).offset(-5.f);
        make.width.equalTo(self.imgView_logo.mas_height).multipliedBy(4/3.f);
    }];
    [self.lab_title mas_remakeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.imgView_logo);
        make.left.equalTo(self.imgView_logo.mas_right).offset(8.f);
        make.right.equalTo(superView).offset(-8.f);
    }];
   
    [self.lab_detail mas_remakeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.lab_title.mas_bottom).offset(4);
        make.left.right.equalTo(self.lab_title);
    }];
    [self.mjLabADLogo mas_remakeConstraints:^(MASConstraintMaker *make) {
        //
        make.right.equalTo(superView).offset(-5.f);
        make.bottom.equalTo(self.imgView_logo.mas_bottom);
    }];
    [self.btn_action mas_remakeConstraints:^(MASConstraintMaker *make) {
        //
        make.left.equalTo(self.lab_title);
        make.bottom.equalTo(superView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(80.f, 25.f));
    }];
}
#pragma mark - btn_action
- (UIButton *)btn_action
{
    if(!_btn_action){
        
        //初始化一个 Button
        _btn_action = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_action setFrame:CGRectZero];
        
        [_btn_action setBackgroundColor:[UIColor colorFromHexString:@"#62d300"]];
        
        //标题
        [_btn_action setTitle:@"立即分享" forState:UIControlStateNormal];
        //标题颜色
        [_btn_action setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn_action.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [_btn_action.layer setCornerRadius:5.f];
        
        //绑定事件
        [_btn_action addTarget:self action:@selector(btnShareClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btn_action;
}
- (void)btnShareClick:(id)sender {
    
    [self shareInformationMethod];
    
}
@end
