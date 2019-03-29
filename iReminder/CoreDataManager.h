#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class NSManagedObjectContext;

static const NSString *CoreDataManagerInitialized = @"CoreDataInitialized";

@interface CoreDataManager : NSObject

+ (CoreDataManager *)sharedInstance;

- (NSManagedObjectContext *)getContext;

@end

NS_ASSUME_NONNULL_END
