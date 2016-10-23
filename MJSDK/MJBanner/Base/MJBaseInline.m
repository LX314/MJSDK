//
//  MJBaseInlineBanner.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/7.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJBaseInline.h"

#import "Tool.h"
#import "MJElement.h"
#import "MJSDKConfiguration.h"

@implementation MJBaseInline
- (void)setUp{
    [super setUp];
}

- (void)shareInformationMethod {
    if (![Tool hasWechatInstalled]) {
        MJNSLog(@"尚未安装微信客户端,无法分享~");
        return;
    }
    NSString * share_image_url = _mjElement.share_image;
    NSString * title = _mjElement.share_title;
    NSString * subtitle = _mjElement.share_subtitle;
    NSString * landing_page_url = _mjElement.mjLandingPageUrl;
    
    __block UIImage *share_image;
    NSLog(@"1`begin download");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [UIImage mj_setImageWithURLString:share_image_url placeholderImage:nil success:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, UIImage * _Nullable image) {
            NSLog(@"2`success");
            share_image = image;
            NSLog(@"3`over");
            [Tool wechatShare:^(KMJWechatShareStatus status) {
            } title:title description:subtitle imagesArray:@[share_image] url:landing_page_url];
        } failure:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error) {
        }];
    });
}
- (void)masonry{
    [super masonry];
}
@end
