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

NS_ASSUME_NONNULL_BEGIN

@implementation UIView (FangYuan)

#pragma mark - Chainable Methods

- (CGFloat)chainLeft {
    _fy_layoutQueue(^{
        [FYConstraintManager
         pushConstraintFrom:self
         section:FYConstraintSectionRight
         ];
    });
    return 0;
}

- (CGFloat)chainRight {
    _fy_layoutQueue(^{
        [FYConstraintManager
         pushConstraintFrom:self
         section:FYConstraintSectionLeft
         ];
    });
    return 0;
}

- (CGFloat)chainTop {
    _fy_layoutQueue(^{
        [FYConstraintManager
         pushConstraintFrom:self
         section:FYConstraintSectionBottom
         ];
    });
    return 0;
}

- (CGFloat)chainBottom {
    _fy_layoutQueue(^{
        [FYConstraintManager
         pushConstraintFrom:self
         section:FYConstraintSectionTop
         ];
    });
    return 0;
}

#pragma mark - Chainable Blocks

#pragma mark Ruler Y

- (FYSectionValueChainableSetter)fy_top {
    return ^(CGFloat top) {
        [self basicSetting:^{
            [self resetRelatedConstraintHorizontal:NO];
            [self popConstraintAt:FYConstraintSectionTop value:top];
        }];
        return self;
    };
}

- (FYSectionValueChainableSetter)fy_bottom {
    return ^(CGFloat bottom) {
        [self basicSetting:^{
            [self resetRelatedConstraintHorizontal:NO];
            [self popConstraintAt:FYConstraintSectionBottom value:bottom];
        }];
        return self;
    };
}

- (FYSectionValueChainableSetter)fy_height {
    return ^(CGFloat height) {
        [self basicSetting:^{
            [self resetRelatedConstraintHorizontal:NO];
            self.rulerY.b = FYFloatMake(height);
        }];
        return self;
    };
}

#pragma mark Ruler X

- (FYSectionValueChainableSetter)fy_left {
    return ^(CGFloat left) {
        [self basicSetting:^{
            [self resetRelatedConstraintHorizontal:YES];
            [self popConstraintAt:FYConstraintSectionLeft value:left];
        }];
        return self;
    };
}

- (FYSectionValueChainableSetter)fy_right {
    return ^(CGFloat right) {
        [self basicSetting:^{
            [self resetRelatedConstraintHorizontal:YES];
            [self popConstraintAt:FYConstraintSectionRight value:right];
        }];
        return self;
    };
}

- (FYSectionValueChainableSetter)fy_width {
    return ^(CGFloat width) {
        [self basicSetting:^{
            [self resetRelatedConstraintHorizontal:YES];
            self.rulerX.b = FYFloatMake(width);
        }];
        return self;
    };
}

- (UIView *(^)(UIEdgeInsets))fy_edge {
    return ^(UIEdgeInsets edge) {
        [self basicSetting:^{
            [self resetRelatedConstraintHorizontal:YES];
            [self resetRelatedConstraintHorizontal:NO];
            [self popConstraintAt:FYConstraintSectionTop value:edge.top];
            [self popConstraintAt:FYConstraintSectionLeft value:edge.left];
            [self popConstraintAt:FYConstraintSectionRight value:edge.right];
            [self popConstraintAt:FYConstraintSectionBottom value:edge.bottom];
        }];
        return self;
    };
}

- (UIView *(^)(CGFloat, CGFloat))fy_xRange {
    return ^(CGFloat left, CGFloat right) {
        [self basicSetting:^{
            [self resetRelatedConstraintHorizontal:YES];
            [self popConstraintAt:FYConstraintSectionLeft value:left];
            [self popConstraintAt:FYConstraintSectionRight value:right];
        }];
        return self;
    };
}

- (void (^)(void))fy_update {
    return ^{
        [FYConstraintManager layout:self.superview];
    };
}

@end

NS_ASSUME_NONNULL_END
