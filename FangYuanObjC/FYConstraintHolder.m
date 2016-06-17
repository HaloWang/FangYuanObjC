//
// Created by 王策 on 16/5/11.
//

#import "FYConstraintHolder.h"


@implementation FYConstraintHolder

- (FYConstraint *)constraintAt:(FYConstraintSection)section {
    switch (section) {
        case FYConstraintSectionBottom:
            return self.bottom;
        case FYConstraintSectionTop:
            return self.top;
        case FYConstraintSectionRight:
            return self.right;
        case FYConstraintSectionLeft:
            return self.left;
        default:
            NSAssert(NO, @"Something wrong!");
            return nil;
    }
}

- (void)set:(FYConstraint *)constraint at:(FYConstraintSection)section {
    switch (section) {
        case FYConstraintSectionBottom:{
            self.bottom = constraint;
            break;
        }
            
        case FYConstraintSectionTop:{
            self.top = constraint;
            break;
        }
            
        case FYConstraintSectionRight:{
            self.right = constraint;
            break;
        }
            
        case FYConstraintSectionLeft:{
            self.left = constraint;
            break;
        }
            
        default:
            NSAssert(NO, @"Something wrong!");
            return;
    }
}

- (void)clearConstraintAt:(FYConstraintSection)section {
    [self set:nil at:section];
}

@end
