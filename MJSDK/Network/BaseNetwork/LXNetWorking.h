//
//  LXNetWorking.h
//  LXNetWorking
//
//  Created by John LXThyme on 16/5/10.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"

@class LXNetWorking;

@protocol LXNetworkingManagerDelegate <NSObject>


@optional
- (void)cleanData;
- (NSDictionary *_Nullable)reformParams:(NSDictionary *_Nullable)params;
- (BOOL)shouldCache;
- (void)managerCallAPIDidSuccess:(LXNetWorking *_Nullable)manager;
- (void)managerCallAPIDidFailed:(LXNetWorking *_Nullable)manager;

@end
@protocol LXDataSourcesManager <NSObject>
//@required
@optional
- (NSString *_Nullable)baseUrl;
- (NSDictionary *_Nullable)commonParams;

@end
@protocol LXParamValidatorManager <NSObject>

@optional
- (BOOL)manager:(LXNetWorking *_Nullable)manager isCorrectWithParamsData:(NSDictionary *_Nullable)data;
- (BOOL)manager:(LXNetWorking *_Nullable)manager isCorrectWithCallBackData:(NSDictionary *_Nullable)data;

@end
@protocol LXCallBackInterceptorManager <NSObject>

@optional
- (void)manager:(LXNetWorking *_Nullable)manager beforePerformSuccessWithSession:(AFHTTPSessionManager *_Nullable)sessionManager;
- (void)manager:(LXNetWorking *_Nullable)manager afterPerformSuccessWithResponse:(AFHTTPSessionManager *_Nullable)sessionManager;
- (void)manager:(LXNetWorking *_Nullable)manager beforePerformFailWithResponse:(AFHTTPSessionManager *_Nullable)sessionManager;
- (void)manager:(LXNetWorking *_Nullable)manager afterPerformFailWithResponse:(AFHTTPSessionManager *_Nullable)sessionManager;
- (BOOL)manager:(LXNetWorking *_Nullable)manager shouldCallAPIWithParams:(NSDictionary *_Nullable)params;
- (void)manager:(LXNetWorking *_Nullable)manager afterCallingAPIWithParams:(NSDictionary *_Nullable)params;

@end

typedef void (^LXSuccessBlock)(NSURLSessionDataTask *_Nullable task, id _Nullable responseObject);
typedef void (^LXFailureBlock)(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error);
typedef void (^LXProgressBlock)(NSProgress *_Nullable downloadProgress);


typedef void(^LXBaseURLString)(NSString *_Nullable baseURLString);
typedef NSDictionary *_Nullable(^LXCommonParams)(NSDictionary *_Nullable params);
typedef NSDictionary *_Nullable(^LXReformParams)(NSDictionary *_Nullable parmas);

typedef BOOL(^LXIsCorrectWithParams)(NSDictionary *_Nullable params);
typedef BOOL(^LXIsCorrectWithResponseData)(NSDictionary *_Nullable params);

typedef void(^LXBeforeSuccess)(NSURLSessionDataTask *_Nullable task, id _Nullable responseObject);
//typedef void(^LXAfterSuccess)(NSURLSessionDataTask *task, id responseObject);
typedef void(^LXBeforeFailure)(NSURLSessionDataTask *_Nullable task, NSError *_Nullable error);
//typedef void(^LXAfterFailure)(NSURLSessionDataTask *task, NSError *error);

typedef BOOL(^LXShouldRequest)(NSDictionary *_Nullable params);
typedef BOOL(^LXShouldResponse)(NSDictionary *_Nullable params);

@interface LXNetWorking : NSObject
{
    
}
@property (nonatomic,retain, readonly)AFHTTPSessionManager *_Nullable manager;
/** <#注释#>*/
@property (nonatomic,copy)NSString *_Nullable baseURLString;
/** <#注释#>*/
@property (nonatomic,assign)id<LXNetworkingManagerDelegate> _Nullable delegate;
@property (nonatomic,assign)id<LXDataSourcesManager> _Nullable dataSource;
@property (nonatomic,assign)id<LXParamValidatorManager> _Nullable validator;
@property (nonatomic,assign)id<LXCallBackInterceptorManager> _Nullable interceptor;

/** <#注释#>*/
//@property (nonatomic,assign)kLXSuccessBlock successBlock;
/** <#注释#>*/
//@property (nonatomic,assign)kLXFailureBlock failureBlock;
/** <#注释#>*/
//@property (nonatomic,assign)kLXProgressBlock progressBlock;
/** <#注释#>*/
//@property (nonatomic,assign)<#type#> <#typeName#>;

+ (instancetype _Nullable)manager;


#pragma mark -
#pragma mark - GET
- (void)GET:(NSString * _Nullable)apiName
     params:(NSDictionary * _Nullable)params
    success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable responseObject))success
    failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error))failure;
#pragma mark -
#pragma mark - POST

- (void)POST:(NSString * _Nullable)apiName params:(NSDictionary * _Nullable)params success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable responseObject))success
     failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error))failure;
- (void)basePOST:(NSString * _Nullable)apiName params:(NSDictionary * _Nullable)params exceptionReport:(BOOL)reportFlag success:(void (^ _Nullable)(NSURLSessionDataTask * _Nonnull dataTask, id _Nullable responseObject))success
     failure:(void (^ _Nullable)(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error))failure;

@end
