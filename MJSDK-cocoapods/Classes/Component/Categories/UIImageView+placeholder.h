//
//  UIImageView+placeholder.h
//  MJSDK-iOS
//
//  Created by WM on 16/7/7.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJImpAds.h"

@interface UIImageView (placeholder)

- (void)mj_setImageWithURLString:(nullable NSString *)urlString
                placeholderImage:(nullable UIImage *)placeholderImage
                          impAds:(nullable MJImpAds *)impAds
                         success:(nullable void (^)(NSURLRequest *_Nullable request, NSHTTPURLResponse * _Nullable response, UIImage *_Nullable image))success
                         failure:(nullable void (^)(NSURLRequest *_Nullable request, NSHTTPURLResponse * _Nullable response, NSError *_Nullable error))failure;

- (void)mjCoupon_setImageWithURLString:(nullable NSString *)urlString
                      placeholderImage:(nullable UIImage *)placeholderImage
                                impAds:(nullable MJImpAds *)impAds
                           retry_times:(NSInteger)retryTimes
                               success:(nullable void (^)(NSURLRequest *_Nullable request, NSHTTPURLResponse * _Nullable response, UIImage *_Nullable image))success
                               failure:(nullable void (^)(NSURLRequest *_Nullable request, NSHTTPURLResponse * _Nullable response, NSError *_Nullable error))failure;

@end
