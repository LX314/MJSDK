//
//  webViewController.m
//  MJSDK-iOS
//
//  Created by WM on 16/9/27.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "MJWebView.h"
#import "MJSDKConfiguration.h"
#import "UIImage+imageNamed.h"


@interface MJWebView () <UIWebViewDelegate>
{

}
@property (nonatomic,retain)UIWebView *clickWebView;
@property (nonatomic,retain)UINavigationController *nav;


@end

@implementation MJWebView
- (void)dealloc {
    NSLog(@"dealloc");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUp];
    
}
//+ (instancetype)manager {
//    NSLog(@"manager");
//    static MJWebView * s_instance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        s_instance = [[MJWebView alloc]init];
//        [s_instance setUp];
//    });
//
//    return s_instance;
//    
//}
- (void)setUp {
    
     [self.view addSubview:self.clickWebView];
}

- (void)requestUrl:(NSString *)url {
    NSString * webUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:webUrl]];
    [self.clickWebView loadRequest:request];
}

- (void)presentWebView {
    [self.parentVC presentViewController:self.nav animated:YES completion:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Load Finished!");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Load Failure!");
}


- (UIWebView *)clickWebView {
    if (!_clickWebView) {
        _clickWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0,kMainScreen_width,kMainScreen_height)];
        [_clickWebView setBackgroundColor:[UIColor lightGrayColor]];
        _clickWebView.center = self.view.center;
        [_clickWebView setScalesPageToFit:YES];
        _clickWebView.delegate = self;
    }
    return _clickWebView;
}

- (UINavigationController *)nav {

    if (!_nav) {
        
        UIViewController *vc_t = self;
        _nav = [[UINavigationController alloc]initWithRootViewController:vc_t];
        _nav.hidesBarsOnSwipe = YES;
        UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemClick:)];
        vc_t.navigationItem.rightBarButtonItem = rightBtnItem;
    }
    return _nav;

}

- (void)rightItemClick:(id)sender {
    
    [self dismiss];
    
}

- (void)dismiss{
    if (self.completion) {
        self.completion();
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        _clickWebView = nil;
        _parentVC = nil;
        _nav = nil;
        [_clickWebView removeFromSuperview];
        [self dismissViewControllerAnimated:YES completion:nil];

    });
}
@end

@implementation NSURLRequest(DataController)

+(BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
    
    return YES;
}

@end
