//
//  ADView.m
//  sdk-ADView
//
//  Created by John LXThyme on 4/22/16.
//  Copyright © 2016 John LXThyme. All rights reserved.
//

#import "MJView.h"


#import "MJFactory.h"
#import "LXLocationManager.h"
#import "MJGradientLayer.h"

@interface MJView ()
{
}

@property (nonatomic, readonly) CGFloat visibleKeyboardHeight;

@end
@implementation MJView
#pragma mark -
#pragma mark - Common Component
- (void)baseInitial{
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
        //注册通知
        [self registerNotifications];
        //启动定位系统
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self getLocation];
        });
        [self initial];
}
- (void)initial{
    [self setBackgroundColor:[UIColor whiteColor]];
}
- (void)getLocation{
    [LXLocationManager getMyLocation];
}
- (void)registerNotifications {
#if TARGET_OS_IOS
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(baseMJReset:)
//                                                 name:UIApplicationDidChangeStatusBarOrientationNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(baseMJReset:)
//                                                 name:UIApplicationDidChangeStatusBarFrameNotification
//                                               object:nil];

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(mjreset:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(mjreset:)
//                                                 name:UIKeyboardDidHideNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(mjreset:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(mjreset:)
//                                                 name:UIKeyboardDidShowNotification
//                                               object:nil];
#endif
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(mjreset:)
//                                                 name:UIApplicationDidBecomeActiveNotification
//                                               object:nil];
}
- (void)baseMJReset:(NSNotification *)notification {
//    NSLog(@"notification:%@",notification.debugDescription);
    if (!self.isShow) {
        return;
    }
//    return;
    BOOL canGoOn = YES;
    if ([notification.name isEqualToString:UIApplicationDidChangeStatusBarOrientationNotification]) {
        UIDeviceOrientation currentOrientation = [UIDevice currentDevice].orientation;
        if (currentOrientation == UIDeviceOrientationPortrait || currentOrientation == UIDeviceOrientationPortraitUpsideDown) {
        } else if (currentOrientation == UIDeviceOrientationLandscapeLeft || currentOrientation == UIDeviceOrientationLandscapeRight) {
        } else {
            canGoOn = NO;
            NSAssert(NO, @"Device Orientation Error!");
            return;
        }
        if (self.kMJOrientation == currentOrientation) {
            return;
        }
        self.kMJOrientation = currentOrientation;
        [self mjreset];
        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];
//        [self masonry];
        return;
    }
    
    if (!canGoOn) {
        return;
    }
    
    if ([notification.name isEqualToString:UIApplicationDidChangeStatusBarFrameNotification]) {
        CGRect rect = [notification.userInfo[UIApplicationStatusBarFrameUserInfoKey] CGRectValue];
        [self getSystemTopHeight:rect];
        
        return;
    }
}
- (CGFloat)getSystemTopHeight:(CGRect)rect {
    systemHeight = CGRectGetHeight(rect);
    return systemHeight;
}
- (void)mjreset{
}
- (void)positionHUD:(NSNotification*)notification{
    
    CGFloat keyboardHeight = 0.0f;
    double animationDuration = 0.0;
    
    
#if TARGET_OS_IOS
    self.frame = [[[UIApplication sharedApplication] delegate] window].bounds;
    UIInterfaceOrientation orientation = UIApplication.sharedApplication.statusBarOrientation;
#endif
    BOOL ignoreOrientation = NO;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if([[NSProcessInfo processInfo] respondsToSelector:@selector(operatingSystemVersion)]) {
        ignoreOrientation = YES;
    }
#endif
    
#if TARGET_OS_IOS
    // Get keyboardHeight in regards to current state
    if(notification) {
        
        NSDictionary* keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [keyboardInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        animationDuration = [keyboardInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        if(notification.name == UIKeyboardWillShowNotification || notification.name == UIKeyboardDidShowNotification) {
            keyboardHeight = CGRectGetWidth(keyboardFrame);
            
            if(ignoreOrientation || UIInterfaceOrientationIsPortrait(orientation)) {
                keyboardHeight = CGRectGetHeight(keyboardFrame);
            }
        }
    } else {
        
        keyboardHeight = self.visibleKeyboardHeight;
    }
    
#endif
    
    
    
//    [self updateMask];
}
- (void)updateMask {
    
    if(self.backgroundLayer) {
        
        [self.backgroundLayer removeFromSuperlayer];
        self.backgroundLayer = nil;
        
    }
    
    switch (self.defaultMaskType) {
            
        case LXMJViewMaskTypeCustom:
        case LXMJViewMaskTypeBlack:{
            
            self.backgroundLayer = [CALayer layer];
            self.backgroundLayer.frame = self.bounds;
            self.backgroundLayer.backgroundColor = self.defaultMaskType == LXMJViewMaskTypeCustom ? self.backgroundLayerColor.CGColor : [UIColor colorWithWhite:0 alpha:0.4].CGColor;
            [self.backgroundLayer setNeedsDisplay];
            
            [self.layer insertSublayer:self.backgroundLayer atIndex:0];
            break;
        }
            
        case LXMJViewMaskTypeGradient:{
            MJGradientLayer *layer = [MJGradientLayer layer];
            self.backgroundLayer = layer;
            self.backgroundLayer.frame = self.bounds;
            CGPoint gradientCenter = self.center;
            gradientCenter.y = (self.bounds.size.height - 0)/2;//self.visibleKeyboardHeight
            layer.gradientCenter = gradientCenter;
            [self.backgroundLayer setNeedsDisplay];
            
            [self.layer insertSublayer:self.backgroundLayer atIndex:0];
            break;
        }
        default:{
            [self setUserInteractionEnabled:NO];
            break;
        }
    }
}
- (CGFloat)visibleKeyboardHeight {
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIPeripheralHostView")] || [possibleKeyboard isKindOfClass:NSClassFromString(@"UIKeyboard")]) {
            return CGRectGetHeight(possibleKeyboard.bounds);
        } else if([possibleKeyboard isKindOfClass:NSClassFromString(@"UIInputSetContainerView")]) {
            for (__strong UIView *possibleKeyboardSubview in [possibleKeyboard subviews]) {
                if([possibleKeyboardSubview isKindOfClass:NSClassFromString(@"UIInputSetHostView")]) {
                    return CGRectGetHeight(possibleKeyboardSubview.bounds);
                }
            }
        }
    }
    return 0;
}


#pragma mark -
#pragma mark - Masonry Methods
//- (void)updateConstraints {
//    [super updateConstraints];
//    //
//    [self masonry];
//}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - kMJOrientation
- (UIDeviceOrientation)kMJOrientation
{
    if(_kMJOrientation == UIDeviceOrientationUnknown){
        _kMJOrientation = UIDeviceOrientationPortrait;
    }
    
    return _kMJOrientation;
}
#pragma mark - btnClose
- (UIButton *)btnClose
{
    if(!_btnClose){
        
        _btnClose = [MJFactory MJADClose];
        //绑定事件
        [_btnClose addTarget:self action:@selector(btnCloseClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btnClose;
}
- (void)btnCloseClick:(id)sender
{
//        UIButton *btn = (UIButton *)sender;
    //
    self.isShow = NO;
    [self removeFromSuperview];
//    [[NSNotificationCenter defaultCenter]postNotificationName:kMJSDKDidBannerClosedNotification object:self];
}
#pragma mark - mjLabADLogo
- (UILabel *)mjLabADLogo
{
    if(!_mjLabADLogo){
        _mjLabADLogo = [MJFactory MJADLogoLab];
        
    }
    
    return _mjLabADLogo;
}
@end
