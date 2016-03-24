//
//  FangYuan.h
//  FangYuanObjCDemo
//
//  Created by 王策 on 16/3/21.
//  Copyright © 2016年 王策. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

struct FYFloat {
    BOOL enable;
    CGFloat value;
};
typedef struct FYFloat FYFloat;

FYFloat FYFloatMake(CGFloat value);
FYFloat FYFloatMakeZero();

typedef NS_ENUM(NSUInteger, FYDimension) {
    FYDimensionNone,
    FYDimensionX,
    FYDimensionY,
    FYDimensionZ,
};

struct FYRuler {
    FYDimension last;
    FYFloat x;
    FYFloat y;
    FYFloat z;
};
typedef struct FYRuler FYRuler;

FYRuler FYRulerMakeZero();

void setRulerX(FYRuler ruler, CGFloat x);
void setRulerY(FYRuler ruler, CGFloat y);
void setRulerZ(FYRuler ruler, CGFloat z);

NSData *NSDataFromRuler(FYRuler ruler);

FYRuler FYRulerFromData(NSData *data);
