//
//  MJJAppsWall.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/9/13.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJAppsWall.h"

#import "MJRE.h"
#import "Tool.h"
#import "MJTool.h"
#import "MJError.h"
#import "MJToast.h"
#import "MJShare.h"
#import "MJDataManager.h"
#import "MJPropManager.h"
#import "MJCouponManager.h"
#import "MJRequestManager.h"
#import "MJExceptionReport.h"
#import "MJAppsFriendlyCell.h"
#import "UIImage+imageNamed.h"
#import "AppNavigationController.h"
#import "MJExceptionReportManager.h"

#import <Masonry.h>
#import <ReactiveCocoa.h>
#import "MJBlocks.h"

#define shareHeight kMainScreen_suitWidth / 320 * 74

@interface MJAppsWall()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *_propParams;
    MJResponse *_mjjResponse;
}
/** 父容器*/
@property (nullable, nonatomic,retain)UIViewController *parentVC;
/** 道具ID*/
@property (nonatomic,retain)NSString *props_id;
/** 道具价格*/
@property (nonatomic,assign)NSInteger price;
/** 数据源*/
@property (nonatomic,retain)MJResponse *mjResponse;
/** 头视图*/
@property (nonatomic,retain)UIView *headView;
/** 标题*/
@property (nonatomic,retain)UILabel *navTitleLabel;
/** 广告类型*/
@property (nonatomic,assign)KMJADType adType;
/** Block*/
@property (nonatomic,copy)kMJGotoExposureBlock mjGotoExposureBlock;

@end
@implementation MJAppsWall
/**
 *  @brief 初始化广告墙
 *
 *  @param adSpaceID  广告位 ID(必须)
 *  @param props_id   道具 ID(必须)
 *  @param price      (分)(必须)
 *
 *  @return instancetype
 */
+ (instancetype)registerAppsWallWithAdSpaceID:(NSString *)adSpaceID props_id:(NSString *)props_id price:(NSInteger)price {
    NSAssert(adSpaceID && adSpaceID.length > 0, @"广告位 ID 不能为空!");
    NSAssert(props_id && props_id.length > 0, @"道具 ID 不能为空!");
    NSAssert(price > 0 && price <= 500, @"价格设置不合理!");
    return [[self alloc]initWithAdSpaceID:adSpaceID props_id:props_id price:price];
}
#pragma mark -
#pragma mark - initial
/**
 *  @brief 初始化广告墙
 *
 *  @param adSpaceID  广告位 ID(必须)
 *  @param props_id   道具 ID(必须)
 *  @param price      (分)(必须)
 *
 *  @return instancetype
 */
- (instancetype)initWithAdSpaceID:(NSString *)adSpaceID props_id:(NSString *)props_id price:(NSInteger)price {
    if (self = [super init]) {
        _adSpaceID = adSpaceID;
        _adType = KMJADAppsType;
        _props_id = props_id;
        _price = price;
        [self racMJResponse];
//        [self initRe];
        //        [self exposureBlock];
        //        [self mjToast];
    }
    return self;
}
- (void)initRe {
    //    [self.table setFrame:CGRectMake(0, 0, kMainScreen_width, kMainScreen_height - 64)];
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    [self.view addSubview:self.table];
    MASAttachKeys(self.table);

    //Hidden line
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //
    [self.table setTableHeaderView:self.headView];
    [self.table setSectionHeaderHeight:roundf(shareHeight)];
    [self.view setNeedsUpdateConstraints];
    [self.view setNeedsLayout];
}
#pragma mark -
#pragma mark - show
- (void)viewDidLoad{
    [super viewDidLoad];
    //
    self.automaticallyAdjustsScrollViewInsets = NO;
    //
    if((kIOSVersion >= 7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    //
    [self initRe];
    //
    [self changeTitle];
}
/**
 *  @brief 应用墙重新加载数据时必须调用
 */
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    //    if (!self.isShow) {
    //        return;
    //    }
    if (self.mjResponse.contentState == kMJAPPSContentFriendUIState || self.mjResponse.contentState == kMJAPPSContentNOTAvailableState) {
        [self.table setRowHeight:CGRectGetHeight(self.table.frame)];
    }else if (self.mjResponse.contentState == kMJAPPSContentNormallyState){
        [self.table setRowHeight:kMJAPPsRowHeight];
    } else {
        NSAssert(NO, @"");
    }
}
/**
 *  @brief dismiss
 */
- (void)dismiss{
    self.isShow = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        [self dismissViewControllerAnimated:YES completion:nil];
    });

}
- (void)rightItemClick:(id)sender{

    [self dismiss];
}
/**
 *  @brief 广告展示

 *  @param parentVC ViewController to present
 *  @param block    block
 */
