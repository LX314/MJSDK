//
//  LocationManager.m
//  RacingFund
//
//  Created by FairyLand on 15/3/6.
//  Copyright (c) 2015年 fulan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXLocationManager.h"
#import "MJSDKConfiguration.h"

#import <CoreLocation/CoreLocation.h>

//Alert 消息
#define kAlertMSGNil(__msg__) [[[UIAlertView alloc]initWithTitle:@"温馨提示" message:__msg__ delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil]show]

@interface LXLocationManager ()<CLLocationManagerDelegate>
{
    
}
@property(nonatomic,retain)CLGeocoder *geocoder;
@property(nonatomic,retain)CLLocationManager *locationManager;


@end
@implementation LXLocationManager
#pragma mark - manager
+ (instancetype)manager {
    static LXLocationManager *__manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __manager = [[[self class] alloc]init];
    });
    
    return __manager;
}
+ (void)getMyLocation
{
    return [[LXLocationManager manager]getMyLocation];
}
- (void)getMyLocation
{
    @try {
        [self getLocation];
    }
    @catch (NSException *exception) {
        kAlertMSGNil(exception.reason);
    }
    @finally {
        //
    }
}
- (void)getLocation
{
    /**
     * 4.请求用户权 限：分为：
     *                  1`requestWhenInUseAuthorization只在前台开启定位
     *                  2`requestAlwaysAuthorization在后台也可定位
     * 注意：建议只请求1和2中的一个，如果两个权限都需要，只请求2即可
     *12这样的顺序，将导致 bug：第一次启动程序后，系统将只请求1的权限，2的权限系统不会请求，只会在下一次启动应用时请 求2
     */
    if (![CLLocationManager locationServicesEnabled])
    {
        kAlertMSGNil(@"定位服务当前可能尚未打开，请在设置中打开！");
        return;
    }
    NSString *status;
    switch ([CLLocationManager authorizationStatus])
    {
        case kCLAuthorizationStatusNotDetermined://用户尚未做出决定是否启用定位服务
        {
            status = @"kCLAuthorizationStatusNotDetermined";
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
            {
                [_locationManager requestWhenInUseAuthorization]; //?只在前台开启定位
//                [_locationManager requestAlwaysAuthorization];//?在后台也可定位
            }
            [self.locationManager startUpdatingLocation];//启动跟踪定位
            break;
        }
        case kCLAuthorizationStatusRestricted://没有获得用户授权使用定位服务,可能用户没有自己禁止访问授权
        {
            status = @"kCLAuthorizationStatusRestricted";
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
            {
                [_locationManager requestWhenInUseAuthorization]; //?只在前台开启定位
//                [_locationManager requestAlwaysAuthorization];//?在后台也可定位
            }
            [self.locationManager startUpdatingLocation];//启动跟踪定位
            break;
        }
        case kCLAuthorizationStatusDenied://用户已经明确禁止应用使用定位服务或者当前系统定位服务处于关闭状态
        {
            status = @"kCLAuthorizationStatusDenied";
            kAlertMSGNil(@"您已禁止应用的定位功能,请在设置开启!");
            break;
        }
        case kCLAuthorizationStatusAuthorizedAlways://应用获得授权可以一直使用定位服务，即使应用不在使用状态
        {
            status = @"kCLAuthorizationStatusAuthorizedAlways";
            [self.locationManager startUpdatingLocation];//启动跟踪定位
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse://使用此应用过程中允许访问定位服务
        {
            status = @"kCLAuthorizationStatusAuthorizedWhenInUse";
            /**
             *  开始定位追踪，开始定位后将按照用户设置的更新频率执行-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations;方法反馈定位信息
             */
            [self.locationManager startUpdatingLocation];//启动跟踪定位
            break;
        }
        default:
        {
            NSAssert(NO, @"发生错误!");
            break;
        }
    }//switch
    NSLog(@"\n\
          status:%@\n",status);
    
}

#pragma mark - CLLocationManagerDelegate
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
//可以通过模拟器设置一个虚拟位置，否则在模拟器中无法调用此方法
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location=[locations firstObject];
    CLLocationCoordinate2D coordinate=location.coordinate;
    if ([self.delegate respondsToSelector:@selector(coordinate2D:)]) {
        [self.delegate coordinate2D:coordinate];
    }
    NSLog(@"\n\
          经度:%f\n\
          纬度:%f\n\
          海拔:%f\n\
          航向:%f\n\
          行走速度:%f",
          coordinate.longitude,
          coordinate.latitude,
          location.altitude,
          location.course,
          location.speed);
    [self getAddressByGeocodeLocation:location];
    /**
     *  如果不需要实时定位，使用完即使关闭定位服务
     */
    [_locationManager stopUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"%@",error);
}

