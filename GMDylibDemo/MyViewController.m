//
//  MyViewController.m
//  GMDylibDemo
//
//  Created by WeiHan on 10/21/14.
//  Copyright (c) 2014 Wei Han. All rights reserved.
//

#import "MyViewController.h"
#import "GMDelegate.h"

#define kTableViewIdentifier        @"kTableViewIdentifier"

@interface MyViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *dataSource;
}

@property (nonatomic, strong) id<GMDelegate> delegate;
@property (nonatomic, strong) UITableView *myTableView;

@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    [self.view addSubview:self.myTableView];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    refreshBtn.frame = CGRectMake(0, 0, 100, 50);
    refreshBtn.center = self.view.center;
    refreshBtn.backgroundColor = [UIColor lightGrayColor];
    [refreshBtn setTitle:@"Refresh" forState:UIControlStateNormal];
    [refreshBtn addTarget:self action:@selector(refreshButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:refreshBtn];
    
    UIButton *addNewBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    addNewBtn.frame = CGRectMake(0, 0, 100, 50);
    addNewBtn.center = CGPointMake(refreshBtn.center.x, refreshBtn.center.y + 100);
    addNewBtn.backgroundColor = [UIColor lightGrayColor];
    [addNewBtn setTitle:@"Add a new" forState:UIControlStateNormal];
    [addNewBtn addTarget:self action:@selector(addNewButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addNewBtn];
    
    [self refresh];
}

- (void)refreshButtonClick:(id)sender
{
    [self refresh];
}

- (void)addNewButton:(id)sender
{
    NSString *lastObj = [dataSource lastObject];
    NSInteger newObj = [lastObj integerValue] + 1;
    [self.delegate addNewObject:[NSString stringWithFormat:@"%ld", (long)newObj]];
    
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
    
    [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DelegateSetter

- (void)setGMDelegate:(id<GMDelegate>)obj
{
    NSLog(@"MyViewController - GMDelegate: %@", obj);
    self.delegate = obj;
}

#pragma mark - UITableViewDataSource

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