- (void)showIn:(UIViewController *)parentVC {// closeBlock:(void(^_Nullable)(void))block {
    if (![self validatePrice]) {
        NSLog(@"价格设置不合理,请重试");
        MJNSLog(@"价格设置不合理,请重试");
        return;
    }
    if (parentVC) {
        self.parentVC = parentVC;
    }
    NSLog(@"1`检查当前道具领取状态...");
    [self queryPropStatus:^(CGFloat need_times) {
        //请求并加载数据
        [self loadDataSuccessBlock:^(MJResponse *mjResponse, NSDictionary *responseObject) {
            //
            mjResponse.need_times = need_times;
            //
            WEAKSELF
            [MJTool responds:weakSelf.delegate toSelector:@selector(mjADWillShow:error:) block:^{
                [weakSelf.delegate mjADWillShow:weakSelf.view error:nil];
            }];
            //------------------
            if (!self.isShow) {
                [self presentApps];
            }
            self.isShow = YES;
            self.mjResponse = mjResponse;
            [self changeTitle];
//            if (block) {
//                block();
//            }
            //--------------
            [MJTool responds:weakSelf.delegate toSelector:@selector(mjADDidEndShow:error:) block:^{
                [weakSelf.delegate mjADDidEndShow:weakSelf.view error:nil];
            }];
        } errorBlock:^(NSURLResponse * _Nonnull response, NSError * _Nonnull error) {
            MJResponse *mjResponse = [MTLJSONAdapter modelOfClass:[MJResponse class] fromJSONDictionary:@{} error:nil];
            mjResponse.contentState = kMJAPPSContentFriendUIState;
            if (!self.isShow) {
                [self presentApps];
            }
//#warning TODO test this case
            self.isShow = YES;
            mjResponse.need_times = need_times;
            self.mjResponse = mjResponse;
            [self changeTitle];
//            if (block) {
//                block();
//            }
        }];
    }];
}
- (void)sortListData {
    //刷新数据
    NSArray *array = self.mjResponse.impAds;
    array = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        MJImpAds *impAds1 = (MJImpAds *)obj1;
        MJImpAds *impAds2 = (MJImpAds *)obj2;
        if (impAds1.hasShared > impAds2.hasShared) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    self.mjResponse.impAds = array;
}
- (void)presentApps {
    UIViewController *vc_t = self;
    AppNavigationController *nav = [[AppNavigationController alloc]initWithRootViewController:vc_t];

    UIImage * navImage = [UIImage mj_imageNamed:@"guanggao@2x.jpg"];
    navImage = [navImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];


    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
    vc_t.navigationItem.rightBarButtonItem = rightBtnItem;
    [self.parentVC presentViewController:nav animated:YES completion:nil];
}

/**
 *  计算 integer 的长度
 *
 *  @param index integer
 *
 *  @return 长度
 */
- (NSInteger)getLength:(NSInteger)index {
    NSInteger length = 0;
    NSInteger index_t = index;
    while (index_t >= 1) {
        length++;
        index_t = index_t / 10.f;
    }
    return length;
}
/**
 *  更新 title
 */
