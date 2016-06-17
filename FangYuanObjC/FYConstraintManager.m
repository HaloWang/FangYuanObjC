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
#define FYConstraints               NSArray<FYConstraint *> *

static dispatch_queue_t _fangyuan_layout_queue() {
    static dispatch_queue_t __fangyuan_layout_queue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __fangyuan_layout_queue = dispatch_queue_create("com.fangyuan.layout", DISPATCH_QUEUE_SERIAL);
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

@property (nonatomic, strong) NSMutableArray<FYConstraint *> *unsetConstraints;
@property (nonatomic, strong) NSMutableArray<FYConstraint *> *storedConstraints;
@property (nonatomic, strong) FYConstraintHolder *holder;

@end

@implementation FYConstraintManager

#pragma mark - Public

+ (void)pushConstraintFrom:(UIView *)from section:(FYConstraintSection)section {
    _fy_should_in_layout_queue_
    FYConstraint *cons = [FYConstraint constraintFrom:from to:nil section:section value:0];
    FYConstraintHolder *holder = [self sharedInstance].holder;
    [holder set:cons at:section];
}

+ (void)popConstraintTo:(UIView *)to section:(FYConstraintSection)section value:(CGFloat)value {
    _fy_should_in_layout_queue_
    FYConstraintManager *manager = [FYConstraintManager sharedInstance];
    
    [manager removeDuplicateConstraintOf:to at:section];
    
    FYConstraintHolder *holder = manager.holder;
    FYConstraint *constraint = [holder constraintAt:section];
    
    if (constraint == nil) {
        return;
    }

    constraint.to = to;
    constraint.value = value;
    [manager.unsetConstraints addObject:constraint];
    [holder clearConstraintAt:section];
    
    NSAssert([manager noConstraintCirculationWith:constraint], @"there is a cycling constraint between view:%@ and view:%@", constraint.to, constraint.from);
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
    for (FYConstraint *constraint in manager.storedConstraints) {
        if (constraint.from != nil && constraint.from == fromView) {
            if (horizontal == isHorizontal(constraint.section)) {
                switch (constraint.section) {
                    case FYConstraintSectionLeft:
                        constraint.to.rulerX.a = FYFloatMake(constraint.value);
                        break;
                        
                    case FYConstraintSectionRight:
                        constraint.to.rulerX.c = FYFloatMake(constraint.value);
                        break;
                        
                    case FYConstraintSectionBottom:
                        constraint.to.rulerY.a = FYFloatMake(constraint.value);
                        break;
                        
                    case FYConstraintSectionTop:
                        constraint.to.rulerY.c = FYFloatMake(constraint.value);
                        break;
                        
                    default:
                        NSAssert(NO, @"Something Wrong!");
                        break;
                }
            }
        }
    }
}

#pragma mark - Private

+ (FYConstraintManager *)sharedInstance {
    static FYConstraintManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [FYConstraintManager new];
        manager.unsetConstraints = [NSMutableArray array];
        manager.storedConstraints = [NSMutableArray array];
        manager.holder = [FYConstraintHolder new];
    });
    return manager;
}

#pragma mark Layout Logic

- (void)layout:(NSMutableArray<UIView *> *)views {
    _fy_should_in_main_queue_
    if (![self hasUnSetConstraint:self.unsetConstraints of:views]) {
        for (UIView *view in views) {
            [view layoutWithFangYuan];
        }
        return;
    }
    
    __block NSArray<FYConstraint *> *constraints = self.unsetConstraints;
    __block BOOL shouldRepeat;
    do {
        shouldRepeat = NO;
        for (UIView *view in views.copy) {
            if ([self hasSetConstraint:constraints to:view]) {
                [view layoutWithFangYuan];
                constraints = [self setConstrains:constraints From:view];
                [views removeObject:view];
            } else {
                shouldRepeat = YES;
            }
        }
    } while (shouldRepeat);
}

- (BOOL)hasSetConstraint:(FYConstraints)constraints to:(UIView *)view {
    for (FYConstraint *cons in constraints) {
        if (cons.to == view) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)hasUnSetConstraint:(FYConstraints)constraints of:(NSArray<UIView *> *)views {
    
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

- (FYConstraints)setConstrains:(FYConstraints)constraints From:(UIView *)view {
    _fy_should_in_main_queue_
    NSMutableArray<FYConstraint *> *_constraints = constraints.mutableCopy;
    [constraints enumerateObjectsUsingBlock:
     ^(FYConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if (obj.from == view) {
             _fy_layoutQueue(^{
                 [self storedConstraintsInsert:obj];
             });
             UIView *from = obj.from;
             UIView *to = obj.to;
             CGFloat value = obj.value;
             switch (obj.section) {
                 case FYConstraintSectionTop:{
                     to.rulerY.a = FYFloatMake(from.fyY + from.fyHeight + value);
                     break;
                 }
                 case FYConstraintSectionBottom:{
                     to.rulerY.c = FYFloatMake(from.superview.fyHeight - from.fyY + value);
                     break;
                 }
                 case FYConstraintSectionLeft:{
                     to.rulerX.a = FYFloatMake(from.fyX + from.fyWidth + value);
                     break;
                 }
                 case FYConstraintSectionRight:{
                     to.rulerX.c = FYFloatMake(from.superview.fyWidth - from.fyX + value);
                     break;
                 }
                 default:
                     NSAssert(NO, @"Something wrong!");
                     break;
             }
             [_constraints removeObject:obj];
         }
     }];
    return _constraints;
}

#pragma mark Assistant Functions

- (void)storedConstraintsInsert:(FYConstraint *)constraint {
    _fy_should_in_layout_queue_
    [self.storedConstraints.copy enumerateObjectsUsingBlock:
     ^(FYConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if (obj.to == nil || obj.from == nil) {
             [self.storedConstraints removeObject:obj];
         } else if (obj.to == constraint.to && obj.section == constraint.section) {
             [self.storedConstraints removeObject:obj];
         }
     }];
    [self.storedConstraints addObject:constraint];
}

- (void)removeDuplicateConstraintOf:(UIView *)view at:(FYConstraintSection)section {
    _fy_should_in_layout_queue_
    
    if (_unsetConstraints.count == 0) {
        return;
    }
    
    [_unsetConstraints.copy enumerateObjectsUsingBlock:
     ^(FYConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if (obj.to == view && obj.section == section) {
             [_unsetConstraints removeObject:obj];
             *stop = YES;
         }
     }];
}

- (BOOL)noConstraintCirculationWith:(FYConstraint *)constraint {
    NSMutableArray<FYConstraint *> * constraints = _unsetConstraints.mutableCopy;
    [constraints filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(FYConstraint * _Nonnull con, NSDictionary<NSString *,id> * _Nullable bindings) {
        return con.to == constraint.from && con.from == constraint.to;
    }]];
    return constraints.count == 0;
}

@end
