//
//  MJViewController.m
//  MJJSDK
//
//  Created by LX314 on 05/23/2016.
//  Copyright (c) 2016 LX314. All rights reserved.
//

#import "ViewController.h"

#import "MJDataManager.h"
#import "MJOpenScreen.h"
#import "MJShare.h"

#import "UIImage+imageNamed.h"
#import "UIImageView+placeholder.h"
#import "MJExceptionReportManager.h"
#import "UIImage+cached.h"

#import "MJBanner.h"
#import "MJAppsWall.h"



@interface ViewController ()<MJADDelegate>
{

    
    __weak IBOutlet UIImageView *_imgView;
    __weak IBOutlet UITextField *_textField_price;

    NSString *_receiptID;
    __weak IBOutlet UIButton *_btnPrice400;
    
    NSString *_bannerTopAdspaceID;
    NSString *_bannerBottomAdspaceID;
    NSString *_interstitialAdspaceID;
    NSString *_inlineAdspaceID;

    CGFloat _price;
    //
    __weak IBOutlet UIButton *_bannerTop;
}
/** <#注释#>*/
//@property (nonatomic,retain)MJBanner *manager;
//
//@property (nonatomic,retain)MJBanner *bannerTop;
@property (nonatomic,retain)MJBanner *jjBannerTop;
//@property (nonatomic,retain)MJBanner *bannerBottom;
@property (nonatomic,retain)MJBanner *jjBannerBottom;
//@property (nonatomic,retain)MJInterstitial * interstitial1;
@property (nonatomic,retain)MJBanner * interstitial1;
//@property (nonatomic,retain)MJInline * inline1;
@property (nonatomic,retain)MJBanner * inline1;
@property (nonatomic,retain)MJOpenScreen * fullOpen1;
@property (nonatomic,retain)MJOpenScreen * halfOpen1;
//@property (nonatomic,retain)MJAppsWall * apps1;
@property (nonatomic,retain)MJAppsWall * apps1;
//@property (nonatomic,retain)MJShare *mjShare;
//@property (nonatomic,retain)SecondVC *secondVC;
//
//- (IBAction)btnShowAlertADView:(id)sender;

@end

@implementation ViewController

