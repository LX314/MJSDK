//
//  MJToast.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/14.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJToast : UIView
{

}

+ (instancetype)manager;

+ (void)show;
+ (void)dismiss;
+ (void)removeAnimation;

- (void)show;
- (void)showIn:(UIView *)view;
- (void)dismiss;
- (void)removeAnimation;

+ (void)toast:(NSString *)toastString in:(UIView *)view;
- (void)toast:(NSString *)toastString in:(UIView *)view;

@end
