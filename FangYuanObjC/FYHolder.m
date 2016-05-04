//
//  FYHolder.m
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import "FYHolder.h"

@implementation FYHolder

- (instancetype)init {
    self = [super init];
    if (self) {
        _rulerX = [FYRuler new];
        _rulerY = [FYRuler new];
        _usingFangYuan = NO;
    }
    return self;
}

@end
