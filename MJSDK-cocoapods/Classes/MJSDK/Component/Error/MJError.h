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
    /** GET 失败*/
    kMJSDKERRORGETRequestFailure = 10002,
    /** POST 失败*/
    kMJSDKERRORPOSTRequestFailure = 10003,
    /** AD Model 组装失败*/
    kMJSDKERRORADModelFailure = 10004,
    /** 请求成功, 但 response 为空*/
    kMJSDKERRORADNOResponseData = 10005,
    /** 请求成功, 但无有效数据*/
    kMJSDKERRORADResponseSuccessButNOImpAdsCount,
    /** 请求成功, 但 code 不正确*/
    kMJSDKERRORResponseSuccessButNotFitCode,
    /** 加载本地数据失败*/
//    kMJSDKERRORADLoadDefaultDataFailure = 10006,
    /** 异常上报[在线]失败*/
    kMJSDKERROROnlineExceptionDataUploadFailure = 10008,
    /** URL 格式不正确*/
    kMJSDKERRORURLFailure = 10009,
    /** 曝光失败*/
    kMJSDKERROROnlineExposureFailure = 10010,
    /** click report 失败*/
    kMJSDKERRORClickReportFailure,

    /** prop query 失败*/
    kMJSDKERRORPropQueryFailure,
    /**  prop claim 失败*/
    kMJSDKERRORPropClaimFailure,
    
    /** 全局配置更新失败*/
    kMJSDKERRORGlobalConfigurationUpdateFailure,
    /** 微信分享失败*/
    kMJSDKERRORWechatShareFailure,
    /** 微信分享成功但 report 失败*/
    kMJSDKERRORWechatShareSuccessButReportFailure,

    /** 图片缓存失败*/
    kMJSDKERRORImageCachedFailure,
    /** 图片缓存超过指定重试次数*/
    kMJSDKERROROverRetryTimesFailure,
//    kMJSDKERROR,
//    kMJSDKERROR,

    /** 优惠券LogoUrl获取失败*/
    kMJSDKERRORGetCouponLogoUrlFailure,
    /** 优惠券券图片Url获取失败*/
    kMJSDKERRORGetCouponImageUrlFailure,
    /** 优惠券券号获取失败*/
    kMJSDKERRORGetCouponsCodeFailure,
    /** 好货推荐上报失败*/
    kMJSDKERRORGoodInfoReportFailure,
    /** 优惠券查询失败*/
    kMJSDKERRORCouponQueryFailure,
    /** 优惠券领取失败*/
    kMJSDKERRORCouponClaimFailure,
    /** 手机号修改失败*/
    kMJSDKERRORCouponUpdateFailure,

} kMJSDKERRORTYPE;

@interface MJError : NSError

@end
