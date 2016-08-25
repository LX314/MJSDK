//
//  MJBaseManager.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/5/31.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJBaseManager.h"

#import "MJBannerManager.h"
#import "MJInterstitialManager.h"
#import "MJInlineManager.h"
#import "MJFullOpenScreen.h"
#import "MJGLButtonInline.h"
#import "MJSDKConf.h"
#import <ReactiveCocoa.h>

@interface MJBaseManager ()<UITableViewDelegate,UITableViewDataSource>
{
    //当前行
    NSIndexPath *_currentSelectedIndexPath;
    //定时器
    dispatch_source_t _timer;
    //第一次启动 _timer
//    BOOL _mjTimerIsFirstStart;
    //父容器
    kMJParentContainer _parentContainer;
    UIView *_parentView;
}
@property (nonatomic,copy)kMJLoadDataSuccess loadDataSuccessBlock;
//Developer
/** <#注释#>*/
//@property (nonatomic,copy)NSString *adSpaceID;


//@property (nonatomic,assign)BOOL createEnabled;
//@property (nonatomic,copy)NSString *password;
//@property (nonatomic,copy)NSString *passwordConfirmation;

@end
@implementation MJBaseManager
#pragma mark -
#pragma mark - init
- (instancetype)init{
    NSAssert(NO, @"必须使用 SDK 提供的初始化方法");
    if (self = [super init]) {
    }
    return self;
}
- (instancetype)initWithAdSpaceID:(NSString *)adSpaceID {
    NSAssert(adSpaceID.length > 0, @"广告位 ID 不能为空!");
    if (self = [super init]) {
        _adSpaceID = adSpaceID;
        _adType = [self getAdType];
        [self baseSetUp];
        [self initRAC];
    }
    return self;
}
- (instancetype)initWithAdSpaceID:(NSString *)adSpaceID position:(KMJADPosition)position {
    NSAssert([[NSStringFromClass([self class]) lowercaseString] containsString:@"banner"], @"非 banner 类型请调用 - initWithAdSpaceID: 方法");
    NSAssert(adSpaceID.length > 0, @"广告位 ID 不能为空!");
    NSAssert(position == 1 || position == 2, @"position 不合法!");
    if (self = [super init]) {
        _adSpaceID = adSpaceID;
        _position = position;
        _adType = [self getAdType];
        [self baseSetUp];
        [self initRAC];
    }
    return self;
}
- (KMJADType)getAdType {
    if ([self isKindOfClass:[MJBannerManager class]]) {
        return KMJADBannerInternalType;
    } else if ([self isKindOfClass:[MJInterstitialManager class]]) {
        return KMJADInterstitalInternalType;
    } else if ([self isKindOfClass:[MJInlineManager class]]) {
        return KMJADInlineInternalType;
    }
    return KMJADUnknownType;
}
- (void)setUpBlock {
    self.dismissBlock = ^() {

    };
}
#pragma mark - loadData
/**
 *  @brief 预加载数据
 */
- (void)preloadData:(kMJBaseBlock)successBlock {
    self.dataState = kMJLoadDataLoadingState;
    NSLog(@"start preloadData...");
    WEAKSELF
    self.mjResponse = nil;
    [self loadDataSuccessBlock:^(MJResponse * _Nonnull mjResponse, NSDictionary *responseObject) {
        NSLog(@"preloadData success...");
        self.dataState = kMJLoadDataReadyState;
        weakSelf.mjResponse = mjResponse;
        if (successBlock) {
            successBlock();
        }
    } errorBlock:nil];// preLoaded:YES];
}
- (void)loadDataSuccessBlock:(kRequestSuccessBlock)successBlock errorBlock:(kRequestErrorBlock)errorBlock {
    MJDataManager *dataManager = [MJDataManager manager];
    [dataManager setEventID:@"4" adlocCode:self.adSpaceID adCount:kMJSDKBannerRequestCount];
    NSDictionary *params = dataManager.requestManager.request;
    WEAKSELF
    [dataManager loadData:params adType:self.adType successBlock:^(MJResponse *mjResponse, NSDictionary *responseObject) {
        weakSelf.dataState = kMJLoadDataReadyState;
        //请求数据成功的回调
        [MJTool responds:weakSelf.delegate toSelector:@selector(mjADRequestData:error:) block:^{
            [weakSelf.delegate mjADRequestData:weakSelf error:nil];
        }];
        if (successBlock) {
            successBlock(mjResponse, responseObject);
        }
    } errorBlock:^(NSURLResponse *response, NSError *error) {
        //重置 dataState
        weakSelf.isShow = NO;
        weakSelf.dataState = kMJLoadDataUnReadyState;
        //请求数据失败的回调
        [MJTool responds:weakSelf.delegate toSelector:@selector(mjADRequestData:error:) block:^{
            [weakSelf.delegate mjADRequestData:weakSelf error:error];
        }];
        if (errorBlock) {
            errorBlock(response, error);
        }
    }];
}

