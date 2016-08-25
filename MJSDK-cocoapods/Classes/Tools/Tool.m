//
//  Tool.m
//  GithubDemo001
//
//  Created by FairyLand on 15/4/1.
//  Copyright (c) 2015年 fulan. All rights reserved.
//

#import "Tool.h"

#import <UIKit/UIKit.h>

#ifdef kLXShowInfo
#import <UIView+Toast.h>
#endif
#ifdef kLXToolMantle
#import <Mantle.h>
#endif
#ifdef kLXSVPullToRefresh
#import <SVPullToRefresh.h>
#endif



#ifndef kAlertMSGNil
//Alert 消息
#define kAlertMSGNil(__msg__) [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:__msg__ delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show]
#endif


@implementation Tool


#pragma mark -
#pragma mark - 设置圆角
+ (void)setCornerRadius:(UIView *)view
{
    [Tool setView:view cornerRadius:4];
}
/**
 *  @brief  设置圆角
 *
 *  @param view          view
 *  @param cornerRadius cornerRadius
 */
+ (void)setView:(UIView *)view cornerRadius:(CGFloat)cornerRadius
{
    __weak UIView *weakView = view;
    weakView.layer.cornerRadius = cornerRadius;
    [weakView.layer setMasksToBounds:YES];
}
#pragma mark -
#pragma mark - 文字高度
/**
 @method 获取指定宽度情况ixa，字符串value的高度
 @param value 待计算的字符串
 @param fontSize 字体的大小
 @param andWidth 限制字符串显示区域的宽度
 @result float 返回的高度
 */
+ (float) heightForString:(NSString *)string font:(UIFont *)font maxWidth:(float)maxWidth
{
    CGSize sizeToFit = [string boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
                            NSFontAttributeName:font
                            } context:nil].size;
    return ceilf(sizeToFit.height);
}
#pragma mark -
#pragma mark - attributedString
+ (NSAttributedString *)attributedStringWithString:(NSString *)string attributes:(NSDictionary *)dict
{
    return [[NSAttributedString alloc]initWithString:string attributes:dict];
}

#pragma mark -
#pragma mark - Json/NSArray|NSDictionary
/**
 *  @brief  将 obj 转换为 Json 字符串
 *
 *  @param obj  json 对象
 *
 *  @return Json 字符串
 */
+ (NSString *)toJsonString:(id)obj
{
    if (![obj isKindOfClass:[NSDictionary class]] && ![obj isKindOfClass:[NSArray class]]) {
        return @"不能转换为 Json!";
    }
    NSError *toJsonError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&toJsonError];
    if (toJsonError) {
        NSString *strMsg = toJsonError.description;
        NSLog(@"toJsonError:%@",strMsg);
        kAlertMSGNil(strMsg);
        return nil;
    }
    NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
/**
 *  @brief  将 json 字符串转换为 json 对象
 *
 *  @param jsonString json 字符串
 *
 *  @return json 对象
 */
+ (id)toJsonObject:(NSString *)jsonString
{
    NSError *error;
    id obj = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:&error];
    if (error) {
        NSString *strMsg = error.description;
        NSLog(@"toJsonError:%@",strMsg);
        kAlertMSGNil(strMsg);
        return nil;
    }
    return obj;
}
#pragma mark -
#pragma mark - 正则判断
/**
 *  @brief  由数字和字母组成，并且要同时含有数字和字母，且长度要在8-16位之间
 *
 *  @param pwd password
 *
 *  @return bool value
 */
+ (BOOL)isPwd:(NSString *)pwd
{
    NSPredicate *predicate;
    NSString *pattern = @"^\\d{6,16}$";//@"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,6}";
    predicate = [NSPredicate predicateWithFormat:@"self matches %@",pattern];
    
    return [predicate evaluateWithObject:pwd];
}
+ (BOOL)isTel:(NSString *)tel
{
    NSString *pattern = @"^(13[0-9]|14[5|7]|15[0|1|2|3|5|6|7|8|9]|18[0|1|2|3|5|6|7|8|9])\\d{8}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",pattern];
    return [predicate evaluateWithObject:tel];
}
+ (BOOL)isIDCard:(NSString *)idCard
{
    NSString *pattern = @"^([0-9]){7,18}(x|X)?$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self matches %@",pattern];
    return [predicate evaluateWithObject:idCard];
}

