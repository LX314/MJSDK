//
//  MJBaseInterstitial.m
//  sdk-ADView
//
//  Created by John LXThyme on 16/5/20.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#import "MJBaseInterstitial.h"

@implementation MJBaseInterstitial
- (void)setUp{
    [super setUp];
}
- (void)masonry{
    [super masonry];

}
#pragma mark - imgView
- (UIImageView *)imgView
{
    if(!_imgView){
        _imgView = [[UIImageView alloc]init];
        [_imgView setContentMode:UIViewContentModeScaleAspectFill];
    }
    
    return _imgView;
}

@end
