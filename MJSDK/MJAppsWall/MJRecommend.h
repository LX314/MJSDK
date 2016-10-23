//
//  MJRecommend.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/4.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MJShare;

@interface MJRecommend : UIView
{
    
}

@property (nonatomic,retain, readonly)UICollectionView *collection;
@property (nonatomic,retain)MJShare * mjShare;

- (void)fill:(NSDictionary *)params;
- (void)isReport:(BOOL)isReport;


@end
