//
//  Tool.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/6.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "Tool.h"

#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDKUI.h>
//#import <ShareSDKConnector/ShareSDKConnector.h>

#import "WXApi.h"

#import "MJSDKConf.h"
#import "MJError.h"

#import "MJExceptionReportManager.h"

@implementation Tool
+ (void)initWechatShare {
    //
    [ShareSDK registerApp:@""];
    [ShareSDK connectWeChatSessionWithAppId:MJWeChatAppID appSecret:MJWeChatAppSecret wechatCls:[WXApi class]];
//    [ShareSDK registerApp:@"iosv1101" activePlatforms:@[
//                                                        @(SSDKPlatformSubTypeWechatTimeline),
////                                                        @(SSDKPlatformTypeWechat),
//                                                        ] onImport:^(SSDKPlatformType platformType) {
//                                                            //
//                                                            switch (platformType) {
//                                                                case SSDKPlatformTypeWechat: {
//                                                                    [ShareSDKConnector connectWeChat:[WXApi class]];
//                                                                    break;
//                                                                }
//                                                                default: {
//                                                                    NSLog(@"Unknown platform type");
//                                                                    break;
//                                                                }
//                                                            }
//                                                        } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
//                                                            //
//                                                            switch (platformType) {
//                                                                case SSDKPlatformTypeWechat: {
//                                                                    [appInfo SSDKSetupWeChatByAppId:MJWeChatAppID
//                                                                                          appSecret:MJWeChatAppSecret];
//                                                                    break;
//                                                                }
//                                                                default: {
//                                                                    NSLog(@"Unknown platform type");
//                                                                    break;
//                                                                }
//                                                            }
//                                                        }];
}
+ (void)wechatShare:(kMJWechatShareStatusBlock)status title:(NSString *)title description:(NSString *)description imagesArray:(NSArray<UIImage *> *)imagesArray url:(NSString *)url viewController:(UIViewController *)vc_t {
        //
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];

    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.mob.com"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建iPad弹出菜单容器,详见第六步
    id<ISSContainer> container = [ShareSDK container];
    [container setIPhoneContainerWithViewController:vc_t];

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {

                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
//    NSString *title;
//    NSString *description;
//    NSArray *imagesArray;
//    NSString *url;
//    title = @"盟聚 - 移动社交广告一站式投放平台";
//    description = @"1`灵活的解决方案组合2`兼顾短期效果与长期价值";
////    url = @"http://mj.weimob.com/";
//    imagesArray = @[
//                          [UIImage imageNamed:@"8cf213a85edf8db10e56a9500a23dd54564e7419.png"]
//                          ];
//    dispatch_async(dispatch_get_main_queue(), ^{
//    NSMutableDictionary *shareDic = [NSMutableDictionary dictionary];
//    [shareDic SSDKSetupShareParamsByText:description
//                                  images:imagesArray
//                                     url:[NSURL URLWithString:url]
//                                   title:title
//                                    type:SSDKContentTypeAuto];
//    [ShareSDK showShareActionSheet:nil items:nil shareParams:shareDic onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//        //
//        switch (state) {
//            case SSDKResponseStateBegin: {
//                status(KMJWechatShareBeginState);
//                NSLog(@"begin share...");
//                break;
//            }
//            case SSDKResponseStateSuccess: {
//                status(KMJWechatShareSuccessState);
//                NSLog(@"share success...");
//                break;
//            }
//            case SSDKResponseStateFail: {
//                status(KMJWechatShareFailState);
//                NSLog(@"share failue...");
//                [self wechatReport:[NSString stringWithFormat:@"微信分享失败:SSDKResponseStateCancel"]];
//                break;
//            }
//            case SSDKResponseStateCancel: {
//                status(KMJWechatShareCancelState);
//                NSLog(@"cancel share...");
//                [self wechatReport:[NSString stringWithFormat:@"微信分享失败:SSDKResponseStateCancel"]];
//                break;
//            }
//            default: {
//                NSAssert(NO, @"share error !!");
//                break;
//            }
//        }
//    }];
//    });
}
+ (void)wechatReport:(NSString *)description {
    MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORWechatShareFailure description:description];
    [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
}
@end