- (void)gotoURL {
    
//    NSString * url = ((AppDelegate *)[UIApplication sharedApplication].delegate).url;
//    //    NSString * url = [[NSUserDefaults standardUserDefaults]objectForKey:@"url"];
//    NSLog(@"%@",url);
//    if (!url) {
//        return;
//    }
//    if ([url rangeOfString:@"openIMGBanner"].location != NSNotFound) {
//        
//        self.bannerTop.adSpaceID = kBannerIMGADSpaceID;
//        [self.bannerTop show];
//        
//    } else if ([url rangeOfString:@"openIMGInterstitial"].location != NSNotFound) {
//    
//        self.interstitial1.adSpaceID = kInterstitialIMGADSpaceID;
//        [self.interstitial1 show];
//       
//    } else if ([url rangeOfString:@"openGLInline"].location != NSNotFound) {
//    
//        self.inline1.adSpaceID = kInlineGLADSpaceID;
//        [self.inline1 show];
//    }
}
//
- (void)viewDidLoad {
    [super viewDidLoad];
    _bannerTopAdspaceID = kBannerIMGADSpaceID;
    _bannerBottomAdspaceID = kBannerGLADSpaceID;
    _interstitialAdspaceID = kInterstitialIMGADSpaceID;
    _inlineAdspaceID = kInlineGLADSpaceID;
    
    

//    // Do any additional setup after loading the view, typically from a nib.
//    //
//    [self initSwitch];
//    //
//    self.title = @"首页";
//    //
//    //    NSArray *fonts = [UIFont familyNames];
//    //    NSLog(@"Fonts:%@",fonts);
//    
////    [SDKProtoTest testRequest];
////    [SDKProtoTest testResponse];
//    //
////    [[MJView manager]registerNotifications];
//    //
////    [self initial2];
//    //
////    [self test1];
//    //
////    [self test2];
//    //
////    [self test4];
//    //
////    [self test5];
//    //
////    [self test6];
//    //
////    [self test7];
//    //
////    [self test8];
//    //
////    [self test9];
//    //
////    [self test10];
//    //
////    [self test11];
//    //
////    [self test12];
//    //
////    [self test13];
//    //
////    NSDictionary *dd = nil;
////    dd[@""];
//    [self testOne];
////    [self test16];
//    //
////    [self test17];
//    //
////    [self test18];
////    MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"1111" code:123456 description:[NSString stringWithFormat:@"异常上报[在线](POST)-failure:%@",@"error"]];
////    NSString *idd = report.msg.adspaceId;
////    NSDictionary *dict = [MTLJSONAdapter JSONDictionaryFromModel:report error:nil];
    //
    [_bannerTop setAccessibilityLabel:@"banner-top-001"];
    [_bannerTop setIsAccessibilityElement:YES];
    //

    NSLog(@"NSLog:价格设置不合理,请重试");
    MJNSLog(@"MJNSLog:价格设置不合理,请重试");
}
//
//- (void)test1 {
//    //
////    [[LXIPManager manager]carrierINIT];
////    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"Info" ofType:@"plist"];
////    NSString *filePath2 = [[NSBundle mainBundle]pathForResource:@"README" ofType:@"txt"];
//////    NSString *plist = [[NSString alloc]initWithContentsOfFile:filePath2 encoding:NSUTF8StringEncoding error:nil];
////    NSString *readME = [[NSString alloc]initWithContentsOfFile:filePath2 encoding:NSUTF8StringEncoding error:nil];
////    readME = [[NSString alloc]initWithFormat:@"%@\n\nqq.com\n----LXThyme",readME];
////    BOOL writeSuccess = [readME writeToFile:filePath2 atomically:YES encoding:NSUTF8StringEncoding error:nil];
////    NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
////    plist = [[NSBundle mainBundle] infoDictionary];
////    NSString *filepath3 = NSHomeDirectory();
////    NSMutableArray *schemes = [plist[@"LSApplicationQueriesSchemes"] mutableCopy];
////    [schemes addObject:@"qq.com111"];
////    [plist setObject:schemes forKey:@"LSApplicationQueriesSchemes"];
////    BOOL success = [plist writeToFile:filePath atomically:YES];
//}
//- (void)test4 {
//    //
////    MJBannerManager *bannerTop = [[MJBannerManager alloc]init];
////    [bannerTop show];
//}
//- (void)test5 {
//    //
////    MJCouponManager *manager = [MJCouponManager manager];
////    [manager loadQuery];
////    [manager loadClaim];
////    [manager loadUpdate:^(NSDictionary *params) {
////        BOOL success = [params[@"success"] boolValue];
////        if (success) {
////            NSLog(@"修改成功!");
////        }
////    }];
//}
//- (void)test6 {
//    //
//    NSInteger ind1 = 2;
//    NSInteger ind2 = 1;
//    NSInteger result = ind1 >> ind2;
//    NSLog(@"result:%ld",result);
//}
//- (void)test7 {
//    //[self test7];
////    [MJExceptionReportManager testUploadOnlineData:nil];
////    [MJExceptionReportManager testUploadOfflineData:nil];
//    [MJExceptionReportManager testUploadExceptionData:nil];
//}
//- (void)test8 {
//    //
////    MJPropManager *manager = [[MJPropManager alloc]init];
//////    manager
////    [MJPropManager query:^(NSDictionary *params) {
////        //
////    }];
//}
//- (void)test9 {
//    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"banner" ofType:@"json"];
//    NSString *impAds = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
//    NSDictionary *dict_impAds = [NSJSONSerialization JSONObjectWithData:[impAds dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
//    NSError *error;
//    MJResponse *response = [MTLJSONAdapter modelOfClass:[MJResponse class] fromJSONDictionary:dict_impAds error:&error];
//    NSLog(@"Response:%@", response);
//}
//- (void)test10 {
//    
//    NSString *url = @"http://download.pchome.net/wallpaper/pic-4270-15-720x1280.jpg";
//    [UIImage mj_setImageWithURLString:url placeholderImage:nil success:nil failure:nil];
//}
//- (void)test101 {
//
//    NSString *url = @"http://download.pchome.net/wallpaper/pic-4270-15-720x1280.jpg";
//    [_imgView mj_setImageWithURLString:url placeholderImage:nil impAds:nil success:nil failure:nil];
//}
//- (IBAction)btnCachedTest:(id)sender {
//    if ([sender tag] == 111) {
//        [self test10];
//    } else {
//        [self test101];
//    }
//}
//
//- (IBAction)btnBack:(id)sender {
//    
//    NSURL * url = [NSURL URLWithString:@"mjsdkrel://"];
//    if ([[UIApplication sharedApplication]canOpenURL:url]) {
//        [[UIApplication sharedApplication]openURL:url];
//    } else {
//    
//        NSLog(@"没有安装此APP");
//    
//    }
//
//}
//
//- (void)test11 {
//    //
//    CGFloat index = 11111.2f;
//    NSLog(@"index:%f",index);
////    
////    [MJSDKUtils registerWithAPPKey:@"app_key"];
////    
////    [MJSDKUtils registerWechatShareWithAppKey:@"app_key" appSecret:@"app_secret"];
//    
////    [MJSDKUtils openDebugStyle];
////    NSLog(@"index:%ld",index);
//}
//- (NSDateComponents *)getDateComponentsFromDate:(NSDate *)fromdate {
//    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
//    NSDateComponents *components = [calendar components:NSCalendarUnitYear |
//                                    NSCalendarUnitMonth |
//                                    NSCalendarUnitDay
//                                               fromDate:fromdate];
//    return components;
//}
//- (NSDateComponents *)getDateIntervalFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
//    NSCalendar *calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
//    NSDateComponents *components = [calendar components:NSCalendarUnitYear |
//                                    NSCalendarUnitMonth |
//                                    NSCalendarUnitDay
//                                               fromDate:fromDate toDate:toDate options:NSCalendarWrapComponents];
//    return components;
//}
//- (void)test12 {
////    MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"111" code:333 description:@"test"];
////    [MJExceptionReportManager insertOffLineExceptionReport:report];
//    [MJExceptionReportManager autoUploadOfflineExceptionReport];
////    [MJExceptionReportManager insertOffLineExceptionReport:report];
////    [MJExceptionReportManager clearAllOfflineReportData];
//    [MJExceptionReportManager autoUploadOfflineExposureReport];
////    [MJExceptionReportManager clearAllOfflineExposureReport];
////    MJCouponManager *manager = [MJCouponManager manager];
////    [manager loadUpdate:^(NSDictionary *params) {
////        BOOL success = [params[@"success"] boolValue];
////        if (success) {
////            NSLog(@"修改成功!");
////            [MJTool saveMJShareTEL:@"13462318935"];
////            
////        }
////    } updatephoneNumber:@"13462318935"];
//    
//}
//- (void)test13 {
//    //[self test13];
//    LXIPManager *ipManager = [[LXIPManager alloc]init];
//    NSString *idfa = ipManager.idfa;
//    NSLog(@"IDFA:%@", idfa);
//}
//- (void)test14 {
//    //
////    NSDate *date = [NSDate date];
////    NSString *dateString = [date descriptionWithLocale:@"en_US"];//en_US||zh_Hans_CN
////    NSString *dateString2 = [date descriptionWithLocale:@"zh_Hans_CN"];
////    NSString *utcDateString = [MJTool getUTCFormateLocalDate:dateString];
////    NSString *localDateString = [MJTool getLocalDateFormateUTCDate:utcDateString];
////    NSDate *bjDate = [MJTool revertToBJTimeZone:date];
////    [MJTool getInernetUTCDate:^(NSDate *utcDate) {
////        NSLog(@"Current BJ date:%@", utcDate);
////    }];
//    /**
//     *  2016-08-18 03:33:56 +0000
//     *  2016-08-19 03:35:20 +0000
//     *  2016-08-19 03:36:19 +0000
//     *  2016-10-16 18:03:25 +0000
//     */
//    NSDictionary *oldDict = @{
//                              @"2658" : @"2016/08/17 17:45:09",
//                              @"2660" : @"2016/08/17 17:45:22",
//                              @"2662" : @"2016/08/17 17:45:51",
//                              @"2663" : @"2016/08/17 17:46:10",
//                              @"2664" : @"2016/08/18 10:30:53",
//                              @"2667" : @"2016/08/18 10:31:04",
//                              @"2669" : @"2016/08/18 10:31:12",
//                              };
//    NSString *json = [MJTool toJsonString:oldDict];
//    [SSKeychain setPassword:json forService:kMJAPPsHasSharedService account:kMJAPPsHasSharedAccount];
////    return;
//}
//- (void)test141 {
////    [self test143GMTDate];return;
////    [MJTool getInernetUTCDate:^(NSDate *utcDate) {
////        [MJTool clearTimeOutSharedData:utcDate];
////    }];
//    [MJTool clearTimeOutSharedData];
//    return;
////    __block NSInteger invID = 2770;
////    [MJTool getInernetUTCDate:^(NSDate *utcDate) {
////        NSString *dateString = @"Fri, 09 Aug 2016 15:17:57";
////        NSDate *date = [MJTool dateFromString:dateString format:nil];
////        NSMutableDictionary *mudict = [NSMutableDictionary dictionary];
////        __block NSDate *virtualDate = date;
////        for (NSInteger i = 0; i < 20; i ++) {
////            NSString *virtualDateString = [MJTool stringFromDate:virtualDate format:nil];//[MJTool dateFromString:timeString format:@"yyyy-MM-dd HH:mm:ssZ"];
////            NSString *invID_t = [NSString stringWithFormat:@"%ld", invID];
////            [mudict setObject:virtualDateString forKey:invID_t];
////            //
////            virtualDate = [virtualDate dateByAddingTimeInterval:24*60*60];
////            invID++;
////        }
////        NSString *json = [MJTool toJsonString:mudict];
////        [SSKeychain setPassword:json forService:kMJAPPsHasSharedService account:kMJAPPsHasSharedAccount];
////    }];
//}
//- (void)test142 {
////    NSString *string =
////    @"2016/08/19 09:47:59+0800";
////    @"2016/08/17 18:14:10+0800";
////    NSDate *datee = [MJTool dateFromString:string format:nil];
////    NSString *json0 = [MJTool stringFromDate:datee format:nil];
//
//    NSString *json = @"{\n  \"2779\" : \"2016/08/17 18:14:31 +0000\",\n  \"2783\" : \"2016/08/21 18:14:31 +0000\",\n  \"2772\" : \"2016/08/10 18:14:31 +0000\",\n  \"2788\" : \"2016/08/26 18:14:31 +0000\",\n  \"2777\" : \"2016/08/15 18:14:31 +0000\",\n  \"2781\" : \"2016/08/19 18:14:31 +0000\",\n  \"2770\" : \"2016/08/08 18:14:31 +0000\",\n  \"2786\" : \"2016/08/24 18:14:31 +0000\",\n  \"2775\" : \"2016/08/13 18:14:31 +0000\",\n  \"2784\" : \"2016/08/22 18:14:31 +0000\",\n  \"2773\" : \"2016/08/11 18:14:31 +0000\",\n  \"2789\" : \"2016/08/27 18:14:31 +0000\",\n  \"2778\" : \"2016/08/16 18:14:31 +0000\",\n  \"2782\" : \"2016/08/20 18:14:31 +0000\",\n  \"2771\" : \"2016/08/09 18:14:31 +0000\",\n  \"2787\" : \"2016/08/25 18:14:31 +0000\",\n  \"2776\" : \"2016/08/14 18:14:31 +0000\",\n  \"2780\" : \"2016/08/18 18:14:31 +0000\",\n  \"2785\" : \"2016/08/23 18:14:31 +0000\",\n  \"2774\" : \"2016/08/12 18:14:31 +0000\"\n}";
//    [SSKeychain setPassword:json forService:kMJAPPsHasSharedService account:kMJAPPsHasSharedAccount];
//    NSDictionary *dict = [MJTool toJsonObject:json];
//    NSLog(@"%ld", dict.count);
//}
//- (void)test143GMTDate {
//    NSDateFormatter *df = [[NSDateFormatter alloc]init];
//    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
//    [df setTimeZone:timeZone];
//    [df setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];//zh_Hans_CN
//    [df setDateFormat:@"dd MMM yyyy hh:mm:ss"];
//
////    NSString *dateString = @"19 Aug 2016 03:24:23";
////    NSDate *date = [df dateFromString:dateString];
//}
//- (void)test15 {
//    //
//    NSArray *array = @[
//                       @"1334567890",
//
//                       @"10345678901",
//                       @"11345678901",
//                       @"12345678901",
//                       @"13345678901",
//                       @"14345678901",
//                       @"15345678901",
//                       @"16345678901",
//                       @"17345678901",
//                       @"18345678901",
//                       @"19345678901",
//
//                       @"00345678901",
//                       @"10345678901",
//                       @"31345678901",
//                       @"42345678901",
//                       @"53345678901",
//                       @"64345678901",
//                       @"75345678901",
//                       @"86345678901",
//                       @"97345678901",
//                       ];
//    static NSInteger index = 0;
//    for (NSString *tel in array) {
//        BOOL isTel = [MJTool judgePhoneNumber:tel];
//        NSMutableString *mustring = [NSMutableString string];
//        if (isTel) {
//            [mustring appendFormat:@"[%ld]", ++index];
//        }
//        [mustring appendFormat:@"%@ isTel:%@", tel, isTel ? @"YES" : @"NO"];
//        NSLog(@"%@", mustring);
//    }
//    NSLog(@"All Tel Count:%ld", index);
//}
- (void)testOne {
    MJShare *mjShare = [[MJShare alloc]init];
    [mjShare showIn:nil];

}
//- (void)test16 {
//    for (NSInteger i = 0; i < 10; i ++) {
//        NSString *key = [NSString stringWithFormat:@"Loc_QueryProp_Status_%ld", i];
//        NSString *loc_doc = kMJNSLocalizedString(key, @"");
//        NSLog(@"%@:%@", key, loc_doc);
//    }
//}
//- (void)test17 {
////    NSDate *dateNow = [MJTool getBJDate];
////    NSString *dateString = [MJTool stringFromDate:dateNow format:nil];
////    NSDate *date = [MJTool dateFromString:dateString format:nil];
////    //
////    __block NSDate *utcDate_t;
////    __block NSString *utcDateString;
////    dispatch_group_t group = dispatch_group_create();
////    dispatch_queue_t queue = dispatch_queue_create("com.mj.mjsdk", DISPATCH_QUEUE_SERIAL);
////    dispatch_group_async(group, queue, ^{
////        [MJTool getInernetUTCDate:^(NSDate *utcDate) {
////            utcDate_t = utcDate;
////            utcDateString = [MJTool stringFromDate:utcDate_t format:nil];
////            NSLog(@"[1`]utcDateString:%@", utcDateString);
////        }];
////        sleep(1.001);
////    });
////    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
////    utcDateString = [MJTool stringFromDate:utcDate_t format:nil];
////    NSLog(@"[2`]utcDateString:%@", utcDateString);
//}
//- (void)test18 {
//    NSString *fileName = @"分享步骤@2x.jpg";
//    NSString *bundlePath = [[NSBundle mainBundle]pathForResource:@"MJSDK" ofType:@"bundle"];
//    NSString *filePath = [[NSBundle bundleWithPath:bundlePath]pathForResource:@"分享步骤@2x" ofType:@"jpg"];
//    NSLog(@"filePath:%@", filePath);
//}
//- (IBAction)btnRefreshPropStatusClick:(id)sender {
////    self.apps1.price = 400;
////    [self.apps1 queryPropAvailable:^(BOOL available) {
////        NSLog(@"Available:%@", available ? @"YES" : @"NO");
////        [_btnPrice400 setEnabled:available];
////    }];
//}
- (IBAction)btnShowAlertADView:(id)sender {
    switch ([sender tag])
    {
        case 110: {
            //yi分享信息
//            [MJTool getInernetUTCDate:^(NSDate *utcDate) {
//                [MJTool clearTimeOutSharedData:utcDate];
//            }];
//            [MJTool clearAllSharedData];
//            [MJExceptionReportManager clearAllOfflineExposureReport];
//            [MJExceptionReportManager clearAllOfflineExceptionReport];
            //
            break;
        }
        case 111://Banner
        {
            self.jjBannerTop.dismissBlock = ^(void){
                NSLog(@"dismiss-Block");
            };
            [self.jjBannerTop show];
            break;
        }
        case 1112://Banner
        {
            self.jjBannerBottom.dismissBlock = ^(void){
                NSLog(@"dismiss-Block");
            };
            [self.jjBannerBottom show];
            break;
        }
        case 112://插屏
        {
            self.interstitial1.dismissBlock = ^(void){
                NSLog(@"dismiss-Block");
            };
            [self.interstitial1 show];
            break;
        }
        case 113: {
            self.inline1.dismissBlock = ^(void){
                NSLog(@"dsimiss..");
            };
            [self.inline1 show];
            break;
        }
        case 1141:case 1142:case 1143:
        case 1144:case 1145:case 1146:{//应用墙RE
            NSInteger price = [_textField_price.text integerValue];
            if (price <= 0) {
                price = [sender tag] % 1140 * 100;
            }
            _price = price;
            _apps1 = nil;
//            self.apps1.parentVC = self;
//            self.apps1.price = price;
            [self.apps1 showIn:self];// closeBlock:^{
//                NSLog(@"apps1-show");
//            }];
            break;
        }
        case 115: {
            [self.fullOpen1 show];
            break;
        }
        case 116: {
            [self.halfOpen1 show];
            break;
        }
        case 117: {//MJShare

//            [self.mjShare showIn:nil];
            break;
        }
        case 118: {//Wechat
//            [self.mjShare show];
            break;
        }        default: {
            NSAssert(NO, @"发生错误!");
            break;
        }
    }//switch
}
//- (IBAction)btnRSClick:(id)sender {
//    switch ([sender tag]) {
//        case 111: {
//            if (_bannerTop && _bannerTop.timer) {
//                dispatch_suspend(_bannerTop.timer);
//            }
//            break;
//        }
//        case 222: {
//            if (_bannerTop && _bannerTop.timer) {
//                dispatch_resume(_bannerTop.timer);
//            }
//            break;
//        }
//        default:
//        {
//            NSAssert(NO, @"发生错误!");
//            break;
//        }
//    }//switch
//
//}
//- (IBAction)btnNextClick:(id)sender {
//    [self.bannerTop scrollToNext];
//}
//- (IBAction)switchValueChanged:(id)sender {
//}
//- (IBAction)btnLoadBundleCLick:(id)sender {
//    [_imgView setImage:[UIImage imageNamed:@"baby"]];
//}
//
//- (void)initSwitch {
//}
- (IBAction)adspaceIDChanged:(id)sender {
    NSInteger selectedIndex = [sender selectedSegmentIndex];
    NSInteger tag = [sender tag];
    switch (selectedIndex) {
        case 0: {//IMG
            if (tag == 111) {
                _bannerTopAdspaceID = kBannerIMGADSpaceID;_jjBannerTop = nil;
            } else if (tag == 222) {
                _bannerBottomAdspaceID = kBannerIMGADSpaceID;_jjBannerBottom = nil;
            } else if (tag == 333) {
                _interstitialAdspaceID = kInterstitialIMGADSpaceID;_interstitial1 = nil;
            } else if(tag == 444) {
                _inlineAdspaceID = kInlineIMGADSpaceID;_inline1 = nil;
            }
            break;
        }
        case 1: {//GL
            if (tag == 111) {
                _bannerTopAdspaceID = kBannerGLADSpaceID;_jjBannerTop = nil;
            } else if (tag == 222) {
                _bannerBottomAdspaceID = kBannerGLADSpaceID;_jjBannerBottom = nil;
            } else if (tag == 333) {
                _interstitialAdspaceID = kInterstitialGLADSpaceID;_interstitial1 = nil;
            } else if(tag == 444) {
                _inlineAdspaceID = kInlineGLADSpaceID;_inline1 = nil;
            }
            break;
        }
        case 2: {//IMG-share
            if(tag == 444) {
                _inlineAdspaceID = kInlineIMGShareADSpaceID;_inline1 = nil;
            }
            break;
        }
        case 3: {//GL-share
            if(tag == 444) {
                _inlineAdspaceID = kInlineGLShareADSpaceID;_inline1 = nil;
            }
            break;
        }
        default: {
            NSAssert(NO, @"发生错误!");
            break;
        }
    }//switch

}
//收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [_textField_price resignFirstResponder];
    
}

