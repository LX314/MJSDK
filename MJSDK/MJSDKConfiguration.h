//
//  MJSDKConfiguration.h
//  sdk-ADView
//
//  Created by John LXThyme on 16/5/20.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#ifndef MJSDKConfiguration_h
#define MJSDKConfiguration_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MJSDKConf.h"

#pragma mark API
//proto api
//#define kMJSDKProtoAPI @"http://r.mjmobi.com/sdk?pf=ios&sv=iOS_v1.0.0"
#define kMJSDKProtoAPI @"http://r.sb.mjmobi.com/sdk?pf=ios&sv=iOS_v1.0.0"
//全局配置接口
//#define kMJSDKGlobalConfAPI @"http://r.mjmobi.com/conf?v=default"
#define kMJSDKGlobalConfAPI @"http://r.sb.mjmobi.com/conf?v=default"
/** 异常上报接口*/
//#define kMJSDKErrorReportAPI @"http://e.mjmobi.com/err"
#define kMJSDKErrorReportAPI @"http://e.sb.mjmobi.com/err"
/** 离线曝光接口*/
//#define kMJSDKOfflineExposureAPI @"http://e.mjmobi.com/imp/off"
#define kMJSDKOfflineExposureAPI @"http://e.sb.mjmobi.com/imp/off"
/** 优惠券查询接口*/
//#define kMJSDKCouponQueryAPI @"http://v.mjmobi.com/cq"
#define kMJSDKCouponQueryAPI @"http://v.sb.mjmobi.com/cq"
/** 优惠券领取接口*/
//#define kMJSDKCouponClaimAPI @"http://v.mjmobi.com/cc"
#define kMJSDKCouponClaimAPI @"http://v.sb.mjmobi.com/cc"
/** 手机号修改接口*/
//#define kMJSDKCouponUpdateAPI @"http://v.mjmobi.com/cu"
#define kMJSDKCouponUpdateAPI @"http://v.sb.mjmobi.com/cu"
/** 道具查询接口*/
//#define kMJSDKPropQueryAPI @"http://v.mjmobi.com/pq"
#define kMJSDKPropQueryAPI @"http://v.sb.mjmobi.com/pq"
/** 道具领取接口*/
//#define kMJSDKPropClaimAPI @"http://v.mjmobi.com/pc"
#define kMJSDKPropClaimAPI @"http://v.sb.mjmobi.com/pc"
#pragma mark - [GPS]Location Geo
static double MJJLongitude = 0;
static double MJJLatitude = 0;


#pragma mark - Notification
#define kMJSDKDidSIMBannerClosedNotification @"kMJSDKDidSIMBannerClosedNotification"
#pragma mark - Global
#define kIOSVersion [[[UIDevice currentDevice]systemVersion]floatValue]

#define kVarName(__XXX__) #__XXX__

//request timeout
#define kMJSDKTimeoutInterval 30.f

//系统状态栏,导航栏高度
static CGFloat systemHeight = 0.f;
static CGFloat kADBannerHeight = 50.f;
static CGFloat kMJInlineHeight = 100.f;
#define kMJInterstitialFullScreenBounds kMainScreen
#define kMJInterstitialHalfScreenBounds CGRectMake(0, 0, 300.f, 250.f)

#pragma mark - 
#define kMJOpenScreenTimerInterval 5.f

#pragma mark - mjSuperiew
#define kMJSuperview ({\
UIWindow *mjSuperView;\
UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;\
mjSuperView = keyWindow;\
mjSuperView;\
})
//static UIWindow *mjSuperview()
//{
////#warning TODO
//    id mjSuperView;
//    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
//    mjSuperView = keyWindow;
//    return mjSuperView;
//}
#define kMJNSLocalizedString(__name__, __comment__)  ({\
NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"MJSDK" ofType:@"bundle"];\
NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];\
NSLocalizedStringFromTableInBundle(__name__, @"Localizable", bundle, __comment__);\
})
//static NSString *kMJNSLocalizedString(NSString *key, NSString *comment) {
//    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"MJSDK" ofType:@"bundle"];
//    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
//    return NSLocalizedStringFromTableInBundle(key, @"Localizable", bundle, comment);
//}
#pragma mark - Banner
/** 类 banner 位于屏幕中的位置
 *  KMJBannerPositionTop: 顶部
 *  KMJBannerPositionBottom: 底部
 *  KMJBannerPositionLeft: 左边<不可用>
 *  KMJBannerPositionRight: 右边<不可用>
 *  KMJBannerPositionCenter:  center<不可用>
 *  KMJBannerPositionCustom: 自定义<不可用>
 */
