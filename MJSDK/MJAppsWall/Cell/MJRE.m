//
//  MJRE.m
//  sdk-ADView
//
//  Created by WM on 16/5/24.
//  Copyright © 2016年 John LXThyme. All rights reserved.
//

#define imageWidth roundf(([UIScreen mainScreen].bounds.size.width/320 * (100 - 10)) * 210 / 90)
#define btn_detailHeight roundf((([UIScreen mainScreen].bounds.size.width * 2 - imageWidth * 2 - 70) * 30 / 150) / 2)

#import "MJRE.h"

#import "Tool.h"
#import "MJTool.h"
#import "UIImage+imageNamed.h"
#import "MJExceptionReportManager.h"

@interface MJRE () {
    MJResponse *_mjResponse;
    MJApps *_apps;
}
/** 分享成功*/
@property (nonatomic,retain) UIImageView * imageView_share;
/** 左广告展示图*/
@property (nonatomic,retain)UIImageView * imageView_show;
/** 右logo展示图*/
@property (nonatomic,retain)UIImageView * imageView_logo;
/** 白色背景图*/
@property (nonatomic,retain)UIView * whiteView;
/** 广告内容*/
@property (nonatomic,retain)UILabel * lab_content;
/** 分享按钮*/
@property (nonatomic,retain)UIButton * btn_detail;

@end

@implementation MJRE

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self initial];
    }
    return self;
}

- (void)initial
{
    /**
     *初始化相关配置
     */
    [self setBackgroundColor:[UIColor colorFromHexString:@"#f2f2f2"]];
    //
    [self.contentView addSubview:self.imageView_show];
    [self.contentView addSubview:self.whiteView];
    [self.whiteView addSubview:self.imageView_logo];
    [self.whiteView addSubview:self.lab_content];
    [self.whiteView addSubview:self.btn_detail];
    [self.whiteView addSubview:self.imageView_share];

    MASAttachKeys(self.imageView_show,self.whiteView,self.imageView_logo,self.lab_content,self.btn_detail,self.imageView_share);
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

- (void)fill:(MJResponse *)response {

    _mjResponse = response;
    MJImpAds *impAds = response.impAds[self.selfIndexPath.row];
    impAds.indexPath = self.selfIndexPath;
    MJApps *apps = impAds.apps;
    _apps = apps;
    MJElement *element = apps.mjElement;
    BOOL hasShared = impAds.hasShared;
    hasShared ? [self sharedStatus] : [self unsharedStatus];
    NSString *image = element.image;
    NSString *detail = element.desc;
    NSString *logUrl = element.icon;
    
    [self.whiteView setBackgroundColor:[UIColor whiteColor]];
    [self.lab_content setText:detail];
    [self.btn_detail setTitle:@"我要分享" forState:UIControlStateNormal];
    [self.imageView_show mj_setImageWithURLString:image placeholderImage:kMJSDKAPPREShowIMGPlaceholderImageName impAds:impAds success:nil failure:nil];
    [self.imageView_logo mj_setImageWithURLString:logUrl placeholderImage:kMJSDKAPPRELogoIMGPlaceholderImageName impAds:impAds success:nil failure:nil];

}

- (void)sharedStatus {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView_share.alpha = 1;
        self.btn_detail.alpha = 0;
    });
}
- (void)unsharedStatus {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.imageView_share.alpha = 0;
        self.btn_detail.alpha = 1;
    });
}

