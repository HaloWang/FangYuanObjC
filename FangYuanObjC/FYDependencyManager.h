//
//  FYDependencyManager.h
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FYDependency.h"

@interface FYDependencyManager : NSObject

/**
 *  推入约束
 *
 *  @param from      约束来源
 *  @param direction 约束方向
 */
+ (void)pushDependencyFrom:(UIView *)from
                 direction:(FYDependencyDirection)direction;

/**
 *  拉取约束
 *
 *  @param to        约束接收者
 *  @param direction 约束方向
 *  @param value     约束值
 */
+ (void)popDependencyTo:(UIView *)to
                direction:(FYDependencyDirection)direction
                    value:(CGFloat)value;

+ (void)layout:(UIView *)view;

@end
