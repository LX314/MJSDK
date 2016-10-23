//
//  MJOpenScreenManager.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/7.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJOpenScreen.h"

#import <ReactiveCocoa.h>

#import "MJTool.h"
#import "Colours.h"
#import "Masonry.h"
#import "MJDataManager.h"
#import "UIImage+cached.h"
#import "MJRequestManager.h"
#import "UIImageView+placeholder.h"
#import "MJExceptionReportManager.h"

//缓存数据 key
#define kMJSDKFullScreenPreLoadedMJResponseData @"kMJSDKFullScreenPreLoadedMJResponseData"
#define kMJSDKHalfScreenPreLoadedMJResponseData @"kMJSDKHalfScreenPreLoadedMJResponseData"

@interface MJOpenScreen ()
{
    id _rootViewController;
    NSTimeInterval _timeInterval;
    kMJTimerStatus _timerStatus;
}
@property (nonatomic, strong) dispatch_source_t timer;
//Developer
/** 广告位ID*/
@property (nonatomic,copy)NSString *adSpaceID;
/** 点击手势*/
@property (nonatomic,retain)UITapGestureRecognizer *tapRecognizer;
/** Manager */
@property (nonatomic,assign)BOOL isShow;
@property (nonatomic,assign)BOOL hasReady;
@property (nonatomic,copy)NSString *showUrl;
/** 曝光*/
@property (nonatomic,copy)kMJGotoExposureBlock mjGotoExposureBlock;
/** 开屏广告*/
@property (nonatomic,retain)UIImageView *imgView;
/** 开屏广告关闭按钮*/
@property (nonatomic,retain)UIButton *btn_skip;
/** 开屏广告倒计时展示*/
@property (nonatomic,retain)UILabel *label_skip;
/** 广告标识*/
@property (nonatomic,retain)UILabel *lab_ad;
/** 数据源*/
@property (nonatomic,retain)NSArray *arrayData;
/** 广告类型*/
@property (nonatomic,assign)KMJADType adType;
/** 数据源*/
@property (nonatomic,retain)MJResponse *mjResponse;

//*************Half***************
/** 广告logo展示框*/
@property (nonatomic,retain)UIImageView *imgView_logo;
/** 广告copyRight展示栏*/
@property (nonatomic,retain)UILabel *lab_description;
/** 开屏广告(半屏)底部logo*/
@property (nonatomic,retain)UIImage * img_halfOpenLogo;
/** 开屏广告(半屏)底部copyRight*/
@property (nonatomic,copy)NSString * str_copyRight;

@end
@implementation MJOpenScreen

/**
 *  @brief 初始化开屏广告
 *
 *  @param adSpaceID 广告位ID
 *
 *  @return instacetype
 */
+ (instancetype)registerFullOpenScreenWithAdSpaceID:(NSString *)adSpaceID {
    NSParameterAssert(adSpaceID && adSpaceID.length >= 5);
    return [[self alloc]initWithAdType:KMJADOpenFullScreenInternalType adSpaceID:adSpaceID ico:nil copyRight:nil];
}

/**
 *  @brief 初始化半屏广告
 *
 *  @param adSpaceID 广告位 ID
 *  @param ico       ico
 *  @param coptRight coptRight description
 *
 *  @return instancetype
 */
+ (instancetype)registerHalfOpenScreenWithAdSpaceID:(NSString *)adSpaceID ico:(UIImage *)ico copyRight:(NSString *)copyRight {
    NSParameterAssert(adSpaceID && adSpaceID.length >= 5);
    NSString *info = [NSString stringWithFormat:@"ico 不正确!:%@",ico];
    NSAssert(ico && [ico isKindOfClass:[UIImage class]], info);
    NSAssert(copyRight && copyRight.length > 1 &&copyRight.length <= 50, @"copyRight 不正确");
    return [[self alloc]initWithAdType:KMJADOpenHalfScreenInternalType adSpaceID:adSpaceID ico:ico copyRight:copyRight];
}
#pragma mark -
#pragma mark - Developer
- (instancetype)init{
    NSAssert(NO, @"必须使用 SDK 提供的初始化方法");
    if (self = [super init]) {
    }
    return self;
}
/**
 *  初始化半屏
 *
 *  @param adSpaceID 广告位 ID
 *  @param ico       ico
 *  @param coptRight coptRight description
 *
 *  @return instancetype
 */