#pragma mark -
#pragma mark - Show
- (void)initRAC {
    [[RACObserve(self, mjResponse) filter:^BOOL(id value) {
        if (!self.mjResponse) {
            return NO;
        }
        if (!self.isShow) {
            NSLog(@"尚未show, 不予处理");
            return NO;
        }
        if (_parentContainer == kMJParentContainerView && !_parentView) {
            NSLog(@"父容器为 view 时,需先设置 parentView");
            return NO;
        }
        return YES;
    }] subscribeNext:^(id x) {
        [self.table reloadData];
        if (self.isShow) {
            if (_parentContainer == kMJParentContainerView && _parentView) {
                [self mj_showInDefaultWindow];
                [self afterShow];
            }else if(_parentContainer == kMJParentContainerWindow) {
                [self mj_showInDefaultWindow];
                [self afterShow];
            } else {
                NSAssert(NO, @"");
            }
            NSLog(@"加载成功- All:%ld", _mjResponse.impAds.count);
        } else {
            NSAssert(NO, @"");
        }

    }];
}
- (void)show {
    if (self.isShow) {
        NSLog(@"已经展示,不能重复展示");
        return;
    }
    if(self.dataState == kMJLoadDataUnReadyState || (self.dataState == kMJLoadDataReadyState && self.mjResponse.impAds <= 0)) {
        NSLog(@"数据源尚未准备好,重新准备中...");
        self.dataState = kMJLoadDataLoadingState;
        WEAKSELF
        [self loadDataSuccessBlock:^(MJResponse *mjResponse, NSDictionary *responseObject) {
            self.isShow = YES;
            weakSelf.mjResponse = mjResponse;
        } errorBlock:nil];
    }else if(self.dataState == kMJLoadDataLoadingState) {
        NSLog(@"缓存数据ing, will show...");
        self.isShow = YES;
    }else if(self.dataState == kMJLoadDataReadyState) {
        NSLog(@"kMJLoadDataReadyState");
        self.isShow = YES;
        self.mjResponse = self.mjResponse;
    } else {
        NSAssert(NO, @"");
    }
}
- (void)showInDefaultWindow {
    _parentContainer = kMJParentContainerWindow;
    [self show];
//    [self mj_showInDefaultWindow];
//    [self afterShow];
}
- (void)showInView:(UIView *)view {
    _parentView = view;
    _parentContainer = kMJParentContainerView;
    [self show];
//    [self mj_showInView:view];
//    [self afterShow];
}
- (void)initial {

}
- (void)mj_showInDefaultWindow {
    [self addSubview:self.table];
    [mjSuperview() addSubview:self];
    MASAttachKeys(self.table, self);
//    [self masonry];
    [self initial];
    _currentSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}
- (void)mj_showInView:(UIView *)view {
    [self addSubview:self.table];
    [view addSubview:self];
    MASAttachKeys(self.table, self);
//    [self masonry];
    [self initial];
    _currentSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}
- (void)afterShow {
    //如果是 banner, 则自动轮播
//    if (self.adType == KMJADBannerInternalType) {
        [self mjTimer];
//    }
}
/**
 * 清除缓存
 */
- (void)clearAdsAndStopAutoRefresh {
}

