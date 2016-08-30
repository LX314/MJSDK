//
//  MJIMGInterstitial.m
//  sdk-ADView
//
//  Created by John LXThyme on 16/5/20.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#import "MJIMGInterstitial.h"

@interface MJIMGInterstitial ()
{
    
}
/** <#注释#>*/
@property (nonatomic,retain)UIImageView *imgView;


@end
@implementation MJIMGInterstitial
- (void)setUp{
    [super setUp];
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.mjLabADLogo];
    [self.contentView addSubview:self.btnClose];
    MASAttachKeys(self.imgView, self.mjLabADLogo, self.btnClose);
}
- (void)fill:(MJImpAds *)impAds {
    MJElement *mjelement = impAds.bannerAds.mjElement;
    NSString *imgUrl = mjelement.image;
    [self.imgView mj_setImageWithURLString:imgUrl placeholderImage:[UIImage imageNamed:kMJSDKInterstitialIMGPlaceholderImageName] impAds:impAds success:nil failure:nil];
//    [self.imgView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:kMJSDKInterstitialIMGPlaceholderImageName]];
}

#pragma mark -
#pragma mark - Masonry Methods
//- (void)updateConstraints{
//    [super updateConstraints];
//    //
//    [self masonry];
//}
- (void)masonry
{//
    [super masonry];
    UIView *superView = self.contentView;
    //
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(superView);
    }];
    [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
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



#pragma mark - imgView
- (UIImageView *)imgView
{
    if(!_imgView){
        _imgView = [[UIImageView alloc]init];
        [_imgView setImage:[UIImage imageNamed:@""]];
        [_imgView setContentMode:UIViewContentModeScaleAspectFill];
    }
    
    return _imgView;
}

@end
