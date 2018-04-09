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

/// 升级布局，在重新设置某个 fy 值时使用。比如在 cellForRow 中为 UITableViewCell 绑定数据时使用 FangYuanObjC 重设 cell.subviews 的布局
@property (nonatomic, readonly) void(^fy_update)(void) DEPRECATED_MSG_ATTRIBUTE("不再需要手动调用");

/// 该方法将调用 view.superview 的 layoutIfNeed 方法，在 UIView.animation 中使用它
@property (nonatomic, readonly) void(^fy_animate)(void);

@end

NS_ASSUME_NONNULL_END
