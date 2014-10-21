//
//  UIViewController+DelegateSetter.h
//  GMDylibDemo
//
//  Created by WeiHan on 10/21/14.
//  Copyright (c) 2014 Wei Han. All rights reserved.
//
//  Note:
//      This category is aiming at 1) supplying an interface for

#import <UIKit/UIKit.h>
#import "GMDelegate.h"

@interface UIViewController (DelegateSetter)

- (void)setGMDelegate:(id<GMDelegate>)obj;

@end
