//
//  MJImpAds.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/21.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "Mantle.h"
#import "MJApps.h"
#import "MJBannerAds.h"

@interface MJImpAds : MTLModel
{

}
/** 是否分享*/
@property (nonatomic,assign)BOOL hasShared;
@property (nonatomic,retain)NSIndexPath *indexPath;


/** YES:图片正常加载| NO: 图片加载失败,显示为打底广告*/
@property (nonatomic,assign)BOOL isNormalLoaded;
/** YES:数据正常加载| NO: 数据加载失败,显示为默认(本地)广告*/
@property (nonatomic,assign)BOOL isDefaultLoaded;

/** 曝光时间*/
@property (nonatomic,assign)BOOL hasExposured;
@property (nonatomic,retain)NSDate *beginShowTime;
@property (nonatomic,retain)NSDate *endShowTime;

/** <#注释#>*/
@property (nonatomic,copy)NSString *showUrl;

//origin
@property (nonatomic, strong) NSString *landingPageUrl;
@property (nonatomic, strong) NSString *innovativeId;
@property (nonatomic, strong) MJApps *apps;
@property (nonatomic, strong) MJBannerAds *bannerAds;
@property (nonatomic, strong) NSString *impressionId;
@property (nonatomic, assign) NSInteger impressionSeqNo;


@end
