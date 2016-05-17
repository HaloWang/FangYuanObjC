//
//  UIView+FangYuan.m
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import "UIView+FangYuan.h"
#import "FYConstraintManager.h"
#import "UIView+FangYuanPrivate.h"

@implementation UIView (FangYuan)

#pragma mark - Chainable Methods

- (CGFloat)chainLeft {
    [FYConstraintManager
     pushConstraintFrom:self
     direction:FYConstraintDirectionLeftRight
     ];
    return 0;
}

- (CGFloat)chainRight {
    [FYConstraintManager
     pushConstraintFrom:self
     direction:FYConstraintDirectionRightLeft
     ];
    return 0;
}

- (CGFloat)chainTop {
    [FYConstraintManager
     pushConstraintFrom:self
     direction:FYConstraintDirectionTopBottom
     ];
    return 0;
}

- (CGFloat)chainBottom {
    [FYConstraintManager
     pushConstraintFrom:self
     direction:FYConstraintDirectionBottomTop
     ];
    return 0;
}

#pragma mark - Chainable Blocks

#pragma mark Ruler Y

- (FYSectionValueChainableSetter)fy_top {
    return ^(CGFloat top) {
        [self basicSetting];
        self.rulerY.a = FYFloatMake(top);
        [FYConstraintManager
         popConstraintTo:self
         direction:FYConstraintDirectionBottomTop
         value:top];
        return self;
    };
}

- (FYSectionValueChainableSetter)fy_bottom {
    return ^(CGFloat bottom) {
        [self basicSetting];
        self.rulerY.c = FYFloatMake(bottom);
        [FYConstraintManager
         popConstraintTo:self
         direction:FYConstraintDirectionTopBottom
         value:bottom];
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
        [FYConstraintManager
         popConstraintTo:self
         direction:FYConstraintDirectionRightLeft
         value:left];
        return self;
    };
}

- (FYSectionValueChainableSetter)fy_right {
    return ^(CGFloat right) {
        [self basicSetting];
        self.rulerX.c = FYFloatMake(right);
        [FYConstraintManager
         popConstraintTo:self
         direction:FYConstraintDirectionLeftRight
         value:right];
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

- (void (^)())toAnimation {
    return ^{
        [FYConstraintManager layout:self.superview];
    };
}

@end
