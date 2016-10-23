//
//  MJJAppsWall.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/9/13.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJADDelegate.h"
//#import "MJBlocks.h"

#define kMJAPPsRowHeight roundf(kMainScreen_suitWidth / 320 * 100)

typedef void(^kMJAppsShowToastBlock)(NSString *_Nullable toastString, BOOL dismiss);
typedef void(^kMJAppsCellClickedBlock)(NSIndexPath *_Nullable indexPath);
typedef void(^kMJAppsGetPropBlock)(void);

@interface MJAppsWall : UIViewController
{

}
/** 广告代理*/
@property (nullable, nonatomic, assign)id<MJADDelegate> delegate;

/** UITableView*/
@property (nullable, nonatomic,retain)UITableView *table;
/** 广告位ID*/
@property (nullable, nonatomic,copy)NSString *adSpaceID;
/** 道具ID*/
@property (nullable, nonatomic,copy)NSString *prop_key;
/** 是否预加载*/
@property (nonatomic,assign)BOOL preLoaded;
/** 是否展示*/
@property (nonatomic,assign)BOOL isShow;

//@property (nonatomic,copy)kMJAppsShowToastBlock mjAppsShowToastBlock;
@property (nullable, nonatomic,copy)kMJAppsShowToastBlock mjAppsShowToastBlock;
//@property (nonatomic,copy)kMJAppsGetPropBlock mjAppsGetPropBlock;
@property (nullable, nonatomic,copy)kMJAppsGetPropBlock mjAppsGetPropBlock;
//@property (nonatomic,copy)kMJAppsCellClickedBlock mjAppsCellClickedBlock;
@property (nullable, nonatomic,copy)kMJAppsCellClickedBlock mjAppsCellClickedBlock;
/**
 *  @brief 初始化广告墙
 *
 *  @param adSpaceID  广告位 ID(必须)
 *  @param props_id   道具 ID(必须)
 *  @param price      (分)(必须)
 *
 *  @return instancetype
 */
+ (instancetype _Nullable)registerAppsWallWithAdSpaceID:(NSString *_Nullable)adSpaceID props_id:(NSString *_Nullable)props_id price:(NSInteger)price;

/**
 *  @brief 道具查询
 *      status: 状态
 *          1、未领取
 *          2、已领取
 *          3、无足够分享次数
 *          4、价格超出上限
 *          5、数据错误
 *          6、无法分享
 *
 *  @param availableBlock availableBlock
 */
- (void)queryPropAvailable:(void(^_Nullable)(BOOL available))availableBlock;

/**
 *  @brief 道具验证
 *      status  状态：
 *         1、成功
 *         2、失败
 *         3、秘钥过期
 *         4、秘钥已经被验证过
 *
 *  @param prop_key     prop_key
 *  @param vertifyBlock vertifyBlock
 */
+ (void)vertify:(NSString *_Nullable)prop_key complete:(void(^_Nullable)(NSDictionary *_Nullable params))vertifyBlock;

/**
 *  @brief 广告展示

 *  @param parentVC ViewController to present
 *  @param block    block
 */
- (void)showIn:(UIViewController *_Nullable)parentVC;// closeBlock:(void(^_Nullable)(void))block;

/**
 *  @brief dismiss
 */
- (void)dismiss;

@end
