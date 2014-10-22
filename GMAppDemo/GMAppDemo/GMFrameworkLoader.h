//
//  GMFrameworkLoader.h
//  GMAppDemo
//
//  Created by WeiHan on 10/22/14.
//  Copyright (c) 2014 Wei Han. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GMFrameworkLoader : NSObject

+ (BOOL)loadFramework:(const char *)libPath;

@end
