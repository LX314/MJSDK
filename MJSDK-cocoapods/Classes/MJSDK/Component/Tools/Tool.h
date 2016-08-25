//
//  Tool.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/6.
//  Copyright © 2016年 WM. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    KMJWechatShareBeginState = 1,
    KMJWechatShareSuccessState = 2,
    KMJWechatShareFailState = 3,
    KMJWechatShareCancelState = 4,
} KMJWechatShareStatus;
typedef void(^kMJWechatShareStatusBlock)(KMJWechatShareStatus status);

@interface Tool : NSObject
{
    
}

+ (void)initWechatShare;
+ (void)wechatShare:(kMJWechatShareStatusBlock)status  title:(NSString *)title description:(NSString *)description imagesArray:(NSArray<UIImage *> *)imagesArray url:(NSString *)url;

@end
