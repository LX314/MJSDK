//
//  MJBanner.m
//  sdk-ADView
//
//  Created by John LXThyme on 16/5/13.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#import "MJIMGBanner.h"

#import "MJImpAds.h"
#import "MJElement.h"
#import "MJBannerAds.h"

@interface MJIMGBanner ()
{
    
}
@property (nonatomic,retain)UIImageView *imgView_banner;
@end

@implementation MJIMGBanner
- (void)setUp{
    [super setUp];
    [self.contentView addSubview:self.imgView_banner];
    MASAttachKeys(self.imgView_banner);
    
}
- (void)clear {

}
- (void)fill:(MJImpAds *)impAds {
    MJElement *mjelement = impAds.bannerAds.mjElement;
    NSString *imgUrl = mjelement.image;

    [self.imgView_banner mj_setImageWithURLString:imgUrl placeholderImage:kMJSDKBannerIMGPlaceholderImageName impAds:impAds success:nil failure:nil];
}

#pragma mark -
#pragma mark - Masonry Methods
- (void)masonry
{
    [super masonry];
    UIView *superView = self.contentView;
    
    [self.imgView_banner mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(superView);
    }];

}
#pragma mark - imgView_banner
- (UIImageView *)imgView_banner
{
    if(!_imgView_banner){
        _imgView_banner = [[UIImageView alloc]init];
        [_imgView_banner setContentMode:UIViewContentModeScaleAspectFill];
        _imgView_banner.layer.masksToBounds = YES;
    }
    
    return _imgView_banner;
}
@end
