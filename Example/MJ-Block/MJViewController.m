//
//  MJViewController.m
//  MJ-Block
//
//  Created by LX314 on 08/25/2016.
//  Copyright (c) 2016 LX314. All rights reserved.
//

#import "MJViewController.h"

#import "Macro.h"
#import "SecondVC.h"

@interface MJViewController ()

@end

@implementation MJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    //
    kBlock = ^(void){
        NSLog(@"*****");
    };

    SecondVC *secondVC = [[SecondVC alloc]init];
    [self.navigationController pushViewController:secondVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
