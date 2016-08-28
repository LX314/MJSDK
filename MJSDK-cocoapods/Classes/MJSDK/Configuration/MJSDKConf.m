//
//  MJSDKConfig.m
//  MJSDK-iOS
//
//  Created by WM on 16/8/10.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJSDKConf.h"

#import "LXIPManager.h"
#import "MJTool.h"
/**
 *  @brief APPKey
 *
 *  com.lxthyme.mjsdkkkkk   --->    b3eb5bfe-8f7d-4e5b-9626-fcbbb8895a88
 *  com.mj.mjsdk                    --->    a978f94d-ead9-485e-a4dc-6bdd6c8d7d7f
 *
 */
const NSString *kMJAppsAPPKey = @"";

/** 微信分享*/
const NSString *MJWeChatAppID = @"wxfec3a696d78c42a5";
const NSString *MJWeChatAppSecret = @"513155cff101fb9def0b18d844dfce39";

BOOL kMJPreLoadData = NO;
BOOL kMJSDKDebugStyle = 1;

/** 广告占位图*/
const NSString *kMJSDKBannerIMGPlaceholderImageName = @"图片加载失败-3";
const NSString *kMJSDKBannerGLPlaceholderImageName = @"图片加载失败-7";
const NSString *kMJSDKInterstitialGLPlaceholderImageName = @"图片加载失败-7";
const NSString *kMJSDKInterstitialIMGPlaceholderImageName = @"图片加载失败-2";
const NSString *kMJSDKInlineGLPlaceholderImageName = @"图片加载失败-4";
const NSString *kMJSDKInlineIMGPlaceholderImageName = @"图片加载失败-5";
const NSString *kMJSDKHalfScreenGLPlaceholderImageName = @"开屏样式-640x960(1).jpg";
const NSString *kMJSDKFullScreenIMGPlaceholderImageName = @"开屏样式(全屏).jpg";
const NSString *kMJSDKAPPREShowIMGPlaceholderImageName = @"图片加载失败-1";
const NSString *kMJSDKAPPRELogoIMGPlaceholderImageName = @"图片加载失败-6";

//请求广告的数量
/** int 当前设置版本号*/
CGFloat kMJSDKGlobalConfVersion = 0;
/** int 默认广告版本号*/
CGFloat kMJSDKCurrentDefaultADVersion = 1.0;
/** int 一次广告请求数*/
NSInteger kMJSDKRequestADCount = 5;
/** */
NSInteger kMJSDKBannerRequestCount = 5;
/** */
NSInteger kMJSDKInterstitalRequestCount = 5;
/** */
NSInteger kMJSDKInlineRequestCount = 5;
/** */
NSInteger kMJSDKAppsRequestCount = 10;
/** */
NSInteger kMJSDKFullOpenScreenRequestCount = 1;

/** long 轮播时间(ms)*/
CGFloat kMJSDKScrollInterval = 30000.f / 1000.f;
/** long 曝光时间(ms)*/
CGFloat kMJSDKExposureTimeInterval = 200.f / 1000.f;

/** */
NSInteger kLXTEST;
/** boolean 是否显示优惠券*/
BOOL kMJSDKShouldDisplayCoupon;
/** 是否优惠券商品可以点击*/
BOOL kMJSDKIsCouponAdClickable;
/** 是否再次显示优惠券信息页*/
BOOL kMJSDKDisplayCouponAgain;

const NSDate *kMJSDKInternetBJDate = nil;

@implementation MJSDKConf

+ (instancetype)manager {
    static MJSDKConf *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[[self class] alloc]init];
        [_manager initial];
    });

    return _manager;
}
- (void)initial {
    kMJSDKInternetBJDate = [MJTool getBJDate];
}
@end
