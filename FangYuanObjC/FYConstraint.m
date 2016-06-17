//
//  FYConstraint.m
//  FangYuanObjC
//
//  Created by 王策 on 16/5/4.
//  Copyright © 2016年 WangCe. All rights reserved.
//

#import "FYConstraint.h"

BOOL isHorizontal(FYConstraintSection section) {
    switch (section) {
        case FYConstraintSectionRight:
        case FYConstraintSectionLeft:
            return YES;
        case FYConstraintSectionBottom:
        case FYConstraintSectionTop:
            return NO;
        default:
            return NO;
    }
}

@implementation FYConstraint

+ (FYConstraint *)constraintFrom:(UIView *)from
                              to:(UIView *)to
                         section:(FYConstraintSection)section
                           value:(CGFloat)value
{
    FYConstraint *cons = [FYConstraint new];
    cons.from          = from;
    cons.to            = to;
    cons.section     = section;
    cons.value         = value;
    return cons;
}

- (NSString *)description {
    return @[
             [super description],
             self.from,
             self.to
             ].description;
}

@end
