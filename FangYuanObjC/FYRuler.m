//
//  FYRuler.m
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import "FYRuler.h"

FYFloat FYFloatMake(CGFloat value) {
    FYFloat fyFloat;
    fyFloat.value = value;
    fyFloat.enable = YES;
    return fyFloat;
}

@implementation FYRuler

- (void)setA:(FYFloat)a {

    _a = a;

    if (!_a.enable) {
        return;
    }

    if (_last != FYSectionNone) {
        if (_last == FYSectionB) {
            _c.enable = NO;
        } else if (_last == FYSectionC) {
            _b.enable = NO;
        }
    }

    _last = FYSectionA;
}

- (void)setB:(FYFloat)b {

    _b = b;

    if (!_b.enable) {
        return;
    }

    if (_last != FYSectionNone) {
        if (_last == FYSectionA) {
            _c.enable = NO;
        } else if (_last == FYSectionC) {
            _a.enable = NO;
        }
    }

    _last = FYSectionB;
}

- (void)setC:(FYFloat)c {

    _c = c;

    if (!_c.enable) {
        return;
    }

    if (_last != FYSectionNone) {
        if (_last == FYSectionA) {
            _b.enable = NO;
        } else if (_last == FYSectionB) {
            _a.enable = NO;
        }
    }

    _last = FYSectionC;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@\na:%f\nb:%f\nc:%f", [self class], self.a.value, self.b.value, self.c.value];
}

@end
