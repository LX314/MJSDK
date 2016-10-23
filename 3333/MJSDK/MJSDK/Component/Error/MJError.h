//
//  MJError.h
//  sdk-ADView
//
//  Created by John LXThyme on 16/4/25.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    /** 没有网络连接*/
    kMJSDKERRORBadNetWorkConnection = 10001,
    /** 请求广告数据超过指定重试次数*/
    kMJSDKERROROverRetryLoadAdDataTimesFailure,
    /** GET 失败*/
    kMJSDKERRORGETRequestFailure = 10002,
    /** POST 失败*/
    kMJSDKERRORPOSTRequestFailure = 10003,
    /** AD Model 组装失败*/
    kMJSDKERRORADModelFailure = 10004,
    /** 请求成功, 但 response 为空*/
    kMJSDKERRORADNOResponseData = 10005,
    /** 请求成功, 但无有效数据*/
    kMJSDKERRORADResponseSuccessButNOImpAdsCount = 10006,
    /** 请求成功, 但 code 不正确*/
    kMJSDKERRORResponseSuccessButNotFitCode = 10007,
    /** elements 为空或解析错误*/
    kMJSDKERRORElementsParseFailure = 10008,
    /** 加载本地数据失败*/
//    kMJSDKERRORADLoadDefaultDataFailure = 10006,
    /** 异常上报[在线]失败*/
    kMJSDKERROROnlineExceptionDataUploadFailure = 10009,
    /** URL 格式不正确*/
    kMJSDKERRORURLFailure = 10010,
    /** 曝光失败*/
    kMJSDKERROROnlineExposureFailure = 10011,
    /** click report 失败*/
    kMJSDKERRORClickReportFailure = 10012,
    /** global conf model revert failure*/
    kMJSDKERRORGlobalConfModelRevertFailure = 10013,

    /** prop query 失败*/
    kMJSDKERRORPropQueryFailure = 10014,
    /**  prop claim 失败*/
    kMJSDKERRORPropClaimFailure = 10015,
    
    /** 全局配置更新失败*/
    kMJSDKERRORGlobalConfigurationUpdateFailure = 10016,
    /** 微信分享失败*/
    kMJSDKERRORWechatShareFailure = 10017,
    /** 微信分享成功但 report 失败*/
    kMJSDKERRORWechatShareSuccessButReportFailure = 10018,

    /** 图片缓存失败*/
    kMJSDKERRORImageCachedFailure = 10019,
    /** 图片缓存超过指定重试次数*/
    kMJSDKERROROverRetryLoadImagesTimesFailure = 10020,
//    kMJSDKERROR,
//    kMJSDKERROR,

    /** 尚未安装微信客户端,无法分享*/
    kMJSDKERRORUninstallWeichatClientFailure = 10021,
    /** 获取设备号失败*/
    kMJSDKERRORGetIDFAFailure = 10022,

    /** 优惠券LogoUrl获取失败*/
    kMJSDKERRORGetCouponLogoUrlFailure = 10023,
    /** 优惠券券图片Url获取失败*/
    kMJSDKERRORGetCouponImageUrlFailure = 10024,
    /** 优惠券券号获取失败*/
    kMJSDKERRORGetCouponsCodeFailure = 10025,
    /** 好货推荐上报失败*/
    kMJSDKERRORGoodInfoReportFailure = 10026,
    /** 优惠券查询失败*/
    kMJSDKERRORCouponQueryFailure = 10027,
    /** 优惠券领取失败*/
    kMJSDKERRORCouponClaimFailure = 10028,
    /** 手机号修改失败*/
    kMJSDKERRORCouponUpdateFailure = 10029,

} kMJSDKERRORTYPE;

@interface MJError : NSError

@end
