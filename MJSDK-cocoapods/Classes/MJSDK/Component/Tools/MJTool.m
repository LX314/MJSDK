//
//  MJTool.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/15.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJTool.h"

#import "MJView.h"
#import "MJGradientLayer.h"

#import <SSKeychain.h>

#import "LXIPManager.h"

#import "MJSDKConfiguration.h"
#import "MJSDKConf.h"

@interface MJTool ()
{

}
/** <#注释#>*/
@property (nonatomic,retain)NSCalendar *calendar;
@property (nonatomic,retain)NSTimeZone *zone;
@property (nonatomic,retain)NSDateFormatter *dateFormatter;

/** 已分享数据*/
@property (nonatomic,retain)NSMutableDictionary *appsShared;
/** MJShare Tel*/
@property (nonatomic,retain)NSMutableDictionary *mjShareTEL;
/**  离线异常上报数据*/
@property (nonatomic,retain)NSMutableDictionary *offlineExceptionReports;
/** 离线曝光数据*/
@property (nonatomic,retain)NSMutableDictionary *offlineExposureReports;
/** 离线开屏(全屏)数据*/
@property (nonatomic,retain)NSMutableDictionary *offlineFullOpenScreenData;
/** 离线开屏(半屏)数据*/
@property (nonatomic,retain)NSMutableDictionary *offlineHalfOpenScreenData;

@end
@implementation MJTool

+ (instancetype)manager {
    static MJTool *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[[self class] alloc]init];
    });
    [_manager.dateFormatter setDateFormat:@"EEE,dd MMM yyyy HH:mm:ss"];
    return _manager;
}

+ (void)masonry:(UIView *)lxSelf portrait:(void(^)(void))portrait orientation:(void(^)(void))orientation {
    MJView *mjView = (MJView *)lxSelf;
    if (mjView.kMJOrientation == UIDeviceOrientationPortrait || mjView.kMJOrientation == UIDeviceOrientationPortraitUpsideDown) {
        if (portrait) {
            portrait();
        }
    } else if (mjView.kMJOrientation == UIDeviceOrientationLandscapeLeft || mjView.kMJOrientation == UIDeviceOrientationLandscapeRight) {
        if (orientation) {
            orientation();
        }
    }
}
+ (void)updateMask:(LXMJViewMaskType)maskType selfView:(UIView *)selfView layer:(CALayer *)bgLayer color:(UIColor *)bgLayerColor
{
    [[MJTool manager]updateMask:maskType selfView:selfView layer:bgLayer color:bgLayerColor];
}
- (void)updateMask:(LXMJViewMaskType)maskType selfView:(UIView *)selfView layer:(CALayer *)bgLayer color:(UIColor *)bgLayerColor {
    
    if(bgLayer) {
        
        [bgLayer removeFromSuperlayer];
        bgLayer = nil;
        
    }
    
    switch (maskType) {
            
        case LXMJViewMaskTypeCustom:
        case LXMJViewMaskTypeBlack:{
            
            bgLayer = [CALayer layer];
            bgLayer.frame = kMainScreen;
            bgLayer.backgroundColor = maskType == LXMJViewMaskTypeCustom ? bgLayerColor.CGColor : [UIColor colorWithWhite:0 alpha:0.4].CGColor;
            [bgLayer setNeedsDisplay];
            
            [selfView.layer insertSublayer:bgLayer atIndex:0];
            break;
        }
            
        case LXMJViewMaskTypeGradient:{
            MJGradientLayer *layer = [MJGradientLayer layer];
            bgLayer = layer;
            bgLayer.frame = kMainScreen;
            CGPoint gradientCenter = kMainScreen_center;
            gradientCenter.y = (kMainScreen_height - 0)/2;//self.visibleKeyboardHeight
            layer.gradientCenter = gradientCenter;
            [bgLayer setNeedsDisplay];
            
            [selfView.layer insertSublayer:bgLayer atIndex:0];
            break;
        }
        default:{
            [selfView setUserInteractionEnabled:NO];
            break;
        }
    }
}
#pragma mark -
#pragma mark - Common Component
+ (NSString *)toJsonString:(id)obj{
    NSError *error;
    NSString *jsonString;
    NSData *jsonData;
    if (![obj isKindOfClass:[NSDictionary class]] && ![obj isKindOfClass:[NSArray class]]) {
        return @"无法解析";
    }
    if ([obj isKindOfClass:[NSData class]]) {
        jsonString = [[NSString alloc]initWithData:obj encoding:NSUTF8StringEncoding];
        return jsonString;
    }
    jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&error];
    jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
