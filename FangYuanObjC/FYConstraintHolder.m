//
// Created by 王策 on 16/5/11.
//

#import "FYConstraintHolder.h"


@implementation FYConstraintHolder

- (FYConstraint *)constraintAt:(FYConstraintDirection)direction {
    switch (direction) {
        case FYConstraintDirectionTopBottom:
            return self.topBottom;
        case FYConstraintDirectionBottomTop:
            return self.bottomTop;
        case FYConstraintDirectionLeftRight:
            return self.leftRight;
        case FYConstraintDirectionRightLeft:
            return self.rightLeft;
        default:
            return nil;
    }
}

- (void)set:(FYConstraint *)constraint At:(FYConstraintDirection)direction {
    switch (direction) {
        case FYConstraintDirectionTopBottom:{
            self.topBottom = constraint;
            break;
        }
            
        case FYConstraintDirectionBottomTop:{
            self.bottomTop = constraint;
            break;
        }
            
        case FYConstraintDirectionLeftRight:{
            self.leftRight = constraint;
            break;
        }
            
        case FYConstraintDirectionRightLeft:{
            self.rightLeft = constraint;
            break;
        }
            
        default:
            return;
    }
}

@end
