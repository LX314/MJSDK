//
//  MJShare.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/20.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJShare.h"

#import "MJShareFirst.h"
#import "MJShareThird.h"
#import "MJShareFifth.h"
#import "MJShareSixth.h"
#import "MJRecommend.h"
#import "MJToast.h"
#import "MJTool.h"


@interface MJShare ()
{
    
    NSArray *_arrayAllSteps;
    BOOL  _isGoodReport;
}
@property (nonatomic,retain)UIButton *btn_close;
/** <#注释#>*/
@property (nonatomic,retain)UIView *mjShare;
@property (nonatomic,retain)UIView *mjHeader;
@property (nonatomic,retain)UIView *mjContent;
/** <#注释#>*/
@property (nonatomic,retain)UIImageView *imgView_headerlogo;


@property (nonatomic,retain)UIImageView *imgView_middleView;

/** <#注释#>*/
@property (nonatomic,retain)MJRecommend *mjRecommend;


@end
@implementation MJShare
- (instancetype)init {
    if (self = [super init]) {
        //
        [self setUp];
        [self setBackgroundColor:[UIColor clearColor]];
        [self initialAllSteps];
    }
    return self;
}

- (void)initialAllSteps {
    MJShareFirst *_firstStep = [[MJShareFirst alloc]init];
    MJShareSecond *_secondStep = [[MJShareSecond alloc]init];
    MJShareThird *_thirdStep = [[MJShareThird alloc]init];
    MJShareFourth *_fourthStep = [[MJShareFourth alloc]init];
    MJShareFifth *_fifthStep = [[MJShareFifth alloc]init];
    MJShareSixth *_sixthStep = [[MJShareSixth alloc]init];
    _arrayAllSteps = @[_firstStep, _secondStep, _thirdStep, _fourthStep, _fifthStep, _sixthStep];
}
- (void)setUp {
    
    [self.mjHeader addSubview:self.btn_close];
    [self.mjHeader addSubview:self.imgView_headerlogo];
    
    [self.mjShare addSubview:self.mjHeader];
    [self.mjShare addSubview:self.imgView_middleView];
    [self.mjShare addSubview:self.mjContent];
    
    [self.mjContent addSubview:self.mjRecommend];
    
    [self addSubview:self.mjShare];
    
    MASAttachKeys(self.btn_close, self.imgView_headerlogo, self.mjHeader, self.mjContent, self.mjRecommend, self.mjShare,self.imgView_middleView);

    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
//    [self masonry];
    //
    self.defaultMaskType = LXMJViewMaskTypeGradient;
    [MJTool updateMask:LXMJViewMaskTypeGradient selfView:self layer:self.backgroundLayer color:self.backgroundLayerColor];
    //
//    [self modifyBlock];
//    [self gotoStepBlock];
}
- (void)show {
    
    [self queryCouponsInfo];
}
- (void)showIn:(MJAppsManager *)appsManager {
    NSString *warnings = [NSString stringWithFormat:@"MJShare must be show in MJAppsManager class, and you 'appsManager' is %@ class", [appsManager class]];
    NSAssert([appsManager isKindOfClass:[MJAppsManager class]] || !appsManager, warnings);
    self.appsManager = appsManager;
    [self queryCouponsInfo];
}
//- (void)modifyBlock {
//    kModifyBlock = ^(KMJShareStep step) {
//
//    };
//
//}
//- (void)gotoStepBlock {
//    __weak typeof(self) weakSelf = self;
//    kGotoStepBlockBlock = ^(KMJShareStep step){
//        static MJBaseShareContent *lastShareContent = nil;
//        MJBaseShareContent *shareContent = _arrayAllSteps[step - 1];
//        if (lastShareContent) {
//            [lastShareContent removeFromSuperview];
//            lastShareContent = nil;
//        }
//        if (![self superview]) {
//            [mjSuperview() addSubview:self];
//            [self masonrySelf];
//        }
//        NSString *step_info = NSStringFromClass([shareContent class]);
//        NSLog(@"%@", step_info);
//        [[MJToast manager]showIn:self];
//        lastShareContent = shareContent;
//        shareContent.currentStep = step;
//        shareContent.mjShare = self;
//        _isGoodReport = NO;
//        [self.mjRecommend isReport:_isGoodReport];
//        [shareContent fill:_params];
//        [weakSelf.mjHeader addSubview:shareContent];
//    };
//}

