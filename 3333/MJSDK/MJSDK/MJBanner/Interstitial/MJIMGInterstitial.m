//
//  MJIMGInterstitial.m
//  sdk-ADView
//
//  Created by John LXThyme on 16/5/20.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#import "MJIMGInterstitial.h"

#import "MJImpAds.h"
#import "MJElement.h"
#import "MJBannerAds.h"

@interface MJIMGInterstitial ()
{
    
}


@end
@implementation MJIMGInterstitial
- (void)setUp{
    [super setUp];
    [self.contentView addSubview:self.imgView];
    MASAttachKeys(self.imgView);
}
- (void)fill:(MJImpAds *)impAds {
    
    MJElement *mjelement = impAds.bannerAds.mjElement;
    NSString *imgUrl = mjelement.image;
    [self.imgView mj_setImageWithURLString:imgUrl placeholderImage:kMJSDKInterstitialIMGPlaceholderImageName impAds:impAds success:nil failure:nil];
}

#pragma mark -
#pragma mark - Masonry Methods
- (void)masonry
{//
    [super masonry];
    UIView *superView = self.contentView;
    //
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(superView);
    }];
}

@end
