//
//  GMFrameworkLoader.m
//  GMAppDemo
//
//  Created by WeiHan on 10/22/14.
//  Copyright (c) 2014 Wei Han. All rights reserved.
//

#import "GMFrameworkLoader.h"
#import <dlfcn.h>

@implementation GMFrameworkLoader

+ (BOOL)loadFramework:(const char *)libPath
{
    BOOL result = YES;
    void* sdl_library = dlopen(libPath, RTLD_LAZY);
    
    result = sdl_library != NULL;
    if (!result)
        NSLog(@"Failed to load framework: %s", libPath);
    
    return result;
}

@end
