//
//  UIView+FangYuan.h
//  FangYuanObjCDemo
//
//  Created by 王策 on 16/3/21.
//  Copyright © 2016年 王策. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIView*(^Constraint)(CGFloat constraint);

@interface UIView (FangYuan)

@property (nonatomic, assign, readonly) CGFloat chainBottom;
@property (nonatomic, assign, readonly) CGFloat chainRight;
@property (nonatomic, assign, readonly) CGFloat chainTop;
@property (nonatomic, assign, readonly) CGFloat chainLeft;

/// 函数：设定某个 UIView 顶部距离其 superview 顶部的距离，相当于 y
@property (nonatomic, readonly) Constraint fy_top;
/// 函数：设定某个 UIView 的高度，相当于 height
@property (nonatomic, readonly) Constraint fy_height;
/// 函数：设定某个 UIView 底部距离其 superview 底部的距离
@property (nonatomic, readonly) Constraint fy_bottom;

/// 函数：设定某个 UIView 左边距离其 superview 左边的距离，相当于 x
@property (nonatomic, readonly) Constraint fy_left;
/// 函数：设定某个 UIView 的宽度，相当于 width
@property (nonatomic, readonly) Constraint fy_width;
/// 函数：设定某个 UIView 右边距离其 superview 右边的距离
@property (nonatomic, readonly) Constraint fy_right;

@end
