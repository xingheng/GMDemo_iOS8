//
//  ViewController.m
//  DemoUITest
//
//  Created by WeiHan on 10/21/14.
//  Copyright (c) 2014 Wei Han. All rights reserved.
//

#import "ViewController.h"
#import <objc/objc-runtime.h>
#import "GMPublic.h"

@interface ViewController ()<GMDelegate>
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
    
    Protocol *protl = objc_getProtocol("GMDelegate");
    NSLog(@"%@ GMDelegate.", protl ? @"found" : @"missed");
    
    objc_registerProtocol(protl);
    
    UIViewController *gmVC = [[gmViewController alloc] init];
    
    [gmVC setGMDelegate:self];
    
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:gmVC];
    [self presentViewController:navigationVC animated:YES completion:nil];
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
