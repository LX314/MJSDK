//
//  MJRecommend.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/4.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MJRecommend : UIView
{

}
@property (nonatomic,retain, readonly)UICollectionView *collection;

- (void)fill:(NSDictionary *)params;
- (void)isReport:(BOOL)isReport;


@end
