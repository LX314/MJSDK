//
//  Request.h
//  SDKProto
//
//  Created by John LXThyme on 16/6/24.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(SInt32, RequestTestType) {
    kProduction = 1,
    kDevelopment = 2,
    kDebug = 3,
};
typedef NS_ENUM(SInt32, RequestDeviceDeviceOrientation) {
    RequestDeviceDeviceOrientationKUnknownDeviceOrientation = 1,
    RequestDeviceDeviceOrientationKPortrait = 2,
    RequestDeviceDeviceOrientationKPortraitUpsideDown = 3,
    RequestDeviceDeviceOrientationKLandscapeLeft = 4,
    RequestDeviceDeviceOrientationKLandscapeRight = 5,
};
typedef NS_ENUM(SInt32, RequestDeviceDeviceType) {
    RequestDeviceDeviceTypeKUnknownDeviceType = 1,
    RequestDeviceDeviceTypeKPhone = 2,
    RequestDeviceDeviceTypeKPad = 3,
    RequestDeviceDeviceTypeKTv = 4,
    RequestDeviceDeviceTypeKPc = 5,
    RequestDeviceDeviceTypeKGameConsole = 6,
    RequestDeviceDeviceTypeKCarPlay = 7,
};
typedef NS_ENUM(SInt32, RequestDevicePlatform) {
    RequestDevicePlatformKIos = 1,
    RequestDevicePlatformKAndroid = 2,
};
typedef NS_ENUM(SInt32, RequestDeviceNetworkConnectionType) {
    RequestDeviceNetworkConnectionTypeKUnknownNetWork = 1,
    RequestDeviceNetworkConnectionTypeKWifi = 2,
    RequestDeviceNetworkConnectionTypeKG2 = 3,
    RequestDeviceNetworkConnectionTypeKG3 = 4,
    RequestDeviceNetworkConnectionTypeKG4 = 5,
    RequestDeviceNetworkConnectionTypeKG5 = 6,
};
typedef NS_ENUM(SInt32, ResponseImpressionAdADType) {
    ResponseImpressionAdADTypeKImgbanner = 1,
    ResponseImpressionAdADTypeKGlbanner = 2,
    ResponseImpressionAdADTypeKImginterstital = 3,
    ResponseImpressionAdADTypeKGlinterstital = 4,
    ResponseImpressionAdADTypeKApps = 5,
    ResponseImpressionAdADTypeKMdapps = 6,
};
typedef NS_ENUM(SInt32, ResponseImpressionAdProductType) {
    ResponseImpressionAdProductTypeKShare = 1,
    ResponseImpressionAdProductTypeKLink = 2,
};
typedef NS_ENUM(SInt32, ResponseImpressionAdResolutionLevel) {
    ResponseImpressionAdResolutionLevelKLevel0 = 0,
    ResponseImpressionAdResolutionLevelKLevel1 = 1,
    ResponseImpressionAdResolutionLevelKLevel2 = 2,
    ResponseImpressionAdResolutionLevelKLevel3 = 3,
};

/**
 *  Request 数据源
 */
@interface MJRequestManager : NSObject
{
    
}
/**  request params*/
@property (nonatomic,retain)NSMutableDictionary *request;

+ (instancetype)manager;

- (void)setEventID:(NSString *)eventID adlocCode:(NSString *)adlocCode adCount:(NSInteger)adCount;
@end
