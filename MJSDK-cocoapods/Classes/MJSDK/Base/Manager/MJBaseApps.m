//
//  MJBaseApps.m
//  sdk-ADView
//
//  Created by John LXThyme on 16/5/23.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#import "MJBaseApps.h"

#import "MJSDKConf.h"
#import "MJShare.h"
#import "MJDataManager.h"
#import "MJPropManager.h"
#import "AppNavigationController.h"
#import "MJExceptionReportManager.h"

#import <ReactiveCocoa.h>

#import "MJCouponManager.h"

@interface MJBaseApps ()<UITableViewDataSource>
{
    NSDictionary *_propParams;
    MJResponse *_mjjResponse;


}
//Developer
/** <#注释#>*/
@property (nonatomic,copy)NSString *adSpaceID;


@end
@implementation MJBaseApps
#pragma mark -
#pragma mark - Developer
/**
 *  @brief 初始化应用墙
 *
 *  @param adSpaceID 广告位 ID(必须)
 *  @param props_id   道具 ID(必须)
 *  @param price     price(分)(必须)
 *
 *  @return
 */
- (instancetype)initWithAdSpaceID:(NSString *)adSpaceID props_id:(NSString *)props_id price:(NSInteger)price {
    NSAssert(adSpaceID && adSpaceID.length > 0, @"广告位 ID 不能为空!");
    NSAssert(props_id && props_id.length > 0, @"道具 ID 不能为空!");
    NSAssert( price > 0 && price <= 500, @"价格设置不合理!");
    if (self = [super init]) {
        _adSpaceID = adSpaceID;
        _adType = KMJAPPsTypeRE;
        _props_id = props_id;
        [self racMJResponse];
        [self racPrice];
//        [self exposureBlock];
        [self mjToast];
    }
    return self;
}

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
//        static NSInteger index = 0;
//        NSLog(@"index:%ld", index);
//        if (index == 1) {
//            if (errorBlock) {
//                errorBlock(nil, nil);
//            }
//        } else {
//            if (successBlock) {
//                successBlock(mjResponse, responseObject);
//            }
//        }
//        NSLog(@"index:%ld", index);
//        index ++;
//        index = index % 3;
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
- (void)racPrice {
    [RACObserve(self, price) filter:^BOOL(id value) {
        if (self.price <= 0 || self.price > 500) {
            NSLog(@"价格设置不合理,请重试");
            return NO;
        }
        return YES;
    }];
}
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
        if (availableCount < need_times) {
            self.mjResponse.contentState = kMJAPPSContentNOTAvailableState;
        }
        if (self.mjResponse.contentState == kMJAPPSContentFriendUIState || self.mjResponse.contentState == kMJAPPSContentNOTAvailableState) {
            NSLog(@"显示友好界面");
            CGFloat rowHeight = CGRectGetHeight(self.table.frame);
            if (rowHeight > 20.f) {
                [self.table setRowHeight:rowHeight];
            }
            [self.table reloadData];
            return;
        }
        [self.table setRowHeight:kMJAPPsRowHeight];
        NSLog(@"开始展示...");
        NSLog(@"排序ing...");
        //排序
        [self sortListData];
        [self.table reloadData];

        NSLog(@"加载成功- All:%ld", _mjResponse.impAds.count);
    }];
}
- (NSInteger)getAvailableShareADCount {
    NSInteger availableCount = 0;
    for (MJImpAds *impAds in self.mjResponse.impAds) {
        if (!impAds.hasShared) {
            availableCount++;
        }
    }
    return availableCount;
}
-(void)changeTitle {

}
- (void)show:(void(^)(void))block {
//    if (self.isShow) {
//        NSLog(@"has shown...");
//        return;
//    }
    if (![self validatePrice]) {
        NSLog(@"价格设置不合理,请重试");
        return;
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
            if (block) {
                block();
            }
            if (!self.isShow) {
                [self presentApps];
            }
            self.isShow = YES;
            self.mjResponse = mjResponse;
            [self changeTitle];
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
            self.isShow = YES;
            self.mjResponse = mjResponse;
        }];
    }];
}
- (BOOL)validatePrice {
    if (self.price <= 0 || self.price > 500) {
        return NO;
    }
    return YES;
}
//检查当前道具领取状态
- (void)queryPropStatus:(void(^)(CGFloat need_times))availableBlock {
    [MJPropManager queryPropID:self.props_id price:self.price propBlock:^(NSDictionary *params) {
        NSInteger status = [params[@"status"] floatValue];
        /**status: 状态
         *  1: 未领取
         *  2: 已领取{今天免费任务已完成，明天再来吧。}
         *  3: 无足够分享次数{分享次数不够，兑换失败。}
         *  4: 价格超出上限{道具价格太高，兑换失败。}
         *  5: 数据错误{发生了一个错误，兑换失败。}
         *  6: 无法分享{另外个免费任务正在进行，兑换失败，请稍后再来。}
         */
        NSString *key = [NSString stringWithFormat:@"Loc_QueryProp_Status_%ld", status];
        NSString *loc_doc = NSLocalizedString(key, @"");
        switch (status) {
            case 1: {//未领取
                NSLog(@"未领取状态...");
                NSLog(@"开始查询尚需分享的次数...");
                CGFloat need_times = [params[@"need_times"] floatValue];
                if (need_times <= 0.f) {
                    NSLog(@"分享次数已经完成,开始领取道具");
                    self.mjAppsGetPropBlock();
                    return;
                }
                NSLog(@"分享次数尚未完成,尚需分享 %f 次", need_times);
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


- (void)presentApps {
    UIViewController *vc_t = self;
    AppNavigationController *nav = [[AppNavigationController alloc]initWithRootViewController:vc_t];

    UIImage * navImage = [UIImage imageNamed:@"guanggao"];
    navImage = [navImage resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20) resizingMode:UIImageResizingModeStretch];
    [self.navigationController.navigationBar setBackgroundImage:navImage forBarMetrics:UIBarMetricsDefault];


    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
    vc_t.navigationItem.rightBarButtonItem = rightBtnItem;
    [self.parentVC presentViewController:nav animated:YES completion:nil];
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
#pragma mark - mjGotoExposureBlock
- (kMJGotoExposureBlock)mjGotoExposureBlock
{
    if(!_mjGotoExposureBlock){
        WEAKSELF
        _mjGotoExposureBlock = ^(MJImpAds *impAds){
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

    return _mjGotoExposureBlock;
}
//- (void)mjToast {
//    kMJAppsShowToastBlock = ^(NSString *toastString, BOOL dismiss){
//        UIView *superView = mjSuperview();
//        [MJToast toast:toastString in:superView];
//    };
//}

/**
 * 清除缓存
 */
- (void)clearAdsAndStopAutoRefresh {
}
#pragma mark -
#pragma mark - internal
- (void)viewDidLoad{
    [super viewDidLoad];
    //
    self.automaticallyAdjustsScrollViewInsets = NO;
    //
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
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
- (void)setMjResponse:(MJResponse *)mjResponse {
    if ([_mjResponse isEqual:mjResponse]) {
        return;
    }
    _mjResponse = mjResponse;
    for (MJImpAds *impAds in _mjResponse.impAds) {
#warning TODO
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
#pragma mark - TableView Required Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

//****************
#pragma mark - mjAppsGetPropBlock
- (kMJAppsGetPropBlock)mjAppsGetPropBlock
{
    if(!_mjAppsGetPropBlock){
        _mjAppsGetPropBlock = ^(){
            if (![MJTool getIDFA]) {
                return;
            }
            [MJPropManager claimPropID:self.props_id price:self.price propBlock:^(NSDictionary *params) {
                /**status: 状态
                 *  1. 成功
                 *  2. 失败
                 */
                NSInteger status = [params[@"status"] integerValue];
                if (!params || status != 1) {
                    MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORPropClaimFailure description:[NSString stringWithFormat:@"[道具][领取]失败{响应成功, read responseObject failure.}responseObject:%@\n\nResponse:%@", [params description], [params description]]];
                    [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
                    return;
                }
                if (status == 1) {
                    NSLog(@"领取道具成功!");
                    self.mjAppsShowToastBlock(@"领取道具成功!", YES);
                    NSString *prop_key = params[@"prop_key"];
                    self.prop_key = prop_key;
                    if ([self.delegate respondsToSelector:@selector(mjClaimProps:)]) {
                        [self.delegate mjClaimProps:prop_key];
                    }
                    //Global conf
                    if (kMJSDKShouldDisplayCoupon) {
                        //优惠券修改手机号
                        NSString * getModifyString = [MJTool getMJShareModifyTel];
                        if (getModifyString) {
                            MJCouponManager *manager = [MJCouponManager manager];
                            [manager loadUpdate:^(NSDictionary * _Nonnull params) {
                                BOOL success = [params[@"success"] boolValue];
                                if (success) {
                                    NSLog(@"修改成功!");
                                }
                                [MJTool saveMJShareNewTel:getModifyString];
                                [MJTool clearLocalTELKeychainModify];

                                MJShare *mjShare = [[MJShare alloc]init];
                                [mjShare showIn:self];
                                return ;

                            } updatephoneNumber:getModifyString];
                        }
                        MJShare *mjShare = [[MJShare alloc]init];
                        [mjShare showIn:self];
                    }
                } else {
                    NSAssert(NO, @"");
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
            UIView *superView = mjSuperview();
            [MJToast toast:toastString in:superView];
        };
    }
    return _mjAppsShowToastBlock;
}
@end
