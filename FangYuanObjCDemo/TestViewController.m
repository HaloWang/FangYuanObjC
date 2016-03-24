//
//  TestViewController.m
//  FangYuanObjCDemo
//
//  Created by 王策 on 16/3/21.
//  Copyright © 2016年 王策. All rights reserved.
//

#import "TestViewController.h"
#import "UIView+FangYuan.h"
#import "FYView.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    FYView *v = [FYView new];
    v.backgroundColor = [UIColor redColor];
    [self.view addSubview:v];
    
    v
    .fy_top(20)
    .fy_left(20)
    .fy_height(100)
    .fy_width(100);
    
}

- (void)dealloc {
    NSLog(@"✅ TestViewController dealloc");
}

@end
