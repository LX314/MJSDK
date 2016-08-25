//
//  MJShareModifyPhoneNumber.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/6/20.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJShareThird.h"
#import "MJToast.h"
#import "MJTool.h"

@implementation MJShareThird
- (void)setUp {
    
    [self addSubview:self.lab_content1];
    [self addSubview:self.lab_content2];
    [self addSubview:self.lab_content3];
    [self addSubview:self.lab_content0];
    
    [self addSubview:self.textField];
    
    [self addSubview:self.btn_modify];
    
    MASAttachKeys(self.lab_content1,self.lab_content2,self.lab_content3, self.lab_content0, self.textField,self.btn_modify);
}
- (void)reset {
    
    [self.lab_content1 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content1 setTextColor:[UIColor colorFromHexString:@"#7c7c7c"]];
    
    [self.lab_content2 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content2 setTextColor:[UIColor colorFromHexString:@"#ff005b"]];
    
    [self.lab_content3 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content3 setTextColor:[UIColor colorFromHexString:@"#7c7c7c"]];
    
    [self.lab_content0 setFont:[UIFont systemFontOfSize:11.f]];
    [self.lab_content0 setTextColor:[UIColor colorFromHexString:@"#7c7c7c"]];

    
    [self.btn_modify setBackgroundImage:[UIImage imageNamed:@"修改1"] forState:UIControlStateNormal];
    [self.btn_modify setBackgroundImage:[UIImage imageNamed:@"修改2"] forState:UIControlStateHighlighted];
    [self.btn_modify setBackgroundImage:[UIImage imageNamed:@"修改3"] forState:UIControlStateDisabled];
  
//    [self.btn_modify setAttributedTitle:[[NSAttributedString alloc]initWithString:@"立即修改" attributes:@{
//                                                                                                       NSForegroundColorAttributeName:[UIColor whiteColor],
//                                                                                                       NSFontAttributeName:[UIFont systemFontOfSize:12.f]
//                                                                                                       }] forState:UIControlStateNormal];
    
}
- (void)fill:(NSDictionary *)params {
    
//    NSString * phoneNumber = [[NSUserDefaults standardUserDefaults]objectForKey:@"phoneNumber"];
//     [self.lab_content2 setText:phoneNumber];
    [self.lab_content1 setText:@"你当前的账户是"];
    [self.lab_content2 setText:[NSString stringWithFormat:@" %@ ",[MJTool getMJShareNewTel]]];
    [self.lab_content3 setText:@"手机号修改后"];
    [self.lab_content0 setText:@"将在下次抢红包时生效"];
    
//    [self.textField setPlaceholder:phoneNumber];
    [self.textField setPlaceholder:[MJTool getMJShareNewTel]];
    [self.textField setBackgroundColor:[UIColor colorFromHexString:@"#ededed"]];
    [self.textField setTextColor:[UIColor colorFromHexString:@"#6d6d6d"]];
    [self.textField setFont:[UIFont systemFontOfSize:12.f]];
    
   
}
- (void)btnModify:(id)sender
{
    NSInteger lastStep = [[[NSUserDefaults standardUserDefaults]objectForKey:@"lastStep"] integerValue];
    NSString * changeNumber = self.textField.text;
    
    if ([MJTool judgePhoneNumber:changeNumber]) {
        [MJTool saveMJShareModifyTel:changeNumber];
        [MJToast toast:@"手机号修改成功，将于下次任务完成生效" in:self];
        kGotoStepBlockBlock(lastStep);
        
    } else {
    
         [MJToast toast:@"手机号输入错误，请重新输入" in:self];
    }
}

- (void)masonry {
    UIView *superView = self;
    [self.lab_content1 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(superView).offset(28.f);
        make.centerX.equalTo(superView).offset(-40.f);
    }];
    
    [self.lab_content2 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.lab_content1.mas_top);
        make.left.equalTo(self.lab_content1.mas_right);
    }];
    
    [self.lab_content3 mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.centerX.equalTo(superView);
        make.top.equalTo(self.lab_content1.mas_bottom);
    }];
    
    [self.lab_content0 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(superView); 
        make.top.equalTo(self.lab_content3.mas_bottom);
        
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.lab_content0.mas_bottom).offset(23.f);
        make.centerX.equalTo(superView);
        make.size.mas_equalTo(CGSizeMake(200.f, 25.f));
    }];
    [self.btn_modify mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.textField.mas_bottom).offset(8.f);
        make.centerX.equalTo(superView);
        make.size.mas_equalTo(CGSizeMake(200.f, 25.f));
    }];

}
@end
