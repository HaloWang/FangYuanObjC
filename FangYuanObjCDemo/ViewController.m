//
//  ViewController.m
//  FangYuanObjCDemo
//
//  Created by 王策 on 16/3/21.
//  Copyright © 2016年 王策. All rights reserved.
//

#import "ViewController.h"
#import <UIView+FangYuan.h>
#import "Demo.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIView *viewInBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.view1 = [UIView new];
    [self.view addSubview:_view1];
    _view1.backgroundColor = [UIColor redColor];
    
    self.view2 = [UIView new];
    [self.view addSubview:_view2];
    _view2.backgroundColor = [UIColor blueColor];
    
    self.view3 = [UIView new];
    [self.view addSubview:_view3];
    _view3.backgroundColor = [UIColor greenColor];
    
    self.btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn1.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_btn1];
    
    self.viewInBtn = [UIView new];
    _viewInBtn.backgroundColor = [UIColor darkGrayColor];
    [self.btn1 addSubview:_viewInBtn];
    
    DemoLayout(^{
        
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
        
        _view2
        .fy_bottom(50)
        .fy_top(_view1.chainBottom)
        .fy_left(10)
        .fy_right(100);
        
        _view3
        .fy_width(25)
        .fy_left(_view1.chainRight + 50)
        .fy_top(50)
        .fy_bottom(_view2.chainTop - 25);
        
        _btn1
        .fy_width(100)
        .fy_right(20)
        .fy_top(100)
        .fy_height(50);
        
        _viewInBtn
        .fy_edge(UIEdgeInsetsMake(3, 3, 3, 3));
        
    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"✅%@", _btn1);
        NSLog(@"✅%@", _viewInBtn);
    });
    
}

@end
