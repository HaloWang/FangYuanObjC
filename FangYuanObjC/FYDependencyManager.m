//
//  FYDependencyManager.m
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import "FYDependencyManager.h"

@interface FYDependencyManager ()

NS_ASSUME_NONNULL_BEGIN

@property(nonatomic, strong) FYDependency *dependencyHolder;
@property(nonatomic, strong) NSMutableArray<FYDependency *> *dependencies;
@property(nonatomic, assign, readonly) BOOL hasDependencies;
@property(nonatomic, assign, readonly) BOOL hasUnSetDependencies;
@property(nonatomic, readonly) NSArray<FYDependency *> *unsetDeps;

NS_ASSUME_NONNULL_END

@end

@implementation FYDependencyManager

#pragma mark - Public

+ (FYDependencyManager *)sharedInstance {
    static FYDependencyManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [FYDependencyManager new];
    });
    return manager;
}

#pragma mark - Private

+ (void)pushDependencyFrom:(UIView *)from to:(UIView *)to direction:(FYDependencyDirection)direction value:(CGFloat)value {

}

+ (void)popDependencyFrom:(UIView *)from to:(UIView *)to direction:(FYDependencyDirection)direction value:(CGFloat)value {

}


- (BOOL)layouting:(UIView *)view {
    return YES;
}

- (void)removeUselessDep {

}

- (BOOL)hasUnSetDependenciesOf:(UIView *)view {
    return YES;
}

- (void)layout {

}

- (void)loadDependenciesOf:(UIView *)view {

}

- (BOOL)allDependenciesLoaddedOf:(UIView *)view {
    return YES;
}

- (BOOL)managing:(UIView *)view {
    return YES;
}

@end
