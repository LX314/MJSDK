//
//  MJSDKConfig.h
//  MJSDK-iOS
//
//  Created by WM on 16/8/10.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LXIPManager;

#pragma mark - Global
UIKIT_EXTERN NSString *kMJAppsAPPKey;

#define kMJAppsIDFA [LXIPManager manager].idfa

#pragma mark - 微信分享
UIKIT_EXTERN NSString *MJWeChatAppID;
UIKIT_EXTERN NSString *MJWeChatAppSecret;

#pragma mark - 广告占位图
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

#pragma mark - 广告SDK配置
UIKIT_EXTERN BOOL kMJPreLoadData;
UIKIT_EXTERN BOOL kMJSDKInternalDebugStyle;
UIKIT_EXTERN BOOL kMJSDKDebugStyle;

UIKIT_EXTERN NSString *kMJSDKADSpaceID;

#pragma mark - 全局配置
UIKIT_EXTERN CGFloat kMJSDKGlobalConfVersion;
UIKIT_EXTERN CGFloat kMJSDKCurrentDefaultADVersion;
UIKIT_EXTERN NSInteger kMJSDKRequestADCount;
UIKIT_EXTERN NSInteger kMJSDKBannerRequestCount;
UIKIT_EXTERN NSInteger kMJSDKInterstitialRequestCount;
UIKIT_EXTERN NSInteger kMJSDKInlineRequestCount;
UIKIT_EXTERN NSInteger kMJSDKAppsRequestCount;
UIKIT_EXTERN NSInteger kMJSDKFullOpenScreenRequestCount;
UIKIT_EXTERN CGFloat kMJSDKScrollInterval;
UIKIT_EXTERN CGFloat kMJSDKExposureTimeInterval;
UIKIT_EXTERN BOOL kMJSDKShouldDisplayCoupon;
UIKIT_EXTERN BOOL kMJSDKIsCouponAdClickable;
UIKIT_EXTERN BOOL kMJSDKDisplayCouponAgain;

#pragma mark - kLXTEST
UIKIT_EXTERN NSInteger kLXTEST;

#pragma mark - 类Banner网络请求的次数
UIKIT_EXTERN NSUInteger kMJSDKSIMBannerReloadCount;

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
