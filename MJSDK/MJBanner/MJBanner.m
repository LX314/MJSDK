//
//  MJJBanner.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/9/12.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJBanner.h"

#import "MJTool.h"
#import "MJFactory.h"
#import "MJError.h"

#import "MJGLBanner.h"
#import "MJIMGBanner.h"

#import "MJGLInline.h"
#import "MJIMGInline.h"

#import "MJGLInterstitial.h"
#import "MJIMGInterstitial.h"

#import "MJDataManager.h"
#import "MJGradientLayer.h"
#import "MJRequestManager.h"
#import "MJExceptionReportManager.h"

#import <ReactiveCocoa.h>
#import <AFNetworkActivityIndicatorManager.h>

@interface MJBanner()<UITableViewDelegate,UITableViewDataSource>
{
    //当前行
    NSIndexPath *_currentSelectedIndexPath;
    //定时器
    //    dispatch_source_t _timer;
    //第一次启动 _timer
    //    BOOL _mjTimerIsFirstStart;
    //父容器
    kMJParentContainer _parentContainer;
    UIView *_parentView;

    kMJTimerStatus _mjTimerStatus;

    NSUInteger _reloadCount;
}
/** UITableView*/
@property (nonatomic,retain)UITableView *table;
/** 关闭按钮*/
@property (nonatomic,retain)UIButton *btnClose;
/** 广告标识*/
@property (nonatomic,retain)UILabel *mjLabADLogo;
//***********
@property (nonatomic,assign)BOOL isShow;
/** 广告类型*/
@property (nonatomic,assign)KMJADType adType;
/** 广告位置*/
@property (nonatomic,assign)KMJADPosition position;
/** 加载数据状态*/
@property (nonatomic,assign)kMJLoadDataState dataState;
/** 定时器*/
@property (nonatomic,strong)dispatch_source_t timer;
@property (nonatomic,copy)kMJLoadDataSuccess loadDataSuccessBlock;
/** 在线曝光*/
@property (nonatomic,copy)kMJGotoExposureBlock mjGotoExposureBlock;
//Developer
/** 广告位ID*/
@property (nonatomic,copy)NSString *adSpaceID;
/** 数据源*/
@property (nonatomic,retain)MJResponse *mjResponse;
/**
 *  @brief Mask
 */
@property (nonatomic, strong) CALayer *backgroundLayer;
@property (assign, nonatomic) LXMJViewMaskType defaultMaskType;
@property (strong, nonatomic) UIColor *backgroundLayerColor;

//*****************************MJView.h
@property (nonatomic, readonly) CGFloat visibleKeyboardHeight;

@end
@implementation MJBanner
- (void)dealloc {
    NSLog(@"------------dealloc-------------");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self bannerClosed];
}
#pragma mark -
#pragma mark - initial
- (instancetype)init{
    NSAssert(NO, @"必须使用 SDK 提供的初始化方法");
    if (self = [super init]) {
    }
    return self;
}
- (void)baseInitial{
    //启动定位系统
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        [LXLocationManager getMyLocation];
    });
    [self initial];
}
- (void)initial{
    [self setBackgroundColor:[UIColor whiteColor]];
    __block CGFloat rowHeight;
    [self doitBanner:^{
        rowHeight = kADBannerHeight;
    } interstitial:^{
        [self setBackgroundColor:[UIColor clearColor]];
        rowHeight = CGRectGetHeight(kMJInterstitialHalfScreenBounds);
        self.defaultMaskType =
        //    LXMJViewMaskTypeNone;
        LXMJViewMaskTypeGradient;
        [self updateMask];
    } inline:^{
        rowHeight = kMJInlineHeight;
    }];
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.table setRowHeight:rowHeight];
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    if (kIOSVersion >= 8.f) {
        self.table.estimatedRowHeight = kADBannerHeight;
    }
}
/**
 *  @brief 初始化Banner广告
 *
 *  @param adSpaceID 广告位 ID
 *  @param position 广告位置
 *
 *  @return instancetype
 */
+ (instancetype)registerBannerWithAdSpaceID:(NSString *)adSpaceID position:(KMJADPosition)position {
    return [[self alloc]initWithAdSpaceID:adSpaceID position:position adType:KMJADBannerInternalType];
}
/**
 *  @brief 初始化插屏广告
 *
 *  @param adSpaceID 广告位 ID
 *
 *  @return instancetype
 */
