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
@property (nonatomic, assign, readonly) FYRuler rulerX;
@property (nonatomic, assign, readonly) FYRuler rulerY;

@end

@implementation UIView (FangYuan)

#pragma mark - Check superview

- (BOOL)hasSuperview {
    BOOL hasSuperview = self.superview != nil;
    return hasSuperview;
}

#pragma mark - Associated Object

#warning 频繁的初始化 NSData ？！真的比直接使用 NSObject 简单吗？！

- (FYRuler)rulerX {
    if (!objc_getAssociatedObject(self, &keyX)) {
        objc_setAssociatedObject(self, &keyX, NSDataFromRuler(FYRulerMakeZero()), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return FYRulerFromData(objc_getAssociatedObject(self, &keyX));
}

- (void)setRulerX:(FYRuler)rulerX {
    objc_setAssociatedObject(self, &keyX, NSDataFromRuler(rulerX), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (FYRuler)rulerY {
    if (!objc_getAssociatedObject(self, &keyY)) {
        objc_setAssociatedObject(self, &keyY, NSDataFromRuler(FYRulerMakeZero()), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return FYRulerFromData(objc_getAssociatedObject(self, &keyY));
}

- (void)setRulerY:(FYRuler)rulerY {
    objc_setAssociatedObject(self, &keyY, NSDataFromRuler(rulerY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Chainable Blocks

#pragma mark - ruler Y

- (Constraint)fy_top {
    return ^(CGFloat top) {
        
        //  Set ruler
        FYRuler rulerY = self.rulerY;
        rulerY.x       = FYFloatMake(top);
        self.rulerY    = rulerY;
        
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
        FYRuler rulerY    = self.rulerY;
        rulerY.z          = FYFloatMake(bottom);
        self.rulerY       = rulerY;
        
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
        FYRuler rulerY    = self.rulerY;
        rulerY.y          = FYFloatMake(height);
        self.rulerY       = rulerY;
        
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
        
        FYRuler rulerX    = self.rulerX;
        rulerX.x          = FYFloatMake(left);
        self.rulerX       = rulerX;
        
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
        
        FYRuler rulerX    = self.rulerX;
        rulerX.z          = FYFloatMake(right);
        self.rulerX       = rulerX;
        
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
        
        FYRuler rulerX = self.rulerX;
        rulerX.y = FYFloatMake(width);
        self.rulerX = rulerX;
        
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
