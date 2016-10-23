//
//  MJFactory.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/7.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJFactory.h"

#import "Colours.h"

@implementation MJFactory

+ (UIButton *)MJADClose {
    //初始化一个 Button
    UIButton *mjADClose = [UIButton buttonWithType:UIButtonTypeCustom];
    [mjADClose setFrame:CGRectZero];
    //        [<#btn#> setBackgroundColor:[UIColor <#color#>]];
    
    
    //背景图片
    //        [mjADClose setBackgroundImage:[UIImage imageNamed:@"横幅关闭按钮1"] forState:UIControlStateNormal];
    [mjADClose setTitle:@"✕" forState:UIControlStateNormal];
    [mjADClose setTitleColor:[UIColor colorFromHexString:@"#cccccc"] forState:UIControlStateNormal];
    [mjADClose.titleLabel setFont:[UIFont systemFontOfSize:12.f]];
    [mjADClose setTag:123456];
    
    return mjADClose;
}
+ (UILabel *)MJADLogoLab {
    UILabel * mjADLogo = [[UILabel alloc]init];
    [mjADLogo setText:@" 广告 "];
    [mjADLogo setTextColor:[UIColor colorFromHexString:@"#ffffff"]];
    [mjADLogo setAlpha:0.5f];
    [mjADLogo setBackgroundColor:[UIColor colorFromHexString:@"#cccccc"]];
//    mjADLogo.layer.edgeAntialiasingMask = kCALayerLeftEdge;
    mjADLogo.layer.masksToBounds = YES;
    [mjADLogo setFont:[UIFont systemFontOfSize:10.f]];
    
    //
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:kMJADLOGOLABBOUNDS byRoundingCorners:UIRectCornerTopLeft cornerRadii:CGSizeMake(5, 5)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = mjADLogo.bounds;
//    maskLayer.path = maskPath.CGPath;
//    mjADLogo.layer.mask = maskLayer;
    return mjADLogo;
}
@end