#pragma mark - 根据坐标取得地名
- (void)getAddressByGeocodeLocation:(CLLocation *)location
{
    [self reverseGeocodeLocation:location];
}
- (void)getAddressByLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [self reverseGeocodeLocation:location];
}
- (void)reverseGeocodeLocation:(CLLocation *)location
{
    //反地理编码
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        [self showAllInfo:placemarks];
    }];
}
- (void)showAllInfo:(NSArray *)placemarks
{
    NSLog(@"共有 %lu 个位置信息",[placemarks count]);
    for (NSInteger i = 0; i < [placemarks count]; i ++)
    {
        CLPlacemark *placemark = (CLPlacemark *)placemarks[i];
        NSLog(@"**************第 %lu 个位置信息**************",i + 1);
        [self showInfo:placemark];
        NSLog(@"**********************");
    }
}
- (void)showInfo:(CLPlacemark *)placemark
{
    NSString *name=placemark.name;//地名
    NSString *thoroughfare=placemark.thoroughfare;//街道
    NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
    NSString *locality=placemark.locality; // 城市
    NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
    NSString *administrativeArea=placemark.administrativeArea; // 州
    NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
    NSString *postalCode=placemark.postalCode; //邮编
    NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
    NSString *country=placemark.country; //国家
    NSString *inlandWater=placemark.inlandWater; //水源、湖泊
    NSString *ocean=placemark.ocean; // 海洋
    NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
    
    NSLog(@"\n\
          国家:%@\n\
          国家编码:%@\n\
          地名:%@\n\
          州 :%@\n\
          城市:%@\n\
          街道:%@\n\
          门牌:%@\n\
          邮编:%@\n\
          标志性建筑:%@\n\
          其他行政区域信息:%@\n\
          水源、湖泊:%@\n\
          海洋:%@\n\
          关联的或利益相关的地标:%@",
          country,//国家
          ISOcountryCode,//国家编码
          name,//地名
          administrativeArea,//州
          locality,//城市
          thoroughfare,//街道
          subThoroughfare,//门牌
          postalCode,//邮编
          
          subLocality,//标志性建筑
          subAdministrativeArea,//其他行政区域信息
          
          inlandWater,//水源、湖泊
          ocean,//海洋
          areasOfInterest//关联的或利益相关的地标
          );
}
#pragma mark - 定位管理器-->>locationManager
- (CLLocationManager *)locationManager
{
    if(!_locationManager){
        /**
         *  NSLocationAlwaysUsageDescription       String  XXX 请求后台定位权限
         *  Required background modes                   Array
         *                        item0             App register for location updates.
         */
        // 1. 实例化定位管理器
        _locationManager = [[CLLocationManager alloc]init];
        //2.设置代理
        _locationManager.delegate = self;
        //
        /**3. 定位精度
         *  设置定位精度,枚举类型
         *  kCLLocationAccuracyBest最精确定位
         *  kCLLocationAccuracyNearestTenMeters十米误差范围
         *  kCLLocationAccuracyHundredMeters百米误差范围
         *  kCLLocationAccuracyKilometer千米误差范围
         *  kCLLocationAccuracyThreeKilometers三千米误差范围
         */
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        /**
         *  位置信息更新最小距离，只有移动大于这个距离才更新位置信息
         *  默认为kCLDistanceFilterNone：不进行距离限制
         */
        CLLocationDistance distance = 10.0f;//十米定位一次
        
//        [_locationManager allowDeferredLocationUpdatesUntilTraveled:<#(CLLocationDistance)#> timeout:<#(NSTimeInterval)#>];
        
        _locationManager.distanceFilter = distance;
        // 5.iOS9新特性：将允许出现这种场景：同一app中多个location manager：一些只能在前台定位，另一些可在后台定位（并可随时 禁止其后台定位）。
        [_locationManager disallowDeferredLocationUpdates];
        
        _locationManager.pausesLocationUpdatesAutomatically = YES;
    }
    /**
     *  startUpdatingHeading开始导航方向追踪
     *  stopUpdatingHeading停止导航方向追踪
     */
    /**
     *  startMonitoringForRegion:
     1.开始对某个区域进行定位追踪，开始对某个区域进行定位后。
     2.如果用户进入或者走出某个区域会调用:
     - (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
     和
     - (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
     代理方法反馈相关信息
     *  stopMonitoringForRegion:停止对某个区域进行定位追踪
     */
    /**
     *  requestWhenInUseAuthorization:
     1.请求获得应用使用时的定位服务授权
     2.注意使用此方法前在要在info.plist中配置NSLocationWhenInUseUsageDescription
     *  requestAlwaysAuthorization:
     1.请求获得应用一直使用定位服务授权
     2.注意使用此方法前要在info.plist中配置NSLocationAlwaysUsageDescription
     */
    /**代理方法:
     *                 //位置发生改变后执行（第一次定位到某个位置之后也会执行）
     *              (1). - (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
     *                 //导航方向发生变化后执行
     *              (2). - (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
     *                 //进入某个区域之后执行
     *              (3). - (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
     *                 //走出某个区域之后执行
     *              (4). - (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
     */
    return _locationManager;
    
}
#pragma mark - 地理编码

