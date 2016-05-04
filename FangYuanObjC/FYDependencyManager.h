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

+ (FYDependencyManager *)sharedInstance;

+ (void)pushDependencyFrom:(UIView *)from
                        to:(UIView *)to
                 direction:(FYDependencyDirection)direction
                     value:(CGFloat)value;

+ (void)popDependencyFrom:(UIView *)from
                       to:(UIView *)to
                direction:(FYDependencyDirection)direction
                    value:(CGFloat)value;

@end
