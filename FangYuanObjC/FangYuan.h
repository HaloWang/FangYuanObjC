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

@interface FYRuler : NSObject

@property (nonatomic, assign) FYDimension last;
@property (nonatomic, assign) FYFloat x;
@property (nonatomic, assign) FYFloat y;
@property (nonatomic, assign) FYFloat z;

@end
