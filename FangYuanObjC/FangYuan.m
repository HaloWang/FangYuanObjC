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

FYRuler FYRulerMakeZero() {
    FYRuler ruler;
    ruler.last = FYDimensionNone;
    ruler.x = FYFloatMakeZero();
    ruler.y = FYFloatMakeZero();
    ruler.z = FYFloatMakeZero();
    return ruler;
}

void setRulerX(FYRuler ruler, CGFloat x) {

    FYFloat fyX = FYFloatMake(x);

    ruler.z = fyX;

    if (!fyX.enable) {
        return;
    }

    if (ruler.last != FYDimensionNone) {
        if (ruler.last == FYDimensionY) {
            ruler.z.enable = NO;
        } else if (ruler.last == FYDimensionZ) {
            ruler.y.enable = NO;
        }
    }

    ruler.last = FYDimensionX;
}

void setRulerY(FYRuler ruler, CGFloat y) {

    FYFloat fyY = FYFloatMake(y);

    ruler.z = fyY;

    if (!fyY.enable) {
        return;
    }

    if (ruler.last != FYDimensionNone) {
        if (ruler.last == FYDimensionX) {
            ruler.z.enable = NO;
        } else if (ruler.last == FYDimensionZ) {
            ruler.x.enable = NO;
        }
    }

    ruler.last = FYDimensionY;
}

void setRulerZ(FYRuler ruler, CGFloat z) {

    FYFloat fyZ = FYFloatMake(z);

    ruler.z = fyZ;

    if (!fyZ.enable) {
        return;
    }

    if (ruler.last != FYDimensionNone) {
        if (ruler.last == FYDimensionX) {
            ruler.y.enable = NO;
        } else if (ruler.last == FYDimensionY) {
            ruler.x.enable = NO;
        }
    }

    ruler.last = FYDimensionZ;
}

FYFloat FYFloatMakeZero() {
    FYFloat fyFloat;
    fyFloat.value = 0;
    fyFloat.enable = NO;
    return fyFloat;
}

NSData *NSDataFromRuler(FYRuler ruler) {
    return [[NSData alloc]initWithBytes:&ruler length:sizeof(ruler)];
};

FYRuler FYRulerFromData(NSData *data) {
    FYRuler ruler;
    [data getBytes:&ruler length:sizeof(ruler)];
    return ruler;
};
