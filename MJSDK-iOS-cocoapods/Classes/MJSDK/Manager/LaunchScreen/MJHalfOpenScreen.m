//
//  MJHalfOpenScreen.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/8.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJHalfOpenScreen.h"

#import "MJSDKConf.h"
#import "UIImageView+placeholder.h"


@interface MJHalfOpenScreen ()
{
    UIImage *_img_halfOpenLogo;
    NSString *_str_copyRight;
}
/** <#注释#>*/
@property (nonatomic,retain)UIImageView *imgView_logo;
/** <#注释#>*/
@property (nonatomic,retain)UILabel *lab_description;

@end
@implementation MJHalfOpenScreen
/**
 *  初始化半屏
 *
 *  @param adSpaceID 广告位 ID
 *  @param ico       ico
 *  @param coptRight coptRight description
 *
 *  @return instancetype
 */
- (instancetype)initWithAdSpaceID:(NSString *)adSpaceID ico:(UIImage *)ico copyRight:(NSString *)copyRight {
    NSAssert(ico && [ico isKindOfClass:[UIImage class]], @"ico 不正确!");
    NSAssert(copyRight && copyRight.length > 1 &&copyRight.length <= 50, @"copyRight 不正确");
    if (self = [super initWithAdSpaceID:adSpaceID]) {
        self.adType = KMJADOpenHalfScreenInternalType;
        self.openScreenStyle = KMJOpenScreen900Style;
//        _img_halfOpenLogo = [UIImage imageNamed:@"halfLogo"];
//        _str_copyRight = @"Copyright © 2016年 WM. All rights reserved.";
        _img_halfOpenLogo = ico;
        _str_copyRight = copyRight;
        [self.imgView_logo setImage:_img_halfOpenLogo];
        [self.lab_description setText:_str_copyRight];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.adType = KMJADOpenHalfScreenInternalType;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.imgView_logo];
    [self.view addSubview:self.lab_description];
    MASAttachKeys(self.imgView_logo,self.lab_description);
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    
}
- (void)fill:(MJImpAds *)impAds {
    MJElement *mjEelements = impAds.bannerAds.mjElement;
    NSString * imageFullUrl = mjEelements.image;

    [self.imgView mj_setImageWithURLString:imageFullUrl placeholderImage:[UIImage imageNamed:kMJSDKHalfScreenGLPlaceholderImageName]  impAds:nil success:nil failure:nil];
}
#pragma mark -
#pragma mark - Masonry Methods
- (void)masonry
{
    [super masonry];
    //
    UIView *superView = self.view;
    //
    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.left.right.equalTo(superView);
//        make.height.equalTo(@(roundf([UIScreen mainScreen].bounds.size.width * 3 / 2)));
        make.bottom.equalTo(self.imgView_logo.mas_top).offset(-15.f);
    }];
    [self.imgView_logo mas_remakeConstraints:^(MASConstraintMaker *make) {
        //
        make.bottom.equalTo(self.lab_description.mas_top).offset(-8.f);
        make.size.mas_equalTo(CGSizeMake(90.f, 38.f));
        make.centerX.equalTo(superView);
    }];
    [self.lab_description mas_remakeConstraints:^(MASConstraintMaker *make) {
        //
        make.bottom.equalTo(superView).offset(-15.f);
        make.centerX.equalTo(superView);
        make.height.equalTo(@16.f);
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
#pragma mark - lab_description
- (UILabel *)lab_description
{
    if(!_lab_description){
        //初始化一个 Label
        _lab_description = [[UILabel alloc]init];
        [_lab_description setFrame:CGRectZero];
        [_lab_description setText:@"Copyright © 2016年 WM. All rights reserved."];
        [_lab_description setTextColor:[UIColor colorFromHexString:@"#787878"]];
        [_lab_description setFont:[UIFont systemFontOfSize:12.f]];
    }
    
    return _lab_description;
}


@end