+ (NSDictionary *)toJsonObject:(id)obj {
    if (!obj) {
        return nil;
    }
    NSError *error;
    NSData *jsonData = obj;
    if ([obj isKindOfClass:[NSString class]]) {
        jsonData = [obj dataUsingEncoding:NSUTF8StringEncoding];
    }
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
    return dict;
}
+ (NSDictionary *)sortDict:(NSDictionary *)dict {

    NSArray *array = [dict allKeys];
    array = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableDictionary *mudict = [NSMutableDictionary dictionary];
    for (id key in array) {
        [mudict setObject:dict[key] forKey:key];
    }
    return [mudict copy];
}
/**
 *  @brief 判断 URL 是否符合规则
 *
 *  @param urlString  urlString
 *
 *  @return bool value
 */
+ (BOOL)judgeURLString:(NSString*)urlString
{
    NSString* urlRegex = @"[a-zA-z]+://[^®]*";
    NSPredicate* urlPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlPredicate evaluateWithObject:urlString];
}

/**
 *  @brief 判断phone Number 是否符合规则
 *
 *  @param phoneNumber phoneNumber
 *
 *  @return bool value
 */
+ (BOOL)judgePhoneNumber:(NSString *)phoneNumber {

    NSString * phoneRegex = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate* phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phonePredicate evaluateWithObject:phoneNumber];

}


#pragma mark -
#pragma mark - NSDate
+ (NSDate *)getInternetBJDate {
    NSDate *utcDate_t= [MJTool getBJDate];
//    dispatch_group_t group = dispatch_group_create();
//    dispatch_queue_t queue = dispatch_queue_create("com.mj.mjsdk-getInternetBJDate", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_group_async(group, queue, ^{
//        [MJTool getInernetUTCDate:^(NSDate *utcDate) {
//            utcDate_t = utcDate;
//        }];
//        NSLog(@"sleep start...");
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            sleep(1.001);
//        });
//        NSLog(@"sleep end...");
//    });
//    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    return utcDate_t;
}
/**
 *  获取网络时间(BeiJing)
 *
 *  @param block 网络时间
 */
//+ (void)getInernetUTCDate:(void(^)(NSDate *utcDate))block {
//        NSString *urlString = @"http://time.windows.com/";
//        urlString = [urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//        [request setURL:[NSURL URLWithString: urlString]];
//        [request setCachePolicy:NSURLRequestReloadIgnoringCacheData];
//        [request setTimeoutInterval:1];
//        [request setHTTPShouldHandleCookies:FALSE];
//        [request setHTTPMethod:@"GET"];
//        NSError *error = nil;
//        NSHTTPURLResponse *response;
//        [NSURLConnection sendSynchronousRequest:request
//                              returningResponse:&response error:&error];
//        [[[NSURLSession sharedSession]dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            if (error) {
//                NSDate *utcdate = [MJTool getBJDate];
//                if (block) {
//                    block(utcdate);
//                }
//                return ;
//            }
//            NSHTTPURLResponse *responsee = (NSHTTPURLResponse *)response;
//            NSDictionary *httpHeaders = [responsee allHeaderFields];
//            //Fri, 19 Aug 2016 03:48:37 GMT
//            NSString *dateString = httpHeaders[@"Date"];
////            dateString = [dateString substringFromIndex:5];
//            dateString = [dateString substringToIndex:[dateString length]-4];
//            MJTool *tool = [MJTool manager];
//            [tool.dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
//            [tool.dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
//            NSDate *gmtDate = [tool.dateFormatter dateFromString:dateString];
//            NSDate *localDate = [self getNowDateFromatAnDate:gmtDate];
//            if (block) {
//                block(localDate);
//            }
//        }]resume];
//}
/**
 *  @brief 获取当前北京时间
 *
 *  @return 当前北京时间
 */
