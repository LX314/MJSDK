//
//  MJBaseApps.h
//  sdk-ADView
//
//  Created by John LXThyme on 16/5/23.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJADDelegate.h"
#import "MJBlocks.h"
#import "MJToast.h"
#import "MJSDKConfiguration.h"

#define kMJAPPsRowHeight roundf(kMainScreen_suitWidth / 320 * 100)

void (^kMJAppsCellClickedBlock)(NSIndexPath *indexPath);
void (^kMJAppsGetPropBlock)(void);
void (^kMJAppsShowToastBlock)(NSString *toastString, BOOL dismiss);

@interface MJBaseApps : UIViewController
{
    
}
/** <#注释#>*/
@property (nonatomic,retain)UITableView *table;

- (void)show;
- (void)show:(void(^)(void))block;
- (void)dismiss;
//- (void)mjreset;


//Developer
/** 父容器*/
@property (nonatomic,retain)UIViewController *parentVC;
/** <#注释#>*/
@property (nonatomic,assign)id<MJADDelegate> delegate;
/** 预加载标志*/
@property (nonatomic,assign)BOOL preLoaded;
/** 数据源*/
@property (nonatomic,retain)MJResponse *mjResponse;
/** <#注释#>*/
@property (nonatomic,assign)KMJADType adType;
/** <#注释#>*/
@property (nonatomic,assign)BOOL isShow;

/********__temporary__********/
/** 道具 ID*/
@property (nonatomic,retain)NSString *props_id;
/**  道具价格*/
@property (nonatomic,assign)NSInteger price;
/********__temporary__********/

/**
 *  @brief 初始化应用墙
 *
 *  @param adSpaceID 广告位 ID(必须)
 *  @param props_id   道具 ID(必须)
 *  @param price     price(分)(必须)
 *
 *  @return
 */
- (instancetype)initWithAdSpaceID:(NSString *)adSpaceID props_id:(NSString *)props_id price:(NSInteger)price;
- (void)loadDataSuccessBlock:(kRequestSuccessBlock)successBlock errorBlock:(kRequestErrorBlock)errorBlock;
/**
 * 清除缓存
 */
- (void)clearAdsAndStopAutoRefresh;

-(void)changeTitle;

- (void)mjToast;

@end
