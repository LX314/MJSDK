//
//  MJPropManager.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/20.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJPropManager.h"

#import "MJExceptionReportManager.h"
#import "MJExceptionReport.h"
#import "LXNetWorking.h"
#import "LXIPManager.h"
#import "MJError.h"

typedef enum : NSUInteger {
    kMJPropRequestUnknownType = 0,
    kMJPropRequestQueryType = 1,// 查询
    kMJPropRequestClaimType = 2,//领取
} kMJPropRequestType;

@interface MJPropManager ()
{

}
/** <#注释#>*/
@property (nonatomic,retain)NSMutableDictionary *params;

@end
@implementation MJPropManager
+ (instancetype)manager {
    static MJPropManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[[self class] alloc]init];
    });
    return _manager;
}
/**
 *  @brief 道具查询
 *
 *  @param propID    道具ID
 *  @param price     道具价格
 *  @param propBlock propBlock
 */
+ (void)queryPropID:(NSString *)propID price:(NSInteger)price adSpaceID:(NSString *)adSpaceID propBlock:(kMJPropManagerBlock)propBlock {
    MJPropManager *manager = [MJPropManager manager];
    LXNetWorking *netWorking = [LXNetWorking manager];
    NSMutableDictionary *params = manager.params;
    params[@"price"] = @(price);
    params[@"props_id"] = propID;
    params[@"request_type"] = @(kMJPropRequestQueryType);
//    params[@"ad_loc_id"] = adSpaceID;
//    NSString *json = [MJTool toJsonString:params];
    [netWorking POST:kMJSDKPropQueryAPI params:params success:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject) {
        /**status: 状态
         *  1: 未领取
         *  2: 已领取{今天免费任务已完成，明天再来吧。}
         *  3: 无足够分享次数{分享次数不够，兑换失败。}
         *  4: 价格超出上限{道具价格太高，兑换失败。}
         *  5: 数据错误{发生了一个错误，兑换失败。}
         *  6: 无法分享{另外个免费任务正在进行，兑换失败，请稍后再来。}
         */
        if (propBlock) {
            propBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:adSpaceID code:kMJSDKERRORPropQueryFailure description:[NSString stringWithFormat:@"[道具][查询]失败:%@", error]];
        [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
        MJNSLog(@"errcode:%ld",report.code);
    }];
}
/**
 *  领取
 *
 *  @param propID    prop id
 *  @param price     price
 *  @param propBlock propBlock
 */
+ (void)claimPropID:(NSString *)propID price:(NSInteger)price adSpaceID:(NSString *)adSpaceID propBlock:(kMJPropManagerBlock)propBlock {
    MJPropManager *manager = [MJPropManager manager];
    LXNetWorking *netWorking = [LXNetWorking manager];
    NSMutableDictionary *params = manager.params;
    params[@"request_type"] = @(kMJPropRequestClaimType);
    params[@"props_id"] = @"";
//    params[@"ad_loc_id"] = adSpaceID;
    [netWorking POST:kMJSDKPropClaimAPI params:params success:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject) {
        /**status: 状态
         *  1. 成功
         *  2. 失败
         */
        if (propBlock) {
            propBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:adSpaceID code:kMJSDKERRORPropClaimFailure description:[NSString stringWithFormat:@"[道具][领取]失败:%@", error]];
        [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
        MJNSLog(@"errcode:%ld",report.code);
    }];
}
/**
 *  道具验证
 *
 *  @param prop_key     prop_key
 *  @param vertifyBlock vertifyBlock
 */
+ (void)vertify:(NSString *)prop_key complete:(kMJPropManagerBlock)vertifyBlock {
    NSString *urlString = [NSString stringWithFormat:@"http://v.mjmobi.com/pv?prop_key=%@", prop_key];
    LXNetWorking *netWorking = [LXNetWorking manager];
    [netWorking GET:urlString params:nil success:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject) {
        if (vertifyBlock) {
            vertifyBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORPropClaimFailure description:[NSString stringWithFormat:@"[道具][验证]失败:%@", error]];
        [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
        MJNSLog(@"errcode:%ld", report.code);
    }];
}
#pragma mark - params
- (NSMutableDictionary *)params
{
    if(!_params){
        _params = [@{
                     @"device_id":@{
                             @"idfa":kMJAppsIDFA,//[LXIPManager manager].idfa,
//                             @"idfa":[LXIPManager manager].idfa,
                             },
                     @"app_id":[@{
                                  @"app_key":kMJAppsAPPKey,//1:新用户,有券|2:老用户,无券|3:老用户,有券
                                  @"bundle_id":[[NSBundle mainBundle] bundleIdentifier],
                                  @"channel_id": @"30001"
                                  } mutableCopy],
                     @"price":@0,
                     @"props_id":@"",
                     @"request_type":@1,
//                     @"ad_loc_id":@""
                     } mutableCopy];
        
    }

    return _params;
}

@end
