//
//  UIImageView+placeholder.m
//  MJSDK-iOS
//
//  Created by WM on 16/7/7.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "UIImageView+placeholder.h"

#import "UIImageView+AFNetworking.h"
#import "MJImpAds.h"
#import "MJError.h"
#import "MJSDKConf.h"
#import "AFImageDownloader.h"
#import "MJExceptionReport.h"

#import "MJExceptionReportManager.h"

#import "UIImage+imageNamed.h"

@implementation UIImageView (placeholder)
- (void)mjCoupon_setImageWithURLString:(nullable NSString *)urlString
                      placeholderImage:(nullable NSString *)placeholderImage
                                impAds:(nullable MJImpAds *)impAds
                           retry_times:(NSInteger)retryTimes
                               success:(nullable void (^)(NSURLRequest *_Nullable request, NSHTTPURLResponse * _Nullable response, UIImage *_Nullable image))success
                               failure:(nullable void (^)(NSURLRequest *_Nullable request, NSHTTPURLResponse * _Nullable response, NSError *_Nullable error))failure {

    if (retryTimes <= 0) {
        MJError *mjerror = [MJError errorWithDomain:@"" code:kMJSDKERROROverRetryLoadImagesTimesFailure userInfo:@{}];
        if (failure) {
            failure(nil, nil, mjerror);
        }
        return;
    }
    retryTimes--;

    [self mj_setImageWithURLString:urlString placeholderImage:placeholderImage impAds:impAds success:nil failure:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error) {
        [self mjCoupon_setImageWithURLString:urlString placeholderImage:placeholderImage impAds:impAds retry_times:retryTimes success:nil failure:failure];
    }];
}
- (void)mj_setImageWithURLString:(NSString *)urlString
                placeholderImage:(NSString *)placeholderImage
                          impAds:(nullable MJImpAds *)impAds
                         success:(void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, UIImage *image))success
                         failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse * _Nullable response, NSError *error))failure {
    [self setImage:[UIImage mj_imageNamed:placeholderImage]];
    WEAKSELF
    urlString = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] <= 9) {
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    }
//    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
   
    if (![MJExceptionReportManager validateAndExceptionReport:urlString]) {
        MJError *mjerror = [MJError errorWithDomain:[NSString stringWithFormat:@"URL:%@ 异常", urlString] code:kMJSDKERRORURLFailure userInfo:@{}];
        NSLog(@"[imgView]缓存失败!:%@", mjerror);
        WEAKSELF
        [weakSelf setImage:[UIImage mj_imageNamed:placeholderImage]];
        impAds.isNormalLoaded = NO;
        if (failure) {
            failure(nil, nil, mjerror);
        }
        return;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    AFImageDownloader *imgDownloader = [AFImageDownloader defaultInstance];
    NSUUID *uuid = [[NSUUID alloc]initWithUUIDString:urlString];
    [imgDownloader downloadImageForURLRequest:request withReceiptID:uuid success:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, UIImage * _Nonnull responseObject) {
        NSLog(@"图片缓存成功!--->>URL:%@", urlString);
        if ([responseObject isKindOfClass:[UIImage class]] && responseObject) {
            [weakSelf setImage:responseObject];
        }
        impAds.isNormalLoaded = YES;
        if (success) {
            success(request, response, responseObject);
        }
    } failure:^(NSURLRequest * _Nonnull request, NSHTTPURLResponse * _Nullable response, NSError * _Nonnull error) {
        NSLog(@"[imgView]缓存失败!");
        WEAKSELF
        [weakSelf setImage:[UIImage mj_imageNamed:placeholderImage]];
        impAds.isNormalLoaded = NO;
        MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORImageCachedFailure description:[NSString stringWithFormat:@"[imgView]缓存失败, ERROR:%@", error]];
        [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
        if (failure) {
            failure(request, response, error);
        }
    }];
}

@end
