//
//  MJShare.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/20.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJAppsWall.h"
#import "MJBlocks.h"

@interface MJShare : UIView
{
    
}
///** 页面跳转步骤*/
@property (nonatomic,copy) kMJGotoStepBlockBlock mjGotoStepBlockBlock;
@property (nonatomic,retain) MJAppsWall *appsManager;
//@property (nonatomic, strong) CALayer *backgroundLayer;
//@property (assign, nonatomic) LXMJViewMaskType defaultMaskType;
@property (strong, nonatomic) UIColor *backgroundLayerColor;
@property (nonatomic,retain) NSDictionary *params;

- (void)showIn:(MJAppsWall *)appsManager;
- (void)fill:(NSDictionary *)params;

@end
