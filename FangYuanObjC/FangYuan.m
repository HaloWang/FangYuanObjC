//
//  FangYuan.m
//  FangYuanObjCDemo
//
//  Created by 王策 on 16/3/21.
//  Copyright © 2016年 王策. All rights reserved.
//

#import "FangYuan.h"

FYFloat FYFloatMake(CGFloat value) {
    FYFloat ruler;
    ruler.value = value;
    ruler.enable = YES;
    return ruler;
}

@implementation FYRuler

- (void)setX:(FYFloat)x {
    
    _x = x;
    
    if (!_x.enable) {
        return;
    }
    
    if (_last != FYDimensionNone) {
        if (_last == FYDimensionY) {
            _z.enable = NO;
        } else if (_last == FYDimensionZ) {
            _y.enable = NO;
        }
    }
    
    _last = FYDimensionX;
}

- (void)setY:(FYFloat)y {
    
    _y = y;
    
    if (!_y.enable) {
        return;
    }
    
    if (_last != FYDimensionNone) {
        if (_last == FYDimensionX) {
            _z.enable = NO;
        } else if (_last == FYDimensionZ) {
            _x.enable = NO;
        }
    }
    
    _last = FYDimensionY;
}

- (void)setZ:(FYFloat)z {
    
    _z = z;
    
    if (!_z.enable) {
        return;
    }
    
    if (_last != FYDimensionNone) {
        if (_last == FYDimensionX) {
            _y.enable = NO;
        } else if (_last == FYDimensionY) {
            _x.enable = NO;
        }
    }
    
    _last = FYDimensionZ;
}

@end
