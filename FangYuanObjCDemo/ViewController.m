//
//  ViewController.m
//  FangYuanObjCDemo
//
//  Created by 王策 on 16/3/21.
//  Copyright © 2016年 王策. All rights reserved.
//

#import "ViewController.h"
#import "UIView+FangYuan.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *v = [UIView new];
    [self.view addSubview:v];
    v.backgroundColor = [UIColor redColor];
    
    v
    .fy_top(100)
    .fy_left(20)
    .fy_bottom(100)
    .fy_right(0)
    .fy_right(50)
    .fy_left(50)
    .fy_bottom(-50)
    .fy_top(200);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