- (instancetype)initWithAdType:(KMJADType)adTye adSpaceID:(NSString *)adSpaceID ico:(UIImage *)ico copyRight:(NSString *)copyRight {
    if (self = [super init]) {
        _adType = adTye;
        _adSpaceID = adSpaceID;
        _img_halfOpenLogo = ico;
        _str_copyRight = copyRight;
        if (_adType == KMJADOpenFullScreenInternalType) {
            [self initialFullOpenScreen];
        } else {
            [self initialHalfOpenScreen];
        }
        [self masonry];
        [self.imgView_logo setImage:_img_halfOpenLogo];
        [self.lab_description setText:_str_copyRight];
        [self.view addGestureRecognizer:self.tapRecognizer];
    }
    return self;
}
#pragma mark - tapRecognizer
- (UITapGestureRecognizer *)tapRecognizer
{
    if(!_tapRecognizer){
        _tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapRecognizer:)];
    }
    return _tapRecognizer;
}
- (void)tapRecognizer:(UIGestureRecognizer *)Recognizer {
     MJImpAds *impAds = self.mjResponse.impAds[0];
    NSString *clickURL = impAds.bannerAds.clickUrl;
    [MJExceptionReportManager mjGotoLandingPageUrl:clickURL before:^{
        _timeInterval += 1;
        if (_timer) {
            dispatch_suspend(_timer);
        }
    } completion:^{
        if (_timer) {
            dispatch_resume(_timer);
        }
    }];
    //
    WEAKSELF
    [MJTool responds:weakSelf.delegate toSelector:@selector(mjADDidClick:error:) block:^{
        [weakSelf.delegate mjADDidClick:weakSelf.view error:nil];
    }];
}
- (void)racMJResponse {
    [[RACObserve(self, mjResponse) filter:^BOOL(id value) {
        //
        return NO;
    }] subscribeNext:^(id x) {
        //
    }];
}

/**
 *  @brief 预加载处理
 */
- (void)preloadData {
    [self loadDataSuccessBlock:^(MJResponse * _Nonnull mjResponse, NSDictionary *responseObject) {
        //save mjresponse
        NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:mjResponse error:nil];
        NSString *jsonString = [MJTool toJsonString:dict];
        [self doitFullOpenScreen:^{
            [[NSUserDefaults standardUserDefaults]setObject:jsonString forKey:kMJSDKFullScreenPreLoadedMJResponseData];
            [[NSUserDefaults standardUserDefaults]synchronize];
        } halfOpenScreen:^{
            [[NSUserDefaults standardUserDefaults]setObject:jsonString forKey:kMJSDKHalfScreenPreLoadedMJResponseData];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }];
        
        //cached other resources
        MJImpAds *impAds = mjResponse.impAds[0];
        [UIImage mj_setImageWithURLString:impAds.bannerAds.mjElement.image placeholderImage:nil success:nil failure:nil];
    } errorBlock:nil];
}

//广告数据请求
- (void)loadDataSuccessBlock:(kRequestSuccessBlock)successBlock errorBlock:(kRequestErrorBlock)errorBlock {
    if (self.hasReady) {
        NSLog(@"had ready...");
//        return;
    }
    MJDataManager *dataManager = [MJDataManager manager];
    [dataManager setEventID:@"4" adlocCode:self.adSpaceID adCount:kMJSDKFullOpenScreenRequestCount];
    NSDictionary *params = dataManager.requestManager.request;
    WEAKSELF
    [dataManager loadData:params adType:self.adType successBlock:^(MJResponse *mjResponse, NSDictionary *responseObject) {
        //
        weakSelf.mjResponse = mjResponse;
        weakSelf.hasReady = YES;
//        NSDictionary *sortedDict = [MJTool sortDict:responseObject];
//        NSString *json = [MJTool toJsonString:sortedDict];
//        if (_isPreLoadData) {
//            _isPreLoadData = NO;
//
//            
//        }
        [MJTool responds:weakSelf.delegate toSelector:@selector(mjADRequestData:error:) block:^{
            [weakSelf.delegate mjADRequestData:weakSelf.view error:nil];
        }];
        if (successBlock) {
            successBlock(mjResponse, responseObject);
        }
    } errorBlock:^(NSURLResponse *response, NSError *error) {
        //
        [MJTool responds:weakSelf.delegate toSelector:@selector(mjADRequestData:error:) block:^{
            [weakSelf.delegate mjADRequestData:weakSelf.view error:error];
        }];
        if (errorBlock) {
            errorBlock(response, error);
        }
    }];
}

