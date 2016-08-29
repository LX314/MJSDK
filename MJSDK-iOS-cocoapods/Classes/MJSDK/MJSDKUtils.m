//
//  MJSDKUtils.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/26.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJSDKUtils.h"

#import "MJGlobalConfModel.h"
#import "MJExceptionReportManager.h"

@implementation MJSDKUtils
+ (BOOL)registerWithAPPKey:(NSString *)appKey {
    kMJAppsAPPKey = appKey;
    //1`
    [MJGlobalConfModel loadServerGlobalConf];
    //2`
    [MJTool clearTimeOutSharedData];
    //3`
    [MJExceptionReportManager autoUploadOfflineExceptionReport];
    //4`
    [MJExceptionReportManager autoUploadOfflineExposureReport];
    
    return YES;
}
+ (BOOL)registerWechatShareWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret {
    MJWeChatAppID = appKey;
    MJWeChatAppSecret = appSecret;
    return YES;
}
+ (void)openDebugLog {
    kMJSDKDebugStyle = 0;
}
+ (void)openPreloadStyle {
    kMJPreLoadData = YES;
}
@end
