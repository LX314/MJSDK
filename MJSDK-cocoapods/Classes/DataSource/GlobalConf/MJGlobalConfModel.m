//
//  MJGlobalConf.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/8/12.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJGlobalConfModel.h"

#import "LXNetWorking.h"
#import "MJSDKConf.h"
#import "SSKeychain.h"
#import "MJSDKConfiguration.h"
#import "MJSDKConf.h"
#import "MJExceptionReportManager.h"
#import "MJTool.h"

@implementation MJGlobalConfModel
#pragma mark -
#pragma mark - Mantle
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"components":@"version",
             @"version": @"version",
             @"defaultAdVersion": @"data.defaultAdVersionCode",//
             @"adRequestCount": @"data.advRequestCount",//
             @"displayCoupon": @"data.isCouponShown",
             @"exposurePeriod": @"data.advShownPeriod",//
             @"adSwitchInterval": @"data.exposurePeriod",//
             @"isCouponAdClickable": @"data.isCouponAdvClickable",//
             @"displayCouponAgain": @"data.isCouponShownAgain",//
             };
}
#pragma mark - components
+ (NSValueTransformer *)componentsJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSDateComponents *com = [MJTool getDateComponentsFromDate:[MJTool getInternetBJDate]];
        return com;
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSDateComponents *com = (NSDateComponents *)value;
        return [NSString stringWithFormat:@"%ld/%ld/%ld", com.year, com.month, com.day];
    }];
}

