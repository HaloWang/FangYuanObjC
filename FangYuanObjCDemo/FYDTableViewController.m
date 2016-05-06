//
//  FYDTableViewController.m
//  FangYuanObjCDemo
//
//  Created by 王策 on 16/5/6.
//  Copyright © 2016年 王策. All rights reserved.
//

#import "FYDTableViewController.h"
#import "FYDTableViewCell.h"
#import <HaloObjC.h>

@interface FYDTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSDictionary<NSString*, NSString *> *> * dataSource;

@end

@implementation FYDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = @[
                        @{
                            @"title":@"title",
                            @"price":@"123456",
                        },
                        @{
                            @"title":@"title",
                            @"price":@"1234567890123456",
                        },
                        @{
                            @"title":@"title",
                            @"price":@"1",
                        },
                        @{
                            @"title":@"title",
                            @"price":@"123456",
                            },
                        @{
                            @"title":@"title",
                            @"price":@"1234567890123456",
                            },
                        @{
                            @"title":@"title",
                            @"price":@"1",
                            },
                        @{
                            @"title":@"title",
                            @"price":@"123456",
                            },
                        @{
                            @"title":@"title",
                            @"price":@"1234567890123456",
                            },
                        @{
                            @"title":@"title",
                            @"price":@"1",
                            },
                        @{
                            @"title":@"title",
                            @"price":@"123456",
                            },
                        @{
                            @"title":@"title",
                            @"price":@"1234567890123456",
                            },
                        @{
                            @"title":@"title",
                            @"price":@"1",
                            },
                        @{
                            @"title":@"title",
                            @"price":@"123456",
                            },
                        @{
                            @"title":@"title",
                            @"price":@"1234567890123456",
                            },
                        @{
                            @"title":@"title",
                            @"price":@"1",
                            },
                        @{
                            @"title":@"title",
                            @"price":@"123456",
                            },
                        @{
                            @"title":@"title",
                            @"price":@"1234567890123456",
                            },
                        @{
                            @"title":@"title",
                            @"price":@"1",
                            },
                        ];
    
    self.tableView                 = [[[UITableView alloc] initWithFrame:CM(0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain] addToSuperview:self.view];
    [self.tableView hl_registerCellClass:[FYDTableViewCell class]];
    self.tableView.dataSource      = self;
    self.tableView.delegate        = self;
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYDTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FYDTableViewCell hl_reuseIdentifier]];
    cell.itemPriceLabel.text = self.dataSource[indexPath.row][@"price"];
    [cell setItemPriceShow:indexPath.row % 2];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
