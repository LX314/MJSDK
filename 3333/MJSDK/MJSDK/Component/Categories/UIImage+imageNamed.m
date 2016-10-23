//
//  UIImage+imageNamed.m
//  MJSDK-iOS
//
//  Created by WM on 16/8/30.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "UIImage+imageNamed.h"

@implementation UIImage (imageNamed)

+ (UIImage *)mj_imageNamed:(NSString *)imgName {
    
    NSArray *array_t = [imgName componentsSeparatedByString:@"."];
    if (array_t.count != 2) {
        return nil;
    }
    NSString *fullName = [array_t firstObject];
    NSString *suffix = [array_t lastObject];
    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"MJSDK" ofType:@"bundle"];
    NSString *imgPath = [[NSBundle bundleWithPath:bundlePath]pathForResource:fullName ofType:suffix];
    UIImage *img = [UIImage imageWithContentsOfFile:imgPath];
    return img;
}


@end
