
#import "FYRuler.h"

FYFloat FYFloatMake(CGFloat value) {
    FYFloat ruler;
    ruler.value = value;
    ruler.enable = YES;
    return ruler;
}

@implementation FYRuler

- (void)setA:(FYFloat)a {
    
    _a = a;
    
    if (!_a.enable) {
        return;
    }
    
    if (_last != FYSectionNone) {
        if (_last == FYSectionB) {
            _c.enable = NO;
        } else if (_last == FYSectionC) {
            _b.enable = NO;
        }
    }
    
    _last = FYSectionA;
}

- (void)setB:(FYFloat)b {
    
    _b = b;
    
    if (!_b.enable) {
        return;
    }
    
    if (_last != FYSectionNone) {
        if (_last == FYSectionA) {
            _c.enable = NO;
        } else if (_last == FYSectionC) {
            _a.enable = NO;
        }
    }
    
    _last = FYSectionB;
}

- (void)setC:(FYFloat)c {
    
    _c = c;
    
    if (!_c.enable) {
        return;
    }
    
    if (_last != FYSectionNone) {
        if (_last == FYSectionA) {
            _b.enable = NO;
        } else if (_last == FYSectionB) {
            _a.enable = NO;
        }
    }
    
    _last = FYSectionC;
}

@end
