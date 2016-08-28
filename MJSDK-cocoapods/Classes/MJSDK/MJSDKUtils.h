//
//  MJSDKUtils.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/26.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJSDKConf.h"

@interface MJSDKUtils : NSObject
{

}
+ (BOOL)registerWithAPPKey:(NSString *)appKey;

+ (BOOL)registerWechatShareWithAppKey:(NSString *)appKey appSecret:(NSString *)appSecret;

+ (void)openDebugLog;
+ (void)openPreloadStyle;

@end
