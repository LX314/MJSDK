//
//  MJLA.m
//  sdk-ADView
//
//  Created by John LXThyme on 16/5/23.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#import "MJLA.h"

@interface MJLA ()
{
    
}
/** <#注释#>*/
@property (nonatomic,retain)UIImageView *imgView_logo;
/** <#注释#>*/
@property (nonatomic,retain)UILabel *lab_title;
/** <#注释#>*/
@property (nonatomic,retain)UILabel *lab_detail;
/** <#注释#>*/
@property (nonatomic,retain)UIButton *btn_dl;


@end
@implementation MJLA
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //
        [self initial];
    }
    return self;
}

- (void)initial
{
    /**
     *初始化相关配置
     *
     */
    [self setBackgroundColor:[UIColor whiteColor]];
    //
    [self.contentView addSubview:self.imgView_logo];
    [self.contentView addSubview:self.lab_title];
    [self.contentView addSubview:self.lab_detail];
    [self.contentView addSubview:self.btn_dl];
    MASAttachKeys(self.imgView_logo,self.lab_title,self.lab_detail,self.btn_dl);
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}
- (void)fill{
//    [self.imgView_logo setImage:<#(UIImage * _Nullable)#>];
    [self.lab_title setText:@"萌店"];
    [self.lab_detail setText:@"新生活 · 新买卖"];
    [self.btn_dl setImage:[UIImage imageNamed:@"下载按钮"] forState:UIControlStateNormal];
}
#pragma mark -
#pragma mark - Masonry Methods
- (void)updateConstraints{
    [super updateConstraints];
    //
    
    [self masonry];
}
- (void)masonry
{//[self masonry];
    UIView *superView = self.contentView;
    
    [self.imgView_logo mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.left.equalTo(superView).offset(10.f);
        make.centerY.equalTo(superView);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    [self.lab_title mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.imgView_logo);
        make.left.equalTo(self.imgView_logo.mas_right).offset(8);
    }];
    [self.lab_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.left.equalTo(self.lab_title);
        make.bottom.equalTo(self.imgView_logo);
    }];
    [self.btn_dl mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.right.equalTo(superView).offset(-10);
        make.centerY.equalTo(superView);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
}
#pragma mark - imgView_logo
- (UIImageView *)imgView_logo
{
    if(!_imgView_logo){
        _imgView_logo = [[UIImageView alloc]init];
        [_imgView_logo setImage:[UIImage imageNamed:@"墙类APP75x75"]];
    }
    
    return _imgView_logo;
}
#pragma mark - lab_title
- (UILabel *)lab_title
{
    if(!_lab_title){
        _lab_title = [[UILabel alloc]init];
        [_lab_title setFont:[UIFont boldSystemFontOfSize:18.f]];
        [_lab_title setTextColor:[UIColor blackColor]];
    }
    
    return _lab_title;
}
#pragma mark - lab_detail
- (UILabel *)lab_detail
{
    if(!_lab_detail){
        _lab_detail = [[UILabel alloc]init];
        [_lab_detail setFont:[UIFont systemFontOfSize:10.f]];
        [_lab_detail setTextColor:[UIColor colorFromHexString:@"#878787"]];
    }
    
    return _lab_detail;
}
#pragma mark - btn_dl
- (UIButton *)btn_dl
{
    if(!_btn_dl){
        _btn_dl = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    
    return _btn_dl;
}

@end
