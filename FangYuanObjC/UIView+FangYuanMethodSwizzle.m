//
//  UIView+FangYuanMethodSwizzle.m
//  FangYuanObjCDemo
//
//  Created by 王策 on 16/3/24.
//  Copyright © 2016年 王策. All rights reserved.
//

#import "UIView+FangYuanMethodSwizzle.h"
#import <objc/runtime.h>

@implementation UIView (FangYuanMethodSwizzle)

+ (void)load {
    [super load];

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
    NSLog(@"✅%@", [self class]);
    
    //  TODO: 但是我怎么知道不同 subview 之间是如何依赖的呢？
    
}



@end
