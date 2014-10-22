//
//  ViewController.m
//  DemoUITest
//
//  Created by WeiHan on 10/21/14.
//  Copyright (c) 2014 Wei Han. All rights reserved.
//

#import "ViewController.h"
#import <objc/objc-runtime.h>
#import <objc/message.h>

@interface ViewController ()
{
    NSMutableArray *dataSource;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Enter new view controller..." forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0, 0, 200, 100)];
    [button setCenter:self.view.center];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
    dataSource = [[NSMutableArray alloc] init];
    for (int i = 0; i <= 10; i++) {
        [dataSource addObject:[NSString stringWithFormat:@"%d", i]];
    }
}

- (void)buttonClick:(id)sender
{
    Class gmViewController = objc_getClass("MyViewController");
    NSLog(@"%@ MyViewController.", gmViewController ? @"found" : @"missed");
    
    UIViewController *gmVC = [[gmViewController alloc] init];
    
#if 1
    Method delegateMethod = class_getInstanceMethod(gmViewController, @selector(setGMDelegate:));
    NSLog(@"%@ delegateMethod.", delegateMethod ? @"found" : @"missed");
    
    void (*typed_method)(id, Method, id) = (void *)method_invoke;
    typed_method(gmVC, delegateMethod, self);
#else
    if ([gmVC respondsToSelector:@selector(setGMDelegate:)])
    {
        void (*typed_msgSend)(id, SEL, id) = (void *)objc_msgSend;
        typed_msgSend(gmVC, @selector(setGMDelegate:), self);
    }
    else
    {
        NSAssert(false, @"Not found setGMDelegate in %@", NSStringFromClass(gmViewController));
    }
#endif
    
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:gmVC];
    [self presentViewController:navigationVC animated:YES completion:nil];
}

- (void)setGMDelegate:(id)obj
{
    NSLog(@"obj: %@", obj);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GMDelegate

- (NSArray *)loadData:(NSError **)error
{
    return dataSource;
}

- (void)addNewObject:(NSObject *)newObj
{
    [dataSource addObject:newObj];
}

@end
