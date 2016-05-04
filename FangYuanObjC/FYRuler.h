//
//  FYRuler.h
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/// 代表一个 CGFloat 值，同时附加有该值是否管用的信息
typedef struct FYFloat {
    BOOL enable;
    CGFloat value;
} FYFloat;

/// 根据 CGFloat 创建一个 FYFloat，该 FYFloat.enable 值为 YES
FYFloat FYFloatMake(CGFloat value);

/// 段
///
/// 每个 Ruler 有 A, B, C, 三段
typedef NS_ENUM(NSUInteger, FYSection) {
    FYSectionNone,
    FYSectionA,
    FYSectionB,
    FYSectionC,
};

/// 标尺，用于衡量某个 UIView 在 X 轴或 Y 轴上的维度
@interface FYRuler : NSObject
/// 最后一次设定的段
@property (nonatomic, assign) FYSection last;
/// a 段上的 CGFloat 值
@property (nonatomic, assign) FYFloat a;
/// b 段上的 CGFloat 值
@property (nonatomic, assign) FYFloat b;
/// c 段上的 CGFloat 值
@property (nonatomic, assign) FYFloat c;

@end
