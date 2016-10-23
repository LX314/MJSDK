//
//  MJBaseInlineBanner.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/7.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJBaseCell.h"

@class MJElement;

@interface MJBaseInline : MJBaseCell
{
    
}
@property(nonatomic, retain)MJElement *mjElement;

- (void)shareInformationMethod;

@end
