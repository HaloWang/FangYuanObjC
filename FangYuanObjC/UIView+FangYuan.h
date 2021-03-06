//
//  UIView+FangYuan.h
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef UIView * _Nullable (^FYSectionValueChainableSetter)(CGFloat value);

@interface UIView (FangYuan)

@property (nonatomic, readonly) CGFloat chainTop;
@property (nonatomic, readonly) CGFloat chainLeft;
@property (nonatomic, readonly) CGFloat chainBottom;
@property (nonatomic, readonly) CGFloat chainRight;

/// 函数：设定某个 UIView 顶部距离其 superview 顶部的距离，相当于 y
@property (nonatomic, readonly) FYSectionValueChainableSetter fy_top;
/// 函数：设定某个 UIView 的高度，相当于 height
@property (nonatomic, readonly) FYSectionValueChainableSetter fy_height;
/// 函数：设定某个 UIView 底部距离其 superview 底部的距离
@property (nonatomic, readonly) FYSectionValueChainableSetter fy_bottom;

/// 函数：设定某个 UIView 左边距离其 superview 左边的距离，相当于 x
@property (nonatomic, readonly) FYSectionValueChainableSetter fy_left;
/// 函数：设定某个 UIView 的宽度，相当于 width
@property (nonatomic, readonly) FYSectionValueChainableSetter fy_width;
/// 函数：设定某个 UIView 右边距离其 superview 右边的距离
@property (nonatomic, readonly) FYSectionValueChainableSetter fy_right;

/// 函数：设定某个 UIView 四个边距离其父视图相对四边的距离
@property (nonatomic, readonly) UIView *(^fy_edge)(UIEdgeInsets edge);

/// 同时设定 fy_left 与 fy_right
@property (nonatomic, readonly) UIView *(^fy_xRange)(CGFloat left, CGFloat right);

/// 同时设定 fy_width 与 fy_height
@property (nonatomic, readonly) UIView *(^fy_size)(CGFloat width, CGFloat height);

/// 该方法将调用直接使用方圆设定某 UIView.frame，在 UIView.animation 中使用该方法以实现动画
@property (nonatomic, readonly) void(^fy_animate)(void);

@end

NS_ASSUME_NONNULL_END
