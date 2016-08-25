//
//  MJAppsManager.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/3.
//  Copyright © 2016年 WM. All rights reserved.
//

#define shareHeight kMainScreen_suitWidth / 320 * 74

#import "MJAppsManager.h"

#import "MJLA.h"
#import "MJRE.h"
#import "MJAppsFriendlyCell.h"

#import "MJPropManager.h"

#import "LXIPManager.h"

#import "UIImage+cached.h"
#import "Tool.h"

#import "MJShare.h"

#import "MJCouponManager.h"

@interface MJAppsManager ()<UITableViewDelegate,UITableViewDataSource>
{
}
/** <#注释#>*/
@property (nonatomic,retain)UIView *headView;
/** <#注释#>*/
@property (nonatomic,retain)UILabel *navTitleLabel;
@end
@implementation MJAppsManager
- (void)viewDidLoad{
    [super viewDidLoad];
    [self initRe];
    //cell 点击时间
    [self cellClickedBlock];
    //领取道具
    [self getPropBlock];
    //show toast
//    [self mjToast];
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
//- (void)viewWillLayoutSubviews {
//    [super viewWillLayoutSubviews];
////    [self.table reloadData];
////    [self changeTitle];
//    //监控 table 状态
//    if (self.mjResponse.contentState) {
//        [self.table setRowHeight:CGRectGetHeight(self.table.frame)];
//    } else {
//        [self.table setRowHeight:kMJAPPsRowHeight];
//    }
//}
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

- (void)cellClickedBlock {
    WEAKSELF
    kMJAppsCellClickedBlock = ^(NSIndexPath *indexPath){
        [weakSelf changeTitle];
        return;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //
//            NSMutableArray *muarr_t = [weakSelf.mjResponse.impAds mutableCopy];
//            id obj = muarr_t[indexPath.row];
//            [muarr_t removeObject:obj];
//            [muarr_t addObject:obj];
//            weakSelf.mjResponse.impAds = [muarr_t copy];
//            [self.table reloadData];
//            [weakSelf.table moveRowAtIndexPath:indexPath toIndexPath:[NSIndexPath indexPathForRow:muarr_t.count - 1 inSection:0]];
//        });

    };
}
- (void)getPropBlock {
    kMJAppsGetPropBlock = ^(){
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
                kMJAppsShowToastBlock(@"领取道具成功!", YES);
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
    cell.selfIndexPath = indexPath;
    [cell fill:self.mjResponse];
    return cell;
    return nil;
}
#pragma mark - TableView Optional Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.mjResponse.contentState == kMJAPPSContentUnknownState) {
        NSAssert(NO, @"");
    }else if(self.mjResponse.contentState == kMJAPPSContentFriendUIState) {
#warning TODO reload request data 第一次刷新成功后第二次进入cell高度出现问题
        WEAKSELF
        [self show:^{
            [weakSelf changeTitle];
        }];
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
        if (![MJTool getIDFA]) {
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
- (void)updateViewConstraints {
    [super updateViewConstraints];
    [self masonry];
}
#pragma mark -
#pragma mark - Masonry Methods
- (void)masonry
{//
    UIView *superView = self.view;
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(superView);
    }];
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
        _navTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 44)];
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
        _navTitleLabel.font = [UIFont fontWithName:@"MicrosoftYaHei" size:15];
        _navTitleLabel.textColor = [UIColor colorFromHexString:@"#8c8a88"];
    }
    return _navTitleLabel;
}
-(UIView *)headView {
    if (!_headView) {
        _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kMainScreen_suitWidth, roundf(shareHeight))];

        UIImageView * headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,kMainScreen_suitWidth, roundf(shareHeight))];

        headImgView.image = [UIImage imageNamed:@"分享步骤"];

        [_headView addSubview:headImgView];
    }

    return _headView;
    
}

#pragma mark -
#pragma mark - API
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
+ (void)vertify:(NSString *)prop_key complete:(kMJPropManagerBlock)vertifyBlock {
    [MJPropManager vertify:prop_key complete:vertifyBlock];
}
@end
