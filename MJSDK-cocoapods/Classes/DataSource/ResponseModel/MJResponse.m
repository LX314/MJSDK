//
//  MJResponse.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/21.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJResponse.h"

#import "MJTool.h"

@interface MJResponse ()<MTLJSONSerializing>
{

}

@end
@implementation MJResponse
#pragma mark -
#pragma mark - Mantle
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"code":@"code",
             @"serverTimestamp":@"server_timestamp",
             @"showUrl":@"show_url",
             @"impAds":@"imp_ads",
             @"eventId":@"event_id",
             };
}

#pragma mark - impAds
+ (NSValueTransformer *)impAdsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:MJImpAds.class];
}


@end
