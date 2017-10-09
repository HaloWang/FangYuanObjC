//
//  FYConstraintManager.h
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FYConstraint.h"

void _fy_layoutQueue(dispatch_block_t block);

#define _fy_wait_layout_queue_ _fy_waitLayoutQueue();
void _fy_waitLayoutQueue(void);

@interface FYConstraintManager : NSObject

/**
 *  推入约束
 *
 *  @param from      约束来源
 *  @param section 约束方向
 */
+ (void)pushConstraintFrom:(UIView *)from
                   section:(FYConstraintSection)section;

/**
 *  拉取约束
 *
 *  @param to        约束接收者
 *  @param section 约束方向
 *  @param value     约束值
 */
+ (void)popConstraintTo:(UIView *)to
                section:(FYConstraintSection)section
                  value:(CGFloat)value;

+ (void)layout:(UIView *)view;

+ (void)resetRelatedConstraintFrom:(UIView *)fromView horizontal:(BOOL)horizontal;

@end
