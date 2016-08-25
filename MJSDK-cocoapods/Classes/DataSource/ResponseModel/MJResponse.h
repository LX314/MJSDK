//
//  MJResponse.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/21.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "Mantle.h"

#import "MJSDKConfiguration.h"

@interface MJResponse : MTLModel
{

}
/**  尚需分享的次数*/
@property (nonatomic,assign)NSInteger need_times;
//@property (nonatomic,assign)KMJADType mjAdType;

/** [应用墙专属]YES: 显示友好界面| NO: 正常界面*/
@property (nonatomic,assign)kMJAPPSContentState contentState;

/** YES:展示默认广告数据| NO: 正常情况*/
@property (nonatomic,assign)BOOL isMJSDKADDataDefault;

//origin
@property (nonatomic, assign) NSInteger code;
@property (nonatomic, assign) NSInteger serverTimestamp;
@property (nonatomic, strong) NSArray *impAds;
@property (nonatomic, strong) NSString *showUrl;
@property (nonatomic, strong) NSString *eventId;





@end
