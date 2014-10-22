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

+ (BOOL)loadFrameworkWithCString:(const char *)libPath
{
    BOOL result = YES;
    
    void* sdl_library = dlopen(libPath, RTLD_LAZY);
    result = sdl_library != NULL;
    
    if (!result)
        NSLog(@"Failed to load framework: %s, error: %s", libPath, dlerror());
    
    dlclose(sdl_library);
    
    return result;
}

+ (BOOL)loadFrameworkWithBundlePath:(NSString *)bundlePath
{
    BOOL result = YES;
    
    NSURL *url = [NSURL URLWithString:bundlePath];
    CFBundleRef libBundle = CFBundleCreate(kCFAllocatorDefault, (CFURLRef)url);
    
//    result = CFBundleLoadExecutable(libBundle);
    
    CFErrorRef err;
    result = CFBundleLoadExecutableAndReturnError(libBundle, &err);
    
    if (!result)
        NSLog(@"Failed to load bundle: %@, error: %@", bundlePath, err);
    
    return result;
}

@end
