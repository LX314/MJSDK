//
//  MJRecommend.m
//  MJSDK-iOS
//
//  Created by John LXThyme on 16/7/4.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJRecommend.h"

#import "Masonry.h"
#import "MJSDKConf.h"
#import "LXNetWorking.h"
#import "MJRecommendCell.h"
#import "MJExceptionReportManager.h"

#define kCollectionCellIdentifier @"CellIdentifier"
#define kCollectionHeaderSectionIdentifier @"HeaderSectionIdentifier"
#define kCollectionFooterSectionCellIdentifier @"FooterSectionCellIdentifier"

@interface MJRecommend ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    BOOL _leftIsReport;
    BOOL _rightIsReport;
}
/** <#注释#>*/
@property (nonatomic,retain)UIImageView *imgView_logo;
@property (nonatomic,retain)UICollectionView *collection;

@property (nonatomic,retain)UIImageView *imgView_bottom;

/** <#注释#>*/
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
//    NSAssert(array.count > 0, @"没有好货推荐信息");
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
//    NSDictionary * modelDic = self.arrayData[indexPath.row];
    MJRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionCellIdentifier forIndexPath:indexPath];
    
    cell.selectedBackgroundView = ({
        UIView *view_t = [[UIView alloc]init];
        [view_t setFrame:cell.frame];
        view_t;
    });
    [cell fill:self.arrayData[indexPath.row]];
//    [cell.imgView_icon setImage:[UIImage imageNamed:modelDic[@"imageName"]]];
//    [cell.lab_detail setText:modelDic[@"labelText"]];
//    [cell.lab_price setText:modelDic[@"price"]];

    return cell;
}

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

//配置优惠券商品是否可以跳转
    NSString * click_url = self.arrayData[indexPath.row][@"click_url"];
    if (![MJExceptionReportManager validateAndExceptionReport:click_url]) {
        return ;
    }
//    NSLog(@"点击是否上报了%@",_isReport);
    
    if (indexPath.row == 0 && _leftIsReport == NO && kMJSDKIsCouponAdClickable == NO) {
        
        [MJExceptionReportManager goodInfoReport:click_url success:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject) {
            
            NSLog(@"左侧商品互动点击上报成功");
            _leftIsReport = YES;
            
            
        } failed:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
            
            NSLog(@"左侧商品互动点击上报失败");
            
            
        }];

    } else if (indexPath.row == 1 && _rightIsReport == NO && kMJSDKIsCouponAdClickable == NO) {
    
    
        [MJExceptionReportManager goodInfoReport:click_url success:^(NSURLSessionDataTask * _Nonnull dataTask, id  _Nullable responseObject) {
            
            NSLog(@"右侧商品互动点击上报成功");
            _rightIsReport = YES;
            
            
        } failed:^(NSURLSessionDataTask * _Nullable dataTask, NSError * _Nonnull error) {
            
            NSLog(@"右侧商品互动点击上报失败");
            
            
        }];
    
    } else if (kMJSDKIsCouponAdClickable == YES) {
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:click_url]];
        
    }
}


#pragma mark - arrayData
- (NSArray *)arrayData
{
    if(!_arrayData){
        _arrayData = @[
//                       @{
//                           @"imageName":@"好货推荐素材1",
//                           @"labelText":@"福建黑叶荔枝两斤",
//                           @"price":@"¥29.0"
//                        },
//                       @{
//                           @"imageName":@"好货推荐素材2",
//                           @"labelText":@"泰国进口椰青2个装",
//                           @"price":@"¥29.9"
//                        }

                           
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
        //        [flowLayout setEstimatedItemSize:<#itemSize#>];
        [flowLayout setMinimumLineSpacing:10];
        [flowLayout setMinimumInteritemSpacing:0];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        //[flowLayout setHeaderReferenceSize:CGSizeMake(CGRectGetWidth(collectFrame), <#HeaderSectionHeight#>)];
        //[flowLayout setFooterReferenceSize:CGSizeMake(CGRectGetWidth(collectFrame), <#FooterSectionHeight#>)];
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
        [_imgView_bottom setImage:[UIImage imageNamed:@"彩条"]];
    }
    
    return _imgView_bottom;

}

@end
