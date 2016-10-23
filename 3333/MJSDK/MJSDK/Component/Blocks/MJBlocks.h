//
//  MJBlocks.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/26.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJResponseDataModels.h"
//@class MJResponseDataModels;
//@class MJImpAds;
//@class MJResponse;

#pragma mark - /***************_MJBaseDataManager_***************/
typedef void(^kRequestSuccessBlock)(MJResponse *_Nullable mjResponse, NSDictionary *_Nullable responseObject);
typedef void(^kRequestErrorBlock)(NSURLResponse *_Nullable response, NSError *_Nullable error);
typedef NSDictionary *_Nullable(^kRRRequestSuccessBlock)(MJResponse *_Nullable mjResponse);
typedef NSDictionary *_Nullable(^kRRRequestErrorBlock)(NSURLResponse *_Nullable response, NSError *_Nullable error);

//void(^_Nonnull kMJGotoExposureBlock)(MJImpAds *_Nonnull impAds);
typedef void(^kMJGotoExposureBlock)(MJImpAds *_Nullable impAds);

typedef void(^kMJExposureSuccessBlock)(void);
typedef void(^kMJExposureFailureBlock)(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nullable error);

typedef void(^kMJBaseBlock)(void);
//typedef void(^kMJBannerDismissBlock)(void);
typedef void(^kMJLoadDataSuccess)(MJResponse *_Nullable mjResponse, NSDictionary *_Nullable responseObject);
typedef BOOL(^kMJBaseTestBlock)(BOOL success);

typedef void(^kMJShareBlock)(NSDictionary * _Nullable params);
typedef void(^kMJClaimFailedBlock) (NSURLSessionDataTask * _Nullable dataTask, NSError * _Nullable error);



#pragma mark -
#pragma mark - MJShare
typedef void(^SuccessBlockType) (NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject);
typedef void(^FailedBlockType) (NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error);

//***********
typedef NS_ENUM(NSInteger, KMJShareStep) {
    KMJShareUnknownStep = 0,
    KMJShareFirstStep = 1,
    KMJShareSecondStep = 2,
    KMJShareThirdStep = 3,
    KMJShareFourthStep = 4,
    KMJShareFifthStep = 5,
    KMJShareSixthStep = 6
};
//void (^kMJGotoStepBlockBlock)(KMJShareStep step);
typedef void(^kMJGotoStepBlockBlock)(KMJShareStep step);

//void (^kMJModifyBlock)(KMJShareStep step);
//typedef void(^kMJModifyBlock)(KMJShareStep step);

//void (^kGetBlock)(KMJShareStep step);
typedef void(^kMJGetBlock)(KMJShareStep step);

//0`network
//1.banner
//2`apps
//3`coupon
//4`prop
typedef void(^kMJPropManagerBlock)(NSDictionary *_Nullable params);



//MJBaseApps.h
typedef void(^kMJAppsCellClickedBlock)(NSIndexPath *_Nullable indexPath);

typedef void(^kMJAppsGetPropBlock)(void);

//typedef void(^kMJAppsShowToastBlock)(NSString *_Nullable toastString, BOOL dismiss);

@interface MJBlocks : NSObject

@end
