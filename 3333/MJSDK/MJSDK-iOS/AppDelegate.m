//
//  AppDelegate.m
//  MJSDK-iOS
//
//  Created by WM on 16/6/13.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

//#import "MJFullOpenScreen.h"
//#import "MJHalfOpenScreen.h"

#import "MJSDKUtils.h"

//#define kMJFullOpenScreen YES

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "Tool.h"

#import <AFNetworkReachabilityManager.h>

#import <Branch.h>

@interface AppDelegate ()//<WXApiDelegate>



@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Override point for customization after application launch.
    //
//    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
//    [self.window setBackgroundColor:[UIColor whiteColor]];
//    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    ViewController *vc = [main instantiateViewControllerWithIdentifier:@"VC_T"];
//    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
//    nav.navigationBar.translucent = NO;
//    self.window.rootViewController = nav;
    
//#ifdef kMJFullOpenScreen
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        MJFullOpenScreen *fullScreenManager = [MJFullOpenScreen manager];
//        [fullScreenManager show];
//    });
//#else
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0005 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        MJHalfOpenScreen *halfScreenManager = [MJHalfOpenScreen manager];
//        [halfScreenManager show];
//    });
//#endif
    [Tool initWechatShare];
    [Fabric with:@[[Crashlytics class]]];
//    [WXApi registerApp:@"wxfec3a696d78c42a5"];
    


//    [[AFNetworkReachabilityManager manager]startMonitoring];
//    AFNetworkReachabilityManager *manager =
//    [AFNetworkReachabilityManager managerForDomain:@"http://www.baidu.com"];
//    [AFNetworkReachabilityManager sharedManager];
//    [manager startMonitoring];
//    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        //
//        NSLog(@"status---:%ld", status);
//    }];

    [MJSDKUtils registerWithAPPKey:@"9f9bac4d-860d-11e6-8c73-a4dcbef43d46"];
    [MJSDKUtils openDebugLog];
    [MJSDKUtils openPreloadStyle];
//    [self.window makeKeyAndVisible];

//    Branch *branch = [Branch getInstance];
//    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error) {
//        if (!error && params) {
//            // params are the deep linked params associated with the link that the user clicked -> was re-directed to this app
//            // params will be empty if no data found
//            // ... insert custom logic here ...
//            NSLog(@"params: %@", params.description);
//        }
//    }];

    return YES;
}
// Respond to URI scheme links
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"URL:%@", url);
    // pass the url to the handle deep link call
//    [[Branch getInstance] handleDeepLink:url];

    // do other deep link routing for the Facebook SDK, Pinterest SDK, etc
    
    return YES;
}

// Respond to Universal Links
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray *restorableObjects))restorationHandler {
//    if (userActivity.activityType == NSUserActivityTypeBrowsingWeb) {
//        NSURL *webpageURL =  userActivity.webpageURL;
//        if (![self handleUniversalLink:webpageURL]) {
//            [[UIApplication sharedApplication] openURL:webpageURL];
//        }
//    }
    NSLog(@"URL:%@", userActivity);
    BOOL handledByBranch = [[Branch getInstance] continueUserActivity:userActivity];
//
    return handledByBranch;
}
- (BOOL)handleUniversalLink:(NSURL *)url {
//    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:true];
//    NSString *host = components.host;
//    NSString *pathComponents = components.path;
    return YES;
}
//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    //处理链接
//    NSString *text = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Other app link" message:url.description delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//    [myAlert show];
//    
//    return YES;
//}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
//{
//    // 监听linePay付款完后wap界面跳转
//    NSString *text = [[url host] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    UIAlertView *myAlert = [[UIAlertView alloc]initWithTitle:@"Other app link" message:url.description delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
//    [myAlert show];
//    return YES;
//}
//
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    self.url = [url absoluteString];
    ViewController *vc = (ViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    [vc gotoURL];
    return YES;
}

//- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//}
//
//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
//}
//- (void)onResp:(BaseResp *)resp {
//
//    //把返回的类型转换成与发送时相对于的返回类型,这里为SendMessageToWXResp
//    SendMessageToWXResp *sendResp = (SendMessageToWXResp *)resp;
//
//    //使用UIAlertView 显示回调信息
//    NSString *str = [NSString stringWithFormat:@"%ld",sendResp.errCode];
//    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"回调信息" message:str delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
//    [alertview show];
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//- (UIInterfaceOrientationMask)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
//{
//    
//    return UIInterfaceOrientationMaskPortrait;
//}


@end



