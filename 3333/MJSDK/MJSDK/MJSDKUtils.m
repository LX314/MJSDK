//
//  MJSDKUtils.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/26.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJSDKUtils.h"

#import "MJTool.h"
#import "LXNetWorking.h"
#import "MJGlobalConfModel.h"
#import "MJExceptionReportManager.h"

@implementation MJSDKUtils
/**
 *  @brief 注册使用SDK
 *
 *  @param appKey 注册SDK得到的AppKey
 *
 *  @return BOOL
 */
+ (BOOL)registerWithAPPKey:(NSString *)appKey {
    kMJAppsAPPKey = appKey;
    //
    [self updateStatus];
    //
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"-----------------status:%ld", status);
        if (status != AFNetworkReachabilityStatusNotReachable) {
            [self updateStatus];
        }
    }];
    
    return YES;
}

/**
 *  @brief 微信分享功能
 *
 *  @param appKey    微信开发者平台注册的AppKey
 *  @param appSecret 微信开发者平台注册的AppSecret
 *
 *  @return BOOL
 */
+ (BOOL)registerWechatShareWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret {
    MJWeChatAppID = appKey;
    MJWeChatAppSecret = appSecret;
    return YES;
}

/**
 *  开启Debug模式
 */
+ (void)openDebugLog {
    kMJSDKDebugStyle = 1;
}

/**
 *  开启预加载模式
 */
+ (void)openPreloadStyle {
    kMJPreLoadData = YES;
}

+ (void)updateStatus {
    //1`
    [MJGlobalConfModel loadServerGlobalConf];
    //2`
    [MJTool clearTimeOutSharedData];
    //3`
    [MJExceptionReportManager autoUploadOfflineExceptionReport];
    //4`
    [MJExceptionReportManager autoUploadOfflineExposureReport];
}
@end
