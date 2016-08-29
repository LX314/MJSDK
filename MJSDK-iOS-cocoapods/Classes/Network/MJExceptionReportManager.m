//
//  MJExceptionDataManager.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/18.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJExceptionReportManager.h"

@implementation MJExceptionReportManager

#pragma mark -
#pragma mark - 异常上报[在线|离线](POST)
#pragma mark - 异常上报[离线](POST)
/**
 *  自动上报离线异常(report)数据[建议在载入 SDK 时自动启用]
 */
+ (void)autoUploadOfflineExceptionReport {
    NSString *localString = [SSKeychain passwordForService:kMJSDKEXCEPTIONREPORTService account:kMJSDKEXCEPTIONREPORTAccount];
    NSDictionary *dict = [MJTool toJsonObject:localString];
    if (!localString || localString.length < 10) {
        NSLog(@"暂无未上报的离线异常上报数据");
        return;
    }
    NSLog(@"[AUTO]开始离线异常上报");
    [MJExceptionReportManager uploadOfflineExceptionReport:dict];
}
/**
 *  向离线数据库中插入异常数据
 *
 *  @param exceptionReport  exceport report
 */
+ (void)insertOffLineExceptionReport:(MJExceptionReport *)exceptionReport {
    //
    NSDictionary *exceptionDict = [MTLJSONAdapter JSONDictionaryFromModel:exceptionReport error:nil];
    //
    NSString *localString = [SSKeychain passwordForService:kMJSDKEXCEPTIONREPORTService account:kMJSDKEXCEPTIONREPORTAccount];
    NSDictionary *dict = [MJTool toJsonObject:localString];
    if (!dict) {
        dict = @{
                 @"data":@[]
                 };
    }
    NSMutableArray *muarr = [dict[@"data"] mutableCopy];
    [muarr addObject:exceptionDict];
    NSMutableDictionary *mudict = [dict mutableCopy];
    [mudict setObject:[muarr copy] forKey:@"data"];
    //
    NSString *jsonString = [MJTool toJsonString:mudict];
    [SSKeychain setPassword:jsonString forService:kMJSDKEXCEPTIONREPORTService account:kMJSDKEXCEPTIONREPORTAccount];
    NSLog(@"异常已加入离线异常队列,目前有 %ld 条离线异常数据待上报,DESCRIPTION:\n%@", muarr.count, [exceptionReport debugDescription]);
}
/**
 *  清空所有存储的离线异常数据
 *
 *  @return  success|failure
 */
+ (BOOL)clearAllOfflineExceptionReport {
    BOOL success = [SSKeychain setPassword:@"" forService:kMJSDKEXCEPTIONREPORTService account:kMJSDKEXCEPTIONREPORTAccount];
    NSLog(@" 已清异常[离线]数据库 - success:%@", success ? @"YES" : @"NO");
    return success;
}
/**
*  异常上报[离线](POST)
*
*  @param exceportReports params
*/
+ (void)uploadOfflineExceptionReport:(NSDictionary *)exceportReport {
    NSString *urlString = kMJSDKErrorReportAPI;
    [[LXNetWorking manager]POST:urlString params:exceportReport success:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject) {
        NSLog(@"离线上报[离线](POST)--success");
        [self clearAllOfflineExceptionReport];
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        NSLog(@"离线上报[离线](POST)失败,待下次重新上传--failure:%@", error);
    }];
}

#pragma mark - 异常上报[在线](POST)
/**
 *  @brief 异常上报[在线](POST)
 *
 *  @param params params
 */
+ (void)uploadOnlineExceptionReport:(NSArray<MJExceptionReport *> *)exceptionReports {
    NSLog(@"--->>exceptionReports:%@", [exceptionReports debugDescription]);
    NSString *urlString = kMJSDKErrorReportAPI;
    NSDictionary *params;
    NSMutableArray *muarr = [NSMutableArray array];
    if (exceptionReports.count == 1) {
        NSDictionary *dict_t  = [MTLJSONAdapter JSONDictionaryFromModel:[exceptionReports firstObject] error:nil];
        [muarr addObject:dict_t];
    } else {
        NSArray *array = [MTLJSONAdapter JSONArrayFromModels:exceptionReports error:nil];
        [muarr addObjectsFromArray:array];
    }
    params = @{
               @"data":[muarr copy]
               };
    [[LXNetWorking manager] basePOST:urlString params:params exceptionReport:YES success:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject) {
        NSLog(@"异常上报[在线](POST)-success");
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        NSLog(@"异常上报[在线](POST)失败,即将加入离线队列...-failure:%@",error);
        MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERROROnlineExceptionDataUploadFailure description:[NSString stringWithFormat:@"异常上报[在线](POST)-failure:%@",error]];
        [MJExceptionReportManager insertOffLineExceptionReport:report];
    }];
}

