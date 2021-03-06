//
//  MJBaseCell.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/5/31.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJBaseCell.h"

#import "MJImpAds.h"
#import "MJElement.h"
#import "MJBannerAds.h"

@interface MJBaseCell ()
{
    //数据是否正常
    BOOL _isNormal;
}
/** 曝光 URL*/
@property (nonatomic,copy)NSString *showURL;
@property (nonatomic,assign)NSInteger impression_seq_no;
/** 该 cell 的 indexPath*/
@property (nonatomic,retain)NSIndexPath *indexPath;

@property (nonatomic,retain)UILabel *lab_index;

@end
@implementation MJBaseCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
//        self.layer.borderColor = [UIColor colorWithRed:0.174 green:0.341 blue:0.000 alpha:1.000].CGColor;
//        self.layer.borderWidth = 2.f;
        //        self.layer.masksToBounds = YES;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self baseSetup];
    }
    return self;
}
- (void)baseSetup {
    [self setUp];
    [self.contentView addSubview:self.lab_index];
    MASAttachKeys(self.lab_index);
    [self masonry];
}
- (void)setUp{
    
}
- (void)layoutSubviews {
    [super layoutSubviews];
//    CGRect bounds = self.mjLabADLogo.bounds;
//    if (bounds.size.width <= 0) {
//        bounds = CGRectMake(0, 0, 26, 12);
//    }
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.mjLabADLogo.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.mjLabADLogo.layer.mask = maskLayer;
}
- (void)fillImpAds:(MJImpAds *)impAds indexPath:(NSIndexPath *)indexPath {
    MJBannerAds *bannerAds = impAds.bannerAds;
//    KMJADType mjAdType = bannerAds.mjAdType;
    MJElement *mjEelements = bannerAds.mjElement;
    //
    self.indexPath = indexPath;
    self.showURL = impAds.showUrl;
    self.impression_seq_no = impAds.impressionSeqNo;
    [self.lab_index setText:[@(indexPath.row) stringValue]];
    impAds.indexPath = indexPath;
    
    if (impAds.landingPageUrl) {
        mjEelements.mjLandingPageUrl = impAds.landingPageUrl;
    }
//    [self.mjLabADLogo setText:@" 广告 "];//[@(indexPath.row) stringValue]];
    //
    [self fill:impAds];
}
- (void)fill:(MJImpAds *)impAds {
//#warning TODO img has loaded normally?
}
- (void)updateMJBannerFrame{
//    CGRect statusBarFrame = [[UIApplication sharedApplication]statusBarFrame];
    UIViewController *rootVC = [[[UIApplication sharedApplication]keyWindow]rootViewController];
    CGRect navbarFrame = CGRectZero,
    tabbarFrame = CGRectZero;
    if ([rootVC isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav  = (UINavigationController *)rootVC;
        navbarFrame = nav.navigationBar.frame;
    } else if([rootVC isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabbar = (UITabBarController *)rootVC;
        tabbarFrame = tabbar.tabBar.frame;
    }
    CGFloat bannerTop = 0.f;
    CGRect bannerFrame = CGRectMake(0,
                                    bannerTop,
                                    CGRectGetWidth(kMainScreen),
                                    kADBannerHeight);
    [self setFrame:bannerFrame];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
//- (void)updateConstraints {
//    [super updateConstraints];
//    //
//    [self masonry];
//}
- (void)masonry{
//    [self.lab_index mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.contentView);
//    }];
}
//#pragma mark - btnClose
//- (UIButton *)btnClose
//{
//    if(!_btnClose){
//        
//        //初始化一个 Button
//        _btnClose = [MJFactory MJADClose];
//        //绑定事件
//        [_btnClose addTarget:self action:@selector(btnCloseClick:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    
//    return _btnClose;
//}
//- (void)btnCloseClick:(id)sender
//{
//    [[NSNotificationCenter defaultCenter]postNotificationName:kMJSDKDidSIMBannerClosedNotification object:self.superOwner];
//}
//#pragma mark - mjLabADLogo
//- (UILabel *)mjLabADLogo
//{
//    if(!_mjLabADLogo){
//        
//        _mjLabADLogo = [MJFactory MJADLogoLab];
//    }
//    
//    return _mjLabADLogo;
//}
#pragma mark - lab_index
- (UILabel *)lab_index
{
    if(!_lab_index){
        _lab_index = [[UILabel alloc]init];
        [_lab_index setFont:[UIFont systemFontOfSize:20.f]];
        [_lab_index setTextAlignment:NSTextAlignmentCenter];
        [_lab_index setBackgroundColor:[UIColor cyanColor]];
        [_lab_index setTextColor:[UIColor magentaColor]];
    }
    return _lab_index;
}

@end
