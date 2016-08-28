//
//  MJBannerAds.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/21.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "Mantle.h"
#import "MJElement.h"
#import "MJSDKConfiguration.h"

@interface MJBannerAds : MTLModel
{
    
}
@property (nonatomic, assign) double templateId;
@property (nonatomic, strong) NSString *clickUrl;
@property (nonatomic, assign) double resolution;
@property (nonatomic, strong) NSString *elements;

@property (nonatomic, strong) NSString *btnUrl;
@property (nonatomic, assign) kMJSDKTargetType targetType;

/** elements -->> MJElement 对象*/
@property (nonatomic,retain)MJElement *mjElement;
/** templateId -->> KMJADType*/
@property (nonatomic,assign)KMJADType mjAdType;

@end
