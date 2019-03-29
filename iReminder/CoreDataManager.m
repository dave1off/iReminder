#import "CoreDataManager.h"
#import <CoreData/CoreData.h>

@interface CoreDataManager ()

@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation CoreDataManager

+ (CoreDataManager *)sharedInstance {
    static CoreDataManager *shared;
    
    if (!shared) {
        shared = [[CoreDataManager alloc] init];
    }
    
    return shared;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [self initializeCoreData];
    }
    
    return self;
}

- (void)initializeCoreData {
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"iReminder" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    [context setPersistentStoreCoordinator:persistentStoreCoordinator];
    [self setContext:context];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentsURL = [[fileManager URLsForDirectory:NSLibraryDirectory inDomains:NSUserDomainMask] lastObject];
        // The directory the application uses to store the Core Data store file. This code uses a file named "DataModel.sqlite" in the application's documents directory.
        NSURL *storeURL = [documentsURL URLByAppendingPathComponent:@"DataModel.sqlite"];
        
        NSError *error = nil;
        
        [persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
        
        NSLog(@"Core Data is initialized");
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CoreDataManagerInitialized object:nil];
    });
}

- (NSManagedObjectContext *)getContext {
    return _context;
}

@end
