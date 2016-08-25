//
//  MJBaseCell.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/5/31.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Colours.h"
#import "MJSDKConf.h"
#import "Masonry.h"
#import "MJExceptionReportManager.h"

#import "UIImage+cached.h"
#import "UIImageView+placeholder.h"
#import "MJResponseDataModels.h"
static CGFloat kSystemHeightBaseCell = 0.f;

@interface MJBaseCell : UITableViewCell
{
}
/** <#注释#>*/
@property (nonatomic,assign)id superOwner;

@property (nonatomic,retain,readonly)UIButton *btnClose;
/** <#注释#>*/
@property (nonatomic,retain,readonly)UILabel *mjLabADLogo;



- (void)btnCloseClick:(id)sender;



- (void)fillImpAds:(MJImpAds *)impAds indexPath:(NSIndexPath *)indexPath;
- (void)fill:(MJImpAds *)impAds;

#pragma mark -
#pragma mark - Common Component
- (void)setUp;
- (void)masonry;

@end
