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
    [self.contentView addSubview:self.btnClose];
    [self.contentView addSubview:self.mjLabADLogo];
    MASAttachKeys(self.btnClose,self.mjLabADLogo);
}
- (void)masonry{
    [super masonry];
    UIView *superView = self.contentView;
    UIView *ss = [self.btnClose superview];
    //0720
    if (!ss) {
        NSAssert(NO, @"");
        return;
    }
    [self.btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(superView).offset(5);
        make.right.equalTo(superView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];

    [self.mjLabADLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.right.equalTo(superView);
        make.bottom.equalTo(superView);
    }];

}

@end
