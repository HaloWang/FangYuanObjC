//
//  FYDependency.m
//  Pods
//
//  Created by 王策 on 16/5/3.
//
//

#import "FYDependency.h"

@implementation FYDependency

+ (FYDependency *)dependencyFrom:(UIView *)from
                              to:(UIView *)to
                       direction:(FYDependencyDirection *)direction
                           value:(CGFloat)value
{
    FYDependency *dep = [FYDependency new];
    dep.from          = from;
    dep.to            = to;
    dep.direction     = direction;
    dep.value         = value;
    dep.hasSet        = NO;
    return dep;
}

@end