+ (instancetype)registerInterstitialWithAdSpaceID:(NSString *)adSpaceID{
    return [[self alloc]initWithAdSpaceID:adSpaceID position:1 adType:KMJADInterstitialInternalType];
}
/**
 *  @brief 注册内嵌广告
 *
 *  @param adSpaceID 广告位 ID
 *
 *  @return instancetype
 */
+ (instancetype)registerInlineWithAdSpaceID:(NSString *)adSpaceID {
    return [[self alloc]initWithAdSpaceID:adSpaceID position:1 adType:KMJADInlineInternalType];
}

/**
 *  @brief 初始化广告位
 *
 *  @param adSpaceID 广告位ID
 *  @param position  广告位置
 *  @param adType    广告类型
 *
 *  @return instancetype
 */
- (instancetype)initWithAdSpaceID:(NSString *)adSpaceID position:(KMJADPosition)position adType:(KMJADType)adType {
    NSString *classString = NSStringFromClass([self class]);
    NSString *lowString = [classString lowercaseString];
    BOOL has = [lowString rangeOfString:@"banner"].location != NSNotFound;
    NSAssert(has, @"非 banner 类型请调用 - initWithAdSpaceID: 方法");
    NSAssert(adSpaceID.length > 0, @"广告位 ID 不能为空!");
    NSAssert(position == 1 || position == 2, @"position 不合法!");
    if (self = [super init]) {
//        self.layer.masksToBounds = YES;
        _adSpaceID = adSpaceID;
        _position = position;
        _adType = adType;
        [self setUp];
        [self initRAC];
        [self registerNotification];
    }
    return self;
}
- (void)registerNotification {
    //application state notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationStateDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationStateDidBecomeInActive:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    //banner closed notification
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mjDidSIMBannerClosed:) name:kMJSDKDidSIMBannerClosedNotification object:nil];
}
- (void)baseSetUp{
    //
    [self setUp];
    //曝光
    //    [self exposureBlock];
    //网络请求时状态栏网络状态小转轮
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}
#pragma mark -
#pragma mark - show
/**
 *  @brief 广告展示
 */
- (void)show {
    if (self.isShow) {
        NSLog(@"已经展示,不能重复展示");
        MJNSLog(@"已经展示,不能重复展示");
        return;
    }
    if(self.dataState == kMJLoadDataUnReadyState || (self.dataState == kMJLoadDataReadyState && self.mjResponse.impAds <= 0)) {
        NSLog(@"数据源尚未准备好,重新准备中...");
        self.dataState = kMJLoadDataLoadingState;
        WEAKSELF
        [self loadDataSuccessBlock:^(MJResponse *mjResponse, NSDictionary *responseObject) {
            STRONGSELF
            strongSelf.isShow = YES;
            strongSelf.mjResponse = mjResponse;
        } errorBlock:nil];
    }else if(self.dataState == kMJLoadDataLoadingState) {
        NSLog(@"缓存数据ing, will show...");
        MJNSLog(@"缓存数据ing");
        self.isShow = YES;
    }else if(self.dataState == kMJLoadDataReadyState) {
        NSLog(@"kMJLoadDataReadyState");
        self.isShow = YES;
        self.mjResponse = self.mjResponse;
    } else {
        NSAssert(NO, @"");
    }
}
- (void)mj_showInDefaultWindow {
    //    [self setUserInteractionEnabled:YES];
    //    [self.table setUserInteractionEnabled:YES];
    [self addSubview:self.table];
    [kMJSuperview addSubview:self];
    MASAttachKeys(self.table, self);
    //    [self masonry];
    [self baseInitial];
    _currentSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}
- (void)mj_showInView:(UIView *)view {
    [self addSubview:self.table];
    [self addSubview:self.mjLabADLogo];
    [self addSubview:self.btnClose];
    [view addSubview:self];
    MASAttachKeys(self.table, self);
    //    [self masonry];
    [self baseInitial];
    _currentSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
}