+ (BOOL)shouldUpdateGlobalConf {
    return YES;
}
+ (void)updateGlobalConf:(NSDictionary *)dictGlobalConf {
    NSError *error;
    MJGlobalConfModel *globalConf = [MTLJSONAdapter modelOfClass:[MJGlobalConfModel class] fromJSONDictionary:dictGlobalConf error:&error];
    if (error || !globalConf) {
        MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORGlobalConfModelRevertFailure description:[NSString stringWithFormat:@"model 转化发生错误!\n\nResponseObject:%@", [dictGlobalConf description]]];
        [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
        return;
    }
    MJGlobalConfModel *localGlobalConf = [self getGlobalConfFromKeychain];
    if (!localGlobalConf) {
        NSLog(@"localGlobalModel 发生错误");
        [self clearLocalGlobalConf];
    }
    if (localGlobalConf.version <= globalConf.version) {
        NSLog(@"开始加载服务端配置");
    } else {
        if(localGlobalConf) {
            NSLog(@"获取的配置过于陈旧,使用本地缓存");
            globalConf = localGlobalConf;
        } else {
            NSLog(@"加载本地缓存有误,使用默认配置");
            return;
        }
    }
    kMJSDKGlobalConfVersion = globalConf.version;
    kMJSDKCurrentDefaultADVersion = globalConf.defaultAdVersion;
    {
        kMJSDKRequestADCount = globalConf.adRequestCount;
        kMJSDKBannerRequestCount = globalConf.adRequestCount;
        kMJSDKInterstitalRequestCount = globalConf.adRequestCount;
        kMJSDKInlineRequestCount = globalConf.adRequestCount;
//        kMJSDKAppsRequestCount;
    }
    kMJSDKShouldDisplayCoupon = globalConf.displayCoupon;
    kMJSDKExposureTimeInterval = globalConf.adSwitchInterval / 1000.f;
    kMJSDKScrollInterval = globalConf.exposurePeriod / 1000.f;
    kMJSDKIsCouponAdClickable = globalConf.isCouponAdClickable;
    kMJSDKDisplayCouponAgain = globalConf.displayCouponAgain;
    [self saveGlobalConfToKeychain:globalConf];
    [globalConf description];
    //
    kMJSDKScrollInterval = 5;
    kMJSDKExposureTimeInterval = 2;
}
+ (void)loadServerGlobalConf {
    LXNetWorking *manager = [LXNetWorking manager];
    [manager GET:kMJSDKGlobalConfAPI params:nil success:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject) {
        NSLog(@"获取服务器配置(GET)- success");
        [self updateGlobalConf:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
        //
        NSLog(@"获取服务器配置失败(GET),开始上传异常...");
        MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORGlobalConfigurationUpdateFailure description:[NSString stringWithFormat:@"获取服务器配置失败(GET), ERROR:%@", error]];
        [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
    }];
}
+ (void)saveGlobalConfToKeychain:(MJGlobalConfModel *)globalConf {
    NSDictionary *dictGlobalConf = [MTLJSONAdapter JSONDictionaryFromModel:globalConf error:nil];
    NSString *jsonString = [MJTool toJsonString:dictGlobalConf];
    [SSKeychain setPassword:jsonString forService:kMJAppsGlobalConfigurationService account:kMJAppsGlobalConfigurationAccount error:nil];
    NSLog(@"配置已保存到本地");
}
+ (MJGlobalConfModel *)getGlobalConfFromKeychain {
    NSString *jsonString = [SSKeychain passwordForService:kMJAppsGlobalConfigurationService account:kMJAppsGlobalConfigurationAccount];
    NSDictionary *dict = [MJTool toJsonObject:jsonString];
    MJGlobalConfModel *globalConf = [MTLJSONAdapter modelOfClass:[MJGlobalConfModel class] fromJSONDictionary:dict error:nil];
    return globalConf;
}
+ (void)clearLocalGlobalConf {
    [SSKeychain setPassword:@"" forService:kMJAppsGlobalConfigurationService account:kMJAppsGlobalConfigurationAccount error:nil];
    NSLog(@"本地配置已清空");
}
+ (NSString *)globalConfdescription {
    NSMutableString *muString = [NSMutableString string];
    [muString appendFormat:@"kMJSDKGlobalConfVersion:%f\n", kMJSDKGlobalConfVersion];
    [muString appendFormat:@"kMJSDKCurrentDefaultADVersion:%f\n", kMJSDKCurrentDefaultADVersion];
    [muString appendFormat:@"kMJSDKRequestADCount:%ld\n", kMJSDKRequestADCount];
    [muString appendFormat:@"kMJSDKShouldDisplayCoupon:%@\n", kMJSDKShouldDisplayCoupon ? @"YES" : @"NO"];
    [muString appendFormat:@"kMJSDKExposureTimeInterval(ms):%f\n", kMJSDKExposureTimeInterval];
    [muString appendFormat:@"kMJSDKScrollInterval(ms):%f\n", kMJSDKScrollInterval];
    [muString appendFormat:@"kMJSDKIsCouponAdClickable:%@\n", kMJSDKIsCouponAdClickable ? @"YES" : @"NO"];
    [muString appendFormat:@"kMJSDKDisplayCouponAgain:%@\n", kMJSDKDisplayCouponAgain ? @"YES" : @"NO"];
    NSLog(@"当前配置为:\n%@", [muString copy]);
    return [muString copy];
}
- (NSString *)description {
    NSMutableString *muString = [NSMutableString string];
    [muString appendFormat:@"kMJSDKGlobalConfVersion:%f\n", self.version];
    [muString appendFormat:@"kMJSDKCurrentDefaultADVersion:%f\n", self.defaultAdVersion];
    [muString appendFormat:@"kMJSDKRequestADCount:%ld\n", self.adRequestCount];
    [muString appendFormat:@"kMJSDKShouldDisplayCoupon:%@\n", self.displayCoupon ? @"YES" : @"NO"];
    [muString appendFormat:@"kMJSDKExposureTimeInterval(ms):%f\n", self.exposurePeriod];
    [muString appendFormat:@"kMJSDKScrollInterval(ms):%f\n", self.adSwitchInterval];
    [muString appendFormat:@"kMJSDKIsCouponAdClickable:%@\n", self.isCouponAdClickable ? @"YES" : @"NO"];
    [muString appendFormat:@"kMJSDKDisplayCouponAgain:%@\n", self.displayCouponAgain ? @"YES" : @"NO"];
    NSLog(@"当前配置为:\n%@", [muString copy]);
    return [muString copy];
}
@end