- (void)wechatShareAndReport {
    NSLog(@"我要分享");
    if (_mjResponse.need_times < 0) {
        _mjResponse.need_times--;
        NSLog(@"已完成任务,请明天再来吧~~");
        self.appsManager.mjAppsShowToastBlock(@"已成功获取道具,请明天再来吧~~", YES);
        return;
    }
    if (_mjResponse.need_times == 0) {
        _mjResponse.need_times--;
        NSLog(@"分享次数已经完成,开始领取道具");
        self.appsManager.mjAppsShowToastBlock(@"分享次数已经完成,开始领取道具", NO);
        self.appsManager.mjAppsGetPropBlock();
        return;
    }

    __block MJImpAds *impAds = _mjResponse.impAds[self.selfIndexPath.row];
    NSString * shareString = impAds.apps.elements;
    NSDictionary *shareJSON = [MJTool toJsonObject:shareString];

    NSString * share_image_url = shareJSON[@"share_image"];
    NSString * share_title = shareJSON[@"share_title"];
    NSString * share_subtitle = shareJSON[@"share_subtitle"];
    NSString * landingPageUrl = impAds.landingPageUrl;

    __block UIImage *share_image;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIImage mj_setImageWithURLString:share_image_url placeholderImage:nil success:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, UIImage * _Nullable image) {
            share_image = image;
            [Tool wechatShare:^(KMJWechatShareStatus status) {
                if(status == KMJWechatShareFailState || status == KMJWechatShareCancelState) {
                    NSLog(@"分享失败");
                    self.appsManager.mjAppsShowToastBlock(@"分享失败", NO);
                }else if(status == KMJWechatShareSuccessState) {
                    //曝光
                    NSString *btnURL = impAds.apps.btnUrl;
                    if (![MJExceptionReportManager validateAndExceptionReport:btnURL]) {
                        self.appsManager.mjAppsShowToastBlock(@"wechat report url error", NO);
                        return ;
                    }
                    //分享上报
                    [MJExceptionReportManager wechatShareReport:btnURL success:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject) {
                        [self sharedStatus];
                        //存储广告位 id 到本地
                        NSString * innovativeId = impAds.innovativeId;
                        [MJTool insertSharedDataForInnovationID:innovativeId];
                        _mjResponse.need_times--;
                        impAds.hasShared = YES;
                        self.appsManager.mjAppsCellClickedBlock(self.selfIndexPath);
                        if (_mjResponse.need_times <= 0) {
                            NSLog(@"分享次数已经完成,开始领取道具");
                            self.appsManager.mjAppsShowToastBlock(@"分享次数已经完成,开始领取道具", NO);
                            self.appsManager.mjAppsGetPropBlock();
                            return;
                        }
                        self.appsManager.mjAppsShowToastBlock(@"分享成功", NO);
                    } failed:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
                        self.appsManager.mjAppsShowToastBlock(@"服务器出错，分享失败", NO);
                    }];
                } else {
                    NSLog(@"status:%ld", status);
                    NSAssert(NO, @"");
                }
                //title长度限制为512字节 description长度限制为1024字节
            } title:share_title description:share_subtitle imagesArray:@[share_image] url:landingPageUrl];
        } failure:^(NSURLRequest * _Nullable request, NSHTTPURLResponse * _Nullable response, NSError * _Nullable error) {
            self.appsManager.mjAppsShowToastBlock(@"分享 logo 下载失败, 请重试",  NO);
        }];
    });
}
#pragma mark -
#pragma mark - Masonry Methods
- (void)updateConstraints{
    [super updateConstraints];
    [self masonry];
}

- (void)masonry {
    UIView *superView = self.contentView;
    [self.imageView_show mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(superView);
        make.left.equalTo(superView).offset(10.f);
        make.bottom.equalTo(superView).offset(-10.f);
    }];
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.bottom.equalTo(self.imageView_show);
        make.left.equalTo(self.imageView_show.mas_right);
        make.right.equalTo(superView).offset(-10.f);
        make.width.equalTo(self.imageView_show).multipliedBy(9/21.f);
    }];
    [self.imageView_share mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.edges.equalTo(self.whiteView);
    }];
    [self.imageView_logo mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.whiteView).offset(3.f);
        make.left.equalTo(self.whiteView).offset(8.f);
        make.right.equalTo(self.whiteView).offset(-8.f);
    }];
    [self.lab_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageView_logo.mas_bottom).offset(3.f);
        make.left.equalTo(self.whiteView).offset(3.f);
        make.right.equalTo(self.whiteView).offset(-3.f);
    }];
    [self.btn_detail mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.top.equalTo(self.lab_content.mas_bottom).offset(3.f);
        make.left.equalTo(self.whiteView).offset(3.f);
        make.right.equalTo(self.whiteView).offset(-3.f);
        make.bottom.equalTo(self.whiteView).offset(-3.f);
        make.height.lessThanOrEqualTo(@20.f);
    }];
}
#pragma mark - imageView_show
-(UIImageView *)imageView_show {

    if (!_imageView_show) {

        _imageView_show = [[UIImageView alloc]init];

    }

    return _imageView_show;

}


#pragma mark - bgView
-(UIView *)whiteView {

    if (!_whiteView) {

        _whiteView = [[UIView alloc]init];

    }

    return _whiteView;
}


#pragma mark - imageView_logo
-(UIImageView *)imageView_logo {

    if (!_imageView_logo) {

        _imageView_logo = [[UIImageView alloc]init];
        _imageView_logo.contentMode = UIViewContentModeScaleAspectFit;
    }

    return _imageView_logo;

}

#pragma mark - lab_content
-(UILabel *)lab_content {

    if (!_lab_content) {

        _lab_content = [[UILabel alloc]init];
        _lab_content.textColor = [UIColor colorFromHexString:@"#787878"];
        _lab_content.adjustsFontSizeToFitWidth = YES;
        _lab_content.numberOfLines = 2;
        _lab_content.textAlignment = NSTextAlignmentCenter;

    }

    return _lab_content;
}

#pragma mark - btn_detail
-(UIButton *)btn_detail {

    if (!_btn_detail) {
        _btn_detail = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btn_detail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _btn_detail.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_btn_detail setBackgroundColor:[UIColor colorFromHexString:@"#63d300"]];
        [_btn_detail.layer setCornerRadius:3.f];
        _btn_detail.userInteractionEnabled = NO;
    }

    return _btn_detail;

}
#pragma mark - imageView_share
-(UIImageView *)imageView_share {

    if (!_imageView_share) {
        _imageView_share = [[UIImageView alloc]init];
        [_imageView_share setImage:[UIImage mj_imageNamed:@"已分享@2x.png"]];
        _imageView_share.alpha = 0;
    }
    
    return _imageView_share;
}
@end
