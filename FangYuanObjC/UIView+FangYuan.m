//
//  UIView+FangYuan.m
//  FangYuanObjCDemo
//
//  Created by 王策 on 16/3/21.
//  Copyright © 2016年 王策. All rights reserved.
//

#import "UIView+FangYuan.h"
#import "FYRuler.h"
#import <objc/runtime.h>

#pragma mark - Helper Function

CGFloat fyHeight(UIView *view) {
    return view.frame.size.height;
}
CGFloat fyWidth(UIView *view) {
    return view.frame.size.width;
}
CGFloat fyX(UIView *view) {
    return view.frame.origin.x;
}
CGFloat fyY(UIView *view) {
    return view.frame.origin.y;
}

static int keyX;
static int keyY;

@interface UIView ()

@property (nonatomic, assign, readonly) BOOL hasSuperview;
/// 横轴标尺
@property (nonatomic, readonly) FYRuler *rulerX;
/// 纵轴标尺
@property (nonatomic, readonly) FYRuler *rulerY;

@end

@implementation UIView (FangYuan)

#pragma mark - Check superview

- (BOOL)hasSuperview {
    BOOL hasSuperview = self.superview != nil;
    return hasSuperview;
}

#pragma mark - Associated Object

- (FYRuler *)rulerX {
    FYRuler *rulerX = objc_getAssociatedObject(self, &keyX);
    if (rulerX == nil) {
        objc_setAssociatedObject(self, &keyX, [FYRuler new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return objc_getAssociatedObject(self, &keyX);
    }
    return rulerX;
}

- (FYRuler *)rulerY {
    FYRuler *rulerY = objc_getAssociatedObject(self, &keyY);
    if (!objc_getAssociatedObject(self, &keyY)) {
        objc_setAssociatedObject(self, &keyY, [FYRuler new], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return objc_getAssociatedObject(self, &keyY);
    }
    return rulerY;
}

#pragma mark - Chainable Blocks

#pragma mark Ruler Y

- (FYSectionValueChainableSetter)fy_top {
    return ^(CGFloat top) {

        //  Set ruler
        self.rulerY.a = FYFloatMake(top);

        //  Set frame
        CGRect frame = self.frame;
        frame.origin.y = top;
        self.frame = frame;

        //  Check superview
        if (!self.hasSuperview) {
            return self;
        }

        //  use value stored in ruler to change frame
        if (self.rulerY.c.enable) {
            frame.size.height = fyHeight(self.superview) - top - self.rulerY.c.value;
        }
        self.frame = frame;

        return self;
    };
}

- (FYSectionValueChainableSetter)fy_bottom {
    return ^(CGFloat bottom) {

        //  Set ruler
        self.rulerY.c = FYFloatMake(bottom);

        //  Check superview
        if (!self.hasSuperview) {
            return self;
        }

        //  use value stored in ruler to change frame
        CGRect frame = self.frame;
        if (self.rulerY.a.enable) {
            frame.size.height = fyHeight(self.superview) - fyY(self) - self.rulerY.c.value;
        } else {
            frame.origin.y = fyHeight(self.superview) - fyHeight(self) - self.rulerY.c.value;
        }
        self.frame = frame;
        return self;
    };
}

- (FYSectionValueChainableSetter)fy_height {
    return ^(CGFloat height) {

        //  Set ruler
        self.rulerY.b = FYFloatMake(height);

        //  Set frame
        CGRect frame = self.frame;
        frame.size.height = height;
        self.frame = frame;

        //  Check superview
        if (!self.hasSuperview) {
            return self;
        }

        //  use value stored in ruler to change frame
        if (self.rulerY.c.enable) {
            frame.origin.y = fyHeight(self.superview) - fyHeight(self) - self.rulerY.c.value;
        }
        self.frame = frame;
        return self;
    };
}

#pragma mark Ruler X

- (FYSectionValueChainableSetter)fy_left {
    return ^(CGFloat left) {

        self.rulerX.a = FYFloatMake(left);

        CGRect frame = self.frame;
        frame.origin.x = left;
        self.frame = frame;

        if (!self.hasSuperview) {
            return self;
        }

        if (self.rulerX.c.enable) {
            frame.size.width = fyWidth(self.superview) - left - self.rulerX.c.value;
        }

        self.frame = frame;
        return self;
    };
}

- (FYSectionValueChainableSetter)fy_right {
    return ^(CGFloat right) {

        self.rulerX.c = FYFloatMake(right);

        if (!self.hasSuperview) {
            return self;
        }

        CGRect frame = self.frame;
        if (self.rulerX.a.enable) {
            frame.size.width = fyWidth(self.superview) - fyX(self) - self.rulerX.c.value;
        } else {
            frame.origin.x = fyWidth(self.superview) - fyWidth(self) - self.rulerX.c.value;
        }

        self.frame = frame;

        return self;
    };
}

- (FYSectionValueChainableSetter)fy_width {
    return ^(CGFloat width) {

        self.rulerX.b = FYFloatMake(width);

        CGRect frame = self.frame;
        frame.size.width = width;
        self.frame = frame;

        if (!self.hasSuperview) {
            return self;
        }

        if (self.rulerX.c.enable) {
            frame.origin.x = fyWidth(self.superview) - fyWidth(self) - self.rulerX.c.value;
        }

        self.frame = frame;

        return self;
    };
}

- (UIView *(^)(UIEdgeInsets))fy_edge {
    return ^(UIEdgeInsets edge) {
        return self
        .fy_top(edge.top)
        .fy_left(edge.left)
        .fy_right(edge.right)
        .fy_bottom(edge.bottom);
    };
}

#pragma mark - Chainable Getters

- (CGFloat)chainBottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)chainTop {
    if (self.hasSuperview) {
        return self.superview.frame.size.height - self.frame.origin.y;
    }
    return 0;
}

- (CGFloat)chainRight {
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)chainLeft {
    if (self.hasSuperview) {
        return self.superview.frame.size.width - self.frame.origin.x;
    }
    return 0;
}


@end