#pragma mark -
#pragma mark - internal
- (void)dealloc {
    NSLog(@"------------dealloc-------------");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    dispatch_source_cancel(_timer);
}
#pragma mark - setUp
- (void)baseSetUp{
//
    [self setUp];
    //曝光
    [self exposureBlock];
    //网络请求时状态栏网络状态小转轮
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}
- (void)setUp{
    [self.table setBackgroundColor:[UIColor clearColor]];
    [self.table setDelegate:self];

    NSString *selfView = [NSStringFromClass([self class]) lowercaseString];
    if([selfView rangeOfString:@"interstitial"].location != NSNotFound) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mjDidIntersitialClosed:) name:kMJSDKDidInterstitialClosedNotification object:nil];
    }else if ([selfView rangeOfString:@"banner"].location != NSNotFound) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mjDidBannerClosed:) name:kMJSDKDidBannerClosedNotification object:nil];
    }
}
#pragma mark - closed methods
- (void)mjDidBannerClosed:(NSNotification *)notification{
    if ([self isEqual:notification.object]) {
        [self bannerClosed];
    }
}
- (void)mjDidIntersitialClosed:(NSNotification *)notification{
    if ([self isEqual:notification.object]) {
        [self resetStatus];
    }
}
- (void)bannerClosed {
    [self resetStatus];
    @try {
        if (_timer) {
            dispatch_source_cancel(_timer);
            _timer = nil;
        }
    } @catch (NSException *exception) {
        NSAssert(NO, @"");
        NSLog(@"Exception:%@", exception);
    } @finally {
        NSLog(@"[finally]dispatch_source_cancel(_timer)");
    }
}
- (void)resetStatus {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isShow = NO;
        self.dataState = kMJLoadDataUnReadyState;
        self.mjResponse = nil;
        for (id obj in self.subviews) {
            if ([obj isKindOfClass:[UIView class]]) {
                UIView *view_t = (UIView *)view_t;
                view_t = nil;
                [view_t removeFromSuperview];
            }
        }
        [self removeFromSuperview];
    });
}
- (void)scrollToNext{
    [self timerEventHandler];
}
#pragma mark -
#pragma mark - block
- (void)exposureBlock {
    WEAKSELF
    kMJGotoExposureBlock = ^(MJImpAds *impAds){
        impAds.hasExposured = YES;
        [MJExceptionReportManager uploadOnlineExposureReport:impAds success:^{
            //
            STRONGSELF
            [MJTool responds:strongSelf.delegate toSelector:@selector(mjADDidExposure:error:) block:^{
                [strongSelf.delegate mjADDidExposure:strongSelf error:nil];
            }];
        } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
            //
            STRONGSELF
            [MJTool responds:strongSelf.delegate toSelector:@selector(mjADDidExposure:error:) block:^{
                [strongSelf.delegate mjADDidExposure:strongSelf error:error];
            }];
        }];
    };
}
- (void)masonry {
    
}
/**
 *  @brief 设置 mjResponse 时,自动设置 showURL 和数据源 arrayData
 *
 *  @param mjResponse <#mjResponse description#>
 */
- (void)setMjResponse:(MJResponse *)mjResponse {
    if ([_mjResponse isEqual:mjResponse]) {
        return;
    }
    _showURL = mjResponse.showUrl;
    _mjResponse = mjResponse;
    for (MJImpAds *impAds in _mjResponse.impAds) {
        impAds.showUrl = _mjResponse.showUrl;
    }
}
#pragma mark - TableView Required Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    //configuration cell...
    return cell;
}
#pragma mark - TableView Optional Methods
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    [MJTool responds:self.delegate toSelector:@selector(mjADWillShow:error:) block:^{
        [weakSelf.delegate mjADWillShow:weakSelf error:nil];
    }];
    NSLog(@"willDisplayCell:ROW[%ld]\t", indexPath.row);
    __block MJImpAds *impAds = self.mjResponse.impAds[indexPath.row];
    if (impAds.hasExposured) {
        NSLog(@"willDisplayCell:ROW[%ld]已经曝光过impressionSeqNo[%ld]", indexPath.row, impAds.impressionSeqNo);
        return;
    }
    NSLog(@"1`开始曝光ROW[%ld] : impressionSeqNo[%ld]",indexPath.row,  impAds.impressionSeqNo);
    impAds.beginShowTime = [MJTool getInternetBJDate];
    //dispatch_after
    double delayInSeconds = kMJSDKExposureTimeInterval;
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_global_queue(0, 0), ^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (!impAds.endShowTime && weakSelf.isShow) {
                kMJGotoExposureBlock(impAds);
            }
        });
    });

}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didEndDisplayingCell[%ld]\t", indexPath.row);
    WEAKSELF
    [MJTool responds:weakSelf.delegate toSelector:@selector(mjADDidEndShow:error:) block:^{
        [weakSelf.delegate mjADDidEndShow:weakSelf error:nil];
    }];
    MJImpAds *impAds = self.mjResponse.impAds[indexPath.row];
    impAds.endShowTime = [MJTool getInternetBJDate];

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MJImpAds *impAds = self.mjResponse.impAds[indexPath.row];
    MJBannerAds *bannerAds = impAds.bannerAds;
    kMJSDKTargetType targetType = bannerAds.targetType;
    //普通链接 （跳转）
    if (targetType == kMJSDKTargetType_NORMAL_LINK) {
        NSString *clickURL = bannerAds.clickUrl;
#warning TODO click Report fix
        [MJExceptionReportManager mjGotoLandingPageUrl:clickURL];
    }else if(targetType == kMJSDKTargetType_BANNER_SHARE_LINK) {//横幅分享型+链接（分享）
        MJBaseInline * cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell shareInformationMethod];
    } else {
        NSLog(@"未知的 targetType");
    }
    WEAKSELF
    [MJTool responds:weakSelf.delegate toSelector:@selector(mjADDidClick:error:) block:^{
        [weakSelf.delegate mjADDidClick:weakSelf error:nil];
    }];
}

