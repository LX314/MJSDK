//
//  MJViewController.m
//  MJSDK-iOS-cocoapods
//
//  Created by LX314 on 08/29/2016.
//  Copyright (c) 2016 LX314. All rights reserved.
//

#import "MJViewController.h"

#import "MJBannerManager.h"

@interface MJViewController ()
{

}
/** <#注释#>*/
@property (nonatomic,retain)MJBannerManager *bannerManager;
@end

@implementation MJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
#pragma mark - bannerManager
- (MJBannerManager *)bannerManager
{
    if(!_bannerManager){
        _bannerManager = [[MJBannerManager alloc]initWithAdSpaceID:@"a6c1deb4-29c4-4386-9729-dc2f97557702" position:KMJADTopPosition];

    }

    return _bannerManager;
}


@end
