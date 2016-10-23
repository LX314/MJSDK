//
//  MJSDKUtils.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/26.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MJSDKConf;

@interface MJSDKUtils : NSObject
{

}
/**
 *  @brief 注册使用SDK
 *
 *  @param appKey 注册SDK得到的AppKey
 *
 *  @return BOOL
 */
+ (BOOL)registerWithAPPKey:(NSString *)appKey;

/**
 *  @brief 微信分享功能
 *
 *  @param appKey    微信开发者平台注册的AppKey
 *  @param appSecret 微信开发者平台注册的AppSecret
 *
 *  @return BOOL
 */
+ (BOOL)registerWechatShareWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret;

/**
 *  @brief 开启Debug模式
 */
+ (void)openDebugLog;

/**
 *  @brief 开启预加载模式
 */
+ (void)openPreloadStyle;

@end
