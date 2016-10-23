//
//  MJElement.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/21.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "Mantle.h"

@interface MJElement : MTLModel
{
    
}
@property(nonatomic, copy)NSString *mjLandingPageUrl;


//origin
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *title;


@property (nonatomic, strong) NSString *share_image;
@property (nonatomic, strong) NSString *share_title;
@property (nonatomic, strong) NSString *share_subtitle;

@end
