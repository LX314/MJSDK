//
//  MJExceptionDataManager.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/18.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJBaseDataManager.h"

#import "MJExceptionReport.h"
/**
 *  @brief 在线上传|离线上传|异常数据上报|曝光
 */
@interface MJExceptionReportManager : MJBaseDataManager
{
    
}
#pragma mark -
#pragma mark - 异常上报[在线|离线](POST)
#pragma mark - 异常上报[离线](POST)
/**
 *  自动上报离线异常(report)数据[建议在载入 SDK 时自动启用]
 */
+ (void)autoUploadOfflineExceptionReport;
/**
 *  向离线数据库中插入异常数据
 *
 *  @param exceptionReport  exceport report
 */
+ (void)insertOffLineExceptionReport:(MJExceptionReport *)exceptionReport;
/**
 *  清空所有存储的离线异常数据
 *
 *  @return  success|failure
 */
+ (BOOL)clearAllOfflineExceptionReport;
/**
 *  异常上报[离线](POST)
 *
 *  @param exceportReports params
 */
+ (void)uploadOfflineExceptionReport:(NSDictionary *)exceportReport;
#pragma mark - 异常上报[在线](POST)
/**
 *  @brief 异常上报[在线](POST)
 *
 *  @param params params
 */
+ (void)uploadOnlineExceptionReport:(NSArray<MJExceptionReport *> *)exceptionReports;
#pragma mark -
#pragma mark - 曝光[在线|离线](GET)
#pragma mark - 曝光[离线](GET)
/**
 *  自动上报离线曝光数据[建议在载入 SDK 时自动启用]
 */
+ (void)autoUploadOfflineExposureReport;
/**
 *  向离线数据库中插入离线曝光数据
 *
 *  @param impAds impAds
 */
+ (void)insertOffLineExposureReport:(MJImpAds *)impAds;
/**
 *  清空所有存储的离线曝光数据
 *
 *  @return  success|failure
 */
+ (BOOL)clearAllOfflineExposureReport;
/**
 *  曝光[离线](GET)
 *
 *  @param exposureReports exposureReports
 */
+ (void)uploadOfflineExposureReports:(NSDictionary *)exposureReports;
#pragma mark - 曝光[在线](GET)
/**
 *  曝光[在线](GET)
 *
 *  @param impAds       impAds
 *  @param successBlock successBlock
 *  @param failureBlock failureBlock
 */
+ (void)uploadOnlineExposureReport:(MJImpAds *)impAds success:(kMJExposureSuccessBlock)successBlock failure:(kMJExposureFailureBlock)failureBlock;
#pragma mark - click report(GET)
/**
 *  @brief click report(GET)
 *
 *  @param url report url
 */
+ (void)mjClickReport:(NSString *)url;
#pragma mark - 外链跳转[landing-page-url]
/**
 *  @brief 外链跳转[landing-page-url]
 *
 *  @param landingPageUrl landingPageUrl
 */
+ (void)mjGotoLandingPageUrl:(NSString *)landingPageUrl;
#pragma mark - url exception report
/**
 *  验证 URL 是否符合规则,若有异常则自动上报,并返回 NO.
 *
 *  @param url url
 *
 *  @return TRUE|FALSE
 */
+ (BOOL)validateAndExceptionReport:(NSString *)url;
#pragma mark -
#pragma mark - Wechat Share Report
/**
 *  微信分享
 *
 *  @param reportURL  report url
 *  @param success   success
 *  @param failed    failed
 */
+ (void)wechatShareReport:(NSString *)reportURL success:(SuccessBlockType)success failed:(FailedBlockType)failed;

#pragma mark -
#pragma mark - Good Info Report

/**
 *  好货推荐
 *
 *  @param reportURL report url
 *  @param success   success
 *  @param failed    failed
 */
+ (void)goodInfoReport:(NSString *)reportURL success:(SuccessBlockType)success failed:(FailedBlockType)failed;

#pragma mark -
#pragma mark - Test sections
+ (void)testUploadOnlineData:(NSDictionary *)params;
//+ (void)testuploadOfflineExceptionReport:(NSDictionary *)params;
+ (void)testUploadExceptionData:(NSDictionary *)params;
@end
