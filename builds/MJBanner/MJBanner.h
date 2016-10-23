//
//  MJJBanner.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/9/12.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJADDelegate.h"

typedef enum : NSUInteger {
    KMJADDefaultPosition = 1,
    KMJADTopPosition = 1,
    KMJADBottomPosition = 2,
} KMJADPosition;
typedef enum : NSUInteger {
    kMJLoadDataUnReadyState,
    kMJLoadDataLoadingState,
    kMJLoadDataReadyState,
} kMJLoadDataState;
typedef enum : NSUInteger {
    kMJParentContainerUnknown,
    kMJParentContainerView,
    kMJParentContainerWindow,
} kMJParentContainer;

typedef void(^kMJBannerDismissBlock)(void);

@interface MJBanner : UIView
{

}
/** 广告代理*/
@property (nonatomic,assign)id<MJADDelegate> delegate;
/** dismissBlock*/
@property (nonatomic,copy)kMJBannerDismissBlock dismissBlock;

/**
 *  @brief 广告展示
 */
- (void)show;

/**
 *  @brief 初始化Banner广告
 *
 *  @param adSpaceID 广告位 ID
 *  @param position 广告位置
 *
 *  @return instancetype
 */
+ (instancetype)registerBannerWithAdSpaceID:(NSString *)adSpaceID position:(KMJADPosition)position;

/**
 *  @brief 初始化插屏广告
 *
 *  @param adSpaceID 广告位 ID
 *
 *  @return instancetype
 */
+ (instancetype)registerInterstitialWithAdSpaceID:(NSString *)adSpaceID;

/**
 *  @brief 初始化内嵌广告
 *
 *  @param adSpaceID 广告位 ID
 *
 *  @return instancetype
 */
+ (instancetype)registerInlineWithAdSpaceID:(NSString *)adSpaceID;



@end