#pragma mark -
#pragma mark - Trim
+ (NSString *)trimAll:(NSString *)string
{
    /**
     NSString *string = @"Lorem    ipsum dolar   sit  amet.";
     string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     
     NSArray *components = [string componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     components = [components filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self <> ''"]];
     
     string = [components componentsJoinedByString:@" "];

     */
    NSMutableString *trimString = [NSMutableString string];
    for (NSInteger i = 0; i < string.length; i ++)
    {
        NSString *str = [string substringWithRange:NSMakeRange(i, 1)];
        if (![str isEqualToString:@" "] && ![str isEqualToString:@"\n"])
        {
            [trimString appendString:str];
        }
    }
    return [trimString copy];
}

#pragma mark -
#pragma mark - Timer
+ (void)addTimer:(UIButton *)btn
{
    [Tool addTimer:btn CountdownSeconds:60.f];
}
+ (void)addTimer:(UIButton *)btn CountdownSeconds:(NSTimeInterval)seconds
{
    /**
     *  GCD Timer
     */
    __block NSInteger index = seconds;
    __weak UIButton *weakBtn = btn;
    __block UIColor *bgColor = weakBtn.backgroundColor;
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        [btn setUserInteractionEnabled:NO];
        [btn setBackgroundColor:[UIColor lightGrayColor]];
    });
    static dispatch_source_t _timer;
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 1 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        //Your code here...
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //
            [weakBtn setTitle:[NSString stringWithFormat:@"%d 秒",index] forState:UIControlStateNormal];
        });
        
        NSLog(@"index:%d",index);
        //stop the timer
        if (0 == index) {
            dispatch_source_cancel(_timer);
        }
        index --;
    });
    
    dispatch_source_set_cancel_handler(_timer, ^{
        //stop the timer here.
        NSLog(@"cancel...");
        dispatch_async(dispatch_get_main_queue(), ^{
            //
            [weakBtn setTitle:@"重新获取" forState:UIControlStateNormal];
            bgColor = [weakBtn.backgroundColor isEqual:[UIColor lightGrayColor]] ? bgColor : weakBtn.backgroundColor;
            [btn setBackgroundColor:bgColor];
            [weakBtn setUserInteractionEnabled:YES];
        });
    });
    dispatch_resume(_timer);
    
}
#pragma mark -
#pragma mark - Emoj
+ (BOOL)isContainsEmoji:(NSString *)string
{
    __block BOOL isContainEmoji = NO;

    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            isContainEmoji = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        isContainEmoji = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        isContainEmoji = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        isContainEmoji = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        isContainEmoji = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        isContainEmoji = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        isContainEmoji = YES;
                                    }
                                }
                            }];

    return isContainEmoji;
}
+ (BOOL)isContainsEmoji2:(NSString *)string
{
    __block BOOL isContainEmoji = NO;

    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            isContainEmoji = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        isContainEmoji = YES;
                                    }
                                } else {
                                    if ((0x2100 <= hs && hs <= 0x27ff) ||
                                        (0x2B05 <= hs && hs <= 0x2b07) ||
                                        (0x2934 <= hs && hs <= 0x2935) ||
                                        (0x3297 <= hs && hs <= 0x3299) ||
                                        hs == 0xa9 || hs == 0xae ||
                                        hs == 0x303d || hs == 0x3030 ||
                                        hs == 0x2b55 || hs == 0x2b1c ||
                                        hs == 0x2b1b || hs == 0x2b50)
                                        {
                                        isContainEmoji = YES;
                                        }
                                }
                            }];

    return isContainEmoji;
}
#pragma mark -
#pragma mark - DEBUG
+ (void)debug:(void(^)(void))debugBlock release:(void(^)(void))releaseBlock
{
    //#define kLXDEBUG 1
#ifdef kLXDEBUG
    if(debugBlock){
        debugBlock();
    }
#else
    if(releaseBlock){
        releaseBlock();
    }
#endif
}



#ifdef kLXShowInfo
#pragma mark -
#pragma mark - ShowInfo
+ (void)showInfo:(NSString *)msg inView:(UIView *)view
{
    __weak UIView *weakView = view;
    if ([msg length] <= 0) {
        msg = @"Msg[为空][缺省]";
    }
    [weakView makeToast:msg duration:3 position:CSToastPositionCenter];
}
#endif

