//
//  MJBannerManager.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/5/27.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJBannerManager.h"

#import "MJIMGBanner.h"
#import "MJGLBanner.h"

@interface MJBannerManager ()<UITableViewDelegate,UITableViewDataSource>
{

}

@end
@implementation MJBannerManager
#pragma mark -
#pragma mark - Common Component
- (void)initial{
    [super initial];
    //
    CGFloat rowHeight = kADBannerHeight;
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.table setRowHeight:rowHeight];
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    if (kIOSVersion >= 8.f) {
        self.table.estimatedRowHeight = kADBannerHeight;
    }
}
- (void)setUp{
    [super setUp];
    [self initial];
}
- (void)show{
    [super show];
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

    if (mjAdType == KMJADBannerIMGType) {
        static NSString *cellBannerIMGIdentifier = @"cellIdentifierBannerIMG";
        MJIMGBanner *cell = [tableView dequeueReusableCellWithIdentifier:cellBannerIMGIdentifier];
        if (!cell)
        {
            cell = [[MJIMGBanner alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellBannerIMGIdentifier];
        }
        //configuration cell...
        cell.superOwner = self;
        [cell fillImpAds:impAds indexPath:indexPath];
        return cell;
    } else if (mjAdType == KMJADBannerGLType) {
        static NSString *cellBannerGLIdentifier = @"cellIdentifierBannerGL";
        MJGLBanner *cell = [tableView dequeueReusableCellWithIdentifier:cellBannerGLIdentifier];
        if (!cell)
        {
            cell = [[MJGLBanner alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellBannerGLIdentifier];
        }
        //configuration cell...
        cell.superOwner = self;
        [cell fillImpAds:impAds indexPath:indexPath];
        return cell;
    } else {
        NSAssert(NO, @"ERROR");
    }
    return nil;
}
#pragma mark - TableView Optional Methods
#pragma mark - Masonry Methods
- (void)updateConstraints{
    [super updateConstraints];
    //
    [self masonry];
}
- (void)masonry
{
    UIView *superView = [self superview];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(superView).priorityLow();
        make.width.lessThanOrEqualTo(@(kMainScreen_suitWidth));
        make.centerX.equalTo(superView);
        make.height.equalTo(@(kADBannerHeight));
        if (self.position == KMJADTopPosition) {
            make.top.equalTo(superView);
        }else if (self.position == KMJADBottomPosition) {
            make.bottom.equalTo(superView);
        }
    }];
    [self.table mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(self);
    }];
}

@end
