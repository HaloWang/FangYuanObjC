//
//  UIView+FangYuan.m
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import "UIView+FangYuan.h"
#import <objc/runtime.h>
#import "FYDependencyManager.h"
#import "FYDependency.h"
#import "FYHolder.h"
#import "FYRuler.h"

@interface UIView ()

/// 横轴标尺
@property (nonatomic, readonly) FYRuler *rulerX;
/// 纵轴标尺
@property (nonatomic, readonly) FYRuler *rulerY;

@property (nonatomic, getter=isUsingFangYuan) BOOL usingFangYuan;

@property (nonatomic, readonly) FYHolder *holder;

@end

@interface UIView (FangYuanHelper)

@property (nonatomic, assign) CGFloat fyX;
@property (nonatomic, assign) CGFloat fyY;
@property (nonatomic, assign) CGFloat fyHeight;
@property (nonatomic, assign) CGFloat fyWidth;

@end

@implementation UIView (FangYuanHelper)

- (CGFloat)fyX {
    return self.frame.origin.x;
}

- (CGFloat)fyY {
    return self.frame.origin.y;
}

- (CGFloat)fyWidth {
    return self.frame.size.width;
}

- (CGFloat)fyHeight {
    return self.frame.size.height;
}

- (void)setFyX:(CGFloat)fyX {
    CGRect rect = self.frame;
    rect.origin.x = fyX;
    self.frame = rect;
}

- (void)setFyY:(CGFloat)fyY {
    CGRect rect = self.frame;
    rect.origin.y = fyY;
    self.frame = rect;
}

- (void)setFyWidth:(CGFloat)fyWidth {
    CGRect rect = self.frame;
    rect.size.width = fyWidth;
    self.frame = rect;
}

- (void)setFyHeight:(CGFloat)fyHeight {
    CGRect rect = self.frame;
    rect.size.height = fyHeight;
    self.frame = rect;
}

@end

@implementation UIView (FangYuan)

#pragma mark - Associated Object

static int _AOHolderKey;

- (FYHolder *)holder {
    FYHolder *holder = objc_getAssociatedObject(self, &_AOHolderKey);
    if (!holder) {
        holder = [FYHolder new];
        objc_setAssociatedObject(self, &_AOHolderKey, holder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return holder;
}

- (FYRuler *)rulerX {
    return self.holder.rulerX;
}

- (FYRuler *)rulerY {
    return self.holder.rulerY;
}

- (BOOL)isUsingFangYuan {
    return self.holder.isUsingFangYuan;
}

- (void)setUsingFangYuan:(BOOL)usingFangYuan {
    self.holder.usingFangYuan = usingFangYuan;
}

#pragma mark - Chainable Methods

- (CGFloat)chainLeft {
    [FYDependencyManager pushDependencyFrom:self to:nil direction:FYDependencyDirectionLeftRight value:0];
    return 0;
}

- (CGFloat)chainRight {
    [FYDependencyManager pushDependencyFrom:self to:nil direction:FYDependencyDirectionRightLeft value:0];
    return 0;
}

- (CGFloat)chainTop {
    [FYDependencyManager pushDependencyFrom:self to:nil direction:FYDependencyDirectionTopBottom value:0];
    return 0;
}

- (CGFloat)chainBottom {
    [FYDependencyManager pushDependencyFrom:self to:nil direction:FYDependencyDirectionBottomTop value:0];
    return 0;
}

#pragma mark - Chainable Blocks

- (void)basicSetting {
    [self setNeedsLayout];
    self.usingFangYuan = YES;
}

#pragma mark Ruler Y

- (FYSectionValueChainableSetter)fy_top {
    return ^(CGFloat top) {
        [self basicSetting];
        self.rulerY.a = FYFloatMake(top);
        return self;
    };
}

- (FYSectionValueChainableSetter)fy_bottom {
    return ^(CGFloat bottom) {
        [self basicSetting];
        self.rulerY.c = FYFloatMake(bottom);
        return self;
    };
}

- (FYSectionValueChainableSetter)fy_height {
    return ^(CGFloat height) {
        [self basicSetting];
        self.rulerY.b = FYFloatMake(height);
        return self;
    };
}

#pragma mark Ruler X

- (FYSectionValueChainableSetter)fy_left {
    return ^(CGFloat left) {
        [self basicSetting];
        self.rulerX.a = FYFloatMake(left);
        return self;
    };
}

- (FYSectionValueChainableSetter)fy_right {
    return ^(CGFloat right) {
        [self basicSetting];
        self.rulerX.c = FYFloatMake(right);
        return self;
    };
}

- (FYSectionValueChainableSetter)fy_width {
    return ^(CGFloat width) {
        [self basicSetting];
        self.rulerX.b = FYFloatMake(width);
        return self;
    };
}

- (UIView *(^)(UIEdgeInsets))fy_edge {
    return ^(UIEdgeInsets edge) {
        return self.fy_top(edge.top).fy_left(edge.left).fy_right(edge.right).fy_bottom(edge.bottom);
    };
}

#pragma mark - Private Methods

#define setIfNE(a, b)\
        if (a != b) {\
            a = b;\
        }

- (void)layoutWithFangYuan {
    
    UIView *superview = self.superview;
    
    //  X
    FYRuler *rx = self.rulerX;
    CGFloat newX;
    CGFloat newWidth;
    if (rx.a.enable) {
        newX = rx.a.value;
        newWidth = rx.b.enable ? superview.fyWidth - newX - rx.c.value : rx.b.value;
    } else {
        newX = superview.fyWidth - rx.b.value - rx.c.value;
        newWidth = rx.b.value;
    }
    setIfNE(self.fyX, newX)
    setIfNE(self.fyWidth, newWidth)
    
    //  Y
    FYRuler *ry = self.rulerY;
    CGFloat newY;
    CGFloat newHeight;
    if (ry.a.enable) {
        newY = ry.a.value;
        newHeight = ry.b.enable ? superview.fyHeight - newY - ry.c.value : ry.b.value;
    } else {
        newY = superview.fyHeight - ry.b.value - ry.c.value;
        newHeight = ry.b.value;
    }
    setIfNE(self.fyY, newY);
    setIfNE(self.fyHeight, newHeight)
}


@end
