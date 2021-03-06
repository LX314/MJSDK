//
//  MJGLInlineBanner.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/8.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJGLInline.h"

#import "MJImpAds.h"
#import "MJElement.h"
#import "MJBannerAds.h"

@interface MJGLInline ()
{
    
}
/** logo*/
@property (nonatomic,retain)UIImageView *imgView_logo;
/** 标题*/
@property (nonatomic,retain)UILabel *lab_title;
/** 描述*/
@property (nonatomic,retain)UILabel *lab_detail;

@end
@implementation MJGLInline
- (void)setUp {
    [super setUp];
    //
    [self.contentView addSubview:self.imgView_logo];
    [self.contentView addSubview:self.lab_title];
    [self.contentView addSubview:self.lab_detail];
    MASAttachKeys(self.imgView_logo,self.lab_title,self.lab_detail);
}
- (void)fill:(MJImpAds *)impAds {
    MJElement *mjelement = impAds.bannerAds.mjElement;
    NSString *title = mjelement.title;
    NSString *detail = mjelement.desc;
    NSString *logUrl = mjelement.icon;
    
    [self.imgView_logo mj_setImageWithURLString:logUrl placeholderImage:kMJSDKInlineGLPlaceholderImageName impAds:impAds success:nil failure:nil];
    [self.lab_title setText:title];
    [self.lab_detail setText:detail];

}
#pragma mark -
#pragma mark - Masonry Methods
- (void)layoutSubviews {
    [super layoutSubviews];
    [self.lab_title setPreferredMaxLayoutWidth:CGRectGetWidth(self.lab_title.frame)];
}
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
    [_lab_title setPreferredMaxLayoutWidth:179.f];
    [_lab_title setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.lab_detail mas_remakeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.lab_title.mas_bottom).offset(6);
        make.left.right.equalTo(self.lab_title);
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
        [_lab_title setFrame:CGRectZero];
        [_lab_title setTextColor:[UIColor colorFromHexString:@"#000000"]];
        [_lab_title setFont:[UIFont systemFontOfSize:18]];
        [_lab_title setLineBreakMode:NSLineBreakByCharWrapping];
        _lab_title.adjustsFontSizeToFitWidth = YES;
    }
    
    return _lab_title;
}

#pragma mark - lab_detail
- (UILabel *)lab_detail
{
    if(!_lab_detail){

        _lab_detail = [[UILabel alloc]init];
        [_lab_detail setFrame:CGRectZero];
        [_lab_detail setNumberOfLines:2];
        [_lab_detail setFont:[UIFont systemFontOfSize:16]];
        [_lab_detail setTextColor:[UIColor colorFromHexString:@"868686"]];
    }
    
    return _lab_detail;
}


@end