- (CLGeocoder *)geocoder
{
    if(!_geocoder){
        
        _geocoder = [[CLGeocoder alloc]init];
        
    }
    
    return _geocoder;
    
}
/**
 *  iOS4 available
 */
- (void)setUPGeocoder
{
//    MKReverseGeocoder *geocoder = [[MKReverseGeocoder alloc]initWithCoordinate:self.myLocation.coordinate];
//    geocoder.delegate = self;
//    //启动gecoder
//    [geocoder start];
}
/**
 *  @brief >= iOS8
 */
- (void)test1 {
    //[self test1];
    // 1. 实例化定位管理器
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    // 2. 设置代理
    manager.delegate = self;
    // 3. 定位精度
    [manager setDesiredAccuracy:kCLLocationAccuracyBest];
    /**
     * 4.请求用户权 限：分为：
     *                  1`requestWhenInUseAuthorization只在前台开启定位
     *                  2`requestAlwaysAuthorization在后台也可定位
     * 注意：建议只请求1和2中的一个，如果两个权限都需要，只请求2即可
     *12这样的顺序，将导致 bug：第一次启动程序后，系统将只请求1的权限，2的权限系统不会请求，只会在下一次启动应用时请 求2
     */
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8)
    {
        [manager requestWhenInUseAuthorization]; //?只在前台开启定位
        [manager requestAlwaysAuthorization];//?在后台也可定位
    }
    // 5.iOS9新特性：将允许出现这种场景：同一app中多个location manager：一些只能在前台定位，另一些可在后台定位（并可随时 禁止其后台定位）。
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9)
    {
        manager.allowsBackgroundLocationUpdates = YES;
    }
    // 6. 更 新用户位置
    [manager startUpdatingLocation];
    /**
     *  NSLocationAlwaysUsageDescription       String  XXX 请求后台定位权限
     *  Required background modes                   Array
     *                        item0             App register for location updates.
     */
}
@end
