//
//  FYConstraintManager.m
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import "FYConstraintManager.h"
#import "UIView+FangYuanPrivate.h"

@interface FYConstraintManager ()

@property (nonatomic, strong) FYConstraint *dependencyHolder;
@property (nonatomic, strong) NSMutableArray<FYConstraint *> *dependencies;
@property (nonatomic, readonly) NSArray<FYConstraint *> *unsetDependencies;

@end

@implementation FYConstraintManager

#pragma mark - Public

+ (void)layout:(UIView *)view {
    [[self sharedInstance] removeUselessDep];
    [[self sharedInstance] layout:view];
}

+ (void)getConstraintFrom:(UIView *)from direction:(FYConstraintDirection)direction {
    [self sharedInstance].dependencyHolder = [FYConstraint dependencyFrom:from to:nil direction:direction value:0];
}

+ (void)setConstraintTo:(UIView *)to direction:(FYConstraintDirection)direction value:(CGFloat)value {
    FYConstraintManager *manager = [FYConstraintManager sharedInstance];
    
    [manager removeDuplicateDependencyOf:to atDirection:direction];
    
    if (!manager.dependencyHolder) {
        return;
    }
    
    manager.dependencyHolder.to = to;
    manager.dependencyHolder.value = value;
    
    //  添加约束
    [manager.dependencies addObject:manager.dependencyHolder];
    manager.dependencyHolder = nil;
}

#pragma mark - Private

+ (FYConstraintManager *)sharedInstance {
    static FYConstraintManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [FYConstraintManager new];
        manager.dependencies = [NSMutableArray array];
    });
    return manager;
}

- (void)removeDuplicateDependencyOf:(UIView *)view atDirection:(FYConstraintDirection)direction {
    __block FYConstraint *dependencyNeedRemove;
    [_dependencies enumerateObjectsUsingBlock:
     ^(FYConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.to == view && obj.direction == direction) {
            dependencyNeedRemove = obj;
            *stop = YES;
        }
    }];
    
    if (dependencyNeedRemove) {
        [_dependencies removeObject:dependencyNeedRemove];
    }
}

- (NSArray<FYConstraint *> *)unsetDependencies {
    NSMutableArray<FYConstraint *> *mArr = self.dependencies;
    [mArr filterUsingPredicate:[NSPredicate predicateWithBlock:
                                ^BOOL(id  _Nonnull evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                                    FYConstraint *dep = evaluatedObject;
                                    return !dep.hasSet;
                                }]];
    return mArr;
}

- (BOOL)allDependenciesLoaddedOf:(UIView *)view {
    for (FYConstraint *dep in self.dependencies) {
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
    
    NSArray<FYConstraint *> *needSetDeps = self.unsetDependencies;
    if (needSetDeps.count == 0) {
        return NO;
    }
    
    for (UIView *subview in view.usingFangYuanSubviews) {
        for (FYConstraint *dep in needSetDeps) {
            if (dep.to == subview) {
                return YES;
            }
        }
    }
    
    return NO;
}

- (void)removeUselessDep {
    NSMutableArray *newDependencies = self.dependencies;
    [self.dependencies enumerateObjectsUsingBlock:
     ^(FYConstraint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    
    // TODO: 下面的代码还可以写的更优雅
    // TODO: 性能方面还是需要提升！static frame ?
    
    if ([self hasUnSetDependenciesOf:view]) {
        do {
            [view.usingFangYuanSubviews enumerateObjectsUsingBlock
             :^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self allDependenciesLoaddedOf:obj]) {
                    [obj layoutWithFangYuan];
                    [self loadDependenciesOf:obj];
                }
            }];
        } while ([self hasUnSetDependenciesOf:view]);
    } else {
        [view.usingFangYuanSubviews enumerateObjectsUsingBlock:
         ^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
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
    [_dependencies enumerateObjectsUsingBlock:
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
             obj.hasSet = YES;
             *stop = YES;
         }
     }];
}

@end
