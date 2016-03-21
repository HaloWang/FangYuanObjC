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
    [self.view addSubview:v];
    
    v.fy_top(20);
}

- (void)dealloc {
    NSLog(@"✅ TestViewController dealloc");
}

@end
