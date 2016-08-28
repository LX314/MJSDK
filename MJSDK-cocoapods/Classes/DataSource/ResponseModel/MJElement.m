//
//  MJElement.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/21.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJElement.h"

@interface MJElement ()<MTLJSONSerializing>
{

}

@end
@implementation MJElement
#pragma mark -
#pragma mark - Mantle
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"title":@"title",
             @"content":@"content",
             @"desc":@"desc",
             @"icon":@"icon",
             @"image":@"image",
             @"share_image":@"share_image",
             @"share_title":@"share_title",
             @"share_subtitle":@"share_subtitle"
             };
}

@end
