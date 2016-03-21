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

static int keyX;
static int keyY;
static int fyTop;
static int fyBottom;
static int fyLeft;
static int fyRight;
static int fyHeight;
static int fyWidth;

@interface UIView ()

@property (nonatomic, assign, readonly) BOOL hasSuperview;
@property (nonatomic, strong, readonly) NSMutableArray *fangYuanX;
@property (nonatomic, strong, readonly) NSMutableArray *fangYuanY;

@end

@implementation UIView (FangYuan)

#pragma mark - Check superview

- (BOOL)hasSuperview {
    BOOL hasSuperview = self.superview != nil;
    return hasSuperview;
}

#pragma mark - Associated Object

- (NSMutableArray *)fangYuanX {
    if (!objc_getAssociatedObject(self, &keyX)) {
        objc_setAssociatedObject(self, &keyX, @[].mutableCopy, OBJC_ASSOCIATION_RETAIN);
    }
    return objc_getAssociatedObject(self, &keyX);
}

- (NSMutableArray *)fangYuanY {
    if (!objc_getAssociatedObject(self, &keyY)) {
        objc_setAssociatedObject(self, &keyY, @[].mutableCopy, OBJC_ASSOCIATION_RETAIN);
    }
    return objc_getAssociatedObject(self, &keyY);
}

#pragma mark - Chainable Blocks

- (Constraint)fy_top {
    if (!objc_getAssociatedObject(self, &fyTop)) {
        __weak typeof(self) weakSelf = self;
        Constraint cb = ^(CGFloat top) {
            
            CGRect frame = self.frame;
            frame.origin.y = top;
            self.frame = frame;
            
            if (self.hasSuperview) {
                // TODO: ⚠️ 未完成
            }
            
            return weakSelf;
        };
        objc_setAssociatedObject(self, &fyTop, cb, OBJC_ASSOCIATION_RETAIN);
    }
    return objc_getAssociatedObject(self, &fyTop);
}

- (Constraint)fy_bottom {
    if (!objc_getAssociatedObject(self, &fyBottom)) {
        __weak typeof(self) weakSelf = self;
        Constraint cb = ^(CGFloat bottom) {
            // TODO: ⚠️ 未完成
            return weakSelf;
        };
        objc_setAssociatedObject(self, &fyBottom, cb, OBJC_ASSOCIATION_RETAIN);
    }
    return objc_getAssociatedObject(self, &fyBottom);
}

- (Constraint)fy_height {
    if (!objc_getAssociatedObject(self, &fyHeight)) {
        __weak typeof(self) weakSelf = self;
        Constraint cb = ^(CGFloat bottom) {
            // TODO: ⚠️ 未完成
            return weakSelf;
        };
        objc_setAssociatedObject(self, &fyHeight, cb, OBJC_ASSOCIATION_RETAIN);
    }
    return objc_getAssociatedObject(self, &fyHeight);
}

- (Constraint)fy_left {
    if (!objc_getAssociatedObject(self, &fyLeft)) {
        __weak typeof(self) weakSelf = self;
        Constraint cb = ^(CGFloat bottom) {
            // TODO: ⚠️ 未完成
            return weakSelf;
        };
        objc_setAssociatedObject(self, &fyLeft, cb, OBJC_ASSOCIATION_RETAIN);
    }
    return objc_getAssociatedObject(self, &fyLeft);
}

- (Constraint)fy_right {
    if (!objc_getAssociatedObject(self, &fyRight)) {
        __weak typeof(self) weakSelf = self;
        Constraint cb = ^(CGFloat bottom) {
            // TODO: ⚠️ 未完成
            return weakSelf;
        };
        objc_setAssociatedObject(self, &fyRight, cb, OBJC_ASSOCIATION_RETAIN);
    }
    return objc_getAssociatedObject(self, &fyRight);
}

- (Constraint)fy_width {
    if (!objc_getAssociatedObject(self, &fyWidth)) {
        __weak typeof(self) weakSelf = self;
        Constraint cb = ^(CGFloat bottom) {
            // TODO: ⚠️ 未完成
            return weakSelf;
        };
        objc_setAssociatedObject(self, &fyWidth, cb, OBJC_ASSOCIATION_RETAIN);
    }
    return objc_getAssociatedObject(self, &fyWidth);
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