/**
 *  @brief 查券
 */
- (void)queryCouponsInfo {
    MJCouponManager *manager = [MJCouponManager manager];

    __weak typeof(self) weakSelf = self;
    [manager loadQuery:^(NSDictionary *params) {
        //1`
        [weakSelf fill:params];
        NSLog(@"%@",params);
        //2`
        BOOL hasRegistered = [params[@"registered"] boolValue];
        NSDictionary *coupons_info = params[@"coupons_info"];
        BOOL hasDefault = [coupons_info[@"coupons_status"] boolValue];
        BOOL hasNew = [coupons_info[@"coupons_status"] boolValue];
        NSInteger usable_coupons_num = [params[@"usable_coupons_num"] integerValue];

        if (!hasRegistered && !hasDefault) {//新用户+无默认券
            NSString *info = @"[1`新用户+无默认券]道具已经领取过";
            NSLog(@"%@",info);
            [MJToast toast:@"道具已经领取过" in:self];
            return ;
        }
        if (!hasRegistered && hasDefault) {//新用户 + 有默认券
            //1`领券
            NSString *info = @"[2`新用户 + 有默认券]";
            NSLog(@"%@",info);
            self.mjGotoStepBlockBlock(KMJShareFirstStep);//firstStep
            return ;
        }
        if (hasRegistered && usable_coupons_num == 0) {//老用户 + 已有0券
            NSString *info = @"[3`老用户 + 已有0券]";
            NSLog(@"%@",info);
            if (hasNew) {
                NSString *info = @"[有新券]";
                NSLog(@"%@",info);
                self.mjGotoStepBlockBlock(KMJShareFifthStep);//fifthStep
            } else {
                [MJToast toast:@"道具已经领取过" in:self];//老用户，已有券0，无新券
                NSLog(@"[无新券]");
            }
            return;
        } else if(hasRegistered && usable_coupons_num > 0) {//老用户 + 已有>=1券
            NSString *info = @"[4`老用户 + 已有>=1券]";
            NSLog(@"%@",info);

            if (hasNew) {
                NSString *info = @"[有新券]";
                NSLog(@"%@",info);
                self.mjGotoStepBlockBlock(KMJShareFourthStep);//fourthStep
            } else {
                NSString *info = @"[无新券]";
                NSLog(@"%@",info);
                self.mjGotoStepBlockBlock(KMJShareSixthStep);//sixthStep
            }
            return;
        }
        NSAssert(NO, @"ERROR");
    }];
}

- (void)fill:(NSDictionary *)params {
    _params = params;
    [self.mjRecommend fill:params];
}
#pragma mark - mjModifyBlock
- (kMJModifyBlock)mjModifyBlock
{
    if(!_mjModifyBlock){
        _mjModifyBlock = ^(KMJShareStep step) {

        };
    }

    return _mjModifyBlock;
}

#pragma mark - mjGotoStepBlockBlock
- (kMJGotoStepBlockBlock)mjGotoStepBlockBlock
{
    WEAKSELF
    if(!_mjGotoStepBlockBlock){
        _mjGotoStepBlockBlock = ^(KMJShareStep step){
            static MJBaseShareContent *lastShareContent = nil;
            MJBaseShareContent *shareContent = _arrayAllSteps[step - 1];
            if (lastShareContent) {
                [lastShareContent removeFromSuperview];
                lastShareContent = nil;
            }
            if (![self superview]) {
                [mjSuperview() addSubview:self];
                [self masonrySelf];
            }
            NSString *step_info = NSStringFromClass([shareContent class]);
            NSLog(@"%@", step_info);
            [[MJToast manager]showIn:self];
            lastShareContent = shareContent;
            shareContent.currentStep = step;
            shareContent.mjShare = self;
            _isGoodReport = NO;
            [self.mjRecommend isReport:_isGoodReport];
            [shareContent fill:_params];
            [weakSelf.mjHeader addSubview:shareContent];
        };

    }

    return _mjGotoStepBlockBlock;
}

