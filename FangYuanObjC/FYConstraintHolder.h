//
// Created by 王策 on 16/5/11.
//


#import <Foundation/Foundation.h>
#import "FYConstraint.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYConstraintHolder : NSObject

@property (nonatomic, strong) FYConstraint * _Nullable topBottom;
@property (nonatomic, strong) FYConstraint * _Nullable bottomTop;
@property (nonatomic, strong) FYConstraint * _Nullable leftRight;
@property (nonatomic, strong) FYConstraint * _Nullable rightLeft;

- (FYConstraint * _Nullable)constraintAt:(FYConstraintDirection)direction;

- (void)set:(FYConstraint * _Nullable)constraint At:(FYConstraintDirection)direction;

- (void)clearConstraintAt:(FYConstraintDirection)direction;

@end

NS_ASSUME_NONNULL_END
