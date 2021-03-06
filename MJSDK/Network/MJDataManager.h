//
//  MJDataManager.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/5/30.
//  Copyright © 2016年 WM. All rights reserved.
//
#import "MJBaseDataManager.h"

@class MJRequestManager;

#define kUSELXTymeMJSDK @"com.lxthyme.mjsdkkkkk"
//#define kUSEDefaultMJSDK @"com.mj.mjsdk"

static NSString *kBannerIMGADSpaceID =
#ifdef kUSEDefaultMJSDK
@"41be4d44-b8e6-4aff-ba85-71f591967b09";
#else
@"01c0baca-860e-11e6-8c73-a4dcbef43d46";
#endif

static NSString *kBannerGLADSpaceID =
#ifdef kUSEDefaultMJSDK
@"6c15eabd-9d3d-4162-9037-aa08a32e8b88";
#else
@"01c0baca-860e-11e6-8c73-a4dcbef43d46";
#endif

static NSString *kInterstitialIMGADSpaceID = //@"d6f18dc3-7360-4ba5-9db7-5915219405ad";
#ifdef kUSEDefaultMJSDK
@"b3667e29-d2b9-4688-b615-162b072747e6";
#else
@"3844852f-860e-11e6-8c73-a4dcbef43d46";
#endif

static NSString *kInterstitialGLADSpaceID = //@"e3037694-7423-4bbd-899b-edafea9466eb";
#ifdef kUSEDefaultMJSDK
@"f4a6b1eb-dd48-43e5-a3da-85122397c2c0";
#else
@"3844852f-860e-11e6-8c73-a4dcbef43d46";
#endif


static NSString *kInlineIMGADSpaceID = //@"0c99beed-ce9d-4f22-ba94-561d8766ee49";
#ifdef kUSEDefaultMJSDK
@"cd14e1f0-3440-406b-88b8-6dd91ea102a7";
#else
@"2ad56e28-860e-11e6-8c73-a4dcbef43d46";
#endif

static NSString *kInlineGLADSpaceID = //@"8e0dfb42-7ca3-45e8-82a9-b704952e9e2d";
#ifdef kUSEDefaultMJSDK
@"efb3b23a-362f-4269-beb2-01fa2b571fbc";
#else
@"2ad56e28-860e-11e6-8c73-a4dcbef43d46";
#endif

static NSString *kInlineIMGShareADSpaceID = //@"b7e54097-d794-4622-9ad2-f3daef8dc7a5";
#ifdef kUSEDefaultMJSDK
@"86fa7fad-d926-414f-8569-314cff71ae63";
#else
@"42bc3bc0-8d40-4614-903d-086cc9fd3efc";
#endif

static NSString *kInlineGLShareADSpaceID = //@"effbfc6a-48f9-4f16-8f07-cad9c7d4f269";
#ifdef kUSEDefaultMJSDK
@"0a344151-356d-459f-8626-e80fcac61e2d";
#else
@"dee00637-5c61-4822-b1cb-972e93012d05";
#endif

static NSString *kHalfOpenScreen = //@"9aaad94a-2a25-4836-8735-42c02d1e46ee";
#ifdef kUSEDefaultMJSDK
@"7c7543ae-7918-4515-a21f-3471b44b0c11";
#else
@"4012dd45-860e-11e6-8c73-a4dcbef43d46";
#endif

static NSString *kFullOpenScreen = //@"efd00682-fc21-46cd-9f18-166be763d057";
#ifdef kUSEDefaultMJSDK
@"eef9e7d1-8f5d-4367-85a2-234f40e1909e";
#else
@"4012dd45-860e-11e6-8c73-a4dcbef43d46";
#endif

static NSString *kAppsADSpaceID = //@"97044aa3-c298-4067-8e05-7bad81483dbb";
#ifdef kUSEDefaultMJSDK
@"745fd065-8d83-4be8-b1b4-c3ab689be3b5";
#else
@"4ecb372f-860e-11e6-8c73-a4dcbef43d46";
#endif

/**
 *  @brief 请求各种类型的广告数据
 *      目前支持的类型有:
 *              banner, interstitial, inline, apps, full/half openscreen
 */
@interface MJDataManager : MJBaseDataManager
{
    
}
/** request 数据源 manager*/
@property (nonatomic,retain)MJRequestManager *requestManager;

+ (instancetype)manager;

#pragma mark -
#pragma mark - 加载数据
/**
 *  请求广告数据
 *
 *  @param params        params
 *  @param adType       adType
 *  @param successBlock successBlock
 *  @param errorBlock   failueBlock
 */
- (void)loadData:(NSDictionary *)params adType:(KMJADType)adType successBlock:(kRequestSuccessBlock)successBlock errorBlock:(kRequestErrorBlock)errorBlock;
/**
 *  配置请求 request
 *
 *  @param eventID   eventID
 *  @param adlocCode adlocCode
 *  @param adCount   adCount
 */
- (void)setEventID:(NSString *)eventID adlocCode:(NSString *)adlocCode adCount:(NSInteger)adCount;
@end