#pragma mark -
#pragma mark - 曝光[在线|离线](GET)
#pragma mark - 曝光[离线](GET)
/**
 *  自动上报离线曝光数据[建议在载入 SDK 时自动启用]
 */
+ (void)autoUploadOfflineExposureReport {
    NSString *localString = [SSKeychain passwordForService:kMJSDKEXPOSUREREPORTService account:kMJSDKEXPOSUREREPORTAccount];
    NSDictionary *dict = [MJTool toJsonObject:localString];
    if (!localString || localString.length < 10) {
        NSLog(@"暂无未上报的离线曝光数据");
        return;
    }
    NSLog(@"[AUTO]开始离线曝光...");
    [MJExceptionReportManager uploadOfflineExposureReports:dict];
}
/**
 *  向离线数据库中插入离线曝光数据
 *
 *  @param impAds impAds
 */
+ (void)insertOffLineExposureReport:(MJImpAds *)impAds {
    //
    NSArray *array = [impAds.showUrl componentsSeparatedByString:@"?"];
    if (array.count != 2) {
        MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORURLFailure description:@"曝光 URL 异常,获取 ? 时失败"];
        [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
        return;
    }
    NSString *info = [array lastObject];
    NSString *exposureReport = [NSString stringWithFormat:@"%@&seqs=%ld", info, impAds.impressionSeqNo];
    //
    NSString *localString = [SSKeychain passwordForService:kMJSDKEXPOSUREREPORTService account:kMJSDKEXPOSUREREPORTAccount];
    NSDictionary *dict = [MJTool toJsonObject:localString];
    if (!dict) {
        dict = @{
                 @"data":@[]
                 };
    }
    NSMutableArray *muarr = [dict[@"data"] mutableCopy];
    [muarr addObject:exposureReport];
    NSMutableDictionary *mudict = [dict mutableCopy];
    [mudict setObject:[muarr copy] forKey:@"data"];
    //
    NSString *jsonString = [MJTool toJsonString:mudict];
    [SSKeychain setPassword:jsonString forService:kMJSDKEXPOSUREREPORTService account:kMJSDKEXPOSUREREPORTAccount];
    NSLog(@"异常已加入离线曝光队列,目前有 %ld 条离线数据待曝光. \nexposureReportURL:%@", muarr.count, exposureReport);
}
/**
 *  清空所有存储的离线曝光数据
 *
 *  @return  success|failure
 */
+ (BOOL)clearAllOfflineExposureReport {
    BOOL success = [SSKeychain setPassword:@"" forService:kMJSDKEXPOSUREREPORTService account:kMJSDKEXPOSUREREPORTAccount];
    NSLog(@" 已清空曝光[离线]数据库 - success:%@", success ? @"YES" : @"NO");
    return success;
}
/**
 *  曝光[离线](GET)
 *
 *  @param exposureReports exposureReports
 */
+ (void)uploadOfflineExposureReports:(NSDictionary *)exposureReports  {
    NSString *urlString = kMJSDKOfflineExposureAPI;
    [[LXNetWorking manager]POST:urlString params:exposureReports success:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject) {
        NSLog(@"曝光[离线](POST)--success");
        [self clearAllOfflineExposureReport];
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        NSLog(@"曝光[离线](POST)失败,待下次重新上传--failure:%@", error);
    }];
}
#pragma mark - 曝光[在线](GET)
/**
 *  曝光[在线](GET)
 *
 *  @param impAds       impAds
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
+ (void)uploadOnlineExposureReport:(MJImpAds *)impAds success:(kMJExposureSuccessBlock)successBlock failure:(kMJExposureFailureBlock)failureBlock {
    NSString *showURL = impAds.showUrl;
    NSInteger impression_seq_no = impAds.impressionSeqNo;
    if (![MJExceptionReportManager validateAndExceptionReport:showURL]) {
        MJError *mjerror = [MJError errorWithDomain:@"曝光 URL 异常" code:kMJSDKERRORURLFailure userInfo:@{}];
        if (failureBlock) {
            failureBlock(nil, mjerror);
        }
        return;
    }
//    BOOL isNormalLoaded = impAds.isNormalLoaded;
//    BOOL isDefaultLoaded = impAds.isDefaultLoaded;
//#warning TODO 正常数据|默认数据曝光(isNormalLoaded)
    NSString *exposureURL = [NSString stringWithFormat:@"%@&seqs=%ld",showURL,impression_seq_no];
    NSLog(@"开始曝光[在线](GET):%@",exposureURL);
    [[LXNetWorking manager]GET:exposureURL params:nil success:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject) {
        //
        NSLog(@"曝光[在线](GET)-success-impression_seq_no:%ld\n++++++++++++++", impression_seq_no);
        if (successBlock) {
            successBlock();
        }
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        //1.离线曝光
        [self insertOffLineExposureReport:impAds];
        //2.异常上报
        NSLog(@"曝光[在线](GET)-失败,开始异常上报:%@\n\nimpression_seq_no:%ld",error, impression_seq_no);
        MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERROROnlineExposureFailure description:[NSString stringWithFormat:@"曝光(GET)-failure:%@\n\nimpression_seq_no:%ld",error, impression_seq_no]];
        [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
        if (failureBlock) {
            failureBlock(dataTask, error);
        }
    }];
}
#pragma mark - click report(GET)
/**
 *  @brief click report(GET)
 *
 *  @param url report url
 */
