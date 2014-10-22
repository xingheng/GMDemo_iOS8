//
//  GMFrameworkLoader.m
//  GMAppDemo
//
//  Created by WeiHan on 10/22/14.
//  Copyright (c) 2014 Wei Han. All rights reserved.
//

#import "GMFrameworkLoader.h"
#import <dlfcn.h>
#import "AFURLSessionManager.h"
#import "ZipArchive.h"


#define kSTRGMZip       @"GM.zip"
#define kSTRGMDylibDemoFramework    @"GMDylibDemo.framework"


@implementation GMFrameworkLoader

+ (BOOL)getFrameworkFromURL:(NSString *)urlString
{
    __block BOOL result = YES;

    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        return [documentsDirectoryURL URLByAppendingPathComponent:kSTRGMZip];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        if (error) {
            result = NO;
            NSLog(@"Error: %@", error);
        }
        
        NSLog(@"File downloaded to: %@", filePath);
        
        [GMFrameworkLoader unzipFramework];
    }];
    [downloadTask resume];
    
    return result;
}

+ (BOOL)zipFramework
{
    BOOL result = YES;
    
    BOOL isDir = YES;
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSArray *subpaths;
    
    NSString *toCompress = @"/Users/hanwei/work/GMDemo/GMDylibDemo/OutFramework/GMDylibDemo.framework";
    NSString *pathToCompress = toCompress;//[documentsDirectory stringByAppendingPathComponent:toCompress];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:pathToCompress isDirectory:&isDir] && isDir){
        subpaths = [fileManager subpathsAtPath:pathToCompress];
    } else if ([fileManager fileExistsAtPath:pathToCompress]) {
        subpaths = [NSArray arrayWithObject:pathToCompress];
    }
    
    NSString *zipFilePath = [documentsDirectory stringByAppendingPathComponent:kSTRGMZip];
    
    ZipArchive *za = [[ZipArchive alloc] init];
    [za CreateZipFile2:zipFilePath];
    if (isDir) {
        for(NSString *path in subpaths){
            NSString *fullPath = [pathToCompress stringByAppendingPathComponent:path];
            if([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && !isDir){
                [za addFileToZip:fullPath newname:path];
            }
        }
    } else {
        [za addFileToZip:pathToCompress newname:toCompress];
    }
    
    result = [za CloseZipFile2];
    
    // test
    [self unzipFramework];
    
    return result;
}

+ (void)unzipFramework
{
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *zipFilePath = [documentsDirectory stringByAppendingPathComponent:kSTRGMZip];
    
    NSString *output = [documentsDirectory stringByAppendingPathComponent:kSTRGMDylibDemoFramework];
    
    ZipArchive* za = [[ZipArchive alloc] init];
    
    if( [za UnzipOpenFile:zipFilePath] ) {
        if( [za UnzipFileTo:output overWrite:YES] != NO ) {
            //unzip data success
            //do something
        }
        
        [za UnzipCloseFile];
    }
}

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

+ (BOOL)loadFramework
{
    return [self loadFrameworkWithBundlePath:kSTRGMDylibDemoFramework];
}

+ (BOOL)loadFrameworkWithBundlePath:(NSString *)bundlePath
{
    BOOL result = YES;
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSURL *url = [NSURL URLWithString:[documentsDirectory stringByAppendingPathComponent:bundlePath]];
    CFBundleRef libBundle = CFBundleCreate(kCFAllocatorDefault, (CFURLRef)url);
    
//    result = CFBundleLoadExecutable(libBundle);
    
    CFErrorRef err;
    result = CFBundleLoadExecutableAndReturnError(libBundle, &err);
    
    if (!result)
        NSLog(@"Failed to load bundle: %@, error: %@", libBundle, err);
    
    return result;
}

@end