/**
 *  @brief 广告展示
 */
- (void)show{
    if (self.isShow) {
        NSLog(@"已经展示,不能重复展示");
        return;
    }
    //读取缓存数据
    __block NSString * savedJsonString;
    [self doitFullOpenScreen:^{
        savedJsonString = [[NSUserDefaults standardUserDefaults]objectForKey:kMJSDKFullScreenPreLoadedMJResponseData];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:kMJSDKFullScreenPreLoadedMJResponseData];
    } halfOpenScreen:^{
        savedJsonString = [[NSUserDefaults standardUserDefaults]objectForKey:kMJSDKHalfScreenPreLoadedMJResponseData];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:kMJSDKHalfScreenPreLoadedMJResponseData];
    }];
   
    NSDictionary *response = [MJTool toJsonObject:savedJsonString];
//    NSDictionary *sortedDict = [MJTool sortDict:response];
//    NSString *json = [MJTool toJsonString:sortedDict];
    NSError *error;
    MJResponse *mjResponse = [MTLJSONAdapter modelOfClass:[MJResponse class] fromJSONDictionary:response error:&error];
    
    if (error || !response || mjResponse.impAds.count <= 0) {
        NSLog(@"首次加载,缓存数据ing...");
        [self preloadData];
        return;
    }
    self.mjResponse = mjResponse;
    WEAKSELF
    [MJTool responds:self.delegate toSelector:@selector(mjADWillShow:error:) block:^{
        [weakSelf.delegate mjADWillShow:weakSelf.view error:nil];
    }];
    self.isShow = YES;
    [self initShow];
    _timerStatus = kMJTimerUnKnownStatus;
    _timeInterval = kMJOpenScreenTimerInterval;
    [self timerResumed];
    self.mjGotoExposureBlock(self.mjResponse.impAds[0]);
    [MJTool responds:self.delegate toSelector:@selector(mjADDidEndShow:error:) block:^{
        [weakSelf.delegate mjADDidEndShow:weakSelf.view error:nil];
    }];
}

- (void)initShow {
    _rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    MJImpAds *impAds = [self.mjResponse.impAds firstObject];
//    MJBannerAds *bannerAds = impAds.bannerAds;
    kMJSuperview.rootViewController = self;
    //
    [self fill:impAds];

}
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
                    [weakSelf.delegate mjADDidExposure:weakSelf.view error:nil];
                }];
            } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
                //
                [MJTool responds:weakSelf.delegate toSelector:@selector(mjADDidExposure:error:) block:^{
                    [weakSelf.delegate mjADDidExposure:weakSelf.view error:error];
                }];
            }];
        };

    }

    return _mjGotoExposureBlock;
}
//- (void)exposureBlock {
//    WEAKSELF
//    kMJGotoExposureBlock = ^(MJImpAds *impAds){
//        impAds.hasExposured = YES;
//        [MJExceptionReportManager uploadOnlineExposureReport:impAds success:^{
//            //
//            [MJTool responds:weakSelf.delegate toSelector:@selector(mjADDidExposure:error:) block:^{
//                [weakSelf.delegate mjADDidExposure:weakSelf.view error:nil];
//            }];
//        } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
//            //
//            [MJTool responds:weakSelf.delegate toSelector:@selector(mjADDidExposure:error:) block:^{
//                [weakSelf.delegate mjADDidExposure:weakSelf.view error:error];
//            }];
//        }];
//    };
//}
/**
 * 清除缓存
 */