#ifdef kLXToolMantle
#pragma mark -
#pragma mark - 转换为 Model
+ (id)mantleRevert:(id)obj toModel:(Class)modelClass
{
    if ([obj count] <= 0) {
        return nil;
    }
    NSError *modelError;
    if ([obj isKindOfClass:[NSDictionary class]])
    {
        id model = [MTLJSONAdapter modelOfClass:modelClass fromJSONDictionary:obj error:&modelError];
        if (modelError) {
            NSString *strMsg = modelError.description;
            kAlertMSGNil(strMsg);
            NSLog(@"strMsg:%@",strMsg);
            return nil;
        }
        return model;
    }else if([obj isKindOfClass:[NSArray class]])
    {
        id model = [MTLJSONAdapter modelsOfClass:modelClass fromJSONArray:obj error:&modelError];
        if (modelError) {
            NSString *strMsg = modelError.description;
            kAlertMSGNil(strMsg);
            NSLog(@"strMsg:%@",strMsg);
            return nil;
        }
        return model;
    } else {
        NSAssert(NO, @"发生错误!");
    }
    return nil;
}
#endif

#ifdef kLXSVPullToRefresh
#pragma mark -
#pragma mark - refresh
/**
 *  @brief  下拉刷新||上提加载
 *
 *  @param obj                UIScrollView||UITableView
 *  @param refreshBlock      下拉刷新
 *  @param tigardUploadBlock 上提加载
 */
+ (void)refresh:(UIScrollView *)obj pullToRefresh:(void(^)(void))refreshBlock tigardUpload:(void(^)(void))tigardUploadBlock
{
    __weak UIScrollView *weakObj = obj;
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        NSDate *date = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"hh:mm:ss"];
        NSString *dateString = [df stringFromDate:date];
        NSString *title = [NSString stringWithFormat:@"最后更新时间:%@",dateString];
        [weakObj.pullToRefreshView setArrowColor:[UIColor whiteColor]];
        [weakObj.pullToRefreshView setTitle:@"松开马上刷新" forState:SVPullToRefreshStateAll];
        [weakObj.pullToRefreshView setSubtitle:title forState:SVPullToRefreshStateAll];
        [weakObj.pullToRefreshView setTitle:@"财富泉,不老泉" forState:SVPullToRefreshStateLoading|SVPullToRefreshStateStopped];
//        [weakObj.pullToRefreshView.titleLabel setFont:[UIFont systemFontOfSize:10]];
        [weakObj.pullToRefreshView.subtitleLabel setFont:[UIFont systemFontOfSize:10]];
    });
    
    [weakObj addPullToRefreshWithActionHandler:^{
        //
        if (refreshBlock) {
            refreshBlock();
        }
        [weakObj.pullToRefreshView stopAnimating];
    }];
    [weakObj addInfiniteScrollingWithActionHandler:^{
        //
        if (tigardUploadBlock) {
            tigardUploadBlock();
        }
        [weakObj.infiniteScrollingView stopAnimating];
    }];
}
#endif

#ifdef kLXBlocksKit
#pragma mark -
#pragma mark - alert
+ (void)alert:(NSString *)title msg:(NSString *)msg cancelTitle:(NSString *)cancelTitle confirmTitle:(NSString *)confirmTitle confirmBlock:(void(^)(void))confirmBlock
{
    [Tool alert:title msg:msg cancelTitle:cancelTitle cancelBlock:nil confirmTitle:confirmTitle confirmBlock:confirmBlock];
}
+ (void)alert:(NSString *)title msg:(NSString *)msg cancelTitle:(NSString *)cancelTitle cancelBlock:(void(^)(void))cancelBlock confirmTitle:(NSString *)confirmTitle confirmBlock:(void(^)(void))confirmBlock
{
    if ([cancelTitle length] <= 0) {
        cancelTitle = @"再看看";
    }
    UIAlertView *alert = [[UIAlertView alloc]bk_initWithTitle:title message:msg];
    [alert bk_addButtonWithTitle:confirmTitle handler:^{
        //
        if (confirmBlock) {
            confirmBlock();
        }
    }];
    [alert bk_setCancelButtonWithTitle:cancelTitle handler:^{
        //
        if (cancelBlock) {
            cancelBlock();
        }
    }];
    [alert show];
}
#endif

@end