#pragma mark -
#pragma mark - 定时器
- (void)mjTimer {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    WEAKSELF
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,DISPATCH_TIME_NOW,kMJSDKScrollInterval * NSEC_PER_SEC, 0 * NSEC_PER_SEC); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        //dispatch_after
        double delayInSeconds = kMJSDKScrollInterval;
        dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(delayInNanoSeconds, dispatch_get_global_queue(0, 0), ^{
            //Your code here...
            [self timerEventHandler];
        });
    });
    dispatch_source_set_cancel_handler(_timer, ^{
        //stop the timer here.
        NSLog(@"cancel timer...");
        [self bannerClosed];
    });
    //
    dispatch_resume(_timer);
//    double delayInSeconds = kMJSDKScrollInterval;
//    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
//    dispatch_after(delayInNanoSeconds, dispatch_get_global_queue(0, 0), ^{
//        //Your code here...
//        if (_timer) {
//            dispatch_resume(_timer);
//        }
//    });
}
- (NSArray<NSIndexPath *> *)getInserRowIndexPathRows:(NSInteger)fromRow length:(NSInteger)length {
    NSMutableArray *muarr = [NSMutableArray array];
    for (NSInteger i = fromRow; i < length; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [muarr addObject:indexPath];
    }
    return [muarr copy];
}
- (void)timerEventHandler {
//    if (!self.isShow) {
//        NSLog(@"had closed...");
//        [self bannerClosed];
//        return;
//    }
    if (!self.mjResponse.impAds || self.mjResponse.impAds.count <= 0) {
        NSLog(@"没有数据!");
        [self bannerClosed];
        return;
    }
    NSLog(@"current[%ld] - goto[%ld]",_currentSelectedIndexPath.row, _currentSelectedIndexPath.row + 1);
    //当剩余3条数据时开始缓存数据
    WEAKSELF
    if (_currentSelectedIndexPath.row > self.mjResponse.impAds.count - 3) {
        //如果 dataState 不是 kMJLoadDataReadyState,则可能已经在缓存,需等待缓存完成.
        NSLog(@"dataState:%ld", kMJLoadDataLoadingState);
        if (self.dataState != kMJLoadDataLoadingState) {
            //重置 dataState
            self.dataState = kMJLoadDataLoadingState;
            NSLog(@"开始预加载...");
            [self loadDataSuccessBlock:^(MJResponse * _Nonnull mjResponse, NSDictionary *responseObject) {
                //
                NSLog(@"开始预加载-success");
                STRONGSELF
                NSMutableArray *muarr = [strongSelf.mjResponse.impAds mutableCopy];
                [muarr addObjectsFromArray:mjResponse.impAds];
                mjResponse.impAds = muarr;
                strongSelf.mjResponse = mjResponse;
            } errorBlock:nil];
        }
    }//if (_currentSelectedIndexPath.row > self.arrayData.count - 3)
    if (_currentSelectedIndexPath.row + 1 <= self.mjResponse.impAds.count - 1) {
        _currentSelectedIndexPath = [NSIndexPath indexPathForRow:_currentSelectedIndexPath.row + 1 inSection:_currentSelectedIndexPath.section];
        dispatch_async(dispatch_get_main_queue(), ^{
            //
            STRONGSELF
            [strongSelf.table scrollToRowAtIndexPath:_currentSelectedIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            NSLog(@"current - ROW:%ld",_currentSelectedIndexPath.row);
        });
    } else {
        NSLog(@"overloaded");
        _currentSelectedIndexPath = [NSIndexPath indexPathForRow:_currentSelectedIndexPath.row - 1 inSection:_currentSelectedIndexPath.section];
    }//if (_currentSelectedIndexPath.row <= self.arrayData.count - 1)
}
#pragma mark - table
- (UITableView *)table
{
    if(!_table){
        //初始化一个 tableView
        //
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.tableFooterView = [[UIView alloc]init];
        [_table setShowsVerticalScrollIndicator:NO];
        [_table setShowsHorizontalScrollIndicator:NO];
        _table.scrollEnabled = NO;
    }
    return _table;
}
#pragma mark -
#pragma mark - setter|getter
- (void)setAdSpaceID:(NSString *)adSpaceID {
    if ([adSpaceID isEqualToString:_adSpaceID]) {
        return;
    }
    _adSpaceID = adSpaceID;
    [self resetStatus];
    if (kMJPreLoadData) {
        [self preloadData:nil];
    }
}
@end
