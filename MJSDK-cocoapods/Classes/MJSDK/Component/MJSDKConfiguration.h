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
#import "MJSDKUtils.h"

#pragma mark - /***************_Global_***************/
#define WEAKSELF typeof(self) __weak weakSelf = self; //weak self for block
#define STRONGSELF  __strong __typeof(self) strongSelf = weakSelf;

//proto api
#define kMJSDKProtoAPI @"http://121.41.5.152:8080/sdk?pf=ios&sv=iOS_v1.0.0"
//@"http://r.mjmobi.com/ios/sdkv1"
#define kMJSDKGlobalConfAPI @"http://121.41.5.152:8080/conf?v=default"
/** 异常上报接口*/
#define kMJSDKErrorReportAPI @"http://e.mjmobi.com/err"
/** 离线曝光接口*/
#define kMJSDKOfflineExposureAPI @"http://120.26.243.229:15000/imp/off"
/** 优惠券查询接口*/
#define kMJSDKCouponQueryAPI @"http://v.mjmobi.com/cq"
/** 优惠券领取接口*/
#define kMJSDKCouponClaimAPI @"http://v.mjmobi.com/cc"
/** 手机号修改接口*/
#define kMJSDKCouponUpdateAPI @"http://v.mjmobi.com/cu"
/** 道具查询接口*/
#define kMJSDKPropQueryAPI @"http://v.mjmobi.com/pq"
/** 道具领取接口*/
#define kMJSDKPropClaimAPI @"http://v.mjmobi.com/pc"


//request timeout
#define kMJSDKTimeoutInterval 30.f

//系统状态栏,导航栏高度
static CGFloat systemHeight = 0.f;
static CGFloat kADBannerHeight = 50.f;
static CGFloat kMJInlineHeight = 100.f;
#define kMJInterstitialFullScreenBounds kMainScreen
#define kMJInterstitialHalfScreenBounds CGRectMake(0, 0, 300.f, 250.f)

#pragma mark - /***************_Geo_***************/
static double MJJLongitude = 0;
static double MJJLatitude = 0;

#pragma mark - /***************_Base_***************/
#define kMJSDKDidBannerClosedNotification @"kMJSDKDidBannerClosedNotification"
#define kMJSDKDidInterstitialClosedNotification @"kMJSDKDidInterstitialClosedNotification"

#pragma mark - mjSuperiew
static UIWindow *mjSuperview()
{
#warning TODO
    id mjSuperView;
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    mjSuperView = keyWindow;
    [keyWindow setWindowLevel:UIWindowLevelAlert];
    return mjSuperView;
}

#pragma mark - /***************_targetType_***************/
typedef enum : NSUInteger {
    kMJSDKTargetType_NORMAL_LINK = 1,//普通链接 （跳转）
    kMJSDKTargetType_WALL_SHARE_LINK = 2,//墙类分享型+链接 （分享）
    kMJSDKTargetType_BANNER_SHARE_LINK = 3,//横幅分享型+链接（分享）
    kMJSDKTargetType_TYPE_MP_MENU_LINK = 4,//微信公众号菜单入口+链接 （用户定义的LANDING PAGE）
    kMJSDKTargetType_MP_GOODS_LINK = 5,////微信公众号菜单入口+商品聚合页链接
} kMJSDKTargetType;


#pragma mark - /***************_Banner Position_***************/
typedef NS_ENUM(NSInteger, KMJBannerPosition) {
    KMJBannerPositionTop = 0,
    KMJBannerPositionBottom = 1,
    KMJBannerPositionLeft = 2,
    KMJBannerPositionRight = 3,
    KMJBannerPositionCenter = 4,
    KMJBannerPositionCustom = 5
};

#pragma mark - /***************_APPs State_***************/
typedef enum : NSUInteger {
    kMJAPPSContentUnknownState,
    kMJAPPSContentNormallyState,
    kMJAPPSContentFriendUIState,
    kMJAPPSContentNOTAvailableState,
} kMJAPPSContentState;

#pragma mark - /***************_OpenScreen Style_***************/
typedef NS_ENUM(NSInteger, KMJOpenScreenStyle) {
    KMJOpenScreenUnknownStyle = 0,
    KMJOpenScreenFullScreenStyle = 1,
    KMJOpenScreen900Style = 2,
    KMJOpenScreen1200Style = 3
};

