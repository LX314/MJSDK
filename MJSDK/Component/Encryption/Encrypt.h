//
//  Encrypt.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/29.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Encrypt : NSObject
{

}

#pragma mark -
#pragma mark - encrypt||dencrypt
+ (NSDictionary *)mjEncrypt:(NSDictionary *)params_t;
+ (NSString *)encrypt:(NSDictionary *)params_t;
+ (NSDictionary *)dencrypt:(NSString *)src_t;


@end
