//
//  ADView.h
//  sdk-ADView
//
//  Created by John LXThyme on 4/22/16.
//  Copyright © 2016 John LXThyme. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJTool.h"

@interface MJView : UIControl
{
    
}
/** <#注释#>*/
@property (nonatomic,assign)UIDeviceOrientation kMJOrientation;
/** <#注释#>*/
@property (nonatomic,retain)UIButton *btnClose;
/** <#注释#>*/
@property (nonatomic,retain)UILabel *mjLabADLogo;
/** Manager */
@property (nonatomic,assign)BOOL isShow;

/**
 *  @brief Mask
 */
@property (nonatomic, strong) CALayer *backgroundLayer;
@property (assign, nonatomic) LXMJViewMaskType defaultMaskType;
@property (strong, nonatomic) UIColor *backgroundLayerColor;

//+ (instancetype)manager;

#pragma mark -
#pragma mark - Common Component
- (void)initial;

- (void)getLocation;

- (void)registerNotifications;
- (void)mjreset;

- (void)updateMask;

//- (void)btnCloseClick:(id)sender;


@end
