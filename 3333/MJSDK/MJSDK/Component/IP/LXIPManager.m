//
//  LXIPManager.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/2.
//  Copyright © 2016年 WM. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "LXIPManager.h"

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <AdSupport/AdSupport.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#include <sys/sysctl.h>

#include <spawn.h>
extern char **environ;

@interface LXIPManager ()
{
    
}
/** <#注释#>*/
@property (nonatomic,retain)CTTelephonyNetworkInfo *networkInfo;
/** <#注释#>*/
@property (nonatomic,retain)CTCarrier *carrier;



@end
@implementation LXIPManager
+ (instancetype)manager {
    static LXIPManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc]init];
    });
    
    return _sharedInstance;
}

+ (NSString *)ip2
{
    //    #import <arpa/inet.h>
    //    #import <arpa/inet.h>
    NSString *_ip;
    if (_ip == nil) {
        _ip = @"Error";
        struct ifaddrs *interfaces = NULL;
        struct ifaddrs *temp_addr = NULL;
        int success = 0;
        // retrieve the current interfaces - returns 0 on success
        success = getifaddrs(&interfaces);
        if (success == 0) {
            // Loop through linked list of interfaces
            temp_addr = interfaces;
            while(temp_addr != NULL) {
                if(temp_addr->ifa_addr->sa_family == AF_INET) {
                    // Check if interface is en0 which is the wifi connection on the iPhone
                    if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                        // Get NSString from C String
                        _ip = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                    }
                }
                temp_addr = temp_addr->ifa_next;
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return _ip;
}

#pragma mark -
#pragma mark - 获取 IP
+ (NSString *)IP
{
    NSError *error;
    NSURL *ipURL = [NSURL URLWithString:
                    //                    @"http://ip.chinaz.com/getip.aspx"
                    //                    @"http://www.whatismyip.com/automation/n09230945.asp"
                    //                    @"http://pv.sohu.com/cityjson?ie=utf-8"
                    @"http://whois.pconline.com.cn/ipJson.jsp"
                    ];
    NSString *ip = [NSString stringWithContentsOfURL:ipURL encoding:1 error:&error];
    return ip ? ip : [error localizedDescription];
}
+ (NSString *)realIP {
    NSString *ipStr;
    @try {
        ipStr = [self realIP:[self IP]];
    }
    @catch (NSException *exception) {
        NSString *strMsg = [@"Exception:" stringByAppendingString:exception.description];
        NSLog(@"%@",strMsg);
//        kAlertMSGNil(strMsg);
    }
    @finally {
        ipStr = [self realIP:[self IP]];
    }
    return ipStr;
}
+ (NSString *)realIP:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    [string stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    NSString *regular = @"[(] {0,}[{].*[}] {0,}[)]";
    NSRange range = [string rangeOfString:regular options:NSRegularExpressionSearch];
    
    NSString *realIPString;
    if (range.location != NSNotFound) {
        realIPString = [string substringWithRange:range];
        realIPString = [realIPString substringWithRange:NSMakeRange(1, realIPString.length - 2)];
    }
    
    if (realIPString.length <= 0 || !realIPString) {
        return nil;
    }
    
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[realIPString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"ERROR:%@",error.localizedDescription);
        return nil;
    }
    
    return dict[@"ip"];
}


#pragma mark -
#pragma mark - 越狱
//判断是否越狱
static const char * __jb_app = NULL;

+ (BOOL)isJailBroken
{
    if ([[UIDevice currentDevice].name rangeOfString:@"Simulator"].location != NSNotFound) {
        return NO;
    }
    BOOL jailbroken = NO;
    NSString *cydiaPath = @"/Applications/Cydia.app";
    NSString *aptPath = @"/private/var/lib/apt/";
    if ([[NSFileManager defaultManager] fileExistsAtPath:cydiaPath]) {
        jailbroken = YES;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:aptPath]) {
        jailbroken = YES;
    }
    return jailbroken;
}
+ (NSString *)jailBreaker
{
    if ( __jb_app )
    {
        return [NSString stringWithUTF8String:__jb_app];
    }
    else
    {
        return @"";
    }
}


#pragma mark -
#pragma mark - Machine Type
- (NSString *)platform
{
    //#include <sys/sysctl.h>
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    free(answer);
    if (!results) {
        results = @"";
    }
    return results;
}

- (NSString *)AIF_machineType
{
    
    NSString *platform = [self platform];
    
    //Simulator
    if ([platform isEqualToString:@"i386"])      return@"Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"Simulator";
    
    //iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6S";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6S Plus";
    
    //iPod Touch
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    
    //iPad
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    if ([platform isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([platform isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    
    if ([platform isEqualToString:@"iPad4,4"]||[platform isEqualToString:@"iPad4,5"]||[platform isEqualToString:@"iPad4,6"]) return @"iPad mini 2";
    if ([platform isEqualToString:@"iPad4,7"]||[platform isEqualToString:@"iPad4,8"]||[platform isEqualToString:@"iPad4,9"])  return @"iPad mini 3";
    
    return @"unknown machine type";
}


#pragma mark -
#pragma mark - CarrierID
#pragma mark - networkInfo
- (CTTelephonyNetworkInfo *)networkInfo
{
    if(!_networkInfo){
        [self carrierINIT];
    }
    
    return _networkInfo;
}
- (CTCarrier *)carrier
{
    if(!_carrier){
        [self carrierINIT];
    }
    
    return _carrier;
}

- (void)carrierINIT {
//#import <CoreTelephony/CTTelephonyNetworkInfo.h>
//#import <CoreTelephony/CTCarrier.h>
    _networkInfo = [[CTTelephonyNetworkInfo alloc] init];
    _carrier = [_networkInfo subscriberCellularProvider];
    _carrierName = [_carrier carrierName];
    _mobileCountryCode = _carrier.mobileCountryCode;
    _mobileNetworkCode = _carrier.mobileNetworkCode;
    UIDevice *device = [UIDevice currentDevice];
    NSString* deviceModel = device.name;
    NSRange simulatorRange = [deviceModel rangeOfString:@"Simulator"];
    if (simulatorRange.location != NSNotFound) {
        _serviceProviderCode = @"Simulator";
    } else {
        _serviceProviderCode = [NSString stringWithFormat:@"%@%@", _mobileCountryCode, _mobileNetworkCode];
    }
}

#pragma mark - idfa
- (NSString *)idfa
{
    if(!_idfa){
        _idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    return _idfa;
}

@end