- (void)clearAdsAndStopAutoRefresh {
}
#pragma mark -
#pragma mark - internal
- (void)initialFullOpenScreen {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.btn_skip];
    [self.view addSubview:self.label_skip];
    [self.view addSubview:self.lab_ad];
    MASAttachKeys(self.imgView,self.btn_skip,self.label_skip,self.lab_ad);
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
}
- (void)initialHalfOpenScreen {
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.btn_skip];
    [self.view addSubview:self.label_skip];
    [self.view addSubview:self.lab_ad];
    MASAttachKeys(self.imgView,self.btn_skip,self.label_skip,self.lab_ad);
    //
    [self.view addSubview:self.imgView_logo];
    [self.view addSubview:self.lab_description];
    MASAttachKeys(self.imgView_logo,self.lab_description);
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)fill:(MJImpAds *)impAds {
    MJElement *mjEelements = impAds.bannerAds.mjElement;
    NSString * imageUrl = mjEelements.image;
    __block NSString *placeholderImageName;
    [self doitFullOpenScreen:^{
        placeholderImageName = kMJSDKFullScreenIMGPlaceholderImageName;
    } halfOpenScreen:^{
        placeholderImageName = kMJSDKHalfScreenGLPlaceholderImageName;
    }];
    [self.imgView mj_setImageWithURLString:imageUrl placeholderImage:placeholderImageName impAds:nil success:nil failure:nil];
    [self.label_skip setText:@"  跳过 5s  "];
}
#pragma mark - Screen Limit
-(BOOL)shouldAutorotate {
    
    return YES;
    
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
    
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return UIInterfaceOrientationPortrait;
    
}
#pragma mark -
#pragma mark - 定时器 - timer
- (dispatch_source_t)timer
{
    if(!_timer){
        //需要将dispatch_source_t timer设置为成员变量，不然会立即释放
        //@property (nonatomic, strong) dispatch_source_t timer;
        //定时器开始执行的延时时间
        NSTimeInterval delayTime = 0;
        //定时器间隔时间
        NSTimeInterval timeInterval = 1;
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
            NSLog(@"[%@][%@]...", KNSStringFromMJADType(self.adType), _timer);
            [self timerEventHandler];
        });
        dispatch_source_set_cancel_handler(_timer, ^{
            //stop the timer here.
            NSLog(@"cancel timer...");
            [self timerCancelHandler];
//            [self timerCancel];
        });
// 启动计时器
//        dispatch_resume(_timer);
    }
    return _timer;
}
- (void)timerEventHandler {
    if(_timeInterval <= 0){ //倒计时结束，关闭
        [self timerCancel];
        return ;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *title = [NSString stringWithFormat:@"  %.0fs 跳过  ",_timeInterval];
        NSLog(@"title:%@",title);
        [self.label_skip setText:title];
        _timeInterval--;
    });
}
- (void)timerCancelHandler {
    dispatch_async(dispatch_get_main_queue(), ^{
        //设置界面的按钮显示 根据自己需求设置
        self.isShow = NO;
        kMJSuperview.rootViewController = _rootViewController;
        _timer = nil;
        NSLog(@"Cancel...");
    });
}
- (void)timerResumed {
    if (_timerStatus != kMJTimerResumedStatus) {
        dispatch_resume(self.timer);
        _timerStatus = kMJTimerResumedStatus;
    }
}
- (void)timerSuspend {
    if (_timer && _timerStatus == kMJTimerResumedStatus) {
        dispatch_suspend(_timer);
        _timerStatus = kMJTimerSuspendStatus;
    }
}
- (void)timerCancel {
    if (!_timer || _timerStatus == kMJTimerSuspendStatus) {
        [self timerResumed];
    }
    if (_timer && _timerStatus == kMJTimerResumedStatus) {
        dispatch_source_cancel(self.timer);
        _timerStatus = kMJTimerCanceledStatus;
    }
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
    _showUrl = [mjResponse.impAds[0] showUrl];
    _mjResponse = mjResponse;
    //    self.arrayData = mjResponse.impAds;
    for (MJImpAds *impAds in _mjResponse.impAds) {
        impAds.showUrl = _mjResponse.showUrl;
    }
}
#pragma mark -
#pragma mark - Masonry Methods
//- (void)updateViewConstraints {
//    [super updateViewConstraints];
//    //
//    [self masonry];
//}
- (void)masonry
{//[self masonry];
//    [super masonry];
    //
    UIView *superView = self.view;
    [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(superView);
    }];
    [self.btn_skip mas_remakeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(superView).offset(15.f);
        make.right.equalTo(superView).offset(-15.f);
    }];
    [self.label_skip mas_remakeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(self.btn_skip);
    }];
    
    [self.lab_ad mas_remakeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.left.equalTo(superView).offset(15.f);
    }];

    if (self.adType == KMJADOpenHalfScreenInternalType) {
        UIView *superView = self.view;
        //
        [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //
            make.top.left.right.equalTo(superView);
            make.bottom.equalTo(self.imgView_logo.mas_top).offset(-15.f);
        }];
        [self.imgView_logo mas_remakeConstraints:^(MASConstraintMaker *make) {
            //
            make.bottom.equalTo(self.lab_description.mas_top).offset(-8.f);
            make.size.mas_equalTo(CGSizeMake(90.f, 38.f));
            make.centerX.equalTo(superView);
        }];
        [self.lab_description mas_remakeConstraints:^(MASConstraintMaker *make) {
            //
            make.bottom.equalTo(superView).offset(-15.f);
            make.centerX.equalTo(superView);
            make.height.equalTo(@16.f);
        }];
    }
}

