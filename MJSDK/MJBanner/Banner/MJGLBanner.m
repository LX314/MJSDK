//
//  MJGLBanner.m
//  sdk-ADView
//
//  Created by John LXThyme on 16/5/19.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#import "MJGLBanner.h"

#import "MJImpAds.h"
#import "MJElement.h"
#import "MJBannerAds.h"

@interface MJGLBanner ()
{
    
}
/** logo*/
@property (nonatomic,retain)UIImageView *imgView_logo;
/** 标题*/
@property (nonatomic,retain)UILabel *lab_title;
/** 详情*/
@property (nonatomic,retain)UILabel *lab_detail;

@end
@implementation MJGLBanner
#pragma mark -
#pragma mark - Common Component
- (void)setUp{
    [super setUp];
    [self setBackgroundColor:[UIColor colorFromHexString:@"#fffffa"]];
    [self.contentView addSubview:self.imgView_logo];
    [self.contentView addSubview:self.lab_title];
    [self.contentView addSubview:self.lab_detail];
    MASAttachKeys(self.imgView_logo,self.lab_title,self.lab_detail);
}
- (void)clear {

}
- (void)fill:(MJImpAds *)impAds {
    
    MJElement *mjelement = impAds.bannerAds.mjElement;
    NSString *title = mjelement.title;
    NSString *detail = mjelement.desc;
    NSString *logUrl = mjelement.icon;
    
    [self.imgView_logo mj_setImageWithURLString:logUrl placeholderImage:kMJSDKBannerGLPlaceholderImageName impAds:impAds success:nil failure:nil];
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
{
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

}
#pragma mark - imgView_logo
- (UIImageView *)imgView_logo
{
    if(!_imgView_logo){
        _imgView_logo = [[UIImageView alloc]init];
        _imgView_logo.layer.masksToBounds = YES;
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
        [_lab_title setFont:[UIFont systemFontOfSize:18.f]];
        [_lab_title setTextAlignment:NSTextAlignmentLeft];
    }
    
    return _lab_title;
}
#pragma mark - lab_detail
- (UILabel *)lab_detail
{
    if(!_lab_detail){
    
        _lab_detail = [[UILabel alloc]init];
        [_lab_detail setFrame:CGRectZero];
        [_lab_detail setTextColor:[UIColor  colorFromHexString:@"#878787"]];
        [_lab_detail setFont:[UIFont systemFontOfSize:10.f]];
        [_lab_detail setTextAlignment:NSTextAlignmentLeft];
        
    }
    
    return _lab_detail;
}

@end
