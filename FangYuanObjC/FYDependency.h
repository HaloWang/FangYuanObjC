//
//  FYDependency.h
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FYDependencyDirection) {
    FYDependencyDirectionBottomTop,
    FYDependencyDirectionLeftRight,
    FYDependencyDirectionRightLeft,
    FYDependencyDirectionTopBottom,
};

@interface FYDependency : NSObject

@property (nonatomic, weak) UIView *from;
@property (nonatomic, weak) UIView *to;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) FYDependencyDirection direction;
@property (nonatomic, assign) BOOL hasSet;

+ (FYDependency *)dependencyFrom:(UIView *)from
                              to:(UIView *)to
                       direction:(FYDependencyDirection)direction
                           value:(CGFloat)value;

@end
