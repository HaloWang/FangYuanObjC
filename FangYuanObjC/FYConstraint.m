//
//  FYConstraint.m
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import "FYConstraint.h"

@implementation FYConstraint

+ (FYConstraint *)dependencyFrom:(UIView *)from
                              to:(UIView *)to
                       direction:(FYConstraintDirection)direction
                           value:(CGFloat)value
{
    FYConstraint *dep = [FYConstraint new];
    dep.from          = from;
    dep.to            = to;
    dep.direction     = direction;
    dep.value         = value;
    dep.hasSet        = NO;
    return dep;
}

- (NSString *)description {
    return @[
             [super description],
             self.from,
             self.to
             ].description;
}

@end
