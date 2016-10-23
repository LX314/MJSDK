//
//  UIImage+cached.m
//  MJSDK-iOS
//
//  Created by WM on 16/8/2.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "UIImage+cached.h"

#import <AFImageDownloader.h>
#import "MJError.h"
#import "MJSDKConf.h"
#import "MJExceptionReportManager.h"
#import "MJExceptionReport.h"

@implementation UIImage (cached)
+ (AFImageDownloadReceipt *_Nullable)mj_setImageWithURLString:(NSString *_Nonnull)urlString
                                             placeholderImage:(nullable UIImage *)placeholderImage
                                                      success:(void(^_Nullable)(NSURLRequest *_Nullable request, NSHTTPURLResponse * _Nullable response, UIImage *_Nullable image))success
                                                      failure:(void(^_Nullable)(NSURLRequest *_Nullable request, NSHTTPURLResponse * _Nullable response, NSError *_Nullable error))failure {
    urlString = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    AFImageDownloader *imgDownloader = [AFImageDownloader defaultInstance];
//    NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:urlString];
    AFImageDownloadReceipt *receipt = [imgDownloader downloadImageForURLRequest:request success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
        NSLog(@"缓存成功!--->>URL:%@", urlString);
        if (success) {
            success(request, response, responseObject);
        }
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"[img]缓存失败,开始上报!");
        MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORImageCachedFailure description:[NSString stringWithFormat:@"[img]缓存失败, ERROR:%@", error]];
        [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
        if (failure) {
            failure(request, response, error);
        }
    }];
    return receipt;
}
@end
