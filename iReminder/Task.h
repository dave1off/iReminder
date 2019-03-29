#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSManagedObject

@property (nonatomic, strong) NSString *taskTitle;
@property (nonatomic, strong) NSString *taskDescription;
@property (nonatomic, strong) NSDate *taskDate;

@end

NS_ASSUME_NONNULL_END
