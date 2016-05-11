//
//  FYConstraintManager.h
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FYConstraint.h"

@interface FYConstraintManager : NSObject

/**
 *  推入约束
 *
 *  @param from      约束来源
 *  @param direction 约束方向
 */
+ (void)getConstraintFrom:(UIView *)from
                direction:(FYConstraintDirection)direction;

/**
 *  拉取约束
 *
 *  @param to        约束接收者
 *  @param direction 约束方向
 *  @param value     约束值
 */
+ (void)setConstraintTo:(UIView *)to
              direction:(FYConstraintDirection)direction
                  value:(CGFloat)value;

+ (void)layout:(UIView *)view;

@end