-(void)changeTitle {
    if (self.mjResponse.need_times < 0) {
        NSLog(@"分享次数 %ld 小于0, 不予更新 title.", self.mjResponse.need_times);
        return;
    }
    NSInteger need_times = self.mjResponse.need_times;
    NSAttributedString *attributeString = [self getAttributeString:need_times];
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        self.navTitleLabel.attributedText = attributeString;
    });
    self.navigationItem.titleView = self.navTitleLabel;
}
#pragma mark -
#pragma mark - RAC
- (void)racMJResponse {
    [[RACObserve(self, mjResponse) filter:^BOOL(id value) {
        if (!self.mjResponse) {
            return NO;
        }
        if (!self.isShow) {
            NSLog(@"尚未show, 不予处理");
            return NO;
        }
        return YES;
    }] subscribeNext:^(id x) {
        if (self.mjResponse.contentState == kMJAPPSContentUnknownState) {
            self.mjResponse.contentState = kMJAPPSContentNormallyState;
        }
        NSInteger availableCount = [self getAvailableShareADCount];
        NSInteger need_times = self.mjResponse.need_times;
        if ((need_times > availableCount) && self.mjResponse.contentState != kMJAPPSContentFriendUIState) {
            self.mjResponse.contentState = kMJAPPSContentNOTAvailableState;
        }
        if (self.mjResponse.contentState == kMJAPPSContentFriendUIState || self.mjResponse.contentState == kMJAPPSContentNOTAvailableState) {
            MJNSLog(@"显示友好界面");
            NSLog(@"显示友好界面.ImpAds.count:%ld\tavailableCount:%ld\tneed_times:%ld", self.mjResponse.impAds.count, availableCount, need_times);
            CGFloat rowHeight = CGRectGetHeight(self.table.frame);
            if (rowHeight > 20.f) {
                [self.table setRowHeight:rowHeight];
            }
            [self.table reloadData];
            return;
        }
        [self.table setRowHeight:kMJAPPsRowHeight];
        NSLog(@"开始展示...");
        MJNSLog(@"开始展示...");
        NSLog(@"排序ing...");
        //排序
        [self sortListData];
        [self.table reloadData];

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
#pragma mark - mjAppsGetPropBlock
//获取道具
- (kMJAppsGetPropBlock)mjAppsGetPropBlock
{
    if(!_mjAppsGetPropBlock){
        WEAKSELF
        _mjAppsGetPropBlock = ^(){
            STRONGSELF
            if (![MJTool getIDFA:strongSelf.adSpaceID]) {
                return;
            }
            [MJPropManager claimPropID:strongSelf.props_id price:strongSelf.price adSpaceID:strongSelf.adSpaceID propBlock:^(NSDictionary *params) {
                /**status: 状态
                 *  1. 成功
                 *  2. 失败
                 */
                NSInteger status = [params[@"status"] integerValue];
                if (!params || status != 1) {
                    MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:strongSelf.adSpaceID code:kMJSDKERRORPropClaimFailure description:[NSString stringWithFormat:@"[道具][领取]失败{响应成功, read responseObject failure.}responseObject:%@\n\nResponse:%@", [params description], [params description]]];
                    [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
                    MJNSLog(@"errcode:%ld", report.code);
                    return;
                }
                if (status == 1) {
                    NSLog(@"领取道具成功!");
                    MJNSLog(@"领取道具成功!");
                    strongSelf.mjAppsShowToastBlock(@"领取道具成功!", YES);
                    NSString *prop_key = params[@"prop_key"];
                    strongSelf.prop_key = prop_key;
                    if ([strongSelf.delegate respondsToSelector:@selector(mjClaimProps:)]) {
                        [strongSelf.delegate mjClaimProps:prop_key];
                    }
                    //Global conf
                    if (kMJSDKShouldDisplayCoupon) {
                        //优惠券修改手机号
                        NSString * getModifyString = [MJTool getMJShareModifyTel];
                        if (getModifyString) {
                            MJCouponManager *manager = [MJCouponManager manager];
                            [manager loadUpdate:strongSelf.adSpaceID update:^(NSDictionary * _Nonnull params) {
                                BOOL success = [params[@"success"] boolValue];
                                if (success) {
                                    NSLog(@"修改成功!");
                                    MJNSLog(@"修改成功!");
                                }
                                [MJTool saveMJShareNewTel:getModifyString];
                                [MJTool clearLocalTELKeychainModify];

                                MJShare *mjShare = [[MJShare alloc]init];
                                [mjShare showIn:strongSelf];
                                return ;

                            } updatephoneNumber:getModifyString];
                        }
                        MJShare *mjShare = [[MJShare alloc]init];
                        [mjShare showIn:strongSelf];
                    }
                } else {
                    NSAssert(NO, @"11");
                }
            }];
        };

    }

    return _mjAppsGetPropBlock;
}
#pragma mark - mjAppsCellClickedBlock
- (kMJAppsCellClickedBlock)mjAppsCellClickedBlock
{
    WEAKSELF
    if(!_mjAppsCellClickedBlock){
        _mjAppsCellClickedBlock = ^(NSIndexPath *indexPath){
            [weakSelf changeTitle];
        };
    }
    return _mjAppsCellClickedBlock;
}
#pragma mark - mjAppsShowToastBlock
- (kMJAppsShowToastBlock)mjAppsShowToastBlock
{
    if(!_mjAppsShowToastBlock){
        _mjAppsShowToastBlock = ^(NSString *toastString, BOOL dismiss){
            UIView *superView = kMJSuperview;
            [MJToast toast:toastString in:superView];
        };
    }
    return _mjAppsShowToastBlock;
}
#pragma mark -
#pragma mark - Prop
- (BOOL)validatePrice {
    if (self.price <= 0 || self.price > 500) {
        return NO;
    }
    return YES;
}
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
- (void)queryPropAvailable:(void(^)(BOOL available))availableBlock {
    [MJPropManager queryPropID:self.props_id price:self.price adSpaceID:self.adSpaceID propBlock:^(NSDictionary *params) {
        NSInteger status = [params[@"status"] floatValue];
        /**status: 状态
         *  1: 未领取
         *  2: 已领取{今天免费任务已完成，明天再来吧。}
         *  3: 无足够分享次数{分享次数不够，兑换失败。}
         *  4: 价格超出上限{道具价格太高，兑换失败。}
         *  5: 数据错误{发生了一个错误，兑换失败。}
         *  6: 无法分享{另外个免费任务正在进行，兑换失败，请稍后再来。}
         */
        BOOL available = status == 1 ? YES : NO;
        if (availableBlock) {
            availableBlock(available);
        }
    }];
}
//检查当前道具领取状态
- (void)queryPropStatus:(void(^)(CGFloat need_times))availableBlock {
    [MJPropManager queryPropID:self.props_id price:self.price adSpaceID:self.adSpaceID propBlock:^(NSDictionary *params) {
        NSInteger status = [params[@"status"] floatValue];
        MJNSLog(@"prop code:100%ld",status);
        /**status: 状态
         *  1: 未领取
         *  2: 已领取{今天免费任务已完成，明天再来吧。}
         *  3: 无足够分享次数{分享次数不够，兑换失败。}
         *  4: 价格超出上限{道具价格太高，兑换失败。}
         *  5: 数据错误{发生了一个错误，兑换失败。}
         *  6: 无法分享{另外个免费任务正在进行，兑换失败，请稍后再来。}
         */
        NSString *key = [NSString stringWithFormat:@"Loc_QueryProp_Status_%ld", status];
        NSString *loc_doc = kMJNSLocalizedString(key, @"");
        switch (status) {
            case 1: {//未领取
                NSLog(@"未领取状态...");
                MJNSLog(@"未领取状态...");
                NSLog(@"开始查询尚需分享的次数...");
                CGFloat need_times = [params[@"need_times"] floatValue];
                if (need_times <= 0.f) {
                    NSLog(@"分享次数已经完成,开始领取道具");
                    MJNSLog(@"分享次数已经完成,开始领取道具");
                    self.mjAppsGetPropBlock();
                    return;
                }
                NSLog(@"分享次数尚未完成,尚需分享 %f 次", need_times);
                MJNSLog(@"分享次数尚未完成,尚需分享 %f 次", need_times);
                if (availableBlock) {
                    availableBlock(need_times);
                }
                break;
            }
            case 2: {
                NSLog(@"%@", loc_doc);
                self.mjAppsShowToastBlock(loc_doc, NO);
                if (kMJSDKDisplayCouponAgain) {
                    MJShare *mjShare = [[MJShare alloc]init];
                    [mjShare showIn:nil];
                }
                break;
            }
            case 3: case 4:case 5:case 6: {
                NSLog(@"%@", loc_doc);
                self.mjAppsShowToastBlock(loc_doc, NO);
                break;
            }
            default:
                break;
        }
    }];
}
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
+ (void)vertify:(NSString *)prop_key complete:(kMJPropManagerBlock)vertifyBlock {
    [MJPropManager vertify:prop_key complete:vertifyBlock];
}
#pragma mark -
#pragma mark - Coupons
#pragma mark -
#pragma mark - MJShare
- (NSInteger)getAvailableShareADCount {
    NSInteger availableCount = 0;
    for (MJImpAds *impAds in self.mjResponse.impAds) {
        if (!impAds.hasShared) {
            availableCount++;
        }
    }
    return availableCount;
}
#pragma mark -
#pragma mark - loadData
- (void)loadDataSuccessBlock:(kRequestSuccessBlock)successBlock errorBlock:(kRequestErrorBlock)errorBlock {
    MJDataManager *dataManager = [MJDataManager manager];
    [dataManager setEventID:@"4" adlocCode:self.adSpaceID adCount:kMJSDKAppsRequestCount];
    NSDictionary *params = dataManager.requestManager.request;
    WEAKSELF
    [dataManager loadData:params adType:self.adType successBlock:^(MJResponse *mjResponse, NSDictionary *responseObject) {
        //
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
#pragma mark -
#pragma mark - delegate
#pragma mark - TableView Required Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.mjResponse.contentState == kMJAPPSContentFriendUIState || self.mjResponse.contentState == kMJAPPSContentNOTAvailableState) {
        return 1;
    }else if (self.mjResponse.contentState == kMJAPPSContentNormallyState){
        return [self.mjResponse.impAds count];
    } else {
        return 0;
        NSAssert(NO, @"");
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.mjResponse.contentState == kMJAPPSContentFriendUIState || self.mjResponse.contentState == kMJAPPSContentNOTAvailableState) {
        static NSString *cellIdentifier = @"MJAppsFriendlyCell";
        MJAppsFriendlyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (!cell) {
            cell = [[MJAppsFriendlyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        [cell fill:self.mjResponse.contentState];
        return cell;
    }else if (self.mjResponse.contentState != kMJAPPSContentNormallyState) {
        NSAssert(NO, @"");
    }
    //    MJImpAds *impAds = self.mjResponse.impAds[indexPath.row];
    //    MJApps *apps = impAds.apps;
    //    KMJADType mjAdType = apps.mjAdType;
    static NSString *cellIdentifier = @"MJRECell";
    MJRE *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[MJRE alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    cell.appsManager = self;
    cell.selfIndexPath = indexPath;
    [cell fill:self.mjResponse];
    return cell;
    return nil;
}
#pragma mark - TableView Optional Methods
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"willDisplayCell:ROW[%ld]\t", indexPath.row);
    __block MJImpAds *impAds = self.mjResponse.impAds[indexPath.row];
    if (self.mjResponse.contentState != kMJAPPSContentNormallyState) {
        return;
    }
    if (impAds.hasExposured) {
        NSLog(@"willDisplayCell:ROW[%ld]已经曝光过", indexPath.row);
        return;
    }
    impAds.beginShowTime = [MJTool getInternetBJDate];
    //dispatch_after
    double delayInSeconds = kMJSDKExposureTimeInterval;
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_global_queue(0, 0), ^{
        //Your code here...
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            if (!impAds.endShowTime) {
                //                kMJGotoExposureBlock(impAds);
                self.mjGotoExposureBlock(impAds);
            }
        });

    });

}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didEndDisplayingCell:ROW[%ld]\t", indexPath.row);
    if (self.mjResponse.contentState != kMJAPPSContentNormallyState) {
        return;
    }
    MJImpAds *impAds = self.mjResponse.impAds[indexPath.row];
    impAds.endShowTime = [MJTool getInternetBJDate];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.mjResponse.contentState == kMJAPPSContentUnknownState) {
        NSAssert(NO, @"");
    }else if(self.mjResponse.contentState == kMJAPPSContentFriendUIState) {
        //#warning TODO reload request data 第一次刷新成功后第二次进入cell高度出现问题
        [self showIn:nil];// closeBlock:nil];
        return;
    }else if(self.mjResponse.contentState == kMJAPPSContentNOTAvailableState) {
        NSLog(@"kMJAPPSContentNOTAvailableState");
        return;
    }
    MJImpAds *impAds = self.mjResponse.impAds[indexPath.row];
    kMJSDKTargetType targetType = impAds.apps.targetType;
    if (impAds.hasShared) {
        NSLog(@"分享过的内容");
        return;
    }
    if(targetType == kMJSDKTargetType_WALL_SHARE_LINK) {//横幅分享型+链接（分享）
        NSLog(@"开始分享");
        if (![MJTool getIDFA:self.adSpaceID]) {
            self.mjAppsShowToastBlock(@"获取设备号失败，无法参与免费兑换道具，请开启权限后重试", NO);
            return;
        }
        if (![Tool hasWechatInstalled]) {
            self.mjAppsShowToastBlock(@"尚未安装微信客户端,无法分享~", NO);
            return;
        }
        MJRE *mjRE = [tableView cellForRowAtIndexPath:indexPath];
        [mjRE wechatShareAndReport];
    } else {
        NSLog(@"未知的 targetType");
    }
    WEAKSELF
    [MJTool responds:weakSelf.delegate toSelector:@selector(mjADDidClick:error:) block:^{
        [weakSelf.delegate mjADDidClick:weakSelf.view error:nil];
    }];
}
#pragma mark -
#pragma mark - masonry
#pragma mark -
#pragma mark - Masonry Methods
- (void)updateViewConstraints {
    [super updateViewConstraints];
    [self masonry];
}
- (void)masonry
{//
    UIView *superView = self.view;
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(superView);
    }];
}
#pragma mark -
#pragma mark - setter/getter
- (void)setMjResponse:(MJResponse *)mjResponse {
    if ([_mjResponse isEqual:mjResponse]) {
        return;
    }
    _mjResponse = mjResponse;
    for (MJImpAds *impAds in _mjResponse.impAds) {
//#warning TODO impAds.showUrl
        impAds.showUrl = _mjResponse.showUrl;
    }

}
#pragma mark - table
- (UITableView *)table
{
    if(!_table){
        //初始化一个 tableView
        _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _table.tableFooterView = [[UIView alloc]init];
        if (kIOSVersion >= 8.f) {
            _table.estimatedRowHeight = kMJAPPsRowHeight;
        }
        _table.rowHeight = UITableViewAutomaticDimension;
    }

    return _table;
}

