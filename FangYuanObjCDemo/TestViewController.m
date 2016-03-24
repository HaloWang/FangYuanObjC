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
#import "FangYuan.h"


@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    FYView *v = [FYView new];
    [self.view addSubview:v];
    v.backgroundColor = [UIColor redColor];
    
    v
    .fy_top(100)
    .fy_left(20)
    .fy_bottom(100)
    .fy_right(0);
    
    FYRuler fy = FYRulerMakeZero();
    fy.x = FYFloatMake(8);
    
    NSData *data = [NSData dataWithBytes:&fy length:sizeof(fy)];
    
    FYRuler zz;
    
    [data getBytes:&zz length:sizeof(zz)];
}

- (void)dealloc {
    NSLog(@"✅ TestViewController dealloc");
}

@end