+ (void)mjClickReport:(NSString *)url {
    NSLog(@"点击上报:%@", url);
    if (![MJExceptionReportManager validateAndExceptionReport:url]) {
        return;
    }
    [[LXNetWorking manager]GET:url params:nil success:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject) {
        //
        NSLog(@"click report(GET)-success");
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        //
        MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORClickReportFailure description:[NSString stringWithFormat:@"click report(GET)-failure:%@",error]];
        [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
    }];
}

#pragma mark - 外链跳转[landing-page-url]
/**
 *  @brief 外链跳转[landing-page-url]
 *
 *  @param landingPageUrl landingPageUrl
 */
+ (void)mjGotoLandingPageUrl:(NSString *)landingPageUrl {
    NSLog(@"goto landingPageURL:%@", landingPageUrl);
    if ([MJExceptionReportManager validateAndExceptionReport:landingPageUrl]) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:landingPageUrl]];
    }
}

#pragma mark - url exception report
/**
 *  验证 URL 是否符合规则,若有异常则自动上报,并返回 NO.
 *
 *  @param url url
 *
 *  @return TRUE|FALSE
 */
+ (BOOL)validateAndExceptionReport:(NSString *)url {
    if (![MJTool judgeURLString:url]) {
        MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORURLFailure description:[NSString stringWithFormat:@"%s --> %@ 异常", kVarName(url), url]];
        NSLog(@"监测到 URL 异常:%@", report);
        [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
        return NO;
    }
    return YES;
}
#pragma mark -
#pragma mark - Wechat Share Report
/**
 *  微信分享
 *
 *  @param reportURL  report url
 *  @param success   success
 *  @param failed    failure
 */
+ (void)wechatShareReport:(NSString *)reportURL success:(SuccessBlockType)success failed:(FailedBlockType)failed {
    [[LXNetWorking manager]GET:reportURL params:nil success:success failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORWechatShareSuccessButReportFailure description:[NSString stringWithFormat:@"微信分享成功,但上报失败:%@", error]];
        [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
    }];
}
#pragma mark -
#pragma mark - Good Info Report
/**
 *  好货推荐
 *
 *  @param reportURL report url
 *  @param success   success
 *  @param failed    failed
 */
+ (void)goodInfoReport:(NSString *)reportURL success:(SuccessBlockType)success failed:(FailedBlockType)failed {

    [[LXNetWorking manager]GET:reportURL params:nil success:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject) {
        
        if (success) {
            success(dataTask,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        
        MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORGoodInfoReportFailure description:[NSString stringWithFormat:@"好货推荐上报失败:%@", error]];
        [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
        if (failed) {
            failed(dataTask,error);
        }
    }];
    
}


#pragma mark -
#pragma mark - Test sections
+ (void)testUploadOnlineData:(NSDictionary *)params {
//    [self uploadOnlineData:@[
//                             @"info=ChRDSTJBaDduZUtoRFo5dFpUR0JVPRAAGgoI8DsQNBg0IMcTGgoI8zsQNBg0IMoTIJSAh7neKg&seqs=1"
//                             ]];
}
+ (void)testUploadOfflineData:(NSDictionary *)params {
    [self uploadOfflineExceptionReport:@{
                              @"data":@[
                                      @"info=ChRDUGZNaDhiZUtoRFo5dFpUR0lRQhAAGgoI1zMQHhgeIK4LGgoI2y4QERgRILIGIP7Nh8beKg==&seqs=2",
                                      @"info=ChRDUGZNaDhiZUtoRFo5dFpUR0lRQhAAGgoI1zMQHhgeIK4LGgoI2y4QERgRILIGIP7Nh8beKg==&seqs=1"]

                              }];
}
+ (void)testUploadExceptionData:(NSDictionary *)params {
    MJExceptionReport *report1 = [MJExceptionReport reportWithADSpaceID:@"" code:200 description:@"msg"];
    NSArray *reports = [MTLJSONAdapter JSONArrayFromModels:@[report1,report1,report1] error:nil];
    [self uploadOnlineExceptionReport:reports];
}

@end
