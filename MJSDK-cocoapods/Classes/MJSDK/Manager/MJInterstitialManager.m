//
//  MJInterstitialManager.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/5/31.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJInterstitialManager.h"

#import "MJGLInterstitial.h"
#import "MJIMGInterstitial.h"

@interface MJInterstitialManager ()<UITableViewDelegate,UITableViewDataSource>
{
    
}

@end
@implementation MJInterstitialManager
#pragma mark -
#pragma mark - Common Component
- (void)initial{
    [super initial];
    //
    [self setBackgroundColor:[UIColor clearColor]];
    [self.table setBounds:CGRectMake(0, 0, 300, 250)];
    [self.table setCenter:self.center];
    [self.table setRowHeight:250.f];
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    if (kIOSVersion >= 8.f) {
        self.table.estimatedRowHeight = CGRectGetHeight(kMJInterstitialHalfScreenBounds);
    }
    self.defaultMaskType =
    //    LXMJViewMaskTypeNone;
    LXMJViewMaskTypeGradient;
    [self updateMask];
}
- (void)setUp{
    [super setUp];
    //
    [self initial];
}
- (void)show{
    [super show];
    //
    [self initial];
}
#pragma mark - TableView Required Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.mjResponse.impAds count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJImpAds *impAds = self.mjResponse.impAds[indexPath.row];
    MJBannerAds *bannerAds = impAds.bannerAds;
    KMJADType mjAdType = bannerAds.mjAdType;
//    MJElement *mjEelements = bannerAds.mjElement;
    if (mjAdType == KMJADInterstitalIMGType) {
        static NSString *cellIMGIdentifier = @"cellIdentifierIMG";
        MJIMGInterstitial *cell = [tableView dequeueReusableCellWithIdentifier:cellIMGIdentifier];
        if (!cell)
        {
            cell = [[MJIMGInterstitial alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIMGIdentifier];
        }
        //configuration cell...
        cell.superOwner = self;
        [cell fillImpAds:impAds indexPath:indexPath];
        return cell;
    } else if (mjAdType == KMJADInterstitalGLType) {
        static NSString *cellGLIdentifier = @"cellIdentifierGL";
        MJGLInterstitial *cell = [tableView dequeueReusableCellWithIdentifier:cellGLIdentifier];
        if (!cell)
        {
            cell = [[MJGLInterstitial alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellGLIdentifier];
        }
        //configuration cell...
        cell.superOwner = self;
        [cell fillImpAds:impAds indexPath:indexPath];
        return cell;
    }
    else {
        NSAssert(NO, @"ERROR");
    }
    return nil;
}
#pragma mark - TableView Optional Methods
- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateMask];
}
#pragma mark -
#pragma mark - Masonry Methods
- (void)updateConstraints{
    [super updateConstraints];
    //
    [self masonry];
}
- (void)masonry {
    UIView *superView = [self superview];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(superView);
    }];

    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.center.equalTo(superView);
        make.size.mas_equalTo(CGSizeMake(300.f, 250.f));
    }];

}

@end
