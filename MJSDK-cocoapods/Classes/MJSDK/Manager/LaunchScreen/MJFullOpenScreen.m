//
//  MJOpenScreenManager.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/7.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJFullOpenScreen.h"

#import "MJSDKConf.h"
#import "MJHalfOpenScreen.h"
#import "MJExceptionReportManager.h"

#import "UIImage+cached.h"
#import "UIImageView+placeholder.h"

#import <ReactiveCocoa.h>

//缓存数据 key
#define kMJSDKFullScreenPreLoadedMJResponseData @"kMJSDKFullScreenPreLoadedMJResponseData"

@interface MJFullOpenScreen ()
{
    NSTimeInterval _timeInterval;
    dispatch_source_t _timer;

}

//Developer
/** <#注释#>*/
@property (nonatomic,copy)NSString *adSpaceID;


/** <#注释#>*/
@property (nonatomic,retain)UIImageView *imgView_logo;
/** <#注释#>*/
@property (nonatomic,retain)UILabel *lab_description;
@property (nonatomic,retain)UITapGestureRecognizer *tapRecognizer;


@end
@implementation MJFullOpenScreen
#pragma mark -
#pragma mark - Developer
- (instancetype)init{
    NSAssert(NO, @"必须使用 SDK 提供的初始化方法");
    if (self = [super init]) {
    }
    return self;
}
- (instancetype)initWithAdSpaceID:(NSString *)adSpaceID {
    NSAssert(adSpaceID && adSpaceID.length > 0, @"广告位 ID 不能为空!");
    if (self = [super init]) {
        _adSpaceID = adSpaceID;
        _adType = KMJADOpenFullScreenInternalType;
        _openScreenStyle = KMJOpenScreenFullScreenStyle;
        [self.view addGestureRecognizer:self.tapRecognizer];
        [self exposureBlock];
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

+ (instancetype)manager {
    static MJFullOpenScreen *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc]initWithAdSpaceID:kFullOpenScreen];
    });

    return _sharedInstance;
}
- (void)tapRecognizer:(UIGestureRecognizer *)Recognizer {
     MJImpAds *impAds = self.mjResponse.impAds[0];
    NSString *clickURL = impAds.bannerAds.clickUrl;
    [MJExceptionReportManager mjGotoLandingPageUrl:clickURL];
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
- (void)preloadData {
    [self loadDataSuccessBlock:^(MJResponse * _Nonnull mjResponse, NSDictionary *responseObject) {
        //save mjresponse
        NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:mjResponse error:nil];
        NSString *jsonString = [MJTool toJsonString:dict];
        [[NSUserDefaults standardUserDefaults]setObject:jsonString forKey:kMJSDKFullScreenPreLoadedMJResponseData];
        [[NSUserDefaults standardUserDefaults]synchronize];
        //cached other resources
        MJImpAds *impAds = mjResponse.impAds[0];
        [UIImage mj_setImageWithURLString:impAds.bannerAds.mjElement.image placeholderImage:nil success:nil failure:nil];
    } errorBlock:nil];
}
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
- (void)show{
    if (self.isShow) {
        NSLog(@"已经展示,不能重复展示");
        return;
    }
    //读取缓存数据
    NSString *savedJsonString = [[NSUserDefaults standardUserDefaults]objectForKey:kMJSDKFullScreenPreLoadedMJResponseData];
    NSDictionary *response = [MJTool toJsonObject:savedJsonString];
//    NSDictionary *sortedDict = [MJTool sortDict:response];
//    NSString *json = [MJTool toJsonString:sortedDict];
    NSError *error;
    MJResponse *mjResponse = [MTLJSONAdapter modelOfClass:[MJResponse class] fromJSONDictionary:response error:&error];
    if (mjResponse) {
//        NSDictionary *reverseDict = [MTLJSONAdapter JSONDictionaryFromModel:mjResponse error:nil];
//        NSDictionary *sortedDict = [MJTool sortDict:reverseDict];
//        NSString *json = [MJTool toJsonString:sortedDict];
//        NSLog(@"");
    }
    [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:kMJSDKFullScreenPreLoadedMJResponseData];
    if (error || !response || mjResponse.impAds.count <= 0) {
        NSLog(@"首次加载,缓存数据ing...");
        [self preloadData];
        return;
    }
    self.mjResponse = mjResponse;
    if (self.mjResponse.impAds.count <= 0) {
        NSLog(@"没有广告,展示默认广告");
        NSAssert(NO, @"没有广告,展示默认广告");
    }
    WEAKSELF
    [MJTool responds:self.delegate toSelector:@selector(mjADWillShow:error:) block:^{
        [weakSelf.delegate mjADWillShow:weakSelf.view error:nil];
    }];
    self.isShow = YES;
    [self initShow];
    kMJGotoExposureBlock(self.mjResponse.impAds[0]);
    [MJTool responds:self.delegate toSelector:@selector(mjADDidEndShow:error:) block:^{
        [weakSelf.delegate mjADDidEndShow:weakSelf.view error:nil];
    }];
}
- (void)initShow {
    _rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    MJImpAds *impAds = [self.mjResponse.impAds firstObject];
//    MJBannerAds *bannerAds = impAds.bannerAds;
    mjSuperview().rootViewController = self;
    //
    [self fill:impAds];

}
- (void)exposureBlock {
    WEAKSELF
    kMJGotoExposureBlock = ^(MJImpAds *impAds){
        impAds.hasExposured = YES;
        [MJExceptionReportManager uploadOnlineExposureReport:impAds success:^{
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
/**
 * 清除缓存
 */
- (void)clearAdsAndStopAutoRefresh {
}
#pragma mark -
#pragma mark - internal

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    //
    [self mjTimer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.btn_skip];
    [self.view addSubview:self.label_skip];
    [self.view addSubview:self.lab_ad];
    
    MASAttachKeys(self.imgView,self.btn_skip,self.label_skip,self.lab_ad);
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.imgView_logo];
    [self.view addSubview:self.lab_description];
    MASAttachKeys(self.imgView_logo,self.lab_description);
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
    //
}
- (void)fill:(MJImpAds *)impAds {
    MJElement *mjEelements = impAds.bannerAds.mjElement;
    NSString * imageUrl = mjEelements.image;
    [self.imgView mj_setImageWithURLString:imageUrl placeholderImage:[UIImage imageNamed:kMJSDKFullScreenIMGPlaceholderImageName] impAds:nil success:nil failure:nil];
    [self.label_skip setText:@"  跳过 5s  "];;
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

- (void)mjTimer {
    //
    WEAKSELF
   _timeInterval = 5; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
//    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(_timer, ^{
        if(_timeInterval<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *title = [NSString stringWithFormat:@"  %.0fs 跳过  ",_timeInterval];
            NSLog(@"title:%@",title);
            [self.label_skip setText:title];
            _timeInterval--;
        });
    });
    dispatch_source_set_cancel_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //设置界面的按钮显示 根据自己需求设置
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.isShow = NO;
                weakSelf.hasReady = NO;
                mjSuperview().rootViewController = _rootViewController;
            });
            NSLog(@"Cancel...");
        });
    });
    dispatch_resume(_timer);
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
- (void)updateViewConstraints {
    [super updateViewConstraints];
    //
    [self masonry];
}
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
        mjSuperview().rootViewController = _rootViewController;
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

@end