+ (NSDate *)getBJDate {
    return [self revertToBJTimeZone:[NSDate date]];
}
+ (NSDate *)getLocaleDate {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return localeDate;
}
/**
 *  @brief 将 GMT 时间转换为北京时间
 *
 *  @param date  GMT 时间
 *
 *  @return 北京时间
 */
+ (NSDate *)revertToBJTimeZone:(NSDate *)date {
    MJTool *tool = [MJTool manager];
    NSInteger interval = [tool.zone secondsFromGMTForDate:date];
    NSDate *localeDate = [date dateByAddingTimeInterval:interval];
    return localeDate;
}
/**
 *  @brief 获取指定时间的 NSDateComponents
 *
 *  @param fromdate fromDate
 *
 *  @return 指定时间的 NSDateComponents
 */
+ (NSDateComponents *)getDateComponentsFromDate:(NSDate *)fromdate {
    MJTool *tool = [MJTool manager];
    NSDateComponents *components = [tool.calendar components:NSCalendarUnitYear |
                                    NSCalendarUnitMonth |
                                    NSCalendarUnitDay
                                               fromDate:fromdate];
    return components;
}
/**
 *  @brief 获取两个时间点的间隔
 *
 *  @param fromDate fromDate
 *  @param toDate   toDate
 *
 *  @return 间隔(NSDateComponents)
 */
+ (NSDateComponents *)getDateIntervalComponentsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    MJTool *tool = [MJTool manager];
    NSDate *bgfromDate;// = [self revertToBJTimeZone:fromDate];
    NSDate *bgtoDate;// = [self revertToBJTimeZone:toDate];
    bgfromDate = fromDate;
    bgtoDate = toDate;
    NSDateComponents *components = [tool.calendar components:NSCalendarUnitYear |
                                    NSCalendarUnitMonth |
                                    NSCalendarUnitDay |
                                    NSCalendarUnitHour
                                               fromDate:bgfromDate toDate:bgtoDate options:NSCalendarWrapComponents];
    return components;
}
/**
 *  @brief 将字符串转换为日期
 *
 *  @param date       日期
 *  @param dateFormat 日期格式
 *
 *  @return 转换后的字符串
 */
+ (NSString *)stringFromDate:(NSDate *)date format:(NSString *)dateFormat {
    MJTool *tool = [MJTool manager];
    if (dateFormat && dateFormat.length > 1) {
        [tool.dateFormatter setDateFormat:dateFormat];
    }
    return [tool.dateFormatter stringFromDate:date];
}
/**
 *  @brief 将字符串转换为日期
 *
 *  @param dateString 日期(字符串)
 *  @param dateFormat 日期格式
 *
 *  @return 转换后的日期
 */
+ (NSDate *)dateFromString:(NSString *)dateString format:(NSString *)dateFormat {
    MJTool *tool = [MJTool manager];
    if (dateFormat && dateFormat.length > 1) {
        [tool.dateFormatter setDateFormat:dateFormat];
    }
    return [tool.dateFormatter dateFromString:dateString];
}
/**
 *  将本地日期字符串转为UTC日期字符串
 *
 *  @param localDate 本地日期[格式:2013-08-03 12:53:51]
 *
 *  @return UTC date string[可自行指定输入输出格式]
 */
+ (NSString *)getUTCFormateLocalDate:(NSString *)localDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}
/**
 *  将UTC日期字符串转为本地时间字符串
 *
 *  @param utcDate UTC date[格式:2013-08-03T04:53:51+0000]
 *
 *  @return local date string
 */
