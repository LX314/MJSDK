//
//  MJImpAds.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/21.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJImpAds.h"

#import "MJExceptionReportManager.h"
#import "MJTool.h"

#import <SSKeychain.h>

@interface MJImpAds ()<MTLJSONSerializing>
{
}

@end
@implementation MJImpAds
#pragma mark -
#pragma mark - Mantle
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             //
//             @"showUrlllllll":@".showUrl",
             @"hasShared":@"innovative_id",
             @"isNormalLoaded":@"innovative_id",
             @"isDefaultLoaded":@"innovative_id",
             //origin
             @"bannerAds":@"banner_ads",
             @"impressionId":@"impression_id",
             @"impressionSeqNo":@"impression_seq_no",
             @"apps":@"apps",
             @"landingPageUrl":@"landing_page_url",
             @"innovativeId":@"innovative_id",
             };
}

#pragma mark - isNormalLoaded
+ (NSValueTransformer *)isNormalLoadedJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return @YES;
    }];
}
#pragma mark - isDefaultLoaded
+ (NSValueTransformer *)isDefaultLoadedJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return @NO;
    }];
}
#pragma mark - bannerAds
+ (NSValueTransformer *)bannerAdsJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:MJBannerAds.class];
}
#pragma mark - apps
+ (NSValueTransformer *)appsJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:MJApps.class];
}
#pragma mark - hasShared
+ (NSValueTransformer *)hasSharedJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        //

        MJTool *tool = [MJTool manager];
        NSDictionary *dict = tool.appsShared;
        BOOL exist = [dict.allKeys containsObject:value];
        return @(exist);
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return @"NO";
    }];
}
@end
