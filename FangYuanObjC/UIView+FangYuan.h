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

@property (nonatomic, readonly) Constraint fy_top;
@property (nonatomic, readonly) Constraint fy_bottom;
@property (nonatomic, readonly) Constraint fy_height;
@property (nonatomic, readonly) Constraint fy_width;
@property (nonatomic, readonly) Constraint fy_left;
@property (nonatomic, readonly) Constraint fy_right;

@end
