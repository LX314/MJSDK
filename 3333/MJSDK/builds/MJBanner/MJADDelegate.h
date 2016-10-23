//
//  MJADDelegate.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/28.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MJADDelegate <NSObject>

@optional
/**
 *  @brief 将要请求广告时的回调
 *
 *  @param adView 广告视图
 *  @param error  错误信息
 */
- (void)mjADRequestData:(UIView *)adView error:(NSError *)error;
/**
 *  @brief 将要显示广告时的回调
 *
 *  @param adView 广告视图
 *  @param error  错误信息
 */

- (void)mjADWillShow:(UIView *)adView error:(NSError *)error;
/**
 *  @brief 结束显示广告时的回调
 *
 *  @param adView 广告视图
 *  @param error  错误信息
 */
- (void)mjADDidEndShow:(UIView *)adView error:(NSError *)error;
/**
 *  @brief 点击广告时的回调
 *
 *  @param adView 广告视图
 *  @param error  错误信息
 */
- (void)mjADDidClick:(UIView *)adView error:(NSError *)error;

/**
 *  @brief 点击广告首次曝光时的回调
 *
 *  @param adView 广告视图
 *  @param error  错误信息
 *
 *  @remark 用户点击广告的回调函数，一次展示仅会计入一次，即一次展示第一次点击时才会调用本方法。
 */
- (void)mjADDidExposure:(UIView *)adView error:(NSError *)error;

/**
 *  @brief 验证道具ID
 *
 *  @param prop_key 道具ID
 */
- (void)mjClaimProps:(NSString *)prop_key;

@end
