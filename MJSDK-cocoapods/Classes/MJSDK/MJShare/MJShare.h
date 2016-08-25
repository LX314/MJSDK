//
//  MJShare.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/20.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJSDKConfiguration.h"

#import "MJAppsManager.h"

@interface MJShare : UIView
{
    
}
/** <#注释#>*/
@property (nonatomic,retain)MJAppsManager *appsManager;
@property (nonatomic, strong) CALayer *backgroundLayer;
@property (assign, nonatomic) LXMJViewMaskType defaultMaskType;
@property (strong, nonatomic) UIColor *backgroundLayerColor;
@property (nonatomic,retain) NSDictionary *params;

//+ (instancetype)manager;

//- (void)show;
- (void)showIn:(MJAppsManager *)appsManager;
- (void)fill:(NSDictionary *)params;

@end
