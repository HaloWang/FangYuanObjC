//
//  FYDependencyManager.m
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import "FYDependencyManager.h"
#import "UIView+FangYuan.h"
#import "UIView+FangYuanPrivate.h"

@interface FYDependencyManager ()

NS_ASSUME_NONNULL_BEGIN

@property(nonatomic, assign, readonly) BOOL hasDependencies;
@property(nonatomic, assign, readonly) BOOL hasUnSetDependencies;
@property(nonatomic, strong) FYDependency *dependencyHolder;
@property(nonatomic, strong) NSMutableArray<FYDependency *> *dependencies;
@property(nonatomic, readonly) NSArray<FYDependency *> *unsetDeps;

NS_ASSUME_NONNULL_END

@end

@implementation FYDependencyManager

#pragma mark - Public

+ (void)layout:(UIView *)view {
    [[self sharedInstance] layout:view];
}

+ (void)pushDependencyFrom:(UIView *)from to:(UIView *)to direction:(FYDependencyDirection)direction value:(CGFloat)value {
    NSAssert(from != nil, @"");
    NSAssert(value == 0, @"");
    [self sharedInstance].dependencyHolder = [FYDependency dependencyFrom:from to:to direction:direction value:value];
}

+ (void)popDependencyFrom:(UIView *)from to:(UIView *)to direction:(FYDependencyDirection)direction value:(CGFloat)value {
    FYDependencyManager *manager = [FYDependencyManager sharedInstance];
    if (!manager.dependencyHolder) {
        return;
    }
    
    NSAssert(to != nil, @"\"to\" should not be nil when pop a dependency");
    NSAssert(from == nil, @"\"from\" should be nil when pop a dependency");
    
    if (direction != manager.dependencyHolder.direction) {
        return;
    }
    
    manager.dependencyHolder.to = to;
    manager.dependencyHolder.value = value;
    
    [manager.dependencies addObject:manager.dependencyHolder];
    manager.dependencyHolder = nil;
}

#pragma mark - Private

- (NSArray<FYDependency *> *)unsetDeps {
    NSMutableArray<FYDependency *> *mArr = self.dependencies;
    [mArr filterUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        FYDependency *dep = evaluatedObject;
        return !dep.hasSet;
    }]];
    return mArr.copy;
}

+ (FYDependencyManager *)sharedInstance {
    static FYDependencyManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [FYDependencyManager new];
        manager.dependencies = [NSMutableArray array];
    });
    return manager;
}

- (BOOL)layouting:(UIView *)view {
    for (FYDependency *dep in self.dependencies) {
        if (dep.from.superview == view) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)allDependenciesLoaddedOf:(UIView *)view {
    [self removeUselessDep];
    for (FYDependency *dep in self.dependencies) {
        if (dep.to == view && !dep.hasSet) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)hasUnSetDependenciesOf:(UIView *)view {
    
    if (!view.subviewUsingFangYuan) {
        return NO;
    }
    
    NSArray<FYDependency *> *needSetDeps = self.unsetDeps;
    if (needSetDeps.count == 0) {
        return NO;
    }
    
    for (UIView *subview in view.usingFangYuanSubviews) {
        for (FYDependency *dep in needSetDeps) {
            if (dep.to == subview) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)removeUselessDep {
    NSMutableArray *newDependencies = @[].mutableCopy;
    [self.dependencies enumerateObjectsUsingBlock:^(FYDependency * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.to == nil && obj.from == nil) {
            [newDependencies addObject:obj];
        }
    }];
    self.dependencies = newDependencies;
}

- (void)layout:(UIView *)view {
    if ([self hasUnSetDependenciesOf:view]) {
        while ([self hasUnSetDependenciesOf:view]) {
            [view.usingFangYuanSubviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self allDependenciesLoaddedOf:obj]) {
                    [obj layoutWithFangYuan];
                    [self loadDependenciesOf:obj];
                }
            }];
        }
    } else {
        [view.usingFangYuanSubviews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [obj layoutWithFangYuan];
        }];
    }
}

- (void)loadDependenciesOf:(UIView *)view {
    NSMutableArray<FYDependency *> *dependenciesShouldLoad = @[].mutableCopy;
    [self.dependencies enumerateObjectsUsingBlock:^(FYDependency * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [dependenciesShouldLoad addObject:obj];
    }];
    
    [dependenciesShouldLoad enumerateObjectsUsingBlock:^(FYDependency * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *from = obj.from;
        UIView *to = obj.to;
        CGFloat value = obj.value;
        switch (obj.direction) {
            case FYDependencyDirectionBottomTop:{
                to.rulerY.a = FYFloatMake(from.fyY + from.fyHeight + value);
                break;
            }
                
            case FYDependencyDirectionTopBottom:{
                to.rulerX.c = FYFloatMake(from.superview.fyWidth - from.fyX + value);
                break;
            }
                
            case FYDependencyDirectionRightLeft:{
                to.rulerX.a = FYFloatMake(from.fyX + from.fyWidth + value);
                break;
            }
                
            case FYDependencyDirectionLeftRight:{
                to.rulerY.c = FYFloatMake(from.superview.fyHeight - from.fyY + value);
                break;
            }
                
            default:
                NSAssert(NO, @"Something wrong!");
                break;
        }
    }];
}

@end
