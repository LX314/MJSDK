//
//  MJAppsDataManager.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/17.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJBaseDataManager.h"

/**
 MJShare 领券的动作类型
 */
typedef enum : NSUInteger {
    kRequestTypeCLAIM_COUPONS = 1,  // 领券
    kRequestTypeCHECK_COUPONS = 2,  // 查券
    kRequestTypeUPDATE_CELLPHONE= 3  // 修改手机
} kRequestType;

/**
 *  @brief 管理 MJShare 领取优惠券的数据操作
 */
@interface MJCouponManager : MJBaseDataManager
{

}
+ (instancetype _Nonnull)manager;

/**
 *  @brief 查券
 *
 *  @param queryBlock queryBlock
 */
- (void)loadQuery:(kMJShareBlock _Nonnull)queryBlock;
/**
 *  @brief  领券
 *
 *  @param claimBlock claimBlock
 */
- (void)loadClaim:(kMJShareBlock _Nullable)claimBlock failure:(kMJClaimFailedBlock _Nullable)failureBlock couponCode:(NSString * _Nullable)code telNumber:(NSString *_Nullable)tel;
/**
 *  @brief 修改手机号
 *
 *  @param updateBlock updateBlock
 */
- (void)loadUpdate:(kMJShareBlock _Nonnull)updateBlock updatephoneNumber:(NSString *_Nonnull)phoneNumber;

@end
