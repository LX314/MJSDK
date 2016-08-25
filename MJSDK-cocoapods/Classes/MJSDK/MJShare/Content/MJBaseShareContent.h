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
#import "MJSDKConfiguration.h"
#import "MJCouponManager.h"

#import "MJTool.h"
#import "MJShare.h"
#import "MJBlocks.h"

//#import "UIImageView+AFNetworking.h"
#import "UIImageView+placeholder.h"

@interface MJBaseShareContent : UIView
{
    
}
@property (nonatomic,retain)MJShare *mjShare;
/** 保存当前界面*/
@property (nonatomic,assign)KMJShareStep currentStep;
/** 修改手机号返回上一个界面*/
@property (nonatomic,assign)KMJShareStep lastStep;
/** <#注释#>*/
@property (nonatomic,retain)UILabel *lab_title;
@property (nonatomic,retain)UILabel *lab_description;
@property (nonatomic,retain)UILabel *lab_content1;
@property (nonatomic,retain)UILabel *lab_content2;
@property (nonatomic,retain)UILabel *lab_content3;
@property (nonatomic,retain)UILabel *lab_content0;

/** 文本输入框*/
@property (nonatomic,retain)UITextField *textField;
//
@property (nonatomic,retain)UIImageView *imgView_content;
//
@property (nonatomic,retain)UIImageView *imgView_icon;

/** <#注释#>*/
@property (nonatomic,retain)UIImageView *imgView_logoLeft;
//
@property (nonatomic,retain)UIImageView *imgView_logoRight;

/** <#注释#>*/
@property (nonatomic,retain)UIButton *btn_modify;
@property (nonatomic,retain)UIButton *btn_get;


/** <#注释#>*/
@property (nonatomic,retain)UIView *line;

- (void)setUp;
- (void)reset;
- (void)fill:(NSDictionary *)params;
- (void)suit;
- (void)masonry;
- (void)btnModify:(id)sender;


@end
