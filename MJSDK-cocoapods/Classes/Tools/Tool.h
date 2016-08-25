//
//  Tool.h
//  GithubDemo001
//
//  Created by FairyLand on 15/4/1.
//  Copyright (c) 2015年 fulan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

//#define kLXShowInfo @"LXShowInfo"
//#define kLXToolMantle @"LXToolMantle"
//#define kLXSVPullToRefresh @"LXSVPullToRefresh"
//#define kLXBlocksKit @"LXBlocksKit"


#ifdef kLXSVPullToRefresh
#endif

@interface Tool : NSObject
{
    
}



#pragma mark - 设置圆角
+ (void)setCornerRadius:(UIView *)view;
/**
 *  @brief  设置圆角
 *
 *  @param view          view
 *  @param cornerRadius cornerRadius
 */
+ (void)setView:(UIView *)view cornerRadius:(CGFloat)cornerRadius;
#pragma mark - 文字高度
/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (float) heightForString:(NSString *)string font:(UIFont *)font maxWidth:(float)maxWidth;
#pragma mark - attributedString
+ (NSAttributedString *)attributedStringWithString:(NSString *)string attributes:(NSDictionary *)dict;
#pragma mark - Json/NSArray|NSDictionary
/**
 *  @brief  将 obj 转换为 Json 字符串
 *
 *  @param obj  json 对象
 *
 *  @return Json 字符串
 */
+ (NSString *)toJsonString:(id)obj;
/**
 *  @brief  将 json 字符串转换为 json 对象
 *
 *  @param jsonString json 字符串
 *
 *  @return json 对象
 */
+ (id)toJsonObject:(NSString *)jsonString;
#pragma mark - 正则判断
/**
 *  @brief  由数字和字母组成，并且要同时含有数字和字母，且长度要在8-16位之间
 *
 *  @param pwd password
 *
 *  @return bool value
 */
+ (BOOL)isPwd:(NSString *)pwd;
+ (BOOL)isTel:(NSString *)tel;
+ (BOOL)isIDCard:(NSString *)idCard;
#pragma mark -
#pragma mark - Trim
+ (NSString *)trimAll:(NSString *)string;
#pragma mark -
#pragma mark - Timer
+ (void)addTimer:(UIButton *)btn;
+ (void)addTimer:(UIButton *)btn CountdownSeconds:(NSTimeInterval)seconds;
#pragma mark -
#pragma mark - DEBUG
+ (void)debug:(void(^)(void))debugBlock release:(void(^)(void))releaseBlock;

#ifdef kLXShowInfo
#pragma mark - Toast-ShowInfo
+ (void)showInfo:(NSString *)info inView:(UIView *)view;
#endif

#ifdef kLXToolMantle
#pragma mark - Mantle-转换为 Model
+ (id)mantleRevert:(id)obj toModel:(Class)modelClass;
#endif

#ifdef kLXSVPullToRefresh
#pragma mark - SVPullToRefresh-refresh
/**
 *  @brief  下拉刷新||上提加载
 *
 *  @param obj                UIScrollView||UITableView
 *  @param refreshBlock      下拉刷新
 *  @param tigardUploadBlock 上提加载
 */
+ (void)refresh:(UIScrollView *)obj pullToRefresh:(void(^)(void))refreshBlock tigardUpload:(void(^)(void))tigardUploadBlock;
#endif

#ifdef kLXBlocksKit
#pragma mark - BlocksKit-alert
+ (void)alert:(NSString *)title msg:(NSString *)msg cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle confirmBlock:(void(^)(void))confirmBlock;
+ (void)alert:(NSString *)title msg:(NSString *)msg cancelTitle:(NSString *)cancelTitle cancelBlock:(void(^)(void))cancelBlock confirmTitle:(NSString *)confirmTitle confirmBlock:(void(^)(void))confirmBlock;
#endif

@end
