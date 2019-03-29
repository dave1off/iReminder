#import "UITextField_Category.h"

@implementation UITextField (UITextField_Category)

- (NSString *)textWithChangingIn:(NSRange)range byReplacementString:(NSString *)string {
    NSMutableString *newString = [NSMutableString stringWithString:self.text];
    
    if (range.length) {
        [newString deleteCharactersInRange:range];
    } else {
        [newString insertString:string atIndex:range.location];
    }
    
    return [NSString stringWithString:newString];
}

@end
