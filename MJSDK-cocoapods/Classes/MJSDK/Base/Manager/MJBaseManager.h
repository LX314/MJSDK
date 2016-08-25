//
//  MJBaseManager.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/5/31.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJView.h"

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
@interface MJBaseManager : MJView
{
    
}
/** <#注释#>*/
@property (nonatomic,assign)KMJADType adType;
/** <#注释#>*/
@property (nonatomic,copy)NSString *showURL;
//@property (nonatomic,retain)NSMutableArray *arrayData;
/** <#注释#>*/
@property (nonatomic,retain)UITableView *table;



#pragma mark -
#pragma mark - Common Component
- (void)setUp;

//- (void)scrollToPre;
- (void)scrollToNext;

- (void)show;
- (void)initial;

//Developer
/** <#注释#>*/
@property (nonatomic,assign)kMJLoadDataState dataState;
/** <#注释#>*/
@property (nonatomic,assign)BOOL isTestMode;
/** <#注释#>*/
@property (nonatomic,assign)id<MJADDelegate> delegate;
/** <#注释#>*/
@property (nonatomic,assign)BOOL hasOpenLogMode;
/** 数据源*/
@property (nonatomic,retain)MJResponse *mjResponse;


//test
@property (nonatomic,copy)NSString *adSpaceID;


- (instancetype)initWithAdSpaceID:(NSString *)adSpaceID position:(KMJADPosition)position;
- (instancetype)initWithAdSpaceID:(NSString *)adSpaceID;
- (void)preloadData:(kMJBaseBlock)successBlock;
/**
 * 清除缓存
 */
- (void)clearAdsAndStopAutoRefresh;

/** dismissBlock*/
@property (nonatomic,copy)kMJBannerDismissBlock dismissBlock;
/** <#注释#>*/
@property (nonatomic,assign)KMJADPosition position;
- (void)showInDefaultWindow;
- (void)showInView:(UIView *)view;

@end
