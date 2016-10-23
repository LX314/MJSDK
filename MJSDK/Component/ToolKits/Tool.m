//
//  Tool.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/6.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "Tool.h"

#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

#import "WXApi.h"

#import "MJSDKConf.h"
#import "MJError.h"
#import "MJExceptionReport.h"

#import "MJExceptionReportManager.h"

@implementation Tool
+ (void)initWechatShare {
    //
    [ShareSDK registerApp:@"iosv1101" activePlatforms:@[
                                                        @(SSDKPlatformSubTypeWechatTimeline),
//                                                        @(SSDKPlatformTypeWechat),
                                                        ] onImport:^(SSDKPlatformType platformType) {
                                                            //
                                                            switch (platformType) {
                                                                case SSDKPlatformTypeWechat: {
                                                                    [ShareSDKConnector connectWeChat:[WXApi class]];
                                                                    break;
                                                                }
                                                                default: {
                                                                    NSLog(@"Unknown platform type");
                                                                    break;
                                                                }
                                                            }
                                                        } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                                            //
                                                            switch (platformType) {
                                                                case SSDKPlatformTypeWechat: {
                                                                    [appInfo SSDKSetupWeChatByAppId:MJWeChatAppID
                                                                                          appSecret:MJWeChatAppSecret];
                                                                    break;
                                                                }
                                                                default: {
                                                                    NSLog(@"Unknown platform type");
                                                                    break;
                                                                }
                                                            }
                                                        }];
}
+ (BOOL)hasWechatInstalled {
    if (![WXApi isWXAppInstalled]) {
        MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORUninstallWeichatClientFailure description:@"尚未安装微信客户端,无法分享~"];
        [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
        MJNSLog(@"errorcode:%ld",report.code);
        return NO;
    }
    return YES;
}
+ (void)wechatShare:(kMJWechatShareStatusBlock)status title:(NSString *)title description:(NSString *)description imagesArray:(NSArray<UIImage *> *)imagesArray url:(NSString *)url {
        //
//    NSString *title;
//    NSString *description;
//    NSArray *imagesArray;
//    NSString *url;
//    title = @"盟聚 - 移动社交广告一站式投放平台";
//    description = @"1`灵活的解决方案组合2`兼顾短期效果与长期价值";
////    url = @"http://mj.weimob.com/";
//    imagesArray = @[
//                      [UIImage imageNamed:@"8cf213a85edf8db10e56a9500a23dd54564e7419.png"]
//                   ];
    dispatch_async(dispatch_get_main_queue(), ^{
    NSMutableDictionary *shareDic = [NSMutableDictionary dictionary];
    [shareDic SSDKSetupShareParamsByText:description
                                  images:imagesArray
                                     url:[NSURL URLWithString:url]
                                   title:title
                                    type:SSDKContentTypeAuto];
    [ShareSDK showShareActionSheet:nil items:nil shareParams:shareDic onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateBegin: {
                NSLog(@"begin share...");
//                status(KMJWechatShareBeginState);
                break;
            }
            case SSDKResponseStateSuccess: {
                NSLog(@"share success...");
                if (status) {
                    status(KMJWechatShareSuccessState);
                }
                break;
            }
            case SSDKResponseStateFail: {
                NSLog(@"share failue...");
                if (status) {
                    status(KMJWechatShareFailState);
                }
                [self wechatReport:[NSString stringWithFormat:@"微信分享失败:SSDKResponseStateCancel"]];
                break;
            }
            case SSDKResponseStateCancel: {
                NSLog(@"cancel share...");
                if (status) {
                    status(KMJWechatShareCancelState);
                }
                [self wechatReport:[NSString stringWithFormat:@"微信分享失败:SSDKResponseStateCancel"]];
                break;
            }
            default: {
                NSAssert(NO, @"share error !!");
                break;
            }
        }
    }];
    });
}
+ (void)wechatReport:(NSString *)description {
    MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORWechatShareFailure description:description];
    [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
}
@end
