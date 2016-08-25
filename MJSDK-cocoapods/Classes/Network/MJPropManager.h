//
//  MJPropManager.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/20.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJBaseDataManager.h"

typedef void(^kMJPropManagerBlock)(NSDictionary *params);

@interface MJPropManager : MJBaseDataManager
{

}

/**
 *  查询
 *
 *  @param propID     prop id
 *  @param price     price
 *  @param propBlock propBlock
 */
+ (void)queryPropID:(NSString *)propID price:(NSInteger)price propBlock:(kMJPropManagerBlock)propBlock;
/**
 *  领取
 *
 *  @param propID     prop id
 *  @param price     price
 *  @param propBlock propBlock
 */
+ (void)claimPropID:(NSString *)propID price:(NSInteger)price propBlock:(kMJPropManagerBlock)propBlock;
/**
 *  道具验证
 *   status  状态：
*         1. 成功
*         2. 失败
*         3. 秘钥过期
*         4. 秘钥已经被验证过
 *
 *  @param prop_key     prop_key
 *  @param vertifyBlock vertifyBlock
 */
+ (void)vertify:(NSString *)prop_key complete:(kMJPropManagerBlock)vertifyBlock;

@end
