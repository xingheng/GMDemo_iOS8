//
//  MyViewController.h
//  GMDylibDemo
//
//  Created by WeiHan on 10/21/14.
//  Copyright (c) 2014 Wei Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMDelegate.h"

@interface MyViewController : UIViewController

@property (nonatomic, strong) id<GMDelegate> delegate;

@end
