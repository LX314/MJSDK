//
//  MJToast.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/14.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJToast.h"

#import "MJSDKConfiguration.h"
#import "Colours.h"
#import "Masonry.h"

@interface MJToast ()
{
    UIView *_superView;
    NSTimeInterval _toastDelay;

}
/** <#注释#>*/
@property (nonatomic,retain)UILabel *label_toast;
/** <#注释#>*/
@property (nonatomic,retain)NSOperationQueue *toastQueue;

@end
@implementation MJToast
- (instancetype)init
{
    if (self = [super init]) {
        //
        _toastDelay = 0;
        [self initial];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //
        [self initial];
    }
    return self;
}
+ (instancetype)manager {
    static MJToast *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[[self class] alloc]init];
        _manager.layer.opacity = 0.f;
    });

    return _manager;
}

- (void)initial
{
    /**
     *初始化相关配置
     *
     //
     [self initial];
     */
    //
    [self setFrame:CGRectMake(0, 0, kMainScreen_width, 40.f)];
    [self setBackgroundColor:[UIColor colorFromHexString:@"#FF7700"]];
//    [self setAlpha:0.8f];
    //
    [self addSubview:self.label_toast];
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}
+ (void)show {
    return [[self manager]show];
}
+ (void)dismiss {
    return [[self manager]dismiss];
}
+ (void)removeAnimation {
    return [[self manager]removeAnimation];
}
- (void)show {
    [mjSuperview() addSubview:self];
//    [self showAnimation];
}
- (void)showIn:(UIView *)view {
    [view addSubview:self];
//    [self showAnimation];
}
- (void)dismiss {
    [self dismissAnimation];
}
+ (void)toast:(NSString *)toastString in:(UIView *)view {
    return [[MJToast manager] toast:toastString in:view];
}
- (void)toast:(NSString *)toastString in:(UIView *)view {
    if (![self superview]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            //
            [view addSubview:self];
        });

    }
    [self performSelector:@selector(toast:) withObject:toastString afterDelay:0];
    _toastDelay += 3.f;
}
- (void)toast:(NSString *)toastString {

    [self.label_toast setText:toastString];
    [self showAnimation];
    _toastDelay -= 2.f;
    if (_toastDelay < 0) {
        _toastDelay = 0.f;
    }
}
- (void)removeAnimation {
//    [self.layer removeAllAnimations];
    [self.layer removeAnimationForKey:@"show-position.y"];
    [self.layer removeAnimationForKey:@"show-opacity"];
    [self.layer removeAnimationForKey:@"dismiss-position.y"];
    [self.layer removeAnimationForKey:@"dismiss-opacity"];
}
- (void)showAnimation {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        CABasicAnimation *animShow = [CABasicAnimation animationWithKeyPath:@"position.y"];
        animShow.fromValue = @(-75.f);
        animShow.duration = 1.f;
        animShow.removedOnCompletion = NO;
        animShow.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animShow.fillMode = kCAFillModeForwards;
        [self.layer addAnimation:animShow forKey:@"show-position.y"];

        CABasicAnimation *animShow2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animShow2.fromValue = @0.f;
        animShow2.toValue = @1.f;
        animShow2.duration = 1.f;
        animShow2.removedOnCompletion = NO;
        animShow2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animShow2.fillMode = kCAFillModeForwards;
        [self.layer addAnimation:animShow2 forKey:@"show-opacity"];
    });

    //dispatch_after
    double delayInSeconds = 2.f;
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^{
        //Your code here...
        [weakSelf dismissAnimation];
    });


}
- (void)dismissAnimation {
    CABasicAnimation *animDismiss1 = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animDismiss1.toValue = @(-75.f);
    animDismiss1.duration = 0.75f;
    animDismiss1.removedOnCompletion = NO;
    animDismiss1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animDismiss1.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animDismiss1 forKey:@"dismiss-position.y"];

    CABasicAnimation *animDismiss2 = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animDismiss2.fromValue = @1.f;
    animDismiss2.toValue = @0.f;
    animDismiss2.duration = 0.75f;
    animDismiss2.removedOnCompletion = NO;
    animDismiss2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animDismiss2.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:animDismiss2 forKey:@"dismiss-opacity"];
}

#pragma mark -
#pragma mark - Masonry Methods
- (void)updateConstraints {
    [super updateConstraints];
    //
    [self masonry];
}
- (void)masonry
{//
    UIView *superView = self;
    //
    [self.label_toast mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.center.equalTo(superView);
    }];
}
#pragma mark - toastQueue
- (NSOperationQueue *)toastQueue
{
    if(!_toastQueue){
//        _toastQueue = [NSOperationQueue mainQueue];
        _toastQueue = [[NSOperationQueue alloc]init];
        _toastQueue.maxConcurrentOperationCount = 1;
    }

    return _toastQueue;
}

#pragma mark - label_toast
- (UILabel *)label_toast
{
    if(!_label_toast){
        //初始化一个 Label
        _label_toast = [[UILabel alloc]init];
        [_label_toast setFrame:CGRectZero];
        [_label_toast setText:@"已成功获取道具3333"];
        [_label_toast setBackgroundColor:[UIColor clearColor]];
        [_label_toast setTextColor:[UIColor whiteColor]];
        [_label_toast setTextAlignment:NSTextAlignmentCenter];
        [_label_toast setFont:[UIFont systemFontOfSize:14.f]];
    }
    return _label_toast;
}


@end
