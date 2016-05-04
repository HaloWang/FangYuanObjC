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
        _usingFangYuan = NO;
    }
    return self;
}

- (FYRuler *)rulerX {
    if (!_rulerX) {
        _rulerX = [FYRuler new];
    }
    return _rulerX;
}

- (FYRuler *)rulerY {
    if (!_rulerY) {
        _rulerY = [FYRuler new];
    }
    return _rulerY;
}

@end
