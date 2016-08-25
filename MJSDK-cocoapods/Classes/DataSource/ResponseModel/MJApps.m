//
//  MJAppsAdditional.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/20.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJApps.h"

@interface MJApps ()<MTLJSONSerializing>
{

}

@end
@implementation MJApps
#pragma mark -
#pragma mark - Mantle
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             //
             @"mjElement":@"elements",
             @"mjAdType":@"template_id",
             //origin
             @"resolution":@"resolution",
             @"templateId":@"template_id",
             @"elements":@"elements",
             @"clickUrl":@"click_url",
             @"btnUrl":@"btn_url",
             @"targetType":@"target_type",
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
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
//        NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:value error:nil];
//        return [MJTool toJsonString:dict];
        return nil;
    }];
}

@end
