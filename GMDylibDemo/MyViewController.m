//
//  MyViewController.m
//  GMDylibDemo
//
//  Created by WeiHan on 10/21/14.
//  Copyright (c) 2014 Wei Han. All rights reserved.
//

#import "MyViewController.h"

#define kTableViewIdentifier        @"kTableViewIdentifier"

@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *dataSource;
}

@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UIButton *myButton;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.myTableView];
    
    self.myButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.myButton.center = self.view.center;
    [self.myButton setTitle:@"Refresh" forState:UIControlStateNormal];
    [self.myButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.myButton];
    
    [self refresh];
}

- (void)buttonClick:(id)sender
{
    [self refresh];
}

- (void)refresh
{
    NSError *err = nil;
    NSArray *arr = [self.delegate loadData:&err];
    if (arr && !err)
        dataSource = [[NSMutableArray alloc] initWithArray:arr];
    else
        NSLog(@"error: %@", err);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewIdentifier];
    }
    
    cell.textLabel.text = [dataSource[indexPath.row] description];
    
    return cell;
}

@end