typedef NS_ENUM(NSInteger, KMJBannerPosition) {
    KMJBannerPositionTop = 0,
    KMJBannerPositionBottom = 1,
    KMJBannerPositionLeft = 2,
    KMJBannerPositionRight = 3,
    KMJBannerPositionCenter = 4,
    KMJBannerPositionCustom = 5
};
typedef enum : NSUInteger {
    kMJTimerUnKnownStatus,
    kMJTimerResumedStatus,
    kMJTimerSuspendStatus,
    kMJTimerCanceledStatus,
} kMJTimerStatus;
#pragma mark - AppsWall
/** kMJSDKTargetType
 *
 *  kMJSDKTargetType_NORMAL_LINK: 普通链接 （跳转）
 *  kMJSDKTargetType_WALL_SHARE_LINK: 墙类分享型+链接 （分享）
 *  kMJSDKTargetType_BANNER_SHARE_LINK: 横幅分享型+链接（分享）
 *  kMJSDKTargetType_TYPE_MP_MENU_LINK: 微信公众号菜单入口+链接 （用户定义的LANDING PAGE）
 *  kMJSDKTargetType_MP_GOODS_LINK = 5: 微信公众号菜单入口+商品聚合页链接
 */
typedef NS_ENUM(NSInteger, kMJSDKTargetType) {
    kMJSDKTargetType_NORMAL_LINK = 1,//普通链接 （跳转）
    kMJSDKTargetType_WALL_SHARE_LINK = 2,//墙类分享型+链接 （分享）
    kMJSDKTargetType_BANNER_SHARE_LINK = 3,//横幅分享型+链接（分享）
    kMJSDKTargetType_TYPE_MP_MENU_LINK = 4,//微信公众号菜单入口+链接 （用户定义的LANDING PAGE）
    kMJSDKTargetType_MP_GOODS_LINK = 5,////微信公众号菜单入口+商品聚合页链接
};
/** 应用墙[AppsWall]应用列表状态
 *
 *  kMJAPPSContentUnknownState
 *  kMJAPPSContentNormallyState: 正常状态
 *  kMJAPPSContentFriendUIState: 1`无数据.2`分享次数不足
 *  kMJAPPSContentNOTAvailableState: 应用墙处于已分享状态
 */
