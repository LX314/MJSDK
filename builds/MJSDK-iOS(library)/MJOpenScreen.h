//
//  MJOpenScreenManager.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/7.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJADDelegate.h"

@interface MJOpenScreen : UIViewController
{
    
}
/** 广告代理*/
@property (nonatomic,assign)id<MJADDelegate> delegate;

/**
 *  @brief 初始化开屏广告
 *
 *  @param adSpaceID 广告位ID
 *
 *  @return instancetype
 */
+ (instancetype)registerFullOpenScreenWithAdSpaceID:(NSString *)adSpaceID;

/**
 *  @brief 广告展示
 */
- (void)show;

/**
 *  @brief 预加载处理
 */
- (void)preloadData;

//***************HALF****************

/**
 *  @brief 初始化半屏广告
 *
 *  @param adSpaceID 广告位 ID
 *  @param ico       ico
 *  @param copyRight copyRight description
 *
 *  @return instancetype
 */
+ (instancetype)registerHalfOpenScreenWithAdSpaceID:(NSString *)adSpaceID ico:(UIImage *)ico copyRight:(NSString *)copyRight;

@end
