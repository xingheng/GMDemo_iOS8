//
//  ViewController.m
//  GMAppDemo
//
//  Created by WeiHan on 10/21/14.
//  Copyright (c) 2014 Wei Han. All rights reserved.
//

#import "ViewController.h"
#import "GMViewController.h"
#import "GMFrameworkLoader.h"

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
    
    NSString *strUrl = @"http://www.uploadhosting.co/uploads/166.111.198.181/GM.zip";
    //@"http://t1.qpic.cn/mblogpic/904bb91df74a345c3f2c/2000";
    //@"https://www.dropbox.com/s/5ptqnr0cyu70csw/git_history.txt";
    NSLog(@"Start to download file '%@'", strUrl);
    
    if (![GMFrameworkLoader getFrameworkFromURL:strUrl])
        NSLog(@"Failed to download file '%@'", strUrl);
    else
        NSLog(@"Finished downloading file '%@'.", strUrl);
}

- (void)buttonClick:(id)sender
{
    GMViewController *gmVC = [[GMViewController alloc] initwithVCName:@"MyViewController" delegate:self];
    
    UINavigationController *navigationVC = [[UINavigationController alloc] initWithRootViewController:gmVC.destinationViewController];
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
