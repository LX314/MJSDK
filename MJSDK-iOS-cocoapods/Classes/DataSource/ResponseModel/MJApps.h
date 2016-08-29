//
//  MJAppsAdditional.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/20.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "Mantle.h"
#import "MJElement.h"
#import "MJSDKConfiguration.h"

@interface MJApps : MTLModel
{

}
//originial
@property (nonatomic, assign) NSInteger        resolution;
@property (nonatomic, strong) NSString         *clickUrl;
@property (nonatomic, assign) NSInteger        templateId;
@property (nonatomic, strong) NSString         *elements;

@property (nonatomic, strong) NSString         *btnUrl;
@property (nonatomic, assign) kMJSDKTargetType targetType;



/** <#注释#>*/
@property (nonatomic,retain)MJElement *mjElement;
@property (nonatomic,assign)KMJADType mjAdType;


@end
