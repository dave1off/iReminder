#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (UITextField_Category)

- (NSString *)textWithChangingIn:(NSRange)range byReplacementString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
