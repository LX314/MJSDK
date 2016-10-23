//
//  MJBaseShareContent.h
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/20.
//  Copyright © 2016年 WM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Masonry.h"
#import "Colours.h"
#import "MJBlocks.h"
#import "MJCouponManager.h"
#import "UIImageView+placeholder.h"
#import "UIImage+imageNamed.h"

@class MJShare;

@interface MJBaseShareContent : UIView
{
    
}
/** 优惠券页面*/
@property (nonatomic,retain)MJShare *mjShare;
/** 保存当前界面*/
@property (nonatomic,assign)KMJShareStep currentStep;
/** 修改手机号返回上一个界面*/
@property (nonatomic,assign)KMJShareStep lastStep;
/** 元素*/
@property (nonatomic,retain)UILabel *lab_title;
@property (nonatomic,retain)UILabel *lab_description;
@property (nonatomic,retain)UILabel *lab_content1;
@property (nonatomic,retain)UILabel *lab_content2;
@property (nonatomic,retain)UILabel *lab_content3;
@property (nonatomic,retain)UILabel *lab_content0;
/** 文本输入框*/
@property (nonatomic,retain)UITextField *textField;
/** 左侧券背景*/
@property (nonatomic,retain)UIImageView *imgView_content;
/** 右侧LOGO背景*/
@property (nonatomic,retain)UIImageView *imgView_icon;
/** 左侧券*/
@property (nonatomic,retain)UIImageView *imgView_logoLeft;
/** 右侧LOGO*/
@property (nonatomic,retain)UIImageView *imgView_logoRight;
/** 修改按钮*/
@property (nonatomic,retain)UIButton *btn_modify;
/** 领取按钮*/
@property (nonatomic,retain)UIButton *btn_get;
/** 底部条纹*/
@property (nonatomic,retain)UIView *line;

- (void)setUp;
- (void)reset;
- (void)suit;
- (void)masonry;
- (void)fill:(NSDictionary *)params;
- (void)delayClickOperation:(id)sender;


@end
