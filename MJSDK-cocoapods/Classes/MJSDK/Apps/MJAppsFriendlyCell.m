//
//  MJAppsFriendlyCell.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/27.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJAppsFriendlyCell.h"

#import "Colours.h"
#import "Masonry.h"

@interface MJAppsFriendlyCell ()
{

}
/** <#注释#>*/
@property (nonatomic,retain)UIImageView *imgView_friendlyLogo;

@end
@implementation MJAppsFriendlyCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imgView_friendlyLogo];
        [self fill:kMJAPPSContentFriendUIState];
        [self setNeedsUpdateConstraints];
        [self setNeedsLayout];
    }
    return self;
}
- (void)fill:(kMJAPPSContentState)contentState {
    self.backgroundColor = [UIColor colorFromHexString:@"#8f8f8f"];
    if (contentState == kMJAPPSContentFriendUIState) {
        [self.imgView_friendlyLogo setImage:[UIImage imageNamed:@"加载失败"]];
    }else if(contentState == kMJAPPSContentNOTAvailableState) {
        [self.imgView_friendlyLogo setImage:[UIImage imageNamed:@"墙广告数量不够"]];
    } else {
        NSAssert(NO, @"");
    }
}
#pragma mark -
#pragma mark - Masonry Methods
- (void)updateConstraints {
    [super updateConstraints];
    //
    [self masonry];
}
- (void)masonry
{//[self masonry];
    UIView *superView = self.contentView;
    [self.imgView_friendlyLogo mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(superView);
    }];

}

#pragma mark - imgView_friendlyLogo
- (UIImageView *)imgView_friendlyLogo
{
    if(!_imgView_friendlyLogo){
        _imgView_friendlyLogo = [[UIImageView alloc]init];
        _imgView_friendlyLogo.contentMode = UIViewContentModeCenter;
    }

    return _imgView_friendlyLogo;
}


@end
