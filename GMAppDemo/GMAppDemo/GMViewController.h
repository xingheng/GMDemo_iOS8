//
//  GMViewController.h
//  GMAppDemo
//
//  Created by WeiHan on 10/22/14.
//  Copyright (c) 2014 Wei Han. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GMViewController : UIViewController

- (id)initwithVCName:(NSString *)vcName
            delegate:(id)delegate;

- (void)setDelegate:(id)objDelegate;

- (UIViewController *)destinationViewController;

@end
