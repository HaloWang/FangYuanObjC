//
//  FYConstraint.h
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FYConstraintSection) {
    FYConstraintSectionTop,
    FYConstraintSectionRight,
    FYConstraintSectionLeft,
    FYConstraintSectionBottom,
};

BOOL isHorizontal(FYConstraintSection section);

@interface FYConstraint : NSObject

@property (nonatomic, weak) UIView *from;
@property (nonatomic, weak) UIView *to;
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) FYConstraintSection section;

+ (FYConstraint *)constraintFrom:(UIView *)from
                              to:(UIView *)to
                         section:(FYConstraintSection)section
                           value:(CGFloat)value;

@end
