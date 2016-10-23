//
//  MJRE.h
//  sdk-ADView
//
//  Created by WM on 16/5/24.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#import "MJBaseAppsCell.h"

#import "MJAppsWall.h"
#import "MJResponse.h"

@interface MJRE : MJBaseAppsCell
{
    
}
@property (nonatomic,retain) NSIndexPath * selfIndexPath;
@property (nonatomic,retain)MJAppsWall *appsManager;

- (void)fill:(MJResponse *)response;

- (void)wechatShareAndReport;

@end
