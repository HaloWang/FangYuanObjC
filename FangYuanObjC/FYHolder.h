//
//  FYHolder.h
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FYRuler.h"

@interface FYHolder : NSObject

@property (nonatomic, strong) FYRuler *rulerX;
@property (nonatomic, strong) FYRuler *rulerY;
@property (nonatomic, assign, getter=isUsingFangYuan) BOOL usingFangYuan;

@end
