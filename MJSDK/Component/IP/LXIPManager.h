//
//  LXIPManager.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/2.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LXIPManager : NSObject
{
    
}
/** <#注释#>*/
@property (nonatomic,copy)NSString *currentRadioAccessTechnology;
/** <#注释#>*/
@property (nonatomic,copy)NSString *carrierName;
/** <#注释#>*/
@property (nonatomic,copy)NSString *mobileCountryCode;
/** <#注释#>*/
@property (nonatomic,copy)NSString *mobileNetworkCode;
/** <#注释#>*/
@property (nonatomic,copy)NSString *isoCountryCode;
/** <#注释#>*/
@property (nonatomic,assign)BOOL allowsVOIP;
/** <#注释#>*/
@property (nonatomic,copy)NSString *serviceProviderCode;
/** <#注释#>*/
@property (nonatomic,copy)NSString *idfa;



+ (instancetype)manager;


+ (NSString *)realIP;

+ (BOOL)isJailBroken;

+ (NSString *)ip2;
- (NSString *)platform;
- (NSString *)AIF_machineType;

- (void)carrierINIT;

@end