+ (NSString *)getLocalDateFormateUTCDate:(NSString *)utcDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];

    NSDate *dateFormatted = [dateFormatter dateFromString:utcDate];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}
/**
 *   IOS 世界标准时间UTC /GMT 转为当前系统时区对应的时间
 *
 *  @param anyDate other date
 *
 *  @return current system date
 */
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate
{
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];//或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}
#pragma mark - dateFormatter
- (NSDateFormatter *)dateFormatter
{
    if(!_dateFormatter){
        _dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setLocale:[NSLocale systemLocale]];
        [_dateFormatter setCalendar:self.calendar];
        NSTimeZone *GTMzone = [NSTimeZone timeZoneForSecondsFromGMT:0];
        [_dateFormatter setTimeZone:GTMzone];
        [_dateFormatter setDateFormat:@"EEE,dd MMM yyyy HH:mm:ss"];//yyyy/MM/dd HH:mm:ss
    }
    return _dateFormatter;
}

- (NSCalendar *)calendar
{
    if(!_calendar) {
        _calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    }

    return _calendar;
}
- (NSTimeZone *)zone
{
    if(!_zone){
        [NSTimeZone resetSystemTimeZone];
        _zone = [NSTimeZone systemTimeZone];

    }

    return _zone;
}

#pragma mark -
#pragma mark - [SSKeychain][APPs]已分享数据库
/**
 *  @brief 从 keychain 提取数据
 *
 *  @return  saved data
 */
//+ (NSDictionary *)getSharedDataFromKeychain {
//    NSString *json = [SSKeychain passwordForService:kMJAPPsHasSharedService account:kMJAPPsHasSharedAccount];
//    if (!json || json.length <= 5) {
//        return nil;
//    }
//    NSDictionary *dict = [MJTool toJsonObject:json];
//    return dict;
//}
/**
 *  @brief 存储字符串 clearText 到 keychain
 *
 *  @param clearText clearText
 */
//+ (void)saveSharedDataToSSKeychain:(NSString *)clearText {
//    [MJTool getInernetUTCDate:^(NSDate *utcDate) {
//        NSString *utcDateString = [MJTool stringFromDate:utcDate format:nil];
//        NSDictionary *dict = [self getSharedDataFromKeychain];
//        NSMutableDictionary *mudict = [dict mutableCopy];
//        [mudict setObject:utcDateString forKey:clearText];
//        //save
//        NSString *json = [MJTool toJsonString:[mudict copy]];
//        BOOL success = [SSKeychain setPassword:json forService:kMJAPPsHasSharedService account:kMJAPPsHasSharedAccount];
//        if (success) {
//            NSLog(@"成功存储已分享数据[innovative_id]");
//        }
//    }];
//}
+ (void)insertSharedDataForInnovationID:(NSString *)innovative_id {
    NSDate *utcDate = [MJTool getInternetBJDate];
    MJTool *tool = [MJTool manager];
    NSString *utcDateString = [MJTool stringFromDate:utcDate format:nil];
    [tool.appsShared setObject:utcDateString forKey:innovative_id];
    NSString *json = [MJTool toJsonString:tool.appsShared];
    BOOL success = [SSKeychain setPassword:json forService:kMJAPPsHasSharedService account:kMJAPPsHasSharedAccount];
    if(success) {
        NSLog(@"[插入数据成功]InnovationID:%@\tutcDate:%@", innovative_id, utcDateString);
    }
}
//+ (void)clearTimeOutSharedData:(void(^)(NSDictionary *dict))completeBlock {
//    NSDictionary *oldDict = [self getSharedDataFromKeychain];
//    [MJTool getInernetUTCDate:^(NSDate *utcDate) {
//        NSMutableDictionary *mudict = [oldDict mutableCopy];
//        //清除过时数据
//        NSLog(@"开始清除过时的 innovative_id 数据");
//        NSMutableDictionary *removedDict = [NSMutableDictionary dictionary];
//        NSMutableDictionary *remainedDict = [NSMutableDictionary dictionary];
//        for (NSString *key in mudict.allKeys) {
//            NSString *value = mudict[key];
//            NSInteger hour = [[value substringWithRange:NSMakeRange(16, 2)]integerValue];
//            NSDate *date = [self dateFromString:value format:nil];
//            if (!date) {
//                NSLog(@"********************DATE:%@\tID:%@", date, key);
//            }
//            NSDateComponents *com = [self getDateIntervalComponentsFromDate:date toDate:utcDate];
//            NSMutableString *mukey = [NSMutableString string];
//            [mukey appendFormat:@"[%2ld]", com.year];
//            [mukey appendFormat:@"[%2ld]", com.month];
//            [mukey appendFormat:@"[%2ld]", com.day];
//            [mukey appendFormat:@"%@", key];
//            if (!(com.year == 0 && com.month == 0 && com.day == 0)) {
//                [removedDict setObject:value forKey:mukey];
//                [mudict removeObjectForKey:key];
//            } else {
//                if (com.hour + hour >= 24.f || com.hour + hour <= 0.f) {
//                    [removedDict setObject:value forKey:mukey];
//                    [mudict removeObjectForKey:key];
//                } else {
//                    [remainedDict setObject:value forKey:mukey];
//                }
//            }
//        }
//        NSDictionary *resultDict = @{
//                                     @"Removed" : removedDict,
//                                     @"Remained" : remainedDict,
//                                     };
//        NSLog(@"--->处理结果[✔︎:%ld\t✘:%ld]:%@",remainedDict.count, removedDict.count, resultDict.debugDescription);
//        if (completeBlock) {
//            completeBlock([mudict copy]);
//        }
//    }];
//}