//- (NSInteger)getRandom{
//    return rand() % 20;
//}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
//    [_textField_price resignFirstResponder];
//}
//#pragma mark -
//#pragma mark - Masonry Methods
//- (void)updateViewConstraints{
//    [super updateViewConstraints];
//    //
//}
//- (void)masonry
//{//
//}
//- (void)initial
//{
//    /**
//     *初始化相关配置
//     *
//     */
//    UIDevice *device = [UIDevice currentDevice];
//    NSDictionary *dict_device = @{
//                                  @"name":device.name,// e.g. "My iPhone"
//                                  @"model":device.model,// e.g. @"iPhone", @"iPod touch"
//                                  @"localizedModel":device.localizedModel,// localized version of model
//                                  @"systemName":device.systemName,// e.g. @"iOS"
//                                  @"systemVersion":device.systemVersion,// e.g. @"4.0"
//                                  @"orientation":@(device.orientation),// return current device orientation.  this will return UIDeviceOrientationUnknown unless device orientation notifications are being generated.
//                                  //          @"identifierForVendor":device.identifierForVendor.UUIDString,//NS_AVAILABLE_IOS(6_0) a UUID that may be used to uniquely identify the device, same across apps from a single vendor
//                                  @"generatesDeviceOrientationNotifications":@(device.generatesDeviceOrientationNotifications),
//                                  //          @"batteryMonitoringEnabled":@(device.batteryMonitoringEnabled),//NS_AVAILABLE_IOS(3_0)
//                                  //          @"batteryState":@(device.batteryState),//NS_AVAILABLE_IOS(3_0)
//                                  //          @"batteryLevel":@(device.batteryLevel),//NS_AVAILABLE_IOS(3_0)
//                                  //          @"proximityMonitoringEnabled":@(device.proximityMonitoringEnabled),//NS_AVAILABLE_IOS(3_0)
//                                  //          @"proximityState":@(device.proximityState),//NS_AVAILABLE_IOS(3_0)
//                                  //          @"multitaskingSupported":@(device.multitaskingSupported),//NS_AVAILABLE_IOS(4_0)
//                                  //          @"userInterfaceIdiom":@(device.userInterfaceIdiom)//NS_AVAILABLE_IOS(3_2)
//                                  };
//    NSLog(@"Device:%@",dict_device);
//}
//#pragma mark -
//#pragma mark - MJADDelegate
//- (void)mjADRequestData:(UIView *)adView error:(NSError *)error{
//    NSLog(@"--->[mjADRequestData]adView:%@\t\terror:%@", adView, error);
//}
///**
// *  @brief 将要显示插屏广告时的回调
// *
// *  @param adView <#adView description#>
// *  @param error  <#error description#>
// */
//- (void)mjADWillShow:(UIView *)adView error:(NSError *)error{
//    NSLog(@"--->[mjADWillShow]adView:%@\t\terror:%@", adView, error);
//}
///**
// *  @brief 结束显示插屏广告时的回调
// *
// *  @param adView <#adView description#>
// *  @param error  <#error description#>
// */
//- (void)mjADDidEndShow:(UIView *)adView error:(NSError *)error{
//    NSLog(@"--->[mjADDidEndShow]adView:%@\t\terror:%@", adView, error);
//}
///**
// *  @brief 点击插屏广告时的回调
// *
// *  @param adView <#adView description#>
// *  @param error  <#error description#>
// */
//- (void)mjADDidClick:(UIView *)adView error:(NSError *)error{
//    NSLog(@"--->[mjADDidClick]adView:%@\t\terror:%@", adView, error);
//}
//// 用户点击广告的回调函数，一次展示仅会计入一次，即一次展示第一次点击时才会调用本方法。
//- (void)mjADDidExposure:(UIView *)adView error:(NSError *)error {
//    NSLog(@"--->[mjADDidExposure]adView:%@\t\terror:%@", adView, error);
//}
//#pragma mark - bannerTop
//- (MJBanner *)bannerTop
//{
//    if(!_bannerTop){
//         _bannerTop = [[MJBanner alloc]initWithAdSpaceID:kBannerIMGADSpaceID position:KMJADTopPosition];
////        _bannerTop.delegate = self;
//        if (kMJPreLoadData) {
//            [_bannerTop preloadData:nil];
//        }
//    }
//    return _bannerTop;
//}
//#pragma mark - bannerBottom
//- (MJBanner *)bannerBottom
//{
//    if(!_bannerBottom){
//        _bannerBottom = [[MJBanner alloc]initWithAdSpaceID:kBannerIMGADSpaceID position:KMJADBottomPosition];
//        //        _bannerTop.delegate = self;
//        if (kMJPreLoadData) {
//            [_bannerBottom preloadData:nil];
//        }
//    }
//    return _bannerBottom;
//}
//#pragma mark - interstitial1
//- (MJInterstitial *)interstitial1
//{
//    if(!_interstitial1){
//        _interstitial1 = [[MJInterstitial alloc]initWithAdSpaceID:kInterstitialIMGADSpaceID];
//        _interstitial1.delegate = self;
//        if (kMJPreLoadData) {
//            [self.interstitial1 preloadData:nil];
//        }
//    }
//    return _interstitial1;
//}
//#pragma mark - inline1
//- (MJInline *)inline1
//{
//    if(!_inline1){
//        _inline1 = [[MJInline alloc]initWithAdSpaceID:kInlineGLShareADSpaceID];
//        if (kMJPreLoadData) {
//            [self.inline1 preloadData:nil];
//        }
//    }
//    return _inline1;
//}
#pragma mark - fullOpen1
- (MJOpenScreen *)fullOpen1
{
    if(!_fullOpen1){
        _fullOpen1 = [MJOpenScreen registerFullOpenScreenWithAdSpaceID:kFullOpenScreen];
        if (kMJPreLoadData) {
            [self.fullOpen1 preloadData];
        }
    }
    return _fullOpen1;
}
#pragma mark - halfOpen1
- (MJOpenScreen *)halfOpen1
{
    if(!_halfOpen1){
        _halfOpen1 = [MJOpenScreen registerHalfOpenScreenWithAdSpaceID:kHalfOpenScreen ico:[UIImage mj_imageNamed:@"halfLogo@2x.png"] copyRight:@"Copyright © 2016年 WM. All rights reserved."];
        if (kMJPreLoadData) {
            [self.halfOpen1 preloadData];
        }
    }
    return _halfOpen1;
}
#pragma mark - apps1
- (MJAppsWall *)apps1
{
    if(!_apps1){
        _apps1 = [MJAppsWall registerAppsWallWithAdSpaceID:kAppsADSpaceID props_id:@"ios-appswall" price:_price];
    }
    return _apps1;
}
//#pragma mark - mjShare
//- (MJShare *)mjShare
//{
//    if(!_mjShare){
//        _mjShare = [[MJShare alloc]init];
//    }
//    return _mjShare;
//}
//#pragma mark - secondVC
//- (SecondVC *)secondVC
//{
//    if(!_secondVC){
//        _secondVC = [[SecondVC alloc]init];
//    }
//    return _secondVC;
//}
//
#pragma mark - jjBannerTop
- (MJBanner *)jjBannerTop
{
    if(!_jjBannerTop){
        _jjBannerTop = [MJBanner registerBannerWithAdSpaceID:_bannerTopAdspaceID position:KMJADTopPosition];
    }
    return _jjBannerTop;
}
#pragma mark - jjBannerBottom
- (MJBanner *)jjBannerBottom
{
    if(!_jjBannerBottom){
        _jjBannerBottom = [MJBanner registerBannerWithAdSpaceID:_bannerBottomAdspaceID position:KMJADBottomPosition];

    }

    return _jjBannerBottom;
}
#pragma mark - interstitial1
- (MJBanner *)interstitial1
{
    if(!_interstitial1){
        _interstitial1 = [MJBanner registerInterstitialWithAdSpaceID:_interstitialAdspaceID];
        _interstitial1.delegate = self;
        if (kMJPreLoadData) {
//            [self.interstitial1 preloadData:nil];
        }
    }
    return _interstitial1;
}
#pragma mark - inline1
- (MJBanner *)inline1
{
    if(!_inline1){
        _inline1 = [MJBanner registerInlineWithAdSpaceID:_inlineAdspaceID];
        if (kMJPreLoadData) {
//            [self.inline1 preloadData:nil];
        }
    }
    return _inline1;
}

@end

