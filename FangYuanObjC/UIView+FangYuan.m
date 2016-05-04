//
//  UIView+FangYuan.m
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import "UIView+FangYuan.h"
#import "FYDependencyManager.h"
#import "UIView+FangYuanPrivate.h"

@implementation UIView (FangYuan)

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

#pragma mark Ruler Y

- (FYSectionValueChainableSetter)fy_top {
    return ^(CGFloat top) {
        [self basicSetting];
        self.rulerY.a = FYFloatMake(top);
        [FYDependencyManager popDependencyFrom:nil to:self direction:FYDependencyDirectionBottomTop value:top];
        return self;
    };
}

- (FYSectionValueChainableSetter)fy_bottom {
    return ^(CGFloat bottom) {
        [self basicSetting];
        self.rulerY.c = FYFloatMake(bottom);
        [FYDependencyManager popDependencyFrom:nil to:self direction:FYDependencyDirectionTopBottom value:bottom];
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
        [FYDependencyManager popDependencyFrom:nil to:self direction:FYDependencyDirectionRightLeft value:left];
        return self;
    };
}

- (FYSectionValueChainableSetter)fy_right {
    return ^(CGFloat right) {
        [self basicSetting];
        self.rulerX.c = FYFloatMake(right);
        [FYDependencyManager popDependencyFrom:nil to:self direction:FYDependencyDirectionLeftRight value:right];
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

@end
