//
//  MJRecommendCell.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/4.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJRecommendCell.h"

#import "Masonry.h"
#import "UIImageView+placeholder.h"
#import "MJExceptionReportManager.h"

@interface MJRecommendCell ()
{

}
@property (nonatomic,retain)UIImageView * imgView_icon;

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

#pragma mark - imgView_icon
-(UIImageView *)imgView_icon {

    if (!_imgView_icon) {
        
        _imgView_icon = [[UIImageView alloc]init];
        
    }
    return _imgView_icon;
    
}

@end