+ (BOOL)clearAllSharedData {
    MJTool *tool = [MJTool manager];
    tool.appsShared = [NSMutableDictionary dictionary];
    BOOL success = [SSKeychain setPassword:@"" forService:kMJAPPsHasSharedService account:kMJAPPsHasSharedAccount];
    NSLog(@"已清空 shared 数据库 - success:%@", success ? @"YES" : @"NO");
    return success;
}
+ (NSDictionary *)clearTimeOutSharedData {
    NSDate *utcDateNow = [MJTool getInternetBJDate];
    MJTool *tool = [MJTool manager];
    NSMutableDictionary *mudict = tool.appsShared;
    //清除过时数据
    NSLog(@"开始清除过时的 innovative_id 数据");
    NSMutableDictionary *removedDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *remainedDict = [NSMutableDictionary dictionary];
    for (NSString *key in mudict.allKeys) {
//        NSInteger keyy = [key integerValue];
        NSString *value = mudict[key];
        NSInteger hour = [[value substringWithRange:NSMakeRange(16, 2)]integerValue];
        NSDate *date = [self dateFromString:value format:nil];
        if (!date) {
            NSLog(@"********************DATE:%@\tvalue:%@\tID:%@", date, value, key);
        }
        NSDateComponents *com = [self getDateIntervalComponentsFromDate:date toDate:utcDateNow];
        NSMutableString *mukey = [NSMutableString string];
        [mukey appendFormat:@"[%2ld]", com.year];
        [mukey appendFormat:@"[%2ld]", com.month];
        [mukey appendFormat:@"[%2ld]", com.day];
        [mukey appendFormat:@"%@", key];
        if (!(com.year == 0 && com.month == 0 && com.day == 0)) {
            [removedDict setObject:value forKey:mukey];
            [mudict removeObjectForKey:key];
        } else {
            if (com.hour + hour >= 24.f || com.hour + hour <= 0.f) {
                [removedDict setObject:value forKey:mukey];
                [mudict removeObjectForKey:key];
            } else {
                [remainedDict setObject:value forKey:mukey];
            }
        }
    }
    NSDictionary *resultDict = @{
                                 @"Removed" : removedDict,
                                 @"Remained" : remainedDict,
                                 };
    NSLog(@"--->处理结果[✔︎:%ld\t✘:%ld]:%@",remainedDict.count, removedDict.count, resultDict.debugDescription);
    tool.appsShared = mudict;
    //
    NSString *json = [MJTool toJsonString:mudict];
    BOOL success = [SSKeychain setPassword:json forService:kMJAPPsHasSharedService account:kMJAPPsHasSharedAccount];
    NSLog(@"已移除 timeout shared 数据 - success:%@", success ? @"YES" : @"NO");
    return [tool.appsShared copy];
}
/**
 *  @brief 清除所有的 keychain data
 */
