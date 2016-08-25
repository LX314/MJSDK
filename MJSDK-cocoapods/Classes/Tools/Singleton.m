//
//  Singleton.m
//  GithubDemo001
//
//  Created by FairyLand on 15/4/2.
//  Copyright (c) 2015年 fulan. All rights reserved.
//

#import "Singleton.h"

#import "Macro.h"

@interface Singleton ()
{
    
}


@end

static Singleton *__instance = nil;

@implementation Singleton


+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[Singleton alloc]init];
    });
    return __instance;
}



@end