typedef NS_ENUM(NSInteger, kMJAPPSContentState) {
    kMJAPPSContentUnknownState,
    kMJAPPSContentNormallyState,//normal state
    kMJAPPSContentFriendUIState,//not data
    kMJAPPSContentNOTAvailableState,//not available state
};
#pragma mark - ADTypes
typedef NS_ENUM(NSInteger, KMJADType) {
    KMJADUnknownType = 0,

    KMJADBannerInternalType = 111,
    KMJADBannerIMGType = 3,
    KMJADBannerGLType = 1,

    KMJADInterstitialInternalType = 222,
    KMJADInterstitialIMGType = 7,
    KMJADInterstitialGLType = 5,

    KMJADInlineInternalType = 333,
    KMJADInlineIMGType = 9,
    KMJADInlineGLType = 11,
    KMJADInlineIMGShareType = 14,
    KMJADInlineGLShareType = 18,

    KMJADOpenFullScreenInternalType = 444,
    KMJADOpenHalfScreenInternalType = 555,
    KMJADOpenFullScreenType = 17,
    KMJADOpenHalfScreenType = 19,

    KMJADAppsType = 666,
    KMJAPPsTypeLA = 113,
    KMJAPPsTypeRE = 13,
};
//static NSString *KNSStringFromMJADType(KMJADType adType) {
//    static NSDictionary *dict;
//    dict= @{
//            @(KMJADUnknownType):@"KMJADUnknownType",
//            @(KMJADBannerInternalType):@"KMJADBannerInternalType",
//            @(KMJADBannerIMGType):@"KMJADBannerIMGType",
//            @(KMJADBannerGLType):@"KMJADBannerGLType",
//            @(KMJADInterstitialInternalType):@"KMJADInterstitialInternalType",
//            @(KMJADInterstitialIMGType):@"KMJADInterstitialIMGType",
//            @(KMJADInterstitialGLType):@"KMJADInterstitialGLType",
//            @(KMJADInlineInternalType):@"KMJADInlineInternalType",
//            @(KMJADInlineIMGType):@"KMJADInlineIMGType",
//            @(KMJADInlineGLType):@"KMJADInlineGLType",
//            @(KMJADInlineIMGShareType):@"KMJADInlineIMGShareType",
//            @(KMJADInlineGLShareType):@"KMJADInlineGLShareType",
//            @(KMJADOpenFullScreenInternalType):@"KMJADOpenFullScreenInternalType",
//            @(KMJADOpenHalfScreenInternalType):@"KMJADOpenHalfScreenInternalType",
//            @(KMJADOpenFullScreenType):@"KMJADOpenFullScreenType",
//            @(KMJADOpenHalfScreenType):@"KMJADOpenHalfScreenType",
//            @(KMJAPPsTypeLA):@"KMJAPPsTypeLA",
//            @(KMJAPPsTypeRE):@"KMJAPPsTypeRE",
//            @(KMJADAppsType):@"KMJADAppsType",
//            };
//    return dict[@(adType)];
//}
#define KNSStringFromMJADType(__adType__) ({\
    static NSDictionary *dict;\
    dict= @{\
            @(KMJADUnknownType):@"KMJADUnknownType",\
    @(KMJADBannerInternalType):@"KMJADBannerInternalType",\
            @(KMJADBannerIMGType):@"KMJADBannerIMGType",\
            @(KMJADBannerGLType):@"KMJADBannerGLType",\
    @(KMJADInterstitialInternalType):@"KMJADInterstitialInternalType",\
            @(KMJADInterstitialIMGType):@"KMJADInterstitialIMGType",\
            @(KMJADInterstitialGLType):@"KMJADInterstitialGLType",\
            @(KMJADInlineInternalType):@"KMJADInlineInternalType",\
            @(KMJADInlineIMGType):@"KMJADInlineIMGType",\
            @(KMJADInlineGLType):@"KMJADInlineGLType",\
            @(KMJADInlineIMGShareType):@"KMJADInlineIMGShareType",\
            @(KMJADInlineGLShareType):@"KMJADInlineGLShareType",\
            @(KMJADOpenFullScreenInternalType):@"KMJADOpenFullScreenInternalType",\
            @(KMJADOpenHalfScreenInternalType):@"KMJADOpenHalfScreenInternalType",\
            @(KMJADOpenFullScreenType):@"KMJADOpenFullScreenType",\
            @(KMJADOpenHalfScreenType):@"KMJADOpenHalfScreenType",\
            @(KMJAPPsTypeLA):@"KMJAPPsTypeLA",\
            @(KMJAPPsTypeRE):@"KMJAPPsTypeRE",\
            @(KMJADAppsType):@"KMJADAppsType",\
            };\
dict[@(__adType__)];\
})
#pragma mark - kMainScreen
/**
 *  适配
 */
# define kMainScreen [[UIScreen mainScreen]bounds]
# define kMainScreen_size kMainScreen.size
# define kMainScreen_center CGPointMake(CGRectGetMidX(kMainScreen), CGRectGetMidY(kMainScreen))

# define kMainScreen_width kMainScreen.size.width
# define kMainScreen_height kMainScreen.size.height

# define kMainScreen_suitWidth (kMainScreen_width < kMainScreen_height ? kMainScreen_width : kMainScreen_height)
# define kMainScreen_suitHeight (kMainScreen_height > kMainScreen_width ? kMainScreen_height : kMainScreen_width)
#define WEAKSELF typeof(self) __weak weakSelf = self; //weak self for block
#define STRONGSELF  __strong __typeof(weakSelf) strongSelf = weakSelf;

#pragma mark - 打印日志
#define MJNSLog(format, ...)                                      \
if(kMJSDKDebugStyle) {                                          \
do {                                                                          \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0);                                                                        \
}
//重写NSLog,Debug模式下打印日志和当前行数
#ifndef NSLog
#if DEBUG
#define NSLog(format, ...) do {                                                                          \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0);
#else
#define NSLog(...) {}
#endif
#endif
#pragma mark -
#pragma mark - Others
#pragma mark - 遮罩类型
typedef NS_ENUM(NSUInteger, LXMJViewMaskType) {
    LXMJViewMaskTypeNone = 1,
    LXMJViewMaskTypeClear,
    LXMJViewMaskTypeBlack,
    LXMJViewMaskTypeGradient,
    LXMJViewMaskTypeCustom
};
#endif /* MJSDKConfiguration_h */
