//
//  UIViewController+DelegateSetter.h
//  GMDylibDemo
//
//  Created by WeiHan on 10/21/14.
//  Copyright (c) 2014 Wei Han. All rights reserved.
//
//  Note:
//      This category is aiming at supplying an interface 1) for UIViewControler to set our GM (generic module) delegate in caller. 2) for MyViewController in framework (GMDylibDemo) to inherit.

#import <UIKit/UIKit.h>
#import "GMDelegate.h"

@interface UIViewController (DelegateSetter)

- (void)setGMDelegate:(id<GMDelegate>)obj;

@end
