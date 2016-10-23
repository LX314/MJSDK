//
//  webViewController.h
//  MJSDK-iOS
//
//  Created by WM on 16/9/27.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ _Nullable kMJCompletionBlock)(void);
@interface MJWebView : UIViewController

@property(nonatomic, copy)kMJCompletionBlock completion;
@property (nullable, nonatomic,retain)UIViewController *parentVC;

- (void)requestUrl:(NSString *_Nullable)url;
- (void)presentWebView;

@end
