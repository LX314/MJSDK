//
//  MJTool.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/15.
//  Copyright © 2016年 WM. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "MJADDelegate.h"
#import "MJBlocks.h"

@interface MJTool : NSObject
{
    
}
/** 已分享数据*/
@property (nonatomic,retain, readonly)NSMutableDictionary *appsShared;
/** MJShare Tel*/
@property (nonatomic,retain, readonly)NSMutableDictionary *mjShareTEL;
/**  离线异常上报数据*/
@property (nonatomic,retain, readonly)NSMutableDictionary *offlineExceptionReports;
/** 离线曝光数据*/
@property (nonatomic,retain, readonly)NSMutableDictionary *offlineExposureReports;
/** 离线开屏(全屏)数据*/
@property (nonatomic,retain, readonly)NSMutableDictionary *offlineFullOpenScreenData;
/** 离线开屏(半屏)数据*/
@property (nonatomic,retain, readonly)NSMutableDictionary *offlineHalfOpenScreenData;

///** 已分享数据*/
//@property (nonatomic,retain)NSMutableDictionary *appsShared;
///** MJShare Tel*/
//@property (nonatomic,retain)NSMutableDictionary *mjShareTEL;
///**  离线异常上报数据*/
//@property (nonatomic,retain)NSMutableDictionary *offlineExceptionReports;
///** 离线曝光数据*/
//@property (nonatomic,retain)NSMutableDictionary *offlineExposureReports;
///** 离线开屏(全屏)数据*/
//@property (nonatomic,retain)NSMutableDictionary *offlineFullOpenScreenData;
///** 离线开屏(半屏)数据*/
//@property (nonatomic,retain)NSMutableDictionary *offlineHalfOpenScreenData;

+ (instancetype)manager;

+ (void)masonry:(UIView *)lxSelf portrait:(void(^)(void))portrait orientation:(void(^)(void))orientation;

+ (void)updateMask:(LXMJViewMaskType)maskType selfView:(UIView *)selfView layer:(CALayer *)bgLayer color:(UIColor *)bgLayerColor;


#pragma mark -
#pragma mark - JSON parser
+ (NSString *)toJsonString:(id)obj;
+ (NSDictionary *)toJsonObject:(id)obj;
+ (NSDictionary *)sortDict:(NSDictionary *)dict;

/**
 *  @brief 判断 URL 是否符合规则
 *
 *  @param urlString  urlString
 *
 *  @return bool value
 */
+ (BOOL)judgeURLString:(NSString*)urlString;

/**
 *  @brief 判断phone Number 是否符合规则
 *
 *  @param phoneNumber phoneNumber
 *
 *  @return bool value
 */
+ (BOOL)judgePhoneNumber:(NSString *)phoneNumber;

#pragma mark -
#pragma mark - NSDate
+ (NSDate *)getInternetBJDate;
/**
 *  获取网络时间(BeiJing)
 *
 *  @param block 网络时间
 */
//+ (void)getInernetUTCDate:(void(^)(NSDate *utcDate))block;
/**
 *  @brief 获取当前北京时间
 *
 *  @return 当前北京时间
 */
+ (NSDate *)getBJDate;
+ (NSDate *)getLocaleDate;
/**
 *  @brief 将 GMT 时间转换为北京时间
 *
 *  @param date  GMT 时间
 *
 *  @return 北京时间
 */
+ (NSDate *)revertToBJTimeZone:(NSDate *)date;
/**
 *  @brief 获取指定时间的 NSDateComponents
 *
 *  @param fromdate fromDate
 *
 *  @return 指定时间的 NSDateComponents
 */
+ (NSDateComponents *)getDateComponentsFromDate:(NSDate *)fromdate;
/**
 *  @brief 获取两个时间点的间隔
 *
 *  @param fromDate fromDate
 *  @param toDate   toDate
 *
 *  @return 间隔(NSDateComponents)
 */
+ (NSDateComponents *)getDateIntervalComponentsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
/**
 *  @brief 将字符串转换为日期
 *
 *  @param date       日期
 *  @param dateFormat 日期格式
 *
 *  @return 转换后的字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)dateFormat;
/**
 *  @brief 将字符串转换为日期
 *
 *  @param dateString 日期(字符串)
 *  @param dateFormat 日期格式
 *
 *  @return 转换后的日期
 */
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)dateFormat;
/**
 *  将本地日期字符串转为UTC日期字符串
 *
 *  @param localDate 本地日期[格式:2013-08-03 12:53:51]
 *
 *  @return UTC date string[可自行指定输入输出格式]
 */
+ (NSString *)getUTCFormateLocalDate:(NSString *)localDate;
/**
 *  将UTC日期字符串转为本地时间字符串
 *
 *  @param utcDate UTC date[格式:2013-08-03T04:53:51+0000]
 *
 *  @return local date string
 */
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate;
/**
 *   IOS 世界标准时间UTC /GMT 转为当前系统时区对应的时间
 *
 *  @param anyDate other date
 *
 *  @return current system date
 */
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate;
#pragma mark -
#pragma mark - SSKeychain
+ (void)insertSharedDataForInnovationID:(NSString *)innovative_id;
+ (NSDictionary *)clearTimeOutSharedData;
+ (BOOL)clearAllSharedData;
/**
 *  @brief 从 keychain 提取数据
 *
 *  @return  saved data
 */
//+ (NSDictionary *)getSharedDataFromKeychain;
/**
 *  @brief 存储字符串 clearText 到 keychain
 *
 *  @param clearText clearText
 */
//+ (void)saveSharedDataToSSKeychain:(NSString *)clearText;
//+ (void)clearTimeOutSharedData:(void(^)(NSDictionary *dict))completeBlock;
/**
 *  @brief 清除所有的 keychain data
 */
//+ (BOOL)clearAllSharedDataFromKeychain;
#pragma mark -
#pragma mark - responds delegate toSelector
/**
 *  @brief set suitable delegate methods
 *
 *  @param delegate  delegate
 *  @param aSelector method selector
 */
+ (void)responds:(id<MJADDelegate>)delegate toSelector:(SEL)aSelector block:(kMJBaseBlock)block;


#pragma mark - local default AD data
+ (NSDictionary *)readDataFromFile:(NSString *)fileName;


#pragma mark - vertify idfa
+ (NSString *)getIDFA;

#pragma mark - Coupon
+ (NSString *)getMJShareNewTel;
+ (NSString *)getMJShareModifyTel;
+ (BOOL)saveMJShareNewTel:(NSString *)tel;
+ (BOOL)saveMJShareModifyTel:(NSString *)tel;
+ (BOOL)clearLocalTELKeychainNew;
+ (BOOL)clearLocalTELKeychainModify;
+ (BOOL)clearLocalTELKeychainALL;
@end
