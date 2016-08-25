//
//  MJAppsDataManager.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/17.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJCouponManager.h"

#import "MJExceptionReportManager.h"
#import "LXNetWorking.h"
#import "LXIPManager.h"

@interface MJCouponManager ()
{
    NSString * _getNewString;
    NSString * _getModifyString;
}
/** <#注释#>*/
@property (nonatomic,retain)NSMutableDictionary *params;

@end

@implementation MJCouponManager
+ (instancetype)manager {
    static MJCouponManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[[self class] alloc]init];
    });

    return _manager;
}
/**
 1.http://121.40.87.159:17000/cq查券
 2.http://121.40.87.159:17000/cc领券
 3.http://121.40.87.159:17000/cu修改手机号
 step 1.判断是否完成任务->YES:(3-6)|NO:go to step 2--->>TODO:response:new|old
 step 2.判断新用户->查询是否有默认券->NO:over{道具已经领取过}|YES:走流程(3-1)
   判断老用户-> 判断已有几张券->x=0:->判断是否能拿新券->NO:over{道具已经领取过}|YES:走流程{提示拿新券}(3-5)
                                               x>=1:->判断是否能拿新券->NO:显示账户下最新的一张券(3-2)(|YES:显示即将可以领取的券{可以领取新券}(3-4)
 (3-1) --next-->(3-2)[last]
 (3-4) --next--(3-4)[last][del按钮]
 (3-5) --next--(3-5)[last][del按钮]

 */
/**
 *  @brief 查券
 *
 *  @param queryBlock queryBlock
 */
- (void)loadQuery:(kMJShareBlock)queryBlock {
    
    LXNetWorking *networking = [LXNetWorking manager];
    NSString *urlString = kMJSDKCouponQueryAPI;
    NSMutableDictionary *queryParams = self.params;
    queryParams[@"request_type"] = @(kRequestTypeCHECK_COUPONS);
    
    _getNewString = [MJTool getMJShareNewTel];
    if (_getNewString) {
        queryParams[@"cellphone"] = _getNewString;
    }
    NSLog(@"%@",queryParams);
    [networking POST:urlString params:queryParams
             success:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject) {
                 
                 if (queryBlock) {
                     queryBlock(responseObject);
                 }
                 
                 NSString * coupons_code = responseObject[@"coupons_info"][@"coupons_code"];
                 if (coupons_code.length <= 0) {
                     MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORGetCouponsCodeFailure description:[NSString stringWithFormat:@"[优惠券][券号]获取失败"]];
                     [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
                 }
                 NSString * image_url = responseObject[@"coupons_info"][@"image_url"];
                 NSString * logo_url = responseObject[@"coupons_info"][@"logo_url"];
                 
                 if ([MJTool judgeURLString:image_url] == NO) {
                     
                     MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORGetCouponImageUrlFailure description:[NSString stringWithFormat:@"[优惠券][券图片]URL异常"]];
                     [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
                 }
                 if ([MJTool judgeURLString:logo_url] == NO) {
                     MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORGetCouponLogoUrlFailure description:[NSString stringWithFormat:@"[优惠券][logo]URL异常"]];
                     [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
                 }
             } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
                 //
                 //                 NSDictionary * dic = @{
                 //                                        @"cellphone" : @"",
                 //                                        @"coupons_info" :  @{
                 //                                                @"coupons_code" : @"4c4cc7694346c31ca44de9ecc23fc5e5",
                 //                                                @"coupons_status" : @1,
                 //                                                @"image_url" : @"http://mj-img.oss-cn-hangzhou.aliyuncs.com/ssp-coupon/mengdian_coupon_1.png",
                 //                                                @"logo_url" : @"http://mj-img.oss-cn-hangzhou.aliyuncs.com/ssp-coupon/mengdian_logo.png",
                 //                                                },
                 //                                        @"goods_info" : @[
                 //                                         @{
                 //                                             @"click_url" : @"https://s.mjmobi.com",
                 //                                             @"image_url" : @"http://mj-img.oss-cn-hangzhou.aliyuncs.com/ssp-coupon/mengdian_good1.png",
                 //                                         },
                 //                                         @{
                 //                                             @"click_url" : @"https://s.mjmobi.com",
                 //                                             @"image_url" : @"http://mj-img.oss-cn-hangzhou.aliyuncs.com/ssp-coupon/mengdian_good2.png"
                 //                                         }
                 //                                         ],
                 //                                        @"registered" : @0,
                 //                                        @"usable_coupons_num" : @0
                 //
                 //                                        };
                 //                 if (queryBlock) {
                 //                     queryBlock(dic);
                 //                 }
                 ////
                 MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORCouponQueryFailure description:[NSString stringWithFormat:@"[优惠券][查询]失败:%@",error]];
                 [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
             }];
    
}

/**
  *  @brief  领券
  *
  *  @param claimBlock claimBlock
  */
- (void)loadClaim:(kMJShareBlock)claimBlock failure:(kMJClaimFailedBlock)failureBlock couponCode:(NSString *)code telNumber:(NSString *)tel {
    LXNetWorking *networking = [LXNetWorking manager];
    NSString *urlString = kMJSDKCouponClaimAPI;
    NSMutableDictionary *params = self.params;
    params[@"request_type"] = @(kRequestTypeCLAIM_COUPONS);
    params[@"coupons_code"] = code;
    params[@"cellphone"] = tel;
    [networking POST:urlString params:params success:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject) {
        //
        if (!params) {
            MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORADNOResponseData description:[NSString stringWithFormat:@"领取优惠券返回数据为空"]];
            [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
        }
        if (claimBlock) {
            claimBlock(responseObject);
        }
        
    } failure:failureBlock];
}
/**
 *  @brief 修改手机号
 *
 *  @param updateBlock updateBlock
 */
- (void)loadUpdate:(kMJShareBlock)updateBlock updatephoneNumber:(NSString *)phoneNumber{
    
    LXNetWorking *networking = [LXNetWorking manager];
    NSString *urlString = kMJSDKCouponUpdateAPI;
    NSMutableDictionary *params = self.params;
    
    params[@"request_type"] = @(kRequestTypeUPDATE_CELLPHONE);
    params[@"cellphone"] = phoneNumber;
    [networking POST:urlString params:params success:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject) {
        //
        if (updateBlock) {
            updateBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORCouponUpdateFailure description:[NSString stringWithFormat:@"[优惠券][手机号修改]失败:%@",error]];
        [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
    }];
}
#pragma mark - params
- (NSMutableDictionary *)params
{
    if(!_params){
        _params = [@{
                    @"device_id":@{
                            @"imei":@"",
                            @"idfa":kMJAppsIDFA,
                            },
                    @"app_id":[@{
                            @"app_key":kMJAppsAPPKey,
                            @"bundle_id":[[NSBundle mainBundle] bundleIdentifier],
                            } mutableCopy],
                    @"cellphone":@"",
                    @"request_type":@(kRequestTypeCHECK_COUPONS),
                    @"coupons_code":@"",
                    @"need_goods_recommend":@YES,
                    } mutableCopy];
    }
    return _params;
}

@end
