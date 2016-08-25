//
//  MJOpenScreenManager.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/7.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Colours.h"
#import "Masonry.h"
#import "MJDataManager.h"

@interface MJFullOpenScreen : UIViewController
{
    id _rootViewController;
}
/** <#注释#>*/
@property (nonatomic,retain)UIImageView *imgView;
/** <#注释#>*/
@property (nonatomic,retain)UIButton *btn_skip;
/** <#注释#>*/
@property (nonatomic,retain)UILabel *label_skip;
/** <#注释#>*/
@property (nonatomic,retain)UILabel *lab_ad;

@property (nonatomic,retain)NSArray *arrayData;

+ (instancetype)manager;

- (void)masonry;



//Developer
/** <#注释#>*/
@property (nonatomic,assign)KMJOpenScreenStyle openScreenStyle;
/** <#注释#>*/
@property (nonatomic,assign)KMJADType adType;
/** 数据源*/
@property (nonatomic,retain)MJResponse *mjResponse;
/** <#注释#>*/
@property (nonatomic,assign)BOOL hasReady;
/** <#注释#>*/
@property (nonatomic,assign)id<MJADDelegate> delegate;
/** Manager */
@property (nonatomic,assign)BOOL isShow;
/** <#注释#>*/
@property (nonatomic,copy)NSString *showUrl;

- (instancetype)initWithAdSpaceID:(NSString *)adSpaceID;

- (void)preloadData;

- (void)show;
- (void)initShow;

@end