- (NSAttributedString *)getAttributeString:(NSInteger)need_times {
    NSInteger length = [self getLength:need_times];
    NSString *title = [NSString stringWithFormat:@"还差分享 %ld 次可领取奖励",need_times];
    //
    NSMutableAttributedString * attributedString = [[NSMutableAttributedString alloc]initWithString:title];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromHexString:@"#2e95fe"] range:NSMakeRange(5, length)];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldItalicMT" size:30] range:NSMakeRange(5, length)];
    [attributedString addAttribute:NSBaselineOffsetAttributeName value:[NSNumber numberWithFloat:-3] range:NSMakeRange(5,length)];
    return [attributedString copy];
}
- (UILabel *)navTitleLabel {
    if (!_navTitleLabel) {
        _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 44)];
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
        _navTitleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:15];
        _navTitleLabel.textColor = [UIColor colorFromHexString:@"#8c8a88"];
        [_navTitleLabel setAdjustsFontSizeToFitWidth:YES];
    }
    return _navTitleLabel;
}
-(UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreen_suitWidth, roundf(shareHeight))];

        UIImageView * headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,kMainScreen_suitWidth, roundf(shareHeight))];

        headImgView.image = [UIImage mj_imageNamed:@"分享步骤@2x.jpg"];

        [_headView addSubview:headImgView];
    }

    return _headView;

}

@end
