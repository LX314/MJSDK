//
//  MJAppsManager.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/3.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJBaseApps.h"

#import "MJPropManager.h"

@interface MJAppsManager : MJBaseApps
{
    
}
/** <#注释#>*/
//@property (nonatomic,assign)KMJADType appsType;
/** <#注释#>*/
@property (nonatomic,copy)NSString *prop_key;

-(void)changeTitle;

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
