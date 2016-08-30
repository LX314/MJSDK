//
//  MJViewController.m
//  MJSDK-iOS-cocoapods
//
//  Created by LX314 on 08/29/2016.
//  Copyright (c) 2016 LX314. All rights reserved.
//

#import "MJViewController.h"

#import "MJBannerManager.h"
#import "MJInterstitialManager.h"
#import "MJInlineManager.h"
#import "MJAppsManager.h"

@interface MJViewController ()
{

}
/** <#注释#>*/
@property (nonatomic,retain)MJBannerManager *bannerManager;
@property (nonatomic,retain)MJInterstitialManager *interstitialManager;
@property (nonatomic,retain)MJInlineManager *inlineManager;
@property (nonatomic,retain)MJAppsManager *appsManager;

@end

@implementation MJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //
}
- (IBAction)btnManagerClick:(id)sender {
    switch ([sender tag]) {
        case 111: {
            [self.bannerManager show];
            break;
        }
        case 222: {
            [self.interstitialManager show];
            break;
        }
        case 333: {
            [self.inlineManager show];
            break;
        }
        case 444: {
            [self.appsManager show:^{
                NSLog(@"appsManager");
            }];
            break;
        }
        default:
            break;
    }
}
#pragma mark - manager
- (MJBannerManager *)bannerManager
{
    if(!_bannerManager){
        _bannerManager = [[MJBannerManager alloc]initWithAdSpaceID:@"a6c1deb4-29c4-4386-9729-dc2f97557702" position:KMJADTopPosition];
    }
    return _bannerManager;
}
#pragma mark - interstitialManager
- (MJInterstitialManager *)interstitialManager
{
    if(!_interstitialManager){
        _interstitialManager = [[MJInterstitialManager alloc]initWithAdSpaceID:@"311b1579-235b-4722-a7f0-8c2c55d934d0"];

    }

    return _interstitialManager;
}
#pragma mark - inlineManager
- (MJInlineManager *)inlineManager
{
    if(!_inlineManager){
        _inlineManager = [[MJInlineManager alloc]initWithAdSpaceID:@"21e2126f-b5c7-49ab-9a44-5a3c690929c1"];

    }

    return _inlineManager;
}
#pragma mark - appsManager
- (MJAppsManager *)appsManager
{
    if(!_appsManager){
        _appsManager = [[MJAppsManager alloc]initWithAdSpaceID:@"7ed68283-1180-47fa-ab47-2a253694e341" props_id:@"props_id" price:333];

    }

    return _appsManager;
}



@end
