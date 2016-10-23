//
//  MJRecommend.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/4.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJRecommend.h"

#import "Masonry.h"
#import "MJShare.h"
#import "MJRecommendCell.h"
#import "UIImage+imageNamed.h"
#import "MJExceptionReportManager.h"


#define kCollectionCellIdentifier @"CellIdentifier"
#define kCollectionHeaderSectionIdentifier @"HeaderSectionIdentifier"
#define kCollectionFooterSectionCellIdentifier @"FooterSectionCellIdentifier"

@interface MJRecommend ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    BOOL _leftIsReport;
    BOOL _rightIsReport;
    BOOL _hasReport;
}
@property (nonatomic,retain)UIImageView *imgView_logo;
@property (nonatomic,retain)UICollectionView *collection;
@property (nonatomic,retain)UIImageView *imgView_bottom;
@property (nonatomic,retain)NSArray *arrayData;

@end
@implementation MJRecommend
- (instancetype)init {
    if (self = [super init]) {
        //
        [self setUp];
        [self setBackgroundColor:[UIColor whiteColor]];

    }
    return self;
}
- (void)setUp {
    
    [self addSubview:self.collection];
    [self addSubview:self.imgView_bottom];

    self.collection.scrollEnabled = NO;

    MASAttachKeys(self.collection,self.imgView_bottom);
    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
    //
    [self.collection registerClass:[MJRecommendCell class] forCellWithReuseIdentifier:kCollectionCellIdentifier];
}
- (void)fill:(NSDictionary *)params {
    NSArray *array = params[@"goods_info"];
    if (array.count <= 0) {
        return;
    }
    self.arrayData = array;
    [self.collection reloadData];
}

- (void)isReport:(BOOL)isReport {
    
    _leftIsReport = isReport;
    _rightIsReport = isReport;
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
    UIView *superView = self;
    //
    [self.collection mas_makeConstraints:^(MASConstraintMaker *make) {
        //
        make.centerX.equalTo(superView);
        make.top.equalTo(superView).offset(5.f);
        make.size.mas_equalTo(CGSizeMake(230.f, 128.f));
    }];
//    
    [self.imgView_bottom mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(superView.mas_centerX);
        make.bottom.equalTo(superView.mas_bottom);
    }];

}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.arrayData count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    MJRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifier forIndexPath:indexPath];
    
    cell.selectedBackgroundView = ({
        UIView *view_t = [[UIView alloc]init];
        [view_t setFrame:cell.frame];
        view_t;
    });
    [cell fill:self.arrayData[indexPath.row]];

    return cell;
}

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //配置优惠券商品是否可以跳转
    NSString * click_url = self.arrayData[indexPath.row][@"click_url"];
    NSArray * array = [click_url componentsSeparatedByString:@"&"];
    NSString * param = array[1];
    NSString * click_type = [param substringFromIndex:param.length - 1];
    if (![MJExceptionReportManager validateAndExceptionReport:click_url]) {
        return ;
    }
    
    if (kMJSDKIsCouponAdClickable == NO) {
        
        self.collection.userInteractionEnabled = NO;
        
    } else if (kMJSDKIsCouponAdClickable == YES && indexPath.row == 0 && _leftIsReport == NO) {
        
        if ([click_type isEqualToString:@"1"]) {
        
            NSLog(@"%ld",indexPath.row);
            [MJExceptionReportManager goodInfoReport:click_url adSpaceID:_mjShare.appsManager.adSpaceID success:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject) {
                
                NSLog(@"左侧商品互动点击上报成功");

            } failed:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
                
                
            }];
            
            _leftIsReport = YES;
            
        } else if ([click_type isEqualToString:@"2"]) {
            
            [MJExceptionReportManager mjGotoLandingPageUrl:click_url before:nil completion:nil];
            
        } else {
            
            NSLog(@"click_type未知");
        }
        
    } else if (kMJSDKIsCouponAdClickable == YES && indexPath.row == 1 && _rightIsReport == NO) {
        
        if ([click_type isEqualToString:@"1"]) {
            
            NSLog(@"%ld",indexPath.row);
            [MJExceptionReportManager goodInfoReport:click_url adSpaceID:_mjShare.appsManager.adSpaceID success:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject) {
                
                NSLog(@"右侧商品互动点击上报成功");
                
            } failed:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
                
                
            }];
            _rightIsReport = YES;
            
        } else if ([click_type isEqualToString:@"2"]) {
            
            [MJExceptionReportManager mjGotoLandingPageUrl:click_url before:nil completion:nil];
            
        } else {
            NSLog(@"click_type未知");
        }
        
    }
}


#pragma mark - arrayData
- (NSArray *)arrayData
{
    if(!_arrayData){
        _arrayData = @[
   
                      ];
    }
    return _arrayData;
}

#pragma mark - collection
- (UICollectionView *)collection
{
    if(!_collection){
        CGRect collectFrame = CGRectMake(0, 0, 230.f, 128.f);
        CGSize itemSize = CGSizeMake(111.f, 128.f);
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        [flowLayout setItemSize:itemSize];
        [flowLayout setMinimumLineSpacing:10];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setSectionInset:UIEdgeInsetsZero];
        _collection = [[UICollectionView alloc]initWithFrame:collectFrame collectionViewLayout:flowLayout];
        [_collection setBackgroundColor:[UIColor whiteColor]];
        [_collection setPagingEnabled:YES];

        _collection.delegate = self;
        _collection.dataSource = self;
    }

    return _collection;
}

#pragma mark - imageView_bottom
-(UIImageView *)imgView_bottom {

    if (!_imgView_bottom) {
    
        _imgView_bottom = [[UIImageView alloc]init];
        [_imgView_bottom setImage:[UIImage mj_imageNamed:@"彩条@2x.png"]];
    }
    
    return _imgView_bottom;

}

@end
