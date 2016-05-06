//
//  ViewController.m
//  FangYuanObjCDemo
//
//  Created by 王策 on 16/3/21.
//  Copyright © 2016年 王策. All rights reserved.
//

#import "ViewController.h"
#import <UIView+FangYuan.h>

@interface ViewController ()

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view1 = [UIView new];
    [self.view addSubview:_view1];
    _view1.backgroundColor = [UIColor redColor];
    
    _view1
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

    self.view2 = [UIView new];
    [self.view addSubview:_view2];
    _view2.backgroundColor = [UIColor blueColor];

    _view2
    .fy_bottom(50)
    .fy_top(_view1.chainBottom)
    .fy_left(10)
    .fy_right(100);

    self.view3 = [UIView new];
    [self.view addSubview:_view3];
    _view3.backgroundColor = [UIColor greenColor];
    
    _view3
    .fy_width(25)
    .fy_left(_view1.chainRight + 50)
    .fy_top(50)
    .fy_bottom(_view2.chainTop - 25);
}

@end
