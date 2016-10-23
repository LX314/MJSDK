//
//  MJExceptionReport.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/28.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJExceptionReport.h"

#import "MJTool.h"
#import "LXIPManager.h"
#import "MJSDKConf.h"

@implementation MJExceptionReport

#pragma mark -
#pragma mark - Mantle
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSSet *set = [self propertyKeys];
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    for (id obj in set) {
        [muDict setObject:obj forKey:obj];
    }
    return [muDict copy];
}
#pragma mark - msg
+ (NSValueTransformer *)msgJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        MJExceptionMsg *msg = [MTLJSONAdapter modelOfClass:[MJExceptionMsg class] fromJSONDictionary:value error:nil];
        NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:msg error:nil];
        return [MTLJSONAdapter modelOfClass:[MJExceptionMsg class] fromJSONDictionary:dict error:nil];
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [MTLJSONAdapter JSONDictionaryFromModel:value error:nil];
    }];
}

+ (instancetype)reportWithADSpaceID:(NSString *)adspaceID code:(NSInteger)code description:(NSString *)desc {
    adspaceID = adspaceID ? adspaceID : @"NaN";
    MJExceptionReport *report = [MTLJSONAdapter modelOfClass:[MJExceptionReport class] fromJSONDictionary:
                                 @{
                                   @"code":@000,
                                   @"desc":@"desc",
                                   @"msg":@{
                                           @"adspaceId":adspaceID
                                           }
                                   } error:nil];
    report.code = code;
    report.desc = desc;
    return report;
}

@end


@implementation MJExceptionMsg

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    NSSet *set = [self propertyKeys];
    NSMutableDictionary *muDict = [NSMutableDictionary dictionary];
    for (id obj in set) {
        [muDict setObject:obj forKey:obj];
    }
    return [muDict copy];
}
#pragma mark - idfa
+ (NSValueTransformer *)idfaJSONTransformer
{
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return kMJAppsIDFA;
    }];
}
#pragma mark - bundleId
+ (NSValueTransformer *)bundleIdJSONTransformer
{
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return [[NSBundle mainBundle] bundleIdentifier];
    }];
}
#pragma mark - appKey
+ (NSValueTransformer *)appKeyJSONTransformer
{
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return kMJAppsAPPKey;
    }];
}
#pragma mark - errorTime
+ (NSValueTransformer *)errorTimeJSONTransformer
{
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        NSDate *utcDate_t = [MJTool getInternetBJDate];
        return [MJTool stringFromDate:utcDate_t format:nil];
    }];
}




@end