//+ (BOOL)clearAllSharedDataFromKeychain {
//    BOOL success = [SSKeychain setPassword:@"" forService:kMJAPPsHasSharedService account:kMJAPPsHasSharedAccount];
//    NSLog(@"已清空 shared 数据库 - success:%@", success ? @"YES" : @"NO");
//    return success;
//}
#pragma mark -
#pragma mark - responds delegate toSelector
/**
 *  @brief set suitable delegate methods
 *
 *  @param delegate  delegate
 *  @param aSelector method selector
 */
+ (void)responds:(id<MJADDelegate>)delegate toSelector:(SEL)aSelector block:(kMJBaseBlock)block {
    if (delegate && [delegate respondsToSelector:aSelector]) {
//        [delegate ];
//        NSLog(@"SEL:%@", aSelector);
        if (block) {
            block();
        }
    }
}

#pragma mark -
#pragma mark - fileManager
+ (NSDictionary *)readDataFromFile:(NSString *)fileName {
    NSString *filePath = [[NSBundle mainBundle]pathForResource:fileName ofType:@"json"];
    NSString *impAds = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *dict_impAds = [NSJSONSerialization JSONObjectWithData:[impAds dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    return dict_impAds;
}
#pragma mark -
#pragma mark - vertify idfa
+ (NSString *)getIDFA {
    LXIPManager *ipManager = [[LXIPManager alloc]init];
    if (ipManager.idfa.length <= 5) {
        NSLog(@"获取设备号失败，无法参与免费兑换道具，请开启权限后重试");
        return nil;
    }
    return ipManager.idfa;
}
#pragma mark -
#pragma mark - Coupon
+ (NSString *)getMJShareNewTel {
    return [self getMJShareTelFromAccount:kMJShareTelNumberAccountNew service:kMJShareTelNumberServiceNew];
}
+ (NSString *)getMJShareModifyTel {
    return [self getMJShareTelFromAccount:kMJShareTelNumberAccountModify service:kMJShareTelNumberServiceModify];
}
+ (BOOL)saveMJShareNewTel:(NSString *)tel {
    return [self saveMJShareTEL:tel inAccount:kMJShareTelNumberAccountNew service:kMJShareTelNumberServiceNew];
}
+ (BOOL)saveMJShareModifyTel:(NSString *)tel {
    return [self saveMJShareTEL:tel inAccount:kMJShareTelNumberAccountModify service:kMJShareTelNumberServiceModify];
}
+ (BOOL)clearLocalTELKeychainNew {
    BOOL success = [self clearLocalTELKeychainFromAccount:kMJShareTelNumberAccountNew service:kMJShareTelNumberServiceNew];
    if (success) {
        NSLog(@"清除手机号[NEW]成功!");
    }
    return success;
}
+ (BOOL)clearLocalTELKeychainModify {
    BOOL success = [self clearLocalTELKeychainFromAccount:kMJShareTelNumberAccountModify service:kMJShareTelNumberServiceModify];
    if (success) {
        NSLog(@"清除手机号[Modify]成功!");
    }
    return success;
}
+ (BOOL)clearLocalTELKeychainALL {
    return [self clearLocalTELKeychainNew] && [self clearLocalTELKeychainModify];
}
+ (NSString *)getMJShareTelFromAccount:(NSString *)account service:(NSString *)service {
    NSString *json = [SSKeychain passwordForService:service account:account];
    NSDictionary *dict = [self toJsonObject:json];
    return dict[kMJShareTelKey];
}
+ (BOOL)saveMJShareTEL:(NSString *)tel inAccount:(NSString *)account service:(NSString *)service {
    NSDictionary *dict = @{
                           kMJShareTelKey:tel,
                           kMJShareDateKey:[self stringFromDate:[self getBJDate] format:nil],
                           };
    NSString *json = [self toJsonString:dict];
    return [SSKeychain setPassword:json forService:service account:account];
}
+ (BOOL)clearLocalTELKeychainFromAccount:(NSString *)account service:(NSString *)service {
    BOOL success = [SSKeychain setPassword:@"" forService:service account:account];
    return success;
}
#pragma mark - 开屏广告存储
//- (NSDictionary *)getDictionaryFromFullScreen {
//
//}
//- (BOOL)saveDictionaryFromFullScreen {
//
//}
//- (void)clearDataFromFullScreen {
//    
//}
#pragma mark - 半屏广告存储

- (NSDictionary *)getDictionaryFromKeychainAccount:(NSString *)account Service:(NSString *)service {
    NSString *json = [SSKeychain passwordForService:service account:account];
    NSDictionary *dict = [MJTool toJsonObject:json];
    return dict;
}
- (BOOL)saveToKeychainAccount:(NSString *)account Service:(NSString *)service dictionary:(NSDictionary *)dict {
    NSString *json = [MJTool toJsonString:dict];
    return [SSKeychain setPassword:json forService:service account:account];
}
- (BOOL)clearKeychainDataFromAccount:(NSString *)account Service:(NSString *)service {
    return [SSKeychain setPassword:@"" forService:service account:account];
}

#pragma mark - appsShared
- (NSDictionary *)appsShared
{
    if(!_appsShared) {
        NSString *json = [SSKeychain passwordForService:kMJAPPsHasSharedService account:kMJAPPsHasSharedAccount];
        if (!json || json.length <= 5) {
            return [NSMutableDictionary dictionary];
        }
        NSDictionary *dict = [MJTool toJsonObject:json];
        _appsShared = [dict mutableCopy];
    }
    return _appsShared;
}
#pragma mark - mjShareTEL
- (NSMutableDictionary *)mjShareTEL
{
    if(!_mjShareTEL) {
        _mjShareTEL = [NSMutableDictionary dictionary];
        NSString *json = [SSKeychain passwordForService:@"" account:@""];
        if (!json || json.length <= 5) {
            return [NSMutableDictionary dictionary];
        }
        NSDictionary *dict = [MJTool toJsonObject:json];
        return [dict mutableCopy];
    }
    return _mjShareTEL;
}
#pragma mark - offlineExceptionReports
- (NSMutableDictionary *)offlineExceptionReports
{
    if(!_offlineExceptionReports) {
        _offlineExceptionReports = [NSMutableDictionary dictionary];
    }
    return _offlineExceptionReports;
}
#pragma mark - offlineExposureReports
- (NSMutableDictionary *)offlineExposureReports
{
    if(!_offlineExposureReports) {
        _offlineExposureReports = [NSMutableDictionary dictionary];
    }
    return _offlineExposureReports;
}
#pragma mark - offlineFullOpenScreenData
- (NSMutableDictionary *)offlineFullOpenScreenData
{
    if(!_offlineFullOpenScreenData){
        _offlineFullOpenScreenData = [NSMutableDictionary dictionary];
    }
    return _offlineFullOpenScreenData;
}
#pragma mark - offlineHalfOpenScreenData
- (NSMutableDictionary *)offlineHalfOpenScreenData
{
    if(!_offlineHalfOpenScreenData){
        _offlineHalfOpenScreenData = [NSMutableDictionary dictionary];
    }
    return _offlineHalfOpenScreenData;
}
@end
