//
//  FYDependencyManager.m
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import "FYDependencyManager.h"
#import "UIView+FangYuanPrivate.h"

@interface FYDependencyManager ()

@property (nonatomic, strong) FYDependency *dependencyHolder;
@property (nonatomic, strong) NSMutableArray<FYDependency *> *dependencies;
@property (nonatomic, readonly) NSArray<FYDependency *> *unsetDependencies;
@property (nonatomic, strong) NSPredicate *filterHasSetPredicate;


@end

@implementation FYDependencyManager

#pragma mark - Public

+ (void)layout:(UIView *)view {
    [[self sharedInstance] layout:view];
}

+ (void)pushDependencyFrom:(UIView *)from to:(UIView *)to direction:(FYDependencyDirection)direction value:(CGFloat)value {
    [self sharedInstance].dependencyHolder = [FYDependency dependencyFrom:from to:to direction:direction value:value];
}

+ (void)popDependencyFrom:(UIView *)from to:(UIView *)to direction:(FYDependencyDirection)direction value:(CGFloat)value {
    FYDependencyManager *manager = [FYDependencyManager sharedInstance];
    if (!manager.dependencyHolder) {
        return;
    }
    
    manager.dependencyHolder.to = to;
    manager.dependencyHolder.value = value;

    //  移除重复的约束
    FYDependency *dependencyNeedRemove;
    for (FYDependency *dependency in manager.dependencies) {
        if (dependency.to == to && manager.dependencyHolder.from == from && dependency.direction == direction) {
            dependencyNeedRemove = dependency;
        }
    }
    if (dependencyNeedRemove) {
        [manager.dependencies removeObject:dependencyNeedRemove];
    }
    
    //  添加约束
    [manager.dependencies addObject:manager.dependencyHolder];
    manager.dependencyHolder = nil;
}

#pragma mark - Private

+ (FYDependencyManager *)sharedInstance {
    static FYDependencyManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [FYDependencyManager new];
        manager.dependencies = [NSMutableArray array];
        manager.filterHasSetPredicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            FYDependency *dep = evaluatedObject;
            return !dep.hasSet;
        }];
    });
    return manager;
}

- (NSArray<FYDependency *> *)unsetDependencies {
    NSMutableArray<FYDependency *> *mArr = self.dependencies;
    [mArr filterUsingPredicate:self.filterHasSetPredicate];
    return mArr.copy;
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
    
    NSArray<FYDependency *> *needSetDeps = self.unsetDependencies;
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
    NSMutableArray *newDependencies = self.dependencies;
    [self.dependencies enumerateObjectsUsingBlock:^(FYDependency * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.to == nil && obj.from == nil) {
            [newDependencies removeObject:obj];
        }
    }];
    self.dependencies = newDependencies;
}

- (void)layout:(UIView *)view {
    
    if (view == nil) {
        return;
    }
    
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
//            printf("ℹ️");
//            NSLog(@"%@", obj.usingFangYuan ? @"YES" : @"NO");
//            NSLog(@"%@",[obj class]);
//            NSLog(@"%@",obj.superview);
//            NSLog(@"%@",NSStringFromCGRect(obj.frame));
            [obj layoutWithFangYuan];
//            NSLog(@"%@",NSStringFromCGRect(obj.frame));
//            NSLog(@"\n");
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
                to.rulerY.c = FYFloatMake(from.superview.fyHeight - from.fyY + value);
                break;
            }
                
            case FYDependencyDirectionRightLeft:{
                to.rulerX.a = FYFloatMake(from.fyX + from.fyWidth + value);
                break;
            }
                
            case FYDependencyDirectionLeftRight:{
                to.rulerX.c = FYFloatMake(from.superview.fyWidth - from.fyX + value);
                break;
            }
                
            default:
                NSAssert(NO, @"Something wrong!");
                break;
        }
        obj.hasSet = YES;
    }];
}

@end
