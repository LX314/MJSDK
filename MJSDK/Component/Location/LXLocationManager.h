//
//  LocationManager.h
//  RacingFund
//
//  Created by FairyLand on 15/3/6.
//  Copyright (c) 2015年 fulan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol LXLocationManagerDelegate <NSObject>

@optional
- (void)coordinate2D:(CLLocationCoordinate2D)coordinate;
- (void)city:(NSString *)city;

@end

@interface LXLocationManager : NSObject
{
    
}
@property(nonatomic,retain)LXLocationManager *manager;
/** <#注释#>*/
@property (nonatomic,assign)id<LXLocationManagerDelegate> delegate;

+ (instancetype)manager;
+ (void)getMyLocation;
- (void)getMyLocation;


@end
