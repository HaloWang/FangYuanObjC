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
        NSMutableArray<UIView *> *viewsNeedLayout = views;
        do {
            [viewsNeedLayout enumerateObjectsUsingBlock:
             ^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                 if ([self hasSetConstraintsOf:obj]) {
                     [obj layoutWithFangYuan];
                     [self setConstrainsFrom:obj];
                     [viewsNeedLayout removeObject:obj];
                 }
            }];
        } while ([self hasUnSetDependenciesOf:views]);
    } else {
        [views enumerateObjectsUsingBlock:
         ^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             [obj layoutWithFangYuan];
         }];
    }
}

- (void)setConstrainsFrom:(UIView *)view {
    __block NSMutableArray<FYConstraint *> *constraintsNeedRemove = @[].mutableCopy;
    [self.constraints enumerateObjectsUsingBlock:
     ^(FYConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         printf("✅");
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
             [constraintsNeedRemove addObject:obj];
         }
     }];
    
    [self.constraints removeObjectsInArray:constraintsNeedRemove];
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
    __block FYConstraint *constraintNeedRemove = nil;
    [self.constraints enumerateObjectsUsingBlock:
     ^(FYConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if (obj.to == view && obj.direction == direction) {
             constraintNeedRemove = obj;
             *stop = YES;
         }
     }];
    [_constraints removeObject:constraintNeedRemove];
}

- (void)removeInvalidConstraint {
    __block NSMutableArray<FYConstraint *> *constraintsNeedRemove = @[].mutableCopy;
    [self.constraints enumerateObjectsUsingBlock:
     ^(FYConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if (obj.to == nil || obj.from == nil) {
             [constraintsNeedRemove addObject:obj];
         }
    }];
    [self.constraints removeObjectsInArray:constraintsNeedRemove];
}

- (void)removeAndWarningCyclingConstraint {
    __block NSMutableArray<FYConstraint *> *constraintsNeedRemove = @[].mutableCopy;
    [_constraints enumerateObjectsUsingBlock:
     ^(FYConstraint * _Nonnull toCons, NSUInteger idx, BOOL * _Nonnull stop) {
        [_constraints enumerateObjectsUsingBlock:
         ^(FYConstraint * _Nonnull fromCons, NSUInteger idx, BOOL * _Nonnull stop) {
            if (toCons.to == fromCons.from && toCons.from == fromCons.to) {
                [constraintsNeedRemove addObject:toCons];
                [constraintsNeedRemove addObject:fromCons];
                *stop = YES;
            }
        }];
    }];
    [self.constraints removeObjectsInArray:constraintsNeedRemove];
}

@end

//            printf("ℹ️");
//            NSLog(@"%@", obj.usingFangYuan ? @"YES" : @"NO");
//            NSLog(@"%@",[obj class]);
//            NSLog(@"%@",obj.superview);
//            NSLog(@"%@",NSStringFromCGRect(obj.frame));
//            NSLog(@"%@",NSStringFromCGRect(obj.frame));
//            NSLog(@"\n");
