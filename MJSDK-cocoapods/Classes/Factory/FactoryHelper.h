//
//  FactoryHelper.h
//  RESideMenu
//
//  Created by FairyLand on 15/9/16.
//  Copyright (c) 2015年 fulan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface FactoryHelper : NSObject
{
    
}


#pragma mark -
#pragma mark - UIButton
+ (UIButton *)lx_ButtonWithFrame:(CGRect)frame clickBlock:(void(^)(id sender))clickBlock;
+ (UIButton *)lx_ButtonWithFrame:(CGRect)frame normalTitle:(NSString *)normalTitle clickBlock:(void(^)(id sender))clickBlock;
+ (UIButton *)lx_ButtonWithType:(UIButtonType)type frame:(CGRect)frame bgColor:(UIColor *)bgColor normalTitle:(NSString *)normalTitle clickBlock:(void(^)(id sender))clickBlock;
+ (UIButton *)lx_ButtonWithType:(UIButtonType)type frame:(CGRect)frame bgColor:(UIColor *)bgColor normalTitle:(NSString *)normalTitle highlightedTitle:(NSString *)highlightedTitle normalTitleColor:(UIColor *)normalTitleColor highlightedTitleColor:(UIColor *)highlightedTitleColor normalBGImage:(UIImage *)normalBGImage highlightedBGImage:(UIImage *)highlightedBGImage tag:(NSInteger)tag clickBlock:(void(^)(id sender))clickBlock;

@end
