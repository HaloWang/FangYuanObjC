//
// Created by 王策 on 16/5/11.
//


#import <Foundation/Foundation.h>
#import "FYConstraint.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYConstraintHolder : NSObject

@property (nonatomic, strong) FYConstraint * _Nullable bottom;
@property (nonatomic, strong) FYConstraint * _Nullable top;
@property (nonatomic, strong) FYConstraint * _Nullable right;
@property (nonatomic, strong) FYConstraint * _Nullable left;

- (FYConstraint * _Nullable)constraintAt:(FYConstraintSection)section;

- (void)set:(FYConstraint * _Nullable)constraint at:(FYConstraintSection)section;

- (void)clearConstraintAt:(FYConstraintSection)section;

@end

NS_ASSUME_NONNULL_END
