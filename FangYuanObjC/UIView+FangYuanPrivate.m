//
//  UIView+FangYuanPrivate.m
//  Pods
//
//  Created by 王策 on 16/5/4.
//
//

#import "UIView+FangYuanPrivate.h"
#import "FYDependencyManager.h"
#import <objc/runtime.h>

#define             \
setIfNE(a, b)       \
if (a != b) {       \
    a = b;          \
}                   \

@implementation UIView (FangYuanPrivate)

#pragma mark - Method Swizzling

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(_swizzled_layoutSubviews);
        
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)_swizzled_layoutSubviews {
    [self _swizzled_layoutSubviews];
    if (!self.subviewUsingFangYuan) {
        return;
    }
    [FYDependencyManager layout:self];
}

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

#pragma mark - Quick Setter / Getter

- (NSArray<UIView *> *)usingFangYuanSubviews {
    NSMutableArray *mArr = @[].mutableCopy;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.usingFangYuan) {
            [mArr addObject:obj];
        }
    }];
    return mArr.copy;
}

- (BOOL)subviewUsingFangYuan {
    for (UIView *subview in self.subviews) {
        if (subview.usingFangYuan) {
            return YES;
        }
    }
    return NO;
}

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

- (void)basicSetting {
    [self setNeedsLayout];
    self.usingFangYuan = YES;
}

- (void)layoutWithFangYuan {
    
    UIView *superview = self.superview;
    
    //  X
    FYRuler *rx = self.rulerX;
    CGFloat newX;
    CGFloat newWidth;
    if (rx.a.enable) {
        newX = rx.a.value;
        newWidth = rx.b.enable ? rx.b.value : superview.fyWidth - newX - rx.c.value;
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
        newHeight = ry.b.enable ? ry.b.value : superview.fyHeight - newY - ry.c.value;
    } else {
        newY = superview.fyHeight - ry.b.value - ry.c.value;
        newHeight = ry.b.value;
    }
    setIfNE(self.fyY, newY);
    setIfNE(self.fyHeight, newHeight)
}

@end
