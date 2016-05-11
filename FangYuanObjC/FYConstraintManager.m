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

@interface FYConstraintManager ()

@property (nonatomic, strong) NSMutableArray<FYConstraint *> *constraints;
@property (nonatomic, strong) FYConstraintHolder *holder;

@end

@implementation FYConstraintManager

#pragma mark - Public

+ (void)getConstraintFrom:(UIView *)from direction:(FYConstraintDirection)direction {
    FYConstraint *cons = [FYConstraint dependencyFrom:from to:nil direction:direction value:0];
    FYConstraintHolder *holder = [self sharedInstance].holder;
    [holder set:cons At:direction];
}

+ (void)setConstraintTo:(UIView *)to direction:(FYConstraintDirection)direction value:(CGFloat)value {
    FYConstraintManager *manager = [FYConstraintManager sharedInstance];
    FYConstraintHolder *holder = [self sharedInstance].holder;
    FYConstraint *cons = [holder constraintAt:direction];
    
    if (cons == nil) {
        return;
    }
    [manager removeInvalidConstraint];
    [manager removeDuplicateDependencyOf:to atDirection:direction];
    [manager removeAndWarningCyclingConstraint];
    cons.to = to;
    cons.value = value;
    [manager.constraints addObject:cons];
    [holder set:nil At:direction];
}

+ (void)layout:(UIView *)view {
    NSMutableArray *viewsNeedLayout = view.usingFangYuanSubviews.mutableCopy;
    if (viewsNeedLayout.count == 0) {
        return;
    }
    [[self sharedInstance] layout:viewsNeedLayout];
}

#pragma mark - Private

+ (FYConstraintManager *)sharedInstance {
    static FYConstraintManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [FYConstraintManager new];
        manager.constraints = [NSMutableArray array];
        manager.holder = [FYConstraintHolder new];
    });
    return manager;
}

#pragma mark Layout Logic

- (void)layout:(NSMutableArray<UIView *> *)views {
    
    if ([self hasUnSetDependenciesOf:views]) {
        NSMutableArray<UIView *> *viewsNeedLayout = views.mutableCopy;
        do {
            NSArray<UIView *> *_viewsNeedLayout = viewsNeedLayout;
            [_viewsNeedLayout enumerateObjectsUsingBlock:
             ^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 if ([self hasSetConstraintsOf:obj]) {
                     [obj layoutWithFangYuan];
                     [self setConstrainsFrom:obj];
                     [viewsNeedLayout removeObject:obj];
                 }
            }];
        } while ([self hasUnSetDependenciesOf:viewsNeedLayout]);
    } else {
        [views enumerateObjectsUsingBlock:
         ^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             [obj layoutWithFangYuan];
         }];
    }
}

- (void)setConstrainsFrom:(UIView *)view {
    [_constraints.copy enumerateObjectsUsingBlock:
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
             [_constraints removeObject:obj];
         }
     }];
}

- (BOOL)hasSetConstraintsOf:(UIView *)view {
    for (FYConstraint *dep in self.constraints) {
        if (dep.to == view) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)hasUnSetDependenciesOf:(NSArray<UIView *> *)views {
    
    if (self.constraints.count == 0) {
        return NO;
    }
    
    for (UIView *view in views) {
        if (![self hasSetConstraintsOf:view]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark Assistant Functions

- (void)removeDuplicateDependencyOf:(UIView *)view atDirection:(FYConstraintDirection)direction {
    [_constraints.copy enumerateObjectsUsingBlock:
     ^(FYConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if (obj.to == view && obj.direction == direction) {
             [_constraints removeObject:obj];
             *stop = YES;
         }
     }];
}

- (void)removeInvalidConstraint {
    [_constraints.copy enumerateObjectsUsingBlock:
     ^(FYConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if (obj.to == nil || obj.from == nil) {
             [self.constraints removeObject:obj];
         }
    }];
}

- (void)removeAndWarningCyclingConstraint {
    NSArray<FYConstraint *> *constraintsCopy = _constraints.copy;
    [constraintsCopy enumerateObjectsUsingBlock:
     ^(FYConstraint * _Nonnull toCons, NSUInteger toIdx, BOOL * _Nonnull toStop) {
        [constraintsCopy enumerateObjectsUsingBlock:
         ^(FYConstraint * _Nonnull fromCons, NSUInteger fromIdx, BOOL * _Nonnull fromStop) {
            if (toCons.to == fromCons.from && toCons.from == fromCons.to) {
                [_constraints removeObject:toCons];
                [_constraints removeObject:fromCons];
                return;
            }
        }];
    }];
}

@end

//            printf("ℹ️");
//            NSLog(@"%@", obj.usingFangYuan ? @"YES" : @"NO");
//            NSLog(@"%@",[obj class]);
//            NSLog(@"%@",obj.superview);
//            NSLog(@"%@",NSStringFromCGRect(obj.frame));
//            NSLog(@"%@",NSStringFromCGRect(obj.frame));
//            NSLog(@"\n");
