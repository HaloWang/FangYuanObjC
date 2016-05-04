//
//  FYDependency.m
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import "FYDependency.h"

@implementation FYDependency

+ (FYDependency *)dependencyFrom:(UIView *)from
                              to:(UIView *)to
                       direction:(FYDependencyDirection)direction
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
