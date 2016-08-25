//
//  MJRecommendCell.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/4.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJRecommendCell : UICollectionViewCell

@property (nonatomic,retain)UIImageView * imgView_icon;
@property (nonatomic,retain)UILabel *lab_detail;
@property (nonatomic,retain)UILabel *lab_price;

- (void)fill:(NSDictionary *)params;

@end
