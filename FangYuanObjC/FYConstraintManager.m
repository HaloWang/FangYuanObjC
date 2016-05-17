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

+ (void)pushConstraintFrom:(UIView *)from direction:(FYConstraintDirection)direction {
    FYConstraint *cons = [FYConstraint constraintFrom:from to:nil direction:direction value:0];
    FYConstraintHolder *holder = [self sharedInstance].holder;
    [holder set:cons At:direction];
}

+ (void)popConstraintTo:(UIView *)to direction:(FYConstraintDirection)direction value:(CGFloat)value {
    
    FYConstraintManager *manager = [FYConstraintManager sharedInstance];
    [manager removeDuplicateConstraintOf:to at:direction];
    
    FYConstraintHolder *holder = [self sharedInstance].holder;
    FYConstraint *cons = [holder constraintAt:direction];
    
    if (cons == nil) {
        return;
    }

    cons.to = to;
    cons.value = value;
    [manager checkCyclingWhenAdding:cons];
    [manager.constraints addObject:cons];
    [holder clearConstraintAt:direction];
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
    
    if (![self hasUnSetConstraintOf:views]) {
        [views enumerateObjectsUsingBlock:
         ^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj layoutWithFangYuan];
        }];
        return;
    }
    
    NSMutableArray<UIView *> *viewsNeedLayout = views;
    __block BOOL shouldRepeat;
    do {
        shouldRepeat = NO;
        [viewsNeedLayout.copy enumerateObjectsUsingBlock:
         ^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
             if ([self hasSetConstraintTo:obj]) {
                 [obj layoutWithFangYuan];
                 [self setConstrainsFrom:obj];
                 [viewsNeedLayout removeObject:obj];
             } else {
                 shouldRepeat = YES;
             }
         }];
    } while (shouldRepeat);
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

- (BOOL)hasSetConstraintTo:(UIView *)view {
    for (FYConstraint *cons in self.constraints) {
        if (cons.to == view) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)hasUnSetConstraintOf:(NSArray<UIView *> *)views {
    
    if (self.constraints.count == 0) {
        return NO;
    }
    
    for (UIView *view in views) {
        if (![self hasSetConstraintTo:view]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark Assistant Functions

- (void)removeDuplicateConstraintOf:(UIView *)view at:(FYConstraintDirection)direction {
    [_constraints.copy enumerateObjectsUsingBlock:
     ^(FYConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         if (obj.to == view && obj.direction == direction) {
             [_constraints removeObject:obj];
             *stop = YES;
         }
     }];
}

- (void)checkCyclingWhenAdding:(FYConstraint *)cons {
    [_constraints enumerateObjectsUsingBlock:
     ^(FYConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         NSAssert(!(obj.to == cons.from && obj.from == cons.to), @"there is a cycling constraint between view:%@ and view:%@", obj.to, obj.from);
    }];
}

@end
