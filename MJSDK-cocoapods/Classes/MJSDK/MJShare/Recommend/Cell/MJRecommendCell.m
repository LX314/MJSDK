//
//  MJRecommendCell.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/4.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJRecommendCell.h"

#import "Masonry.h"
#import "Colours.h"
#import "MJExceptionReportManager.h"
#import "UIImageView+placeholder.h"

@interface MJRecommendCell ()


@end

@implementation MJRecommendCell
- (void)prepareForReuse {
    [super prepareForReuse];
    NSLog(@"");
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //
        [self setUp];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}
-(void)setUp {
    
    [self addSubview:self.imgView_icon];
    [self addSubview:self.lab_detail];
    [self addSubview:self.lab_price];
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];

}
- (void)fill:(NSDictionary *)params {
    NSString *url = params[@"image_url"];
//    NSAssert(url.length > 0, @"好货推荐 URL 不能为空!");
    if ([MJExceptionReportManager validateAndExceptionReport:url] == YES) {
        [self.imgView_icon mj_setImageWithURLString:url placeholderImage:nil impAds:nil success:nil failure:nil];
    }
}
#pragma mark -
#pragma mark - Masonry Methods
- (void)updateConstraints {
    [super updateConstraints];
    //
    [self masonry];
}
#pragma mark -
#pragma mark - Masonry Methods
- (void)masonry
{//[self masonry];
    UIView *superView = self;
    //
    [self.imgView_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(superView);
    }];

}

- (void)masonry1
{//[self masonry];
    UICollectionViewCell *superView = self;
    //
    [self.imgView_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.left.equalTo(superView);
        make.size.mas_equalTo(CGSizeMake(111.f, 111.f));
    }];
    [self.lab_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.left.equalTo(self.imgView_icon);
        make.height.equalTo(@(20.f));
    }];
    
    [self.lab_price mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.imgView_icon.mas_bottom).offset(5.f);
        make.right.left.equalTo(self.imgView_icon);
        make.height.equalTo(@(12.f));
    }];

}

#pragma mark - imgView_icon
-(UIImageView *)imgView_icon {

    if (!_imgView_icon) {
        
        _imgView_icon = [[UIImageView alloc]init];
        
    }
    return _imgView_icon;
    
}

#pragma mark - lab_detail
-(UILabel *)lab_detail {

    if(!_lab_detail){
        //初始化一个 Label
        _lab_detail = [[UILabel alloc]init];
        [_lab_detail setFrame:CGRectZero];
        [_lab_detail setBackgroundColor:[UIColor blackColor]];
        _lab_detail.alpha = 0.7;
        [_lab_detail setTextColor:[UIColor whiteColor]];
        [_lab_detail setTextAlignment:NSTextAlignmentCenter];
        [_lab_detail setFont:[UIFont systemFontOfSize:11.f]];
    }

    return _lab_detail;


}

#pragma mark - lab_price
-(UILabel *)lab_price {
    
    if(!_lab_price){
        //初始化一个 Label
        _lab_price = [[UILabel alloc]init];
        [_lab_price setFrame:CGRectZero];
        [_lab_price setTextColor:[UIColor colorFromHexString:@"#ff004b"]];
        [_lab_price setTextAlignment:NSTextAlignmentCenter];
        [_lab_price setFont:[UIFont systemFontOfSize:12.f]];
    }
    
    return _lab_price;
    
    
}




@end
