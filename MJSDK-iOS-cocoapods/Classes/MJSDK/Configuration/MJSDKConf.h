//
//  MJSDKConfig.h
//  MJSDK-iOS
//
//  Created by WM on 16/8/10.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LXIPManager.h"

/** Global*/
UIKIT_EXTERN NSString *kMJAppsAPPKey;

#define kMJAppsIDFA @"111"// [LXIPManager manager].idfa
/** 微信分享*/
UIKIT_EXTERN NSString *MJWeChatAppID;
UIKIT_EXTERN NSString *MJWeChatAppSecret;

/** 广告占位图 */
UIKIT_EXTERN NSString *kMJSDKBannerIMGPlaceholderImageName;
UIKIT_EXTERN NSString *kMJSDKBannerGLPlaceholderImageName;
UIKIT_EXTERN NSString *kMJSDKInterstitialGLPlaceholderImageName;
UIKIT_EXTERN NSString *kMJSDKInterstitialIMGPlaceholderImageName;
UIKIT_EXTERN NSString *kMJSDKInlineGLPlaceholderImageName;
UIKIT_EXTERN NSString *kMJSDKInlineIMGPlaceholderImageName;
UIKIT_EXTERN NSString *kMJSDKHalfScreenGLPlaceholderImageName;
UIKIT_EXTERN NSString *kMJSDKFullScreenIMGPlaceholderImageName;
UIKIT_EXTERN NSString *kMJSDKAPPREShowIMGPlaceholderImageName;
UIKIT_EXTERN NSString *kMJSDKAPPRELogoIMGPlaceholderImageName;

/*************_配置项[1]_*************/
UIKIT_EXTERN NSDate *kMJSDKInternetBJDate;
UIKIT_EXTERN BOOL kMJPreLoadData;
UIKIT_EXTERN BOOL kMJSDKDebugStyle;
/** 默认广告版本号*/
UIKIT_EXTERN CGFloat kMJSDKGlobalConfVersion;
UIKIT_EXTERN CGFloat kMJSDKCurrentDefaultADVersion;
UIKIT_EXTERN NSInteger kMJSDKRequestADCount;
UIKIT_EXTERN NSInteger kMJSDKBannerRequestCount;
UIKIT_EXTERN NSInteger kMJSDKInterstitalRequestCount;
UIKIT_EXTERN NSInteger kMJSDKInlineRequestCount;
UIKIT_EXTERN NSInteger kMJSDKAppsRequestCount;
UIKIT_EXTERN NSInteger kMJSDKFullOpenScreenRequestCount;

UIKIT_EXTERN CGFloat kMJSDKScrollInterval;
UIKIT_EXTERN CGFloat kMJSDKExposureTimeInterval;

#pragma mark - kLXTEST
UIKIT_EXTERN NSInteger kLXTEST;

#pragma mark - Coupon
/*************_配置项[2]_*************/
/** 是否显示优惠券*/
UIKIT_EXTERN BOOL kMJSDKShouldDisplayCoupon;
/** 是否优惠券商品可以点击*/
UIKIT_EXTERN BOOL kMJSDKIsCouponAdClickable;
/** 是否再次显示优惠券信息页*/
UIKIT_EXTERN BOOL kMJSDKDisplayCouponAgain;

#pragma mark -
#pragma mark - [Keychain]Account||Service
#pragma mark - MJShare Tel
/** 手机号(优惠券)[SSKeychain]*/
#define kMJShareTelKey @"kMJShareTelKey"
#define kMJShareDateKey @"kMJShareDateKey"
#define kMJShareTelNumberAccountNew [NSString stringWithFormat:@"%@-kMJShareTelNumberAccountNew", kMJAppsIDFA]
#define kMJShareTelNumberServiceNew [NSString stringWithFormat:@"%@-kMJShareTelNumberServiceNew", kMJAppsAPPKey]

#define kMJShareTelNumberAccountModify [NSString stringWithFormat:@"%@-kMJShareTelNumberAccountModify", kMJAppsIDFA]
#define kMJShareTelNumberServiceModify [NSString stringWithFormat:@"%@-kMJShareTelNumberServiceModify", kMJAppsAPPKey]

#pragma mark - [APPs]已分享数据库
#define kMJAPPsHasSharedAccount [NSString stringWithFormat:@"%@-kMJAPPsHasSharedAccount", kMJAppsIDFA]
#define kMJAPPsHasSharedService [NSString stringWithFormat:@"%@-kMJAPPsHasSharedService", kMJAppsIDFA]

#pragma mark - 异常上报数据库[离线]
#define kMJSDKEXCEPTIONREPORTService [NSString stringWithFormat:@"%@-MJSDKEXCEPTIONREPORT", kMJAppsAPPKey]
#define kMJSDKEXCEPTIONREPORTAccount [NSString stringWithFormat:@"%@-MJSDKEXCEPTIONREPORT", kMJAppsIDFA]

#pragma mark - 曝光数据库[离线]
#define kMJSDKEXPOSUREREPORTService [NSString stringWithFormat:@"%@-MJSDKEXPOSUREREPORT", kMJAppsAPPKey]
#define kMJSDKEXPOSUREREPORTAccount [NSString stringWithFormat:@"%@-MJSDKEXPOSUREREPORT", kMJAppsIDFA]

#pragma mark - 全局配置数据库
#define kMJAppsGlobalConfigurationService [NSString stringWithFormat:@"%@-MJSDK", kMJAppsAPPKey]
#define kMJAppsGlobalConfigurationAccount [NSString stringWithFormat:@"%@-MJSDK", kMJAppsIDFA]

#pragma mark - 开屏广告存储
#define kMJSDKFullScreenPreLoadedMJResponseDataService [NSString stringWithFormat:@"%@-kMJSDKFullScreenPreLoadedMJResponseDataService", kMJAppsAPPKey]
#define kMJSDKFullScreenPreLoadedMJResponseDataAccount [NSString stringWithFormat:@"%@-kMJSDKFullScreenPreLoadedMJResponseDataAccount", kMJAppsIDFA]

#pragma mark - 半屏广告存储
#define kMJSDKHalfScreenPreLoadedMJResponseDataService [NSString stringWithFormat:@"%@-kMJSDKHalfScreenPreLoadedMJResponseDataService", kMJAppsAPPKey]
#define kMJSDKHalfScreenPreLoadedMJResponseDataAccount [NSString stringWithFormat:@"%@-kMJSDKHalfScreenPreLoadedMJResponseDataAccount", kMJAppsIDFA]

@interface MJSDKConf : NSObject
{

}

+ (instancetype)manager;

@end
