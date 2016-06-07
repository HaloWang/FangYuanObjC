//
//  FYConstraintManager.m
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import "FYConstraintManager.h"
#import "UIView+FangYuanPrivate.h"
#import "FYConstraintHolder.h"

#define _fy_should_in_layout_queue_ NSAssert(![NSThread isMainThread], nil);
#define _fy_should_in_main_queue_   NSAssert([NSThread isMainThread], nil);
#define FYConstraintS               NSArray<FYConstraint *> *

static dispatch_queue_t _fangyuan_layout_queue() {
    static dispatch_queue_t __fangyuan_layout_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __fangyuan_layout_queue = dispatch_queue_create("fangyuan.layout", DISPATCH_QUEUE_SERIAL);
    });
    return __fangyuan_layout_queue;
}

void _fy_layoutQueue(dispatch_block_t block) {
    dispatch_async(_fangyuan_layout_queue(), block);
}

void _fy_waitLayoutQueue() {
    dispatch_barrier_sync(_fangyuan_layout_queue(), ^{});
}

@interface FYConstraintManager ()

@property (nonatomic, strong) NSMutableArray<FYConstraint *> *constraints;
@property (nonatomic, strong) NSMutableArray<FYConstraint *> *settedConstraints;
@property (nonatomic, strong) FYConstraintHolder *holder;

@end

@implementation FYConstraintManager

#pragma mark - Public

+ (void)pushConstraintFrom:(UIView *)from direction:(FYConstraintDirection)direction {
    _fy_should_in_layout_queue_
    FYConstraint *cons = [FYConstraint constraintFrom:from to:nil direction:direction value:0];
    FYConstraintHolder *holder = [self sharedInstance].holder;
    [holder set:cons At:direction];
}

+ (void)popConstraintTo:(UIView *)to direction:(FYConstraintDirection)direction value:(CGFloat)value {
    _fy_should_in_layout_queue_
    FYConstraintManager *manager = [FYConstraintManager sharedInstance];
    [manager removeDuplicateConstraintOf:to at:direction];
    
    FYConstraintHolder *holder = [self sharedInstance].holder;
    FYConstraint *cons = [holder constraintAt:direction];
    
    if (cons == nil) {
        return;
    }

    cons.to = to;
    cons.value = value;
    [manager.constraints addObject:cons];
    [holder clearConstraintAt:direction];
    NSAssert([manager noConstraintCirculationWith:cons], @"there is a cycling constraint between view:%@ and view:%@", cons.to, cons.from);
}

+ (void)layout:(UIView *)view {
    NSMutableArray *viewsNeedLayout = view.usingFangYuanSubviews.mutableCopy;
    if (viewsNeedLayout.count == 0) {
        return;
    }
    _fy_wait_layout_queue_
    [[self sharedInstance] layout:viewsNeedLayout];
}

+ (void)resetRelatedConstraintFrom:(UIView *)fromView horizontal:(BOOL)horizontal {
    _fy_should_in_layout_queue_
    FYConstraintManager *manager = self.sharedInstance;
    [manager.settedConstraints.copy enumerateObjectsUsingBlock:^(FYConstraint* _Nonnull constraint, NSUInteger idx, BOOL * _Nonnull stop) {
        if (constraint.from != nil) {
            if (constraint.from == fromView) {
                if (horizontal == isHorizontal(constraint.direction)) {
                    switch (constraint.direction) {
                        case FYConstraintDirectionRightLeft:
                            constraint.to.rulerX.a = FYFloatMake(constraint.value);
                            break;
                            
                        case FYConstraintDirectionLeftRight:
                            constraint.to.rulerX.c = FYFloatMake(constraint.value);
                            break;
                            
                        case FYConstraintDirectionTopBottom:
                            constraint.to.rulerY.a = FYFloatMake(constraint.value);
                            break;
                            
                        case FYConstraintDirectionBottomTop:
                            constraint.to.rulerY.c = FYFloatMake(constraint.value);
                            break;
                            
                        default:
                            NSAssert(NO, @"Something Wrong!");
                            break;
                    }
                }
            }
        } else {
            [manager.settedConstraints removeObject:constraint];
        }
    }];
}

#pragma mark - Private

