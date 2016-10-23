//
//  MJIMGInlineBanner.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/8.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJIMGInline.h"

#import "MJImpAds.h"
#import "MJElement.h"
#import "MJBannerAds.h"

@interface MJIMGInline ()
{
    
}
/** <#注释#>*/
@property (nonatomic,retain)UIImageView *imgView;

@end
@implementation MJIMGInline
- (void)setUp {
    [super setUp];
    [self.contentView addSubview:self.imgView];
    MASAttachKeys(self.imgView);
    [self initial];
}
- (void)initial {
    [self setBackgroundColor:[UIColor whiteColor]];
}
- (void)fill:(MJImpAds *)impAds {
    
    MJElement *mjelement = impAds.bannerAds.mjElement;
    self.mjElement = mjelement;
    NSString *imgUrl = mjelement.image;

    [self.imgView mj_setImageWithURLString:imgUrl placeholderImage:kMJSDKInlineIMGPlaceholderImageName impAds:impAds success:nil failure:nil];

}

#pragma mark -
#pragma mark - Masonry Methods
- (void)masonry
{
    [super masonry];
    UIView *superView = self.contentView;
    CGFloat padding = 5;
    UIEdgeInsets edge = UIEdgeInsetsMake(padding, padding, padding, padding);

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