#pragma mark -
#pragma mark - Masonry Methods
- (void)updateConstraints {
    [super updateConstraints];
    //
    [self masonry];
}
- (void)masonrySelf
{
    UIView *superView = [self superview];
    //
    [self mas_makeConstraints:^(MASConstraintMaker *make) {

        make.edges.equalTo(superView);
    }];
}

- (void)masonry
{//
    UIView *superView = self.mjShare;
    [self.mjShare mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(275.f, 385.f));
    }];
    
    [self.btn_close mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mjHeader.mas_top).offset(5);
        make.right.equalTo(self.mjHeader.mas_right).offset(-5);
        
    }];
    
    [self.imgView_headerlogo mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mjHeader).offset(20.f);
        make.centerX.equalTo(self.mjHeader);
    }];
    
    [self.mjHeader mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.left.right.equalTo(superView);
        make.height.equalTo(@228.f);
    }];
    
    [self.imgView_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mjHeader.mas_bottom);
        make.right.equalTo(self.mjHeader.mas_right);
    }];

    [self.mjContent mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.imgView_middleView.mas_bottom);
        make.left.right.equalTo(superView);
        make.height.equalTo(@141.f);
    }];

    [self.mjRecommend mas_makeConstraints:^(MASConstraintMaker *make) {

        make.top.equalTo(self.mjContent);
        make.left.bottom.right.equalTo(superView);
        make.height.equalTo(self.mjContent.mas_height);
    }];
    
  
}
#pragma mark - mjShare
- (UIView *)mjShare
{
    if(!_mjShare){
        _mjShare = [[UIView alloc]init];
        
    }
    
    return _mjShare;
}

#pragma mark - imgView_headerlogo
- (UIImageView *)imgView_headerlogo
{
    if(!_imgView_headerlogo){
        
        _imgView_headerlogo = [[UIImageView alloc]init];
        [_imgView_headerlogo setImage:[UIImage imageNamed:@"分享已完成"]];
    }

    return _imgView_headerlogo;
}
#pragma mark - mjHeader
- (UIView *)mjHeader
{
    if(!_mjHeader){
        
        _mjHeader = [[UIView alloc]init];
        
        UIGraphicsBeginImageContext(CGSizeMake(275.f, 228.f));
        [[UIImage imageNamed:@"背景_01"] drawInRect:CGRectMake(0, 0, 275.f, 228.f)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _mjHeader.backgroundColor = [UIColor colorWithPatternImage:image];
        
        [_mjHeader setUserInteractionEnabled:YES];
    }
    
    return _mjHeader;
}


#pragma mark - mjContent
- (UIView *)mjContent
{
    if(!_mjContent){
        _mjContent = [[UIView alloc]init];
        
        UIGraphicsBeginImageContext(CGSizeMake(275.f, 175.f));
        [[UIImage imageNamed:@"背景_03"] drawInRect:CGRectMake(0, 0, 275.f, 175.f)];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        _mjContent.backgroundColor = [UIColor colorWithPatternImage:image];
    }
    
    return _mjContent;
}

#pragma mark - middle_imgView
- (UIImageView *)imgView_middleView {

    if (!_imgView_middleView) {
        _imgView_middleView = [[UIImageView alloc]init];
        [_imgView_middleView setImage:[UIImage imageNamed:@"背景_02"]];

    }

    return _imgView_middleView;

}
#pragma mark - btn_close
- (UIButton *)btn_close
{
    if(!_btn_close){
        
        //初始化一个 Button
        _btn_close = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_close setFrame:CGRectZero];
        [_btn_close setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        //绑定事件
        [_btn_close addTarget:self action:@selector(btnClose:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btn_close;
}
- (void)btnClose:(id)sender
{
    if (self.appsManager) {
        [self.appsManager dismiss];
    }
    [MJToast removeAnimation];
    [self removeFromSuperview];
}

#pragma mark - mjRecommend
- (MJRecommend *)mjRecommend
{
    if(!_mjRecommend){
        _mjRecommend = [[MJRecommend alloc]init];
    }

    return _mjRecommend;
}

@end
