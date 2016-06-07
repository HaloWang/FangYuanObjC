//
//  UIView+FangYuanPrivate.h
//  Pods
//
//  Created by 王策 on 16/5/4.
//
//

#import <UIKit/UIKit.h>
#import "FYRuler.h"
#import "FYHolder.h"
#import "FYConstraint.h"

@interface UIView (FangYuanPrivate)

@property (nonatomic, readonly) FYHolder *fy_AssociatedObjectHolder;
@property (nonatomic, readonly) FYRuler *rulerX;
@property (nonatomic, readonly) FYRuler *rulerY;

@property (nonatomic, getter=isUsingFangYuan) BOOL usingFangYuan;
@property (nonatomic, readonly) NSArray<UIView *> *usingFangYuanSubviews;

@property (nonatomic, assign) CGFloat fyX;
@property (nonatomic, assign) CGFloat fyY;
@property (nonatomic, assign) CGFloat fyHeight;
@property (nonatomic, assign) CGFloat fyWidth;

- (void)layoutWithFangYuan;

- (void)basicSetting:(void(^)())setting;

- (void)popConstraintAt:(FYConstraintDirection)direction value:(CGFloat)value;

- (void)resetRelatedConstraintHorizontal:(BOOL)isHorizontal;

@end
