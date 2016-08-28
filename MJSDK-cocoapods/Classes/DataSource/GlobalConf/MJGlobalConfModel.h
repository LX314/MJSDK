//
//  MJGlobalConf.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/8/12.
//  Copyright © 2016年 WM. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Mantle.h"
/**
 *  MJSDK 全局配置文件
 */
@interface MJGlobalConfModel : MTLModel<MTLJSONSerializing>
{

}
/** 当前设置版本号*/
@property (nonatomic,assign)CGFloat version;
/** 默认广告版本号*/
@property (nonatomic,assign)CGFloat defaultAdVersion;
/** 一次广告请求数*/
@property (nonatomic,assign)NSInteger adRequestCount;
/** boolean 是否显示优惠券*/
@property (nonatomic,assign)BOOL displayCoupon;
/** 曝光生效时间(ms)*/
@property (nonatomic,assign)CGFloat exposurePeriod;
/** 广告切换间隔(ms)*/
@property (nonatomic,assign)CGFloat adSwitchInterval;
/** 是否优惠券商品可以点击*/
@property (nonatomic,assign)BOOL isCouponAdClickable;
/** 是否再次显示优惠券信息页*/
@property (nonatomic,assign)BOOL displayCouponAgain;
/** 获取配置时的时间*/
//@property (nonatomic,copy) NSString *date;
/** <#注释#>*/
@property (nonatomic,retain)NSDateComponents *components;

+ (void)loadServerGlobalConf;

@end
/**{
"version": 1,//当前设置版本号
 "data": {
 "defaultAdVersion": 0,//默认广告版本号
 "adRequestCount": 5,//一次广告请求数
 "displayCoupon": 1,//boolean 是否显示优惠券
 "exposurePeriod": 200,//曝光生效时间
 "adSwitchInterval": 30000,//广告切换间隔
 "isCouponAdClickable": 1,//是否优惠券商品可以点击
 "displayCouponAgain": 1//是否再次显示优惠券信息页
 }
}*/
