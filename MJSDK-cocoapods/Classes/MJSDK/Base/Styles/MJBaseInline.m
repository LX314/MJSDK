//
//  MJBaseInlineBanner.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/7.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJBaseInline.h"
#import "Tool.h"
#import "UIImage+cached.h"

@implementation MJBaseInline
- (void)setUp{
}

- (void)shareInformationMethod {
    
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

//                if (![MJTool judgeURLString:landing_page_url]) {
//                    MJExceptionReport *report = [MJExceptionReport modelWithDictionary:@{} error:nil];
//                    report.code = 222;
//                    report.desc = @"btnURL异常";
//                    [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
//                }

                
            } title:title description:subtitle imagesArray:@[share_image] url:landing_page_url];
            
            
        } failure:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error) {
            
        }];
        
    });
 
}
- (void)share {
    //    __block MJImpAds *impAds = _mjResponse.impAds[self.selfIndexPath.row];
//    NSString * shareString = impAds.apps.elements;
//    NSDictionary *shareJSON = [MJTool toJsonObject:shareString];
//
//    NSString * share_image_url = shareJSON[@"share_image"];
//    NSString * share_title = shareJSON[@"share_title"];
//    NSString * share_subtitle = shareJSON[@"share_subtitle"];
//    NSString * landingPageUrl = impAds.landingPageUrl;
//
//    __block UIImage *share_image;
//    NSLog(@"1`begin download");
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [UIImage mj_setImageWithURLString:share_image_url placeholderImage:nil success:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, UIImage * _Nullable image) {
//            NSLog(@"2`success");
//            share_image = image;
//            NSLog(@"3`wechat share");
//            [Tool wechatShare:^(KMJWechatShareStatus status) {
//                if (status == KMJWechatShareBeginState) {
//                    NSLog(@"KMJWechatShareBeginState...");
//                }else if(status == KMJWechatShareFailState && status == KMJWechatShareCancelState) {
//                    NSLog(@"分享失败");
//                    kMJAppsShowToastBlock(@"分享失败", NO);
//                }else if(status == KMJWechatShareSuccessState) {
//                    kMJAppsShowToastBlock(@"分享成功", NO);
//                    //曝光
//                    NSString *btnURL = impAds.apps.btnUrl;
//                    if (![MJExceptionReportManager validateAndExceptionReport:btnURL]) {
//                        kMJAppsShowToastBlock(@"wechat report url error", NO);
//                        return ;
//                    }
//                } else {
//                    NSAssert(NO, @"");
//                }
//                //title长度限制为512字节 description长度限制为1024字节
//            } title:share_title description:share_subtitle imagesArray:@[share_image] url:landingPageUrl];
//        } failure:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error) {
//        }];
//    });
}
@end