#pragma mark - /***************_遮罩类型_***************/
typedef NS_ENUM(NSUInteger, LXMJViewMaskType) {
    LXMJViewMaskTypeNone = 1,
    LXMJViewMaskTypeClear,
    LXMJViewMaskTypeBlack,
    LXMJViewMaskTypeGradient,
    LXMJViewMaskTypeCustom
};

#pragma mark - /***************_All ADTypes_***************/
typedef NS_ENUM(NSInteger, KMJADType) {
    KMJADUnknownType = 0,

    KMJADBannerInternalType = 111,
    KMJADBannerIMGType = 3,
    KMJADBannerGLType = 1,

    KMJADInterstitalInternalType = 222,
    KMJADInterstitalIMGType = 7,
    KMJADInterstitalGLType = 5,

    KMJADInlineInternalType = 333,
    KMJADInlineIMGType = 9,
    KMJADInlineGLType = 11,
    KMJADInlineIMGShareType = 14,
    KMJADInlineGLShareType = 18,

    KMJADOpenFullScreenInternalType = 444,
    KMJADOpenHalfScreenInternalType = 555,
    KMJADOpenFullScreenType = 17,
    KMJADOpenHalfScreenType = 19,

    KMJAPPsTypeLA = 113,
    KMJAPPsTypeRE = 13,
};

static NSString *KNSStringFromMJADType(KMJADType adType) {
    static NSDictionary *dict;
    dict= @{
            @(KMJADUnknownType):@"KMJADUnknownType",
            @(KMJADBannerInternalType):@"KMJADBannerInternalType",
            @(KMJADBannerIMGType):@"KMJADBannerIMGType",
            @(KMJADBannerGLType):@"KMJADBannerGLType",
            @(KMJADInterstitalInternalType):@"KMJADInterstitalInternalType",
            @(KMJADInterstitalIMGType):@"KMJADInterstitalIMGType",
            @(KMJADInterstitalGLType):@"KMJADInterstitalGLType",
            @(KMJADInlineInternalType):@"KMJADInlineInternalType",
            @(KMJADInlineIMGType):@"KMJADInlineIMGType",
            @(KMJADInlineGLType):@"KMJADInlineGLType",
            @(KMJADInlineIMGShareType):@"KMJADInlineIMGShareType",
            @(KMJADInlineGLShareType):@"KMJADInlineGLShareType",
            @(KMJADOpenFullScreenInternalType):@"KMJADOpenFullScreenInternalType",
            @(KMJADOpenHalfScreenInternalType):@"KMJADOpenHalfScreenInternalType",
            @(KMJADOpenFullScreenType):@"KMJADOpenFullScreenType",
            @(KMJADOpenHalfScreenType):@"KMJADOpenHalfScreenType",
            @(KMJAPPsTypeLA):@"KMJAPPsTypeLA",
            @(KMJAPPsTypeRE):@"KMJAPPsTypeRE",
            };
    return dict[@(adType)];
}

#pragma mark -
#pragma mark - Macro
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

#define kIOSVersion [[[UIDevice currentDevice]systemVersion]floatValue]

#define kVarName(__XXX__) #__XXX__

//#define kMJSDKDebugStyle
//#ifdef kMJSDKDebugStyle
//#define NSLog(format, ...) do {                                                                          \
//fprintf(stderr, "<%s : %d> %s\n",                                           \
//[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
//__LINE__, __func__);                                                        \
//(NSLog)((format), ##__VA_ARGS__);                                           \
//fprintf(stderr, "-------\n");                                               \
//} while (0);
//#else
//#define NSLog(format, ...)
//#endif

//#define kMJSDKDebugStyle NO
#define NSLog(format, ...)                                      \
if(kMJSDKDebugStyle) {                                          \
do {                                                                          \
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
} while (0);                                                                        \
}



//#if kMJSDKDebugStyle
//#define NSLog(format, ...)                                              \
//do {                                                                                \
//fprintf(stderr, "<%s : %d> %s\n",                               \
//[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],                      \
//__LINE__, __func__);                                            \
//(NSLog)((format), ##__VA_ARGS__);                           \
//fprintf(stderr, "-------\n");                                               \
//} while (0);
//#else
//#define NSLog(format, ...)
//#endif




#endif /* MJSDKConfiguration_h */
