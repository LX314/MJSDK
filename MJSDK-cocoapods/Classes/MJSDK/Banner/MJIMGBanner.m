//
//  MJBanner.m
//  sdk-ADView
//
//  Created by John LXThyme on 16/5/13.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#import "MJIMGBanner.h"

@interface MJIMGBanner ()
{
    
}
@end

@implementation MJIMGBanner
- (void)setUp{
    [super setUp];
    [self.contentView addSubview:self.imgView_banner];
    [self.contentView addSubview:self.mjLabADLogo];
    [self.contentView addSubview:self.btnClose];
    MASAttachKeys(self.imgView_banner, self.mjLabADLogo, self.btnClose);
    
}
- (void)clear {
    [self.mjLabADLogo setText:@" 广告 "];
    [self.imgView_banner setImage:[UIImage imageNamed:@"横幅banner样式"]];
}
- (void)fill:(MJImpAds *)impAds {
    MJElement *mjelement = impAds.bannerAds.mjElement;
    NSString *imgUrl = mjelement.image;
//
    [self.imgView_banner mj_setImageWithURLString:imgUrl placeholderImage:[UIImage imageNamed:kMJSDKBannerIMGPlaceholderImageName] impAds:impAds success:nil failure:nil];
//    [self.imgView_banner setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:kMJSDKBannerIMGPlaceholderImageName]];
}

#pragma mark -
#pragma mark - Masonry Methods
- (void)updateConstraints {
    [super updateConstraints];
    //
    [self masonry];
}
- (void)masonry
{//
    [super masonry];
    UIView *superView = self.contentView;
    
    [self.imgView_banner mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(superView);
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
#pragma mark - imgView_banner
- (UIImageView *)imgView_banner
{
    if(!_imgView_banner){
        _imgView_banner = [[UIImageView alloc]init];
//        [_imgView_banner setImage:[UIImage imageNamed:@"横幅banner样式"]];
        [_imgView_banner setContentMode:UIViewContentModeScaleAspectFill];
        _imgView_banner.layer.masksToBounds = YES;
    }
    
    return _imgView_banner;
}
@end