//轮播
- (void)afterShow {
    //如果是 banner, 则自动轮播
//    if (self.adType == KMJADBannerInternalType) {
        [self resumed];
//    }
}
#pragma mark - setUp
- (void)setUp{
    //
    [self.table setBackgroundColor:[UIColor clearColor]];
    [self.table setDelegate:self];
    [self initial];
    //曝光
    //    [self exposureBlock];
    //网络请求时状态栏网络状态小转轮
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
}
- (void)applicationStateDidBecomeInActive:(NSNotification *)notification {
    [self suspend];
}
- (void)applicationStateDidBecomeActive:(NSNotification *)notification {
    [self resumed];
}
- (void)mjDidSIMBannerClosed:(NSNotification *)notification {
//    id obj = notification.object;
//    if (!obj) {
//        NSAssert(NO, @"");
//    }
//    if ([obj isEqual:self]) {
        [self bannerClosed];
//    }
}
- (void)bannerClosed {
    //    [self.btnClose setUserInteractionEnabled:NO];
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        [self.btnClose setUserInteractionEnabled:YES];
    //    });
    [self resetStatus];
    [self canceld];
}
- (void)resetStatus {
    if (self.dismissBlock) {
        self.dismissBlock();
    }
    _isShow = NO;
    _dataState = kMJLoadDataUnReadyState;
    _mjResponse = nil;
    [self.table removeFromSuperview];
    _table = nil;
    [self removeFromSuperview];
}
- (void)scrollToNext{
    [self timerEventHandler];
}
#pragma mark -
#pragma mark - RAC
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
        id superView = [self superview];
        if (!superView) {
            [self mj_showInView:[MJTool getTopView]];
            [self masonry];
            [self afterShow];
        }
        NSLog(@"加载成功- All:%ld", _mjResponse.impAds.count);
    }];
}
#pragma mark -
#pragma mark - block
#pragma mark - mjGotoExposureBlock
- (kMJGotoExposureBlock)mjGotoExposureBlock
{
    if(!_mjGotoExposureBlock){
        WEAKSELF
        _mjGotoExposureBlock = ^(MJImpAds *impAds){
            impAds.hasExposured = YES;
            [MJExceptionReportManager uploadOnlineExposureReport:impAds adSpaceID:weakSelf.adSpaceID success:^{
                //
                [MJTool responds:weakSelf.delegate toSelector:@selector(mjADDidExposure:error:) block:^{
                    [weakSelf.delegate mjADDidExposure:weakSelf error:nil];
                }];
            } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
                //
                [MJTool responds:weakSelf.delegate toSelector:@selector(mjADDidExposure:error:) block:^{
                    [weakSelf.delegate mjADDidExposure:weakSelf error:error];
                }];
            }];
        };

    }

    return _mjGotoExposureBlock;
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
//    _showURL = mjResponse.showUrl;
    _mjResponse = mjResponse;
    for (MJImpAds *impAds in _mjResponse.impAds) {
        impAds.showUrl = _mjResponse.showUrl;
    }
}
#pragma mark -
#pragma mark - 定时器 - timer
- (dispatch_source_t)timer
{
    if(!_timer){
        //需要将dispatch_source_t timer设置为成员变量，不然会立即释放
        //@property (nonatomic, strong) dispatch_source_t timer;
        //定时器开始执行的延时时间
        NSTimeInterval delayTime = kMJSDKScrollInterval;
        //定时器间隔时间
        NSTimeInterval timeInterval = kMJSDKScrollInterval;
        //创建子线程队列
        dispatch_queue_t timerQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        //使用之前创建的队列来创建计时器
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, timerQueue);
        //设置延时执行时间，delayTime为要延时的秒数
        dispatch_time_t startDelayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC));
        //设置计时器
        dispatch_source_set_timer(_timer, startDelayTime, timeInterval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
        dispatch_source_set_event_handler(_timer, ^{
            //执行事件
            NSLog(@"[%@][%@]timer resumed...", KNSStringFromMJADType(self.adType), _timer);
            [self timerEventHandler];
        });
        dispatch_source_set_cancel_handler(_timer, ^{
            //stop the timer here.
            NSLog(@"cancel timer...");
            if (_mjTimerStatus == kMJTimerCanceledStatus) {
                [self resetStatus];
                self.timer = nil;
            }
        });
        // 启动计时器
        //        dispatch_resume(_timer);
    }
    return _timer;
}
- (void)resumed {
    if (_mjTimerStatus != kMJTimerResumedStatus) {
        _mjTimerStatus = kMJTimerResumedStatus;
        self.isShow = YES;
        dispatch_resume(self.timer);
    }
}
- (void)suspend {
    if (_timer && _mjTimerStatus == kMJTimerResumedStatus) {
        NSLog(@"timer suspend...");
        self.isShow = NO;
        _mjTimerStatus = kMJTimerSuspendStatus;
        dispatch_suspend(_timer);
    }
}
- (void)canceld {
    if (!_timer || _mjTimerStatus == kMJTimerSuspendStatus) {
        [self resumed];
    }
    self.isShow = NO;
    _mjTimerStatus = kMJTimerCanceledStatus;
    dispatch_source_cancel(self.timer);
    self.timer = nil;
}
- (void)timerEventHandler {
    UIApplicationState applicationState = [UIApplication sharedApplication].applicationState;
    if (applicationState != UIApplicationStateActive) {
        [self suspend];
        return;
    }
    if (!self.mjResponse.impAds || self.mjResponse.impAds.count <= 0) {
        NSLog(@"没有数据!");
        [self bannerClosed];
        return;
    }
//    if (self.mjResponse.impAds.count == 1) {
//        NSLog(@"impAds.count == %ld, then auto suspend.", self.mjResponse.impAds.count);
//        [self timerPrerLoadData];
//        [self suspend];
//        return;
//    }
    NSLog(@"current[%ld] - goto[%ld]",_currentSelectedIndexPath.row, _currentSelectedIndexPath.row + 1);
    //当剩余3条数据时开始缓存数据
    NSInteger count = self.mjResponse.impAds.count;
    if (_currentSelectedIndexPath.row > (count - 2)) {
        [self timerPrerLoadData];
    }//if (_currentSelectedIndexPath.row > self.arrayData.count - 3)
    count = self.mjResponse.impAds.count;
    if (_currentSelectedIndexPath.row <= (count - 2)) {
        _currentSelectedIndexPath = [NSIndexPath indexPathForRow:_currentSelectedIndexPath.row + 1 inSection:_currentSelectedIndexPath.section];
        dispatch_async(dispatch_get_main_queue(), ^{
            //
            [self.table scrollToRowAtIndexPath:_currentSelectedIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
            NSLog(@"current - ROW:%ld",_currentSelectedIndexPath.row);
        });
    } else {
        NSLog(@"overloaded");
        dispatch_async(dispatch_get_main_queue(), ^{
            _currentSelectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            if (!self.mjResponse && self.mjResponse.impAds.count <= 0) {
                NSLog(@"**********");
                NSAssert(NO, @"");
                return;
            }
            [self.table scrollToRowAtIndexPath:_currentSelectedIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        });
    }//if (_currentSelectedIndexPath.row <= self.arrayData.count - 1)
}
- (void)timerPrerLoadData {
    //如果 dataState 不是 Applications/Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk/System/Library/PrivateFrameworks/StoreServices.framework/StoreServiceskMJLoadDataReadyState,则可能已经在缓存,需等待缓存完成.
    NSLog(@"dataState:%ld", kMJLoadDataLoadingState);
    if (self.dataState != kMJLoadDataLoadingState) {
        //重置 dataState
        self.dataState = kMJLoadDataLoadingState;
        NSLog(@"开始预加载...");
        MJNSLog(@"开始预加载...");
        WEAKSELF
        [self loadDataSuccessBlock:^(MJResponse * _Nonnull mjResponse, NSDictionary *responseObject) {
            //
            NSLog(@"开始预加载-success");
            STRONGSELF
            NSMutableArray *muarr = [strongSelf.mjResponse.impAds mutableCopy];
            [muarr addObjectsFromArray:mjResponse.impAds];
            mjResponse.impAds = muarr;
            strongSelf.mjResponse = mjResponse;
            [strongSelf.table reloadData];
        } errorBlock:nil];
    }
}
#pragma mark -
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
//- (void)loadDataSuccessBlock:(kRequestSuccessBlock)successBlock errorBlock:(kRequestErrorBlock)errorBlock {
//    [self baseLoadDataSuccessBlock:^(MJResponse * _Nullable mjResponse, NSDictionary * _Nullable responseObject) {
//        <#code#>
//    } errorBlock:^(NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
//        _reloadCount++;
//        if (_reloadCount >= kMJSDKSIMBannerReloadCount) {
//            weakSelf.isShow = NO;
//            weakSelf.dataState = kMJLoadDataUnReadyState;
//            //请求数据失败的回调
//            [MJTool responds:weakSelf.delegate toSelector:@selector(mjADRequestData:error:) block:^{
//                [weakSelf.delegate mjADRequestData:weakSelf error:error];
//            }];
//            if (errorBlock) {
//                errorBlock(response, error);
//            }
//        } else {
//
//        }
//    }];
//}
- (void)loadDataSuccessBlock:(kRequestSuccessBlock)successBlock errorBlock:(kRequestErrorBlock)errorBlock {
//    [self loadDataReloadTimes:kMJSDKSIMBannerReloadCount successBlock:successBlock errorBlock:errorBlock];
    [self loadDataReloadTimes:kMJSDKSIMBannerReloadCount successBlock:^(MJResponse * _Nullable mjResponse, NSDictionary * _Nullable responseObject) {
//        NSLog(@"success");
        if (successBlock) {
            successBlock(mjResponse, responseObject);
        }
    } errorBlock:^(NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
//        NSLog(@"error");
    }];
}
- (void)loadDataReloadTimes:(NSInteger)reloadTimes successBlock:(kRequestSuccessBlock)successBlock errorBlock:(kRequestErrorBlock)errorBlock {
    if (reloadTimes <= 0) {
        MJError *mjerror = [MJError errorWithDomain:@"" code:kMJSDKERROROverRetryLoadAdDataTimesFailure userInfo:@{}];
        if (errorBlock) {
            errorBlock(nil, mjerror);
        }
        return;
    }
    NSLog(@"reloadCount:%ld", reloadTimes);
    reloadTimes--;
    [self baseLoadDataSuccessBlock:successBlock errorBlock:^(NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
        [self loadDataReloadTimes:reloadTimes successBlock:successBlock errorBlock:errorBlock];
    }];
}
- (void)baseLoadDataSuccessBlock:(kRequestSuccessBlock)successBlock errorBlock:(kRequestErrorBlock)errorBlock {
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
#pragma mark - delegate
#pragma mark - TableView Required Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mjResponse.impAds count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self doitReturnBanner:^id{
        MJImpAds *impAds = self.mjResponse.impAds[indexPath.row];
        MJBannerAds *bannerAds = impAds.bannerAds;
        KMJADType mjAdType = bannerAds.mjAdType;

        if (mjAdType == KMJADBannerIMGType) {
            static NSString *cellBannerIMGIdentifier = @"cellIdentifierBannerIMG";
            MJIMGBanner *cell = [tableView dequeueReusableCellWithIdentifier:cellBannerIMGIdentifier];
            if (!cell)
            {
                cell = [[MJIMGBanner alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellBannerIMGIdentifier];
            }
            //configuration cell...
            cell.superOwner = self;
            [cell fillImpAds:impAds indexPath:indexPath];
            return cell;
        } else if (mjAdType == KMJADBannerGLType) {
            static NSString *cellBannerGLIdentifier = @"cellIdentifierBannerGL";
            MJGLBanner *cell = [tableView dequeueReusableCellWithIdentifier:cellBannerGLIdentifier];
            if (!cell)
            {
                cell = [[MJGLBanner alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellBannerGLIdentifier];
            }
            //configuration cell...
            cell.superOwner = self;
            [cell fillImpAds:impAds indexPath:indexPath];
            return cell;
        } else {
            NSAssert(NO, @"ERROR");
        }
        return nil;
    } interstitial:^id{
        MJImpAds *impAds = self.mjResponse.impAds[indexPath.row];
        MJBannerAds *bannerAds = impAds.bannerAds;
        KMJADType mjAdType = bannerAds.mjAdType;
        //    MJElement *mjEelements = bannerAds.mjElement;
        if (mjAdType == KMJADInterstitialIMGType) {
            static NSString *cellIMGIdentifier = @"cellIdentifierIMG";
            MJIMGInterstitial *cell = [tableView dequeueReusableCellWithIdentifier:cellIMGIdentifier];
            if (!cell)
            {
                cell = [[MJIMGInterstitial alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIMGIdentifier];
            }
            //configuration cell...
            cell.superOwner = self;
            [cell fillImpAds:impAds indexPath:indexPath];
            return cell;
        } else if (mjAdType == KMJADInterstitialGLType) {
            static NSString *cellGLIdentifier = @"cellIdentifierGL";
            MJGLInterstitial *cell = [tableView dequeueReusableCellWithIdentifier:cellGLIdentifier];
            if (!cell)
            {
                cell = [[MJGLInterstitial alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellGLIdentifier];
            }
            //configuration cell...
            cell.superOwner = self;
            [cell fillImpAds:impAds indexPath:indexPath];
            return cell;
        }
        else {
            NSAssert(NO, @"ERROR");
        }
        return nil;
    } inline:^id{
        MJImpAds *impAds = self.mjResponse.impAds[indexPath.row];
        MJBannerAds *bannerAds = impAds.bannerAds;
        KMJADType mjAdType = bannerAds.mjAdType;
        if (mjAdType == KMJADInlineIMGType || mjAdType == KMJADInlineIMGShareType) {
            static NSString *cellIMGInlineIdentifier = @"cellIdentifier_MJIMGInline";
            MJIMGInline *cell = [tableView dequeueReusableCellWithIdentifier:cellIMGInlineIdentifier];
            if (!cell) {
                cell = [[MJIMGInline alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIMGInlineIdentifier];
            }
            //configuration cell...
            cell.superOwner = self;
            [cell fillImpAds:impAds indexPath:indexPath];
            return cell;
        } else if (mjAdType == KMJADInlineGLType) {
            static NSString *cellGLInlineIdentifier = @"cellIdentifier_MJGLInline";
            MJGLInline *cell = [tableView dequeueReusableCellWithIdentifier:cellGLInlineIdentifier];
            if (!cell) {
                cell = [[MJGLInline alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellGLInlineIdentifier];
            }
            //configuration cell...
            cell.superOwner = self;
            [cell fillImpAds:impAds indexPath:indexPath];
            return cell;
        } else {
            NSAssert(NO, @"ERROR");
        }
        return nil;
    }];
}
#pragma mark - TableView Optional Methods
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    WEAKSELF
    [MJTool responds:self.delegate toSelector:@selector(mjADWillShow:error:) block:^{
        [weakSelf.delegate mjADWillShow:weakSelf error:nil];
    }];
//    NSLog(@"willDisplayCell:ROW[%ld]\t", indexPath.row);
    __block MJImpAds *impAds = self.mjResponse.impAds[indexPath.row];
    if (impAds.hasExposured) {
//        NSLog(@"willDisplayCell:ROW[%ld]已经曝光过impressionSeqNo[%ld]", indexPath.row, impAds.impressionSeqNo);
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
                //                kMJGotoExposureBlock(impAds);
                self.mjGotoExposureBlock(impAds);
            }
        });
    });

}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"didEndDisplayingCell[%ld]\t", indexPath.row);
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
        if ([MJExceptionReportManager validateAndExceptionReport:clickURL]) {
            [MJExceptionReportManager mjGotoLandingPageUrl:clickURL before:^{
                [self suspend];
            } completion:^{
                [self resumed];
            }];
        }
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
#pragma mark - components
- (id)doitBanner:(void(^)(void))bannerBlock interstitial:(void(^)(void))interstitialBlock inline:(void(^)(void))inlineBlock {
    if (self.adType == KMJADBannerInternalType) {
        if (bannerBlock) {
            bannerBlock();
        }
    }else if (self.adType == KMJADInterstitialInternalType){
        if (interstitialBlock) {
            interstitialBlock();
        }
    }else if (self.adType == KMJADInlineInternalType){
        if (inlineBlock) {
            inlineBlock();
        }
    } else {
        NSAssert(NO, @"");
    }
    return nil;
}
- (id)doitReturnBanner:(id(^)(void))bannerBlock interstitial:(id(^)(void))interstitialBlock inline:(id(^)(void))inlineBlock {
    if (self.adType == KMJADBannerInternalType) {
        if (bannerBlock) {
            return bannerBlock();
        }
    }else if (self.adType == KMJADInterstitialInternalType){
        if (interstitialBlock) {
            return interstitialBlock();
        }
    }else if (self.adType == KMJADInlineInternalType){
        if (inlineBlock) {
            return inlineBlock();
        }
    } else {
        NSAssert(NO, @"");
    }
    return nil;
}
- (void)updateMask {

    if(self.backgroundLayer) {

        [self.backgroundLayer removeFromSuperlayer];
        self.backgroundLayer = nil;

    }
    switch (self.defaultMaskType) {

        case LXMJViewMaskTypeCustom:
        case LXMJViewMaskTypeBlack:{

            self.backgroundLayer = [CALayer layer];
            self.backgroundLayer.frame = self.bounds;
            self.backgroundLayer.backgroundColor = self.defaultMaskType == LXMJViewMaskTypeCustom ? self.backgroundLayerColor.CGColor : [UIColor colorWithWhite:0 alpha:0.4].CGColor;
            [self.backgroundLayer setNeedsDisplay];

            [self.layer insertSublayer:self.backgroundLayer atIndex:0];
            break;
        }

        case LXMJViewMaskTypeGradient:{
            MJGradientLayer *layer = [MJGradientLayer layer];
            self.backgroundLayer = layer;
            self.backgroundLayer.frame = self.bounds;
            CGPoint gradientCenter = self.center;
            gradientCenter.y = (self.bounds.size.height - 0)/2;//self.visibleKeyboardHeight
            layer.gradientCenter = gradientCenter;
            [self.backgroundLayer setNeedsDisplay];

            [self.layer insertSublayer:self.backgroundLayer atIndex:0];
            break;
        }
        default:{
            [self setUserInteractionEnabled:NO];
            break;
        }
    }
}
#pragma mark -
#pragma mark - masonry
- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect bounds = self.mjLabADLogo.bounds;
    if (bounds.size.width <= 0) {
        bounds = CGRectMake(0, 0, 26, 12);
    }
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.mjLabADLogo.bounds;
    maskLayer.path = maskPath.CGPath;
    self.mjLabADLogo.layer.mask = maskLayer;
    //
    [self doitBanner:nil interstitial:^{
        [self updateMask];
    } inline:nil];
}
//- (void)updateConstraints{
//    [super updateConstraints];
//    //
//    [self masonry];
//}
- (void)masonry
{
    [self doitBanner:^{
        UIView *superView = [self superview];
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            //
            make.edges.equalTo(superView).priorityLow();
            make.width.lessThanOrEqualTo(@(kMainScreen_suitWidth));
            make.centerX.equalTo(superView);
            make.height.equalTo(@(kADBannerHeight));
            if (self.position == KMJADTopPosition) {
                make.top.equalTo(superView).offset(20.f);
            }else if (self.position == KMJADBottomPosition) {
                make.bottom.equalTo(superView);
            }
        }];
        [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.edges.equalTo(self);
        }];
        [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.top.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [self.mjLabADLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
    } interstitial:^{
        UIView *superView = [self superview];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.edges.equalTo(superView);
        }];

        [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.center.equalTo(superView);
            make.size.mas_equalTo(CGSizeMake(300.f, 250.f));
        }];
        [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.top.equalTo(self.table).offset(5);
            make.right.equalTo(self.table).offset(-5);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [self.mjLabADLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.right.equalTo(self.table);
            make.bottom.equalTo(self.table);
        }];
    } inline:^{
        UIView *superView = [self superview];

        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            //
            make.edges.equalTo(superView).priorityLow();
            make.top.equalTo(superView).offset(20.f);
            make.width.lessThanOrEqualTo(@(kMainScreen_suitWidth));
            make.centerX.equalTo(superView);
            make.height.equalTo(@(kMJInlineHeight));
        }];
        [self.table mas_remakeConstraints:^(MASConstraintMaker *make) {
            //
            make.edges.equalTo(self);
        }];
        [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.top.equalTo(self).offset(5);
            make.right.equalTo(self).offset(-5);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [self.mjLabADLogo mas_makeConstraints:^(MASConstraintMaker *make) {
            //
            make.right.equalTo(self).offset(-5.f);
            make.bottom.equalTo(self).offset(-5.f);
        }];
    }];
}
#pragma mark -
#pragma mark - setter/getter

#pragma mark - closed methods

#pragma mark -
#pragma mark - block

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
#pragma mark - btnClose
- (UIButton *)btnClose
{
    if(!_btnClose){

        _btnClose = [MJFactory MJADClose];
        //绑定事件
        [_btnClose addTarget:self action:@selector(btnCloseClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _btnClose;
}
- (void)btnCloseClick:(id)sender
{
    //        UIButton *btn = (UIButton *)sender;
    //
    self.isShow = NO;
    [self removeFromSuperview];
    [self mjDidSIMBannerClosed:nil];
    //    [[NSNotificationCenter defaultCenter]postNotificationName:kMJSDKDidBannerClosedNotification object:self];
}
#pragma mark - mjLabADLogo
- (UILabel *)mjLabADLogo
{
    if(!_mjLabADLogo){
        _mjLabADLogo = [MJFactory MJADLogoLab];
    }
    return _mjLabADLogo;
}

@end
