//
//  MJRE.h
//  sdk-ADView
//
//  Created by WM on 16/5/24.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#import "MJBaseAppsCell.h"

//void(^kSelectedCell)(NSIndexPath *indexPath);
@interface MJRE : MJBaseAppsCell
{
    
}
@property (nonatomic,retain) NSIndexPath * selfIndexPath;
@property (nonatomic,retain) NSMutableArray *muarr;
//注释
@property (nonatomic,retain) UIImageView * imageView_share;

@property (nonatomic,assign) NSInteger shareNum;

- (void)fill:(MJResponse *)response;

- (void)wechatShareAndReport;

@end
