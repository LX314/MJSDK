//
//  UIImage+cached.h
//  MJSDK-iOS
//
//  Created by WM on 16/8/2.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJImpAds.h"
#import "AFImageDownloader.h"

@interface UIImage (cached)

+ (AFImageDownloadReceipt *_Nullable)mj_setImageWithURLString:(NSString *_Nonnull)urlString
                                    placeholderImage:(nullable UIImage *)placeholderImage
                                             success:(void(^_Nullable)(NSURLRequest *_Nullable request, NSHTTPURLResponse * _Nullable response, UIImage *_Nullable image))success
                                             failure:(void(^_Nullable)(NSURLRequest *_Nullable request, NSHTTPURLResponse * _Nullable response, NSError *_Nullable error))failure;
@end
