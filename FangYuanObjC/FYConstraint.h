//
//  FYConstraint.h
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FYConstraintDirection) {
    FYConstraintDirectionBottomTop,
    FYConstraintDirectionLeftRight,
    FYConstraintDirectionRightLeft,
    FYConstraintDirectionTopBottom,
};

@interface FYConstraint : NSObject

@property (nonatomic, weak) UIView *from;
@property (nonatomic, weak) UIView *to;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) FYConstraintDirection direction;

+ (FYConstraint *)dependencyFrom:(UIView *)from
                              to:(UIView *)to
                       direction:(FYConstraintDirection)direction
                           value:(CGFloat)value;

@end
