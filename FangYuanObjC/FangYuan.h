
#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/// 代表一个 CGFloat 值，同时附加有该值是否管用的信息
struct FYFloat {
    BOOL enable;
    CGFloat value;
};
typedef struct FYFloat FYFloat;

/// 根据 CGFloat 创建一个 FYFloat，该 FYFloat.enable 值为 YES
FYFloat FYFloatMake(CGFloat value);

/// 维度
typedef NS_ENUM(NSUInteger, FYDimension) {
    FYDimensionNone,
    FYDimensionX,
    FYDimensionY,
    FYDimensionZ,
};

/// 标尺，用于衡量某个 UIView 在 X 轴或 Y 轴上的维度
@interface FYRuler : NSObject
/// 最后一次设定的维度
@property (nonatomic, assign) FYDimension last;
/// X 维度上的 CGFloat 值
@property (nonatomic, assign) FYFloat x;
/// Y 维度上的 CGFloat 值
@property (nonatomic, assign) FYFloat y;
/// Z 维度上的 CGFloat 值
@property (nonatomic, assign) FYFloat z;

@end
