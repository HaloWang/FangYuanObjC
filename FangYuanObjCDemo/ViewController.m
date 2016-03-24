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
    
    UIView *view1 = [UIView new];
    [self.view addSubview:view1];
    view1.backgroundColor = [UIColor redColor];
    
    view1
    .fy_bottom(-50)
    .fy_top(100)
    .fy_left(20)
    .fy_bottom(100)
    .fy_right(0)
    .fy_right(50)
    .fy_left(50)
    .fy_top(200)
    .fy_width(50)
    .fy_height(200);

    UIView *view2 = [UIView new];
    [self.view addSubview:view2];
    view2.backgroundColor = [UIColor blueColor];

    view2
    .fy_bottom(50)
    .fy_top(view1.chainBottom)
    .fy_left(10)
    .fy_right(view1.chainLeft);


    UIView *view3 = [UIView new];
    [self.view addSubview:view3];
    view3.backgroundColor = [UIColor greenColor];
    
    NSLog(@"%f",view2.chainRight);
    
    view3
    .fy_bottom(view2.chainTop)
    .fy_top(50)
    .fy_left(view1.chainRight + 50)
    .fy_width(25);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
