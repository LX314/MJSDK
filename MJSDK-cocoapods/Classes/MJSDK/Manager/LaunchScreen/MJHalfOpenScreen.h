//
//  MJHalfOpenScreen.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/8.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJFullOpenScreen.h"

@interface MJHalfOpenScreen : MJFullOpenScreen
{
    
}

//@property (nonatomic,retain)NSArray *arrayData;

@property (nonatomic,retain)UIImage * img_halfOpenLogo;

@property (nonatomic,copy)NSString * str_copyRight;

//- (void)show;
//+ (instancetype)manager;
/**
 *  初始化半屏
 *
 *  @param adSpaceID 广告位 ID
 *  @param ico       ico
 *  @param coptRight coptRight description
 *
 *  @return instancetype
 */
- (instancetype)initWithAdSpaceID:(NSString *)adSpaceID ico:(UIImage *)ico copyRight:(NSString *)copyRight;

@end
