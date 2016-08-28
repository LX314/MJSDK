//
//  MJInlineManager.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/8.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJInlineManager.h"

#import "MJIMGInline.h"
#import "MJGLInline.h"
#import "MJGLButtonInline.h"

@interface MJInlineManager ()<UITableViewDelegate,UITableViewDataSource>
{
    
}


@end
@implementation MJInlineManager
#pragma mark -
#pragma mark - Common Component
- (void)initial {
    [super initial];
    //
    CGFloat rowHeight = kMJInlineHeight;
    [self.table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    [self.table setBounds:self.bounds];
//    [self.table setCenter:self.center];
    [self.table setRowHeight:rowHeight];
    [self.table setDelegate:self];
    [self.table setDataSource:self];
    if (kIOSVersion >= 8.f) {
        self.table.estimatedRowHeight = kMJInlineHeight;
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
    if (mjAdType == KMJADInlineIMGType || mjAdType == KMJADInlineIMGShareType) {
        static NSString *cellIMGInlineIdentifier = @"cellIdentifier_MJIMGInline";
        MJIMGInline *cell = [tableView dequeueReusableCellWithIdentifier:cellIMGInlineIdentifier];
        if (!cell) {
            cell = [[MJIMGInline alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIMGInlineIdentifier];
        }
        //configuration cell...
        cell.superOwner = self;
        [cell fillImpAds:impAds indexPath:indexPath];
        return cell;
    } else if (mjAdType == KMJADInlineGLType) {
        static NSString *cellGLInlineIdentifier = @"cellIdentifier_MJGLInline";
        MJGLInline *cell = [tableView dequeueReusableCellWithIdentifier:cellGLInlineIdentifier];
        if (!cell) {
            cell = [[MJGLInline alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellGLInlineIdentifier];
        }
        //configuration cell...
        cell.superOwner = self;
        [cell fillImpAds:impAds indexPath:indexPath];
        return cell;
    } else if (mjAdType == KMJADInlineGLShareType) {
        static NSString *cellGLButtonInlineIdentifier = @"cellIdentifier_MJGLButtonInline";
        MJGLButtonInline *cell = [tableView dequeueReusableCellWithIdentifier:cellGLButtonInlineIdentifier];
        if (!cell)
        {
            cell = [[MJGLButtonInline alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellGLButtonInlineIdentifier];
        }
        //configuration cell...
        [cell fillImpAds:impAds indexPath:indexPath];
        cell.btnInlineIndexPath = indexPath;
        return cell;
    } else {
        NSAssert(NO, @"ERROR");
    }
    return nil;
}
#pragma mark -
#pragma mark - Masonry Methods
- (void)updateConstraints{
    [super updateConstraints];
    //
    [self masonry];
}
- (void)masonry
{//[self masonry];
//07.20    [super masonry];
    //
    UIView *superView = [self superview];

    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(superView).priorityLow();
        make.top.equalTo(superView);
        make.width.lessThanOrEqualTo(@(kMainScreen_suitWidth));
        make.centerX.equalTo(superView);
        make.height.equalTo(@(kMJInlineHeight));
    }];
    [self.table mas_remakeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(self);
    }];
}


@end