+ (FYConstraintManager *)sharedInstance {
    static FYConstraintManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [FYConstraintManager new];
        manager.constraints = [NSMutableArray array];
        manager.settedConstraints = [NSMutableArray array];
        manager.holder = [FYConstraintHolder new];
    });
    return manager;
}

#pragma mark Layout Logic

- (void)layout:(NSMutableArray<UIView *> *)views {
    _fy_should_in_main_queue_
    if (![self hasUnSetConstraint:self.constraints of:views]) {
        [views enumerateObjectsUsingBlock:
         ^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj layoutWithFangYuan];
        }];
        return;
    }
    
    NSMutableArray<UIView *> *layoutingViews = views;
    __block NSArray<FYConstraint *> *layoutingConstraints = self.constraints;
    __block BOOL shouldRepeat;
    do {
        shouldRepeat = NO;
        [layoutingViews.copy enumerateObjectsUsingBlock:
         ^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if ([self hasSetConstraint:layoutingConstraints to:obj]) {
                 [obj layoutWithFangYuan];
                 layoutingConstraints = [self setConstrains:layoutingConstraints From:obj];
                 [layoutingViews removeObject:obj];
             } else {
                 shouldRepeat = YES;
             }
         }];
    } while (shouldRepeat);
}

- (FYConstraintS)setConstrains:(FYConstraintS)constraints From:(UIView *)view {
    _fy_should_in_main_queue_
    NSMutableArray<FYConstraint *> *_cons = constraints.mutableCopy;
    [constraints.copy enumerateObjectsUsingBlock:
     ^(FYConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if (obj.from == view) {
             UIView *from = obj.from;
             UIView *to = obj.to;
             CGFloat value = obj.value;
             switch (obj.direction) {
                 case FYConstraintDirectionBottomTop:{
                     to.rulerY.a = FYFloatMake(from.fyY + from.fyHeight + value);
                     break;
                 }
                 case FYConstraintDirectionTopBottom:{
                     to.rulerY.c = FYFloatMake(from.superview.fyHeight - from.fyY + value);
                     break;
                 }
                 case FYConstraintDirectionRightLeft:{
                     to.rulerX.a = FYFloatMake(from.fyX + from.fyWidth + value);
                     break;
                 }
                 case FYConstraintDirectionLeftRight:{
                     to.rulerX.c = FYFloatMake(from.superview.fyWidth - from.fyX + value);
                     break;
                 }
                 default:
                     NSAssert(NO, @"Something wrong!");
                     break;
             }
             [_cons removeObject:obj];
             _fy_layoutQueue(^{
                 [self setSettedConstraint:obj];
             });
         }
     }];
    return _cons;
}

- (BOOL)hasSetConstraint:(FYConstraintS)constraints to:(UIView *)view {
    for (FYConstraint *cons in constraints) {
        if (cons.to == view) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)hasUnSetConstraint:(FYConstraintS)constraints of:(NSArray<UIView *> *)views {
    
    if (constraints.count == 0) {
        return NO;
    }
    
    for (UIView *view in views) {
        if (![self hasSetConstraint:constraints to:view]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark Assistant Functions

- (void)setSettedConstraint:(FYConstraint *)constraint {
    _fy_should_in_layout_queue_
    [self.settedConstraints.copy enumerateObjectsUsingBlock:
     ^(FYConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if (obj.to == nil || obj.from == nil) {
             [self.settedConstraints removeObject:obj];
         } else if (obj.to == constraint.to && obj.direction == constraint.direction) {
             [self.settedConstraints removeObject:obj];
         }
     }];
    [self.settedConstraints addObject:constraint];
}

- (void)removeDuplicateConstraintOf:(UIView *)view at:(FYConstraintDirection)direction {
    _fy_should_in_layout_queue_
    [_constraints.copy enumerateObjectsUsingBlock:
     ^(FYConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if (obj.to == view && obj.direction == direction) {
             [_constraints removeObject:obj];
             *stop = YES;
         }
     }];
}

- (BOOL)noConstraintCirculationWith:(FYConstraint *)cons {
    NSMutableArray<FYConstraint *> * constraints = _constraints;
    [constraints filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(FYConstraint * _Nonnull con, NSDictionary<NSString *,id> * _Nullable bindings) {
        return con.to == cons.from && con.from == cons.to;
    }]];
    return constraints.count == 0;
}

@end
