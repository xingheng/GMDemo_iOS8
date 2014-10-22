//
//  GMViewController.m
//  GMAppDemo
//
//  Created by WeiHan on 10/22/14.
//  Copyright (c) 2014 Wei Han. All rights reserved.
//

#import "GMViewController.h"
#import "GMFrameworkLoader.h"
#import <objc/objc-runtime.h>

@interface GMViewController ()
{
    Class destGMViewControllerClass;
    UIViewController *destGMViewController;
}

@end

@implementation GMViewController


- (id)initwithVCName:(NSString *)vcName
            delegate:(id)delegate
{
//    if ([GMFrameworkLoader loadFrameworkWithCString:"/Users/hanwei/work/GMDemo/GMDylibDemo/OutFramework/GMDylibDemo.framework/GMDylibDemo"])
    if ([GMFrameworkLoader loadFrameworkWithBundlePath:@"/Users/hanwei/work/GMDemo/GMDylibDemo/OutFramework/GMDylibDemo.framework"])
    {
        [self loadDestinationClass];
        if (delegate)
            [self setDelegate:delegate];
        
        return self;
    }
    else
        return nil;
}

- (void)loadDestinationClass
{
    Class gmViewController = objc_getClass("MyViewController");
    
    if (gmViewController) {
        NSLog(@"found MyViewController.");
        destGMViewControllerClass = gmViewController;
        destGMViewController = [[destGMViewControllerClass alloc] init];
    } else {
        NSLog(@"missed MyViewController");
        return;
    }
}

- (void)setDelegate:(id)objDelegate
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    SEL delegateSEL = @selector(setGMDelegate:);
#pragma clang diagnostic pop
    
// Both solutionA and solutionB work well.
#if 1   // SolutionA
    Method delegateMethod = class_getInstanceMethod(destGMViewControllerClass, delegateSEL);
    NSLog(@"%@ delegateMethod.", delegateMethod ? @"found" : @"missed");
    
    void (*typed_method)(id, Method, id) = (void *)method_invoke;
    typed_method(destGMViewController, delegateMethod, objDelegate);
#else   // SolutionB
    if ([destGMViewController respondsToSelector:delegateSEL])
    {
        void (*typed_msgSend)(id, SEL, id) = (void *)objc_msgSend;
        typed_msgSend(destGMViewController, delegateSEL, objDelegate);
    }
    else
    {
        NSAssert(false, @"Not found setGMDelegate in %@", NSStringFromClass(destGMViewControllerClass));
    }
#endif
}

- (UIViewController *)destinationViewController
{
    return destGMViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
