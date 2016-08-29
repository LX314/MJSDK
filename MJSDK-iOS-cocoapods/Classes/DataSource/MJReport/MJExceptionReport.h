//
//  MJExceptionReport.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/28.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Mantle.h"

@class MJExceptionMsg;

@interface MJExceptionReport : MTLModel<MTLJSONSerializing>
{

}
@property (nonatomic, strong)MJExceptionMsg *msg;
@property (nonatomic, assign)NSInteger code;
@property (nonatomic, strong)NSString *desc;

+ (instancetype)reportWithADSpaceID:(NSString *)adspaceID code:(NSInteger)code description:(NSString *)desc;

@end

@interface MJExceptionMsg : MTLModel<MTLJSONSerializing>
{

}
@property (nonatomic, strong)NSString *idfa;
@property (nonatomic, strong)NSString *bundleId;
@property (nonatomic, strong)NSString *appKey;
@property (nonatomic, strong)NSString *imei;
@property (nonatomic, strong)NSString *adspaceId;
@property (nonatomic, strong)NSString *errorTime;
@property (nonatomic, strong)NSString *adId;


@end