- (void)dealloc {
}
#pragma mark - arrayData
- (NSArray *)arrayData
{
    if(!_arrayData){
        _arrayData = @[
                    
                       ];
    }
    return _arrayData;
}


#pragma mark - btn_skip
- (UIButton *)btn_skip
{
    if(!_btn_skip){
        
        //初始化一个 Button
        _btn_skip = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_skip setFrame:CGRectZero];
        
        [_btn_skip setBackgroundColor:[UIColor colorFromHexString:@"#ffffff"]];
        
        //标题
        [_btn_skip setTitle:@"" forState:UIControlStateNormal];
        //标题颜色
        [_btn_skip setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_btn_skip.layer setCornerRadius:8.f];
        [_btn_skip setAlpha:0.2f];
        
        //绑定事件
        [_btn_skip addTarget:self action:@selector(btnSkipClick:) forControlEvents:UIControlEventTouchUpInside];

        
    }
    
    return _btn_skip;
}
- (void)btnSkipClick:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        kMJSuperview.rootViewController = _rootViewController;
        dispatch_source_cancel(_timer);
    });
}
#pragma mark - label_skip
- (UILabel *)label_skip
{
    if(!_label_skip){
        _label_skip = [[UILabel alloc]init];
        [_label_skip setAlpha:0.8f];
        [_label_skip setTextColor:[UIColor whiteColor]];
        [_label_skip setFont:[UIFont systemFontOfSize:14.f]];
        [_label_skip.layer setShadowColor:[UIColor blackColor].CGColor];
        [_label_skip.layer setShadowOffset:CGSizeMake(1, 1)];
        [_label_skip.layer setShadowOpacity:0.8];
    }
    
    return _label_skip;
}
#pragma mark - imgView
- (UIImageView *)imgView
{
    if(!_imgView){
        
        _imgView = [[UIImageView alloc]init];
        
    }
    
    return _imgView;
}
#pragma mark - lab_ad
- (UILabel *)lab_ad
{
    if(!_lab_ad){
        _lab_ad = [[UILabel alloc]init];
        [_lab_ad setText:@"广告"];
        [_lab_ad setTextColor:[UIColor whiteColor]];
        [_lab_ad setFont:[UIFont systemFontOfSize:12.f]];
        [_lab_ad setAlpha:0.8f];
        [_lab_ad.layer setShadowColor:[UIColor blackColor].CGColor];
        [_lab_ad.layer setShadowOffset:CGSizeMake(1, 1)];
        [_lab_ad.layer setShadowOpacity:0.8];
    }
    return _lab_ad;
}



#pragma mark -
#pragma mark - Half Screen Style 
#pragma mark - imgView_logo
- (UIImageView *)imgView_logo
{
    if(!_imgView_logo){
        _imgView_logo = [[UIImageView alloc]init];
        
    }
    
    return _imgView_logo;
}
#pragma mark - lab_description
- (UILabel *)lab_description
{
    if(!_lab_description){
        //初始化一个 Label
        _lab_description = [[UILabel alloc]init];
        [_lab_description setFrame:CGRectZero];
        [_lab_description setText:@"Copyright © 2016年 WM. All rights reserved."];
        [_lab_description setTextColor:[UIColor colorFromHexString:@"#787878"]];
        [_lab_description setFont:[UIFont systemFontOfSize:12.f]];
    }
    
    return _lab_description;
}

#pragma mark -
#pragma mark - Half
- (id)doitFullOpenScreen:(void(^)(void))fullOpenScreenBlock halfOpenScreen:(void(^)(void))halfOpenScreenBlock {
    if (self.adType == KMJADOpenFullScreenInternalType) {
        if (fullOpenScreenBlock) {
            fullOpenScreenBlock();
        }
    }else if (self.adType == KMJADOpenHalfScreenInternalType){
        if (halfOpenScreenBlock) {
            halfOpenScreenBlock();
        }
    } else {
        NSAssert(NO, @"");
    }
    return nil;
}

@end
