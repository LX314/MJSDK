//
//  AppNavigationController.m
//  MJSDK-iOS
//
//  Created by WM on 16/6/19.
//  Copyright © 2016年 WM. All rights reserved.
//

#import "AppNavigationController.h"

@implementation AppNavigationController


-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {


    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        //
    }
    return self;
}

-(void)viewDidLoad {

    [super viewDidLoad];

}

-(BOOL)shouldAutorotate {
    
    return NO;

}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations {

    return UIInterfaceOrientationMaskPortrait;

}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {

    return UIInterfaceOrientationPortrait;

}

-(void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    //
}

@end
