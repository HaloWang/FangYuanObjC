
#import <Foundation/Foundation.h>
#import "FYDependency.h"

NS_ASSUME_NONNULL_BEGIN

@interface FYDependencyManager : NSObject

+ (FYDependencyManager *)sharedInstance;

+ (void)pushDependencyFrom:(UIView *)from
                        to:(UIView *)to
                 direction:(FYDependencyDirection *)direction
                     value:(CGFloat)value;

+ (void)popDependencyFrom:(UIView *)from
                       to:(UIView *)to
                direction:(FYDependencyDirection *)direction
                    value:(CGFloat)value;


@end

NS_ASSUME_NONNULL_END
