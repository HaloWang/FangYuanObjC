//
//  FYDemoListViewController.m
//  FangYuanObjCDemo
//
//  Created by 王策 on 16/5/6.
//  Copyright © 2016年 王策. All rights reserved.
//

#import "FYDemoListViewController.h"
#import "ViewController.h"
#import "FYDTableViewController.h"
#import <HaloObjC.h>

@interface FYDemoListViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) NSArray<Class> *vcs;

@end

@implementation FYDemoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titles = @[@"ViewController", @"TableViewController"];
    self.vcs = @[[ViewController class], [FYDTableViewController class]];
    
    self.tableView = [[[UITableView alloc] initWithFrame:CM(0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain] addToSuperview:self.view];
    [self.tableView hl_registerCellClass:[UITableViewCell class]];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[self.vcs[indexPath.row] new] animated:YES];
}


@end
