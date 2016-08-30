//
//  MJIMGInlineBanner.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/8.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJIMGInline.h"

@interface MJIMGInline ()
{
    
}
/** <#注释#>*/
@property (nonatomic,retain)UIImageView *imgView;

@end
@implementation MJIMGInline
- (void)setUp {
    [super setUp];
    //
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.mjLabADLogo];
    MASAttachKeys(self.mjLabADLogo, self.imgView);
    //
    [self initial];
}
- (void)initial {
    [self setBackgroundColor:[UIColor whiteColor]];
}
- (void)fill:(MJImpAds *)impAds {
    MJElement *mjelement = impAds.bannerAds.mjElement;
    self.mjElement = mjelement;
    [self.btnClose removeFromSuperview];
    NSString *imgUrl = mjelement.image;

    [self.imgView mj_setImageWithURLString:imgUrl placeholderImage:[UIImage imageNamed:kMJSDKInlineIMGPlaceholderImageName] impAds:impAds success:nil failure:nil];
//    [self.imgView setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:kMJSDKInlineIMGPlaceholderImageName]];

}

#pragma mark -
#pragma mark - Masonry Methods


#pragma mark -
#pragma mark - Masonry Methods
- (void)masonry
{//[self masonry];
    [super masonry];
    UIView *superView = self.contentView;
    CGFloat padding = 8;
    UIEdgeInsets edge = UIEdgeInsetsMake(padding, padding, padding, padding);
    [self.mjLabADLogo mas_remakeConstraints:^(MASConstraintMaker *make) {
        //
        make.right.bottom.equalTo(self.imgView);
    }];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(superView).insets(edge);
    }];
}
#pragma mark - imgView
- (UIImageView *)imgView
{
    if(!_imgView){
        _imgView = [[UIImageView alloc]init];
    }
    
    return _imgView;
}

@end
