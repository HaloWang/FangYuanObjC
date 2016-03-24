//
//  UIView+FangYuan.m
//  FangYuanObjCDemo
//
//  Created by 王策 on 16/3/21.
//  Copyright © 2016年 王策. All rights reserved.
//

#import "UIView+FangYuan.h"
#import "FangYuan.h"
#import <objc/runtime.h>

CGFloat GetHeight(UIView *view) {
    return view.frame.size.height;
}
CGFloat GetWidth(UIView *view) {
    return view.frame.size.width;
}
CGFloat GetX(UIView *view) {
    return view.frame.origin.x;
}
CGFloat GetY(UIView *view) {
    return view.frame.origin.y;
}

static int keyX;
static int keyY;

@interface UIView ()

@property (nonatomic, assign, readonly) BOOL hasSuperview;
@property (nonatomic, assign, readonly) FYRuler *rulerX;
@property (nonatomic, assign, readonly) FYRuler *rulerY;

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
        return objc_getAssociatedObject(self, &keyX);
    }
    return rulerY;
}

#pragma mark - Chainable Blocks

#pragma mark - ruler Y

- (Constraint)fy_top {
    return ^(CGFloat top) {
        
        //  Set ruler
        self.rulerY.x       = FYFloatMake(top);
        
        //  Set frame
        CGRect frame   = self.frame;
        frame.origin.y = top;
        self.frame     = frame;
        
        //  Check superview
        if (!self.hasSuperview) {
            return self;
        }
        
        //  use value stored in ruler to change frame
        if (self.rulerY.z.enable) {
            frame.size.height = GetHeight(self.superview) - top - self.rulerY.z.value;
        }
        self.frame = frame;
        
        return self;
    };
}

- (Constraint)fy_bottom {
    return ^(CGFloat bottom) {
        
        //  Set ruler
        self.rulerY.z          = FYFloatMake(bottom);
        
        //  Check superview
        if (!self.hasSuperview) {
            return self;
        }
        
        //  use value stored in ruler to change frame
        CGRect frame = self.frame;
        if (self.rulerY.x.enable) {
            frame.size.height = GetHeight(self.superview) - GetY(self) - self.rulerY.z.value;
        } else {
            frame.origin.y = GetHeight(self.superview) - GetHeight(self) - self.rulerY.z.value;
        }
        self.frame = frame;
        return self;
    };
}

- (Constraint)fy_height {
    return ^(CGFloat height) {
        
        //  Set ruler
        self.rulerY.y          = FYFloatMake(height);
        
        //  Set frame
        CGRect frame      = self.frame;
        frame.size.height = height;
        self.frame        = frame;
        
        //  Check superview
        if (!self.hasSuperview) {
            return self;
        }
        
        //  use value stored in ruler to change frame
        if (self.rulerY.z.enable) {
            frame.origin.y = GetHeight(self.superview) - GetHeight(self) - self.rulerY.z.value;
        }
        self.frame = frame;
        return self;
    };
}

#pragma mark - ruler X

- (Constraint)fy_left {
    return ^(CGFloat left) {
        
        self.rulerX.x          = FYFloatMake(left);
        
        CGRect frame = self.frame;
        frame.origin.x = left;
        self.frame = frame;
        
        if (!self.hasSuperview) {
            return self;
        }
        
        if (self.rulerX.z.enable) {
            frame.size.width = GetWidth(self.superview) - left - self.rulerX.z.value;
        }
        
        self.frame = frame;
        return self;
    };
}

- (Constraint)fy_right {
    return ^(CGFloat right) {
        
        self.rulerX.z          = FYFloatMake(right);
        
        if (!self.hasSuperview) {
            return self;
        }
        
        CGRect frame = self.frame;
        if (self.rulerX.x.enable) {
            frame.size.width = GetWidth(self.superview) - GetX(self) - self.rulerX.z.value;
        } else {
            frame.origin.x = GetWidth(self.superview) - GetWidth(self) - self.rulerX.z.value;
        }

        self.frame = frame;
        
        return self;
    };
}

- (Constraint)fy_width {
    return ^(CGFloat width) {

        self.rulerX.y = FYFloatMake(width);
        
        CGRect frame = self.frame;
        frame.size.width = width;
        self.frame = frame;
        
        if (!self.hasSuperview) {
            return self;
        }
        
        if (self.rulerX.z.enable) {
            frame.origin.x = GetWidth(self.superview) - GetWidth(self) - self.rulerX.z.value;
        }
        
        return self;
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
        return self.superview.frame.size.width + self.frame.origin.x;
    }
    return 0;
}


@end
