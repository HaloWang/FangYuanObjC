//
//  FYConstraint.m
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import "FYConstraint.h"

BOOL isHorizontal(FYConstraintDirection direction) {
    switch (direction) {
        case FYConstraintDirectionLeftRight:
        case FYConstraintDirectionRightLeft:
            return YES;
        case FYConstraintDirectionTopBottom:
        case FYConstraintDirectionBottomTop:
            return NO;
        default:
            return NO;
    }
}

@implementation FYConstraint

+ (FYConstraint *)constraintFrom:(UIView *)from
                              to:(UIView *)to
                       direction:(FYConstraintDirection)direction
                           value:(CGFloat)value
{
    FYConstraint *cons = [FYConstraint new];
    cons.from          = from;
    cons.to            = to;
    cons.direction     = direction;
    cons.value         = value;
    return cons;
}

- (NSString *)description {
    return @[
             [super description],
             self.from,
             self.to
             ].description;
}

@end
