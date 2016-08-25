
//  MJDataManager.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/5/30.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJDataManager.h"

#warning TODO 1
//#import "Encrypt.h"
#import "MJTool.h"
#import "MJError.h"
#import "LXLocationManager.h"
#import "MJExceptionReportManager.h"

@interface MJDataManager ()<LXLocationManagerDelegate>
{
    
}

@end
@implementation MJDataManager
- (instancetype)init {
    if (self = [super init]) {
        [self getMyLocation];
    }
    return self;
}
+ (instancetype)manager {
    static MJDataManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[[self class] alloc]init];
    });
    return _sharedInstance;
}
/**
 *  获取当前用户地理位置
 */
- (void)getMyLocation {
    LXLocationManager *manager = [LXLocationManager manager];
    manager.delegate = self;
    [manager getMyLocation];
}
#pragma mark - loadData
/**
 *  请求广告数据
 *
 *  @param params       params
 *  @param adType       adType
 *  @param successBlock successBlock
 *  @param errorBlock   failueBlock
 */
- (void)loadData:(NSDictionary *)params adType:(KMJADType)adType successBlock:(kRequestSuccessBlock)successBlock errorBlock:(kRequestErrorBlock)errorBlock {
    //encrypt
    #warning TODO 2
    NSString *dst;// = [Encrypt encrypt:params];
    NSString *adSpaceID = params[@""];
    //封装 request
    NSMutableURLRequest *murequest = [[AFJSONRequestSerializer serializer] requestWithMethod:@"post" URLString:kMJSDKProtoAPI parameters:nil error:nil];
    murequest.timeoutInterval= kMJSDKTimeoutInterval;
    [murequest setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    [murequest setValue:@"text/html" forHTTPHeaderField:@"Accept"];
    [murequest setHTTPBody:[dst dataUsingEncoding:NSUTF8StringEncoding]];

    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:murequest completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORPOSTRequestFailure description:[NSString stringWithFormat:@"请求 %@ 类型数据时发生错误\n\nerror.localizedDescription:%@", KNSStringFromMJADType(adType), error.localizedDescription]];
            [MJExceptionReportManager insertOffLineExceptionReport:report];
            if (errorBlock) {
                errorBlock(response, error);
            }
            NSLog(@"%@", report.desc);
            return;
        }
//        NSString *json = [MJTool toJsonString:responseObject];
        MJResponse *mjResponse;
        {
            MJError *error_t;
            mjResponse = [MTLJSONAdapter modelOfClass:[MJResponse class] fromJSONDictionary:responseObject error:&error_t];
            if (error_t) {
                MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:adSpaceID code:kMJSDKERRORADModelFailure description:[NSString stringWithFormat:@"ERROR:%@\r\nresponseObject:%@", error_t, responseObject]];
                [MJExceptionReportManager insertOffLineExceptionReport:report];
                NSLog(@"package the model failure");
                if (errorBlock) {
                    errorBlock(response, error);
                }
                return;
            }
        }
        if (mjResponse.code != 100) {
            //请求数据成功,但 code 异常
            MJError *error = [MJError errorWithDomain:@"请求成功,但 code 显示为异常" code: kMJSDKERRORResponseSuccessButNotFitCode userInfo:@{@"old_response":[responseObject description]}];
            MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:kMJSDKERRORResponseSuccessButNotFitCode description:[NSString stringWithFormat:@"请求成功,但 code 显示为异常,old_response:%@", [responseObject description]]];
            [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
            if (errorBlock) {
                errorBlock(response, error);
            }
            return;
        }
        NSDictionary *localResponseObject;
        if (mjResponse.impAds.count <= 0) {
            MJError *error_t = [MJError errorWithDomain:[NSString stringWithFormat:@"[%@]无返回数据[mjResponse.impAds]",KNSStringFromMJADType(adType)] code: kMJSDKERRORADResponseSuccessButNOImpAdsCount userInfo:@{@"old_response":[responseObject description]}];
            MJExceptionReport *report = [MJExceptionReport reportWithADSpaceID:@"" code:error_t.code description:[NSString stringWithFormat:@"%@", error]];
            [MJExceptionReportManager uploadOnlineExceptionReport:@[report]];
        }
        if (successBlock) {
            successBlock(mjResponse, responseObject);
        }
    }];
    [dataTask resume];
}
#pragma mark -
#pragma mark - Necessary Info
/**
 *  配置请求 request
 *
 *  @param eventID   eventID
 *  @param adlocCode adlocCode
 *  @param adCount   adCount
 */
- (void)setEventID:(NSString *)eventID adlocCode:(NSString *)adlocCode adCount:(NSInteger)adCount {
    NSMutableDictionary *request_t = self.requestManager.request;
    NSMutableDictionary *impression_t = request_t[@"impression"];
    request_t[@"event_id"] = eventID;
    impression_t[@"adloc_code"] = adlocCode;
    impression_t[@"ad_count"] = @(adCount);
}

- (void)coordinate2D:(CLLocationCoordinate2D )coordinate{
    MJJLatitude = coordinate.latitude;
    MJJLongitude = coordinate.longitude;
    //
    NSMutableDictionary*geo = self.requestManager.request[@"device"][@"geo"];
    geo[@"longitude"] = @(MJJLatitude);
    geo[@"latitude"] = @(MJJLongitude);
}

#pragma mark - requestManager
- (MJRequestManager *)requestManager
{
    if(!_requestManager){
        _requestManager = [MJRequestManager manager];
    }
    return _requestManager;
}
@end
