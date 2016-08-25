//
//  MJADDelegate.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/28.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MJADDelegate <NSObject>

- (void)mjADRequestData:(UIView *)adView error:(NSError *)error;
- (void)mjADWillShow:(UIView *)adView error:(NSError *)error;
- (void)mjADDidEndShow:(UIView *)adView error:(NSError *)error;
- (void)mjADDidClick:(UIView *)adView error:(NSError *)error;
// 用户点击广告的回调函数，一次展示仅会计入一次，即一次展示第一次点击时才会调用本方法。
- (void)mjADDidExposure:(UIView *)adView error:(NSError *)error;


- (void)mjClaimProps:(NSString *)prop_key;

@end
