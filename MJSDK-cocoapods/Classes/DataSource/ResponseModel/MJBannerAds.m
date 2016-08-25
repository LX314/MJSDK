//
//  MJBannerAds.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/21.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJBannerAds.h"

#import "MJTool.h"

@interface MJBannerAds ()<MTLJSONSerializing>
{

}

@end
@implementation MJBannerAds
#pragma mark -
#pragma mark - Mantle
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             //
             @"mjAdType":@"template_id",
             @"mjElement":@"elements",
             //origin
             @"templateId":@"template_id",
             @"clickUrl":@"click_url",
             @"resolution":@"resolution",
             @"elements":@"elements",
             @"targetType":@"target_type",
             @"btnUrl":@"btn_url",
             };
}
#pragma mark - mjElement
+ (NSValueTransformer *)mjElementJSONTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
#warning error report
        if (!value || [value length] <= 5) {
            //            NSAssert(NO, @"elements can't be nil!");
            NSLog(@"elements can't be nil!");
            return nil;
        }
        NSDictionary *dict_elements = [NSJSONSerialization JSONObjectWithData:[value dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
        return [MTLJSONAdapter modelOfClass:[MJElement class] fromJSONDictionary:dict_elements error:nil];
//    }];
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if (!value) {
            return @"";
        }
        NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:value error:nil];
        NSMutableDictionary *mudict = [NSMutableDictionary dictionary];
        for (id key in dict) {
            id obj = dict[key];
            if (obj && ![obj isKindOfClass:[NSNull class]]) {
                [mudict setObject:obj forKey:key];
            }
        }
        NSString *json = [MJTool toJsonString:[mudict copy]];
        return json;
}];
}

@end
