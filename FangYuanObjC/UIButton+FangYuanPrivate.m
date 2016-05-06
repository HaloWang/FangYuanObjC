//
//  UIButton+FangYuanPrivate.m
//  Pods
//
//  Created by 王策 on 16/5/6.
//
//

#import "UIButton+FangYuanPrivate.h"
#import <objc/runtime.h>
#import "FYDependencyManager.h"
#import "UIView+FangYuanPrivate.h"


//  @see http://stackoverflow.com/questions/35590676/custom-uibutton-layoutsubviews-doesnt-work-unless-super-layoutsubviews-is-c

// TODO: 永远不要写重复的代码！

@implementation UIButton (FangYuanPrivate)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(layoutSubviews);
        SEL swizzledSelector = @selector(_swizzled_layoutSubviews);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        method_exchangeImplementations(originalMethod, swizzledMethod);
    });
}

//  If doesn't implement following method, we will get:
//  *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[_UINavigationBarBackground state]: unrecognized selector sent to instance 0x12f589420'

- (void)_swizzled_layoutSubviews {
    [self _swizzled_layoutSubviews];
    if (!self.subviewUsingFangYuan) {
        return;
    }
    [FYDependencyManager layout:self];
}

@end
