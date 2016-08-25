//
//  FactoryHelper.m
//  RESideMenu
//
//  Created by FairyLand on 15/9/16.
//  Copyright (c) 2015年 fulan. All rights reserved.
//

#import "FactoryHelper.h"

#import "Colours.h"
//#import "LXButton.h"

@implementation FactoryHelper


#pragma mark -
#pragma mark - UIButton
+ (UIButton *)lx_ButtonWithFrame:(CGRect)frame clickBlock:(void(^)(id sender))clickBlock
{
    return [FactoryHelper lx_ButtonWithType:UIButtonTypeCustom frame:frame bgColor:[UIColor fuschiaColor] normalTitle:@"lx.Button" highlightedTitle:nil normalTitleColor:nil highlightedTitleColor:nil normalBGImage:nil highlightedBGImage:nil tag:0 clickBlock:clickBlock];
}
+ (UIButton *)lx_ButtonWithFrame:(CGRect)frame normalTitle:(NSString *)normalTitle clickBlock:(void(^)(id sender))clickBlock
{
    return [FactoryHelper lx_ButtonWithType:UIButtonTypeCustom frame:frame bgColor:[UIColor fuschiaColor] normalTitle:normalTitle highlightedTitle:nil normalTitleColor:nil highlightedTitleColor:nil normalBGImage:nil highlightedBGImage:nil tag:0 clickBlock:clickBlock];
}
+ (UIButton *)lx_ButtonWithType:(UIButtonType)type frame:(CGRect)frame bgColor:(UIColor *)bgColor normalTitle:(NSString *)normalTitle clickBlock:(void(^)(id sender))clickBlock
{
    return [FactoryHelper lx_ButtonWithType:type frame:frame bgColor:bgColor normalTitle:normalTitle highlightedTitle:nil normalTitleColor:nil highlightedTitleColor:nil normalBGImage:nil highlightedBGImage:nil tag:0 clickBlock:clickBlock];
}
+ (UIButton *)lx_ButtonWithType:(UIButtonType)type frame:(CGRect)frame bgColor:(UIColor *)bgColor normalTitle:(NSString *)normalTitle highlightedTitle:(NSString *)highlightedTitle normalTitleColor:(UIColor *)normalTitleColor highlightedTitleColor:(UIColor *)highlightedTitleColor normalBGImage:(UIImage *)normalBGImage highlightedBGImage:(UIImage *)highlightedBGImage tag:(NSInteger)tag clickBlock:(void(^)(id sender))clickBlock
{
    //初始化一个 Button
    UIButton *btn = [UIButton buttonWithType:type];
    
    [btn setFrame:frame];
    [btn setBackgroundColor:bgColor];
    
    //标题
    [btn setTitle:normalTitle forState:UIControlStateNormal];
    [btn setTitle:highlightedTitle forState:UIControlStateHighlighted];
    
    //标题颜色
    [btn setTitleColor:normalTitleColor forState:UIControlStateNormal];
    [btn setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
    
    //背景图片
    [btn setBackgroundImage:normalBGImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highlightedBGImage forState:UIControlStateHighlighted];
    
    //绑定事件
//    [btn LX_addEventHandler:^(id sender) {
//        if (clickBlock) {
//            clickBlock(sender);
//        }
//    } forControlEvents:UIControlEventTouchUpInside];

    [btn setTag:tag];
    
    return btn;
}
@end
