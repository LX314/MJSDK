//
//  MJViewController.h
//  MJJSDK
//
//  Created by LX314 on 05/23/2016.
//  Copyright (c) 2016 LX314. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^kCouponsCodeBlock1)(NSString * code);

@interface ViewController : UIViewController

//- (void)couponCode:(kCouponsCodeBlock1)block;
- (void)gotoURL;
@end
