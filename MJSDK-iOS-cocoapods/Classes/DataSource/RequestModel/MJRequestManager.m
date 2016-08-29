//
//  Request.m
//  SDKProto
//
//  Created by John LXThyme on 16/6/24.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#import "MJRequestManager.h"

#import "LXIPManager.h"
#import "MJSDKConfiguration.h"
#import "MJSDKConf.h"
#import "MJTool.h"

#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@interface MJRequestManager ()
{
    
}

@end
@implementation MJRequestManager

+ (instancetype)manager {
    static MJRequestManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[[self class] alloc]init];
    });
    
    return _manager;
}

- (void)setEventID:(NSString *)eventID adlocCode:(NSString *)adlocCode adCount:(NSInteger)adCount {
    NSMutableDictionary *request_t = self.request;
    NSMutableDictionary *impression_t = request_t[@"impression"];
    request_t[@"event_id"] = eventID;
    impression_t[@"adloc_code"] = adlocCode;
    impression_t[@"ad_count"] = @(adCount);
}
#pragma mark -
#pragma mark - REQUEST
#pragma mark - request
- (NSMutableDictionary *)request
{
    UIDevice *device = [UIDevice currentDevice];

    NSDate *date = [MJTool getInternetBJDate];
    UInt32 timeStamp = [date timeIntervalSince1970];
    if(!_request){
        int pixelWidth = kMainScreen_width * [UIScreen mainScreen].scale;
        int pixelHeight = kMainScreen_height * [UIScreen mainScreen].scale;
        
        NSString *carrierId = [LXIPManager manager].mobileNetworkCode;

        
        _request = [@{
                      @"request_type" : @(kProduction),//```
                      @"event_id" : @"---eventId---",//请求唯一标示a
                      @"device" : [@{
                              @"ip" : @"0.0.0.0",
                              @"user_agent" : @"userAgent",
                              
                              @"pixel_width" : @(pixelWidth),
                              @"pixel_height" : @(pixelHeight),
                              @"physical_size" : @0.f,//TODO
                              
                              @"is_js_enabled" : @(false),
                              @"is_flash_enabled" : @(false),
                              
                              @"name" : device.name,
                              @"brand" : @"Apple",
                              @"model" : device.model,
                              
                              @"os" : device.systemName,
                              @"os_version" : device.systemVersion,
                              @"is_rooted" : @([LXIPManager isJailBroken]),
                              
                              @"device_orientation" : @(MJDeviceOrientation(device.orientation)),//```
                              
                              @"device_type" : @(MJDeviceType()),
                              
                              @"platform" : @(RequestDevicePlatformKIos),
                              
                              @"network_connection_type" : @(MJWWANStatus()),//```
                              
                              @"carrier_id" : @([carrierId intValue]),
                              
                              @"geo" : [@{//```
                                      @"longitude" : @(MJJLongitude),
                                      @"latitude" : @(MJJLatitude)
                                      } mutableCopy],
                              } mutableCopy],
                      @"app" : [@{
                              @"app_key" : kMJAppsAPPKey,
                              @"bundle_id" : [[NSBundle mainBundle] bundleIdentifier],
                              } mutableCopy],
                      @"user" : [@{
                                   @"phone_number" : @"",
                                   @"imei" : @"",
                                   @"mac" : @"",
                                   @"openuuid" : [device identifierForVendor].UUIDString,
                                   @"idfa" : kMJAppsIDFA,//[LXIPManager manager].idfa,//```
                                   @"android_id" : @"",
                                   @"app_user_id" : @"",
                                   } mutableCopy],
                      @"sdk" : [@{
                                  @"sdk_version" : @"iOS_v1.0.0",
                                  @"timestamp" : @(timeStamp),//```
                              } mutableCopy],
                      @"impression" : [@{
                                         @"adloc_code" : @"---adloc_code---",
                              @"ad_count" : @3,//---ad_count---
                              } mutableCopy],
                      } mutableCopy];
        
    }
    //
//    _request[@"request_type"] = @"";
//    _request[@"event_id"] = @"";
    {NSMutableDictionary *device_info = _request[@"device"];
        device_info[@"device_orientation"] = @(MJDeviceOrientation(device.orientation));
        device_info[@"network_connection_type"] = @(MJWWANStatus());
        {NSMutableDictionary *geo_info = device_info[@"geo"];
            geo_info[@"longitude"] = @(MJJLongitude);
            geo_info[@"latitude"] = @(MJJLatitude);
        }
    }
//    NSDictionary *app_info = _request[@"app"];
//    NSDictionary *user_info = _request[@"user"];
    {NSMutableDictionary *sdk_info = _request[@"sdk"];
        sdk_info[@"timestamp"] = @(timeStamp);
    }
//    NSDictionary *impression_info = _request[@"impression"];
    return _request;
}
#pragma mark -
#pragma mark - <#name#>
static RequestDeviceDeviceType MJDeviceType() {
    
    RequestDeviceDeviceType deviceType;
    
    UIDevice *device = [UIDevice currentDevice];
    if ([device.model rangeOfString:@"phone"].location != NSNotFound) {
        deviceType = RequestDeviceDeviceTypeKPhone;
    } else if ([device.model rangeOfString:@"pad"].location != NSNotFound) {
        deviceType = RequestDeviceDeviceTypeKPad;
    } else if ([device.model rangeOfString:@"pod"].location != NSNotFound){
//#warning Pod
        deviceType = RequestDeviceDeviceTypeKPad;
    } else {
        deviceType = RequestDeviceDeviceTypeKUnknownDeviceType;
    }
    return deviceType;
}
static RequestDeviceDeviceOrientation MJDeviceOrientation(UIDeviceOrientation orientation) {
    NSDictionary *deviceOrientation = @{
                                        @(UIDeviceOrientationUnknown):@(RequestDeviceDeviceOrientationKUnknownDeviceOrientation),
                                        @(UIDeviceOrientationPortrait):@(RequestDeviceDeviceOrientationKPortrait),
                                        @(UIDeviceOrientationPortraitUpsideDown):@(RequestDeviceDeviceOrientationKPortraitUpsideDown),
                                        @(UIDeviceOrientationLandscapeLeft):@(RequestDeviceDeviceOrientationKLandscapeLeft),
                                        @(UIDeviceOrientationLandscapeRight):@(RequestDeviceDeviceOrientationKLandscapeRight),
                                        @(UIDeviceOrientationFaceUp):@(RequestDeviceDeviceOrientationKUnknownDeviceOrientation),
                                        @(UIDeviceOrientationFaceDown):@(RequestDeviceDeviceOrientationKUnknownDeviceOrientation)
                                        };
    return [deviceOrientation[@(orientation)] intValue];
}
static RequestDeviceNetworkConnectionType MJWWANStatus() {
    NSString *status = [LXIPManager manager].currentRadioAccessTechnology;
    if (!status) return RequestDeviceNetworkConnectionTypeKUnknownNetWork;
    static NSDictionary *dict;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dict = @{
                 CTRadioAccessTechnologyGPRS : @(RequestDeviceNetworkConnectionTypeKG2),  // 2.5G   171Kbps
                 CTRadioAccessTechnologyEdge : @(RequestDeviceNetworkConnectionTypeKG2),  // 2.75G  384Kbps
                 CTRadioAccessTechnologyWCDMA : @(RequestDeviceNetworkConnectionTypeKG3), // 3G     3.6Mbps/384Kbps
                 CTRadioAccessTechnologyHSDPA : @(RequestDeviceNetworkConnectionTypeKG3), // 3.5G   14.4Mbps/384Kbps
                 CTRadioAccessTechnologyHSUPA : @(RequestDeviceNetworkConnectionTypeKG3), // 3.75G  14.4Mbps/5.76Mbps
                 CTRadioAccessTechnologyCDMA1x : @(RequestDeviceNetworkConnectionTypeKG3), // 2.5G
                 CTRadioAccessTechnologyCDMAEVDORev0 : @(RequestDeviceNetworkConnectionTypeKG3),
                 CTRadioAccessTechnologyCDMAEVDORevA : @(RequestDeviceNetworkConnectionTypeKG3),
                 CTRadioAccessTechnologyCDMAEVDORevB : @(RequestDeviceNetworkConnectionTypeKG3),
                 CTRadioAccessTechnologyeHRPD : @(RequestDeviceNetworkConnectionTypeKG3),
                 CTRadioAccessTechnologyLTE : @(RequestDeviceNetworkConnectionTypeKG4)// LTE:3.9G 150M/75M  LTE-Advanced:4G 300M/150M
                 };
    });
    return [dict[status] intValue];
}
@end
