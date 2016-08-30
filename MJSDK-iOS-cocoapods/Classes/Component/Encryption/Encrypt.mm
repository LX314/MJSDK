//
//  Encrypt.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/29.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "Encrypt.h"

#include "gcipher.h"
#include "Base64.h"

#import <UIKit/UIKit.h>

@interface Encrypt ()
{
    
}

@end
@implementation Encrypt

+ (instancetype)manager {
    static Encrypt *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[[self class] alloc]init];
    });
    
    return _manager;
}
//std::string ekey = "02EEa83c6c1211e10b9f88966ceec34908eb946f7ed6e441af42b3c0f3218140";
//std::string ikey = "bfFFec55c30130c1d8cd1862ed2a4cd2c76ac33bc0c4ce8a3d3bbd3ad5687792";
GCipher LXEncrypt() {
    std::string ekey = "02EEa83c6c1211e10b9f88966ceec34908eb946f7ed6e441af42b3c0f3218140";
    std::string ikey = "bfFFec55c30130c1d8cd1862ed2a4cd2c76ac33bc0c4ce8a3d3bbd3ad5687792";
    std::string iv = "7c4254781b68670d765a2e63331f491a";
    GCipher gcipher(ekey, ikey);
    return gcipher;
}
#pragma mark -
#pragma mark - encrypt||dencrypt
+ (NSDictionary *)mjEncrypt:(NSDictionary *)params_t {
    NSString *dst = [self encrypt:params_t];
    NSDictionary *params = @{
                             @"ad_request":dst
//                             @"":dst
                             };
    return params;
}
+ (NSString *)encrypt:(NSDictionary *)params_t {
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:params_t options:NSJSONWritingPrettyPrinted error:nil];
    NSString *cstr_t = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    std::string iv = LXIV();
    std::string csrc_t = toCString(cstr_t);
//    csrc_t = "1234567890abcdefABCDEF";
    std::string cdst_t;
    GCipher gcipher = LXEncrypt();
//    GCipher gcipher(ekey, ikey);
    gcipher.Cipher(csrc_t,  iv, &cdst_t);
    NSString *ocdst_t = LXBase64encode(cdst_t);
    return ocdst_t;
}
+ (NSDictionary *)dencrypt:(NSString *)src_t {
    NSDictionary *params_t;
    return params_t;
}

#pragma mark -
#pragma mark - IV
std::string LXIV() {
    return "7c4254781b68670d765a2e63331f491a";
}
#pragma mark -
#pragma mark - base64 encode|dencode
static NSString *LXBase64encode(std::string src_t) {
    std::string csrc_t = src_t;
    std::string cdst_t = Base64_encode(reinterpret_cast<const unsigned char*>(csrc_t.c_str()), csrc_t.length());
    NSString *ocdst_t = toOCString(cdst_t);
    return ocdst_t;
}
std::string LXBase64dencode(NSString *src_t) {
    std::string csrc_t = toCString(src_t);
    std::string dst_t = Base64_decode(csrc_t);
    return dst_t;
}
#pragma mark -
#pragma mark - string||NSString
std::string toCString(NSString *ocstr_t) {
    std::string cstrs_t = [ocstr_t cStringUsingEncoding:NSUTF8StringEncoding];
    return cstrs_t;
}
static NSString *toOCString(std::string cstr_t) {
    NSString *ocstr_t = [NSString stringWithCString:cstr_t.c_str() encoding:NSUTF8StringEncoding];
    return ocstr_t;
}
@end
