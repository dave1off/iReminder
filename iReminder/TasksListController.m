#import "TasksListController.h"
#import <Masonry/Masonry.h>
#import <CoreData/CoreData.h>
#import "CoreDataManager.h"
#include "Task.h"
#include "TaskController.h"

@interface TasksListController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UITableView *tasksList;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation TasksListController

- (instancetype)init {
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action:) name:CoreDataManagerInitialized object:nil];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initializeTasksList];
    [self initializeFetchedResultsController];
    
    [self.navigationItem setTitle:@"Tasks"];
    
    [self.view setBackgroundColor: [UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTask:)];
}

- (void)action:(NSNotification *)sender {
    NSError *error = nil;
    
    if ([self.fetchedResultsController performFetch:&error]) {
        NSLog(@"%ld", [[self.fetchedResultsController fetchedObjects] count]);
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tasksList reloadData];
    });
}

- (void)addTask:(UIBarButtonItem *)sender {
    [self.navigationController pushViewController:[[TaskController alloc] initWithTask:nil] animated:YES];
}

- (void)longPressAction:(UILongPressGestureRecognizer *)sender {
    if (sender.state != UIGestureRecognizerStateBegan) { return; }
    
    [self.tasksList setEditing:![self.tasksList isEditing] animated:YES];
    
    [self.tasksList beginUpdates];
    [self.tasksList endUpdates];
}

- (void)initializeTasksList {
    self.tasksList = [[UITableView alloc] init];
    [self.tasksList setTableFooterView: [[UIView alloc] init]];
    
    [self.tasksList setDelegate:self];
    [self.tasksList setDataSource:self];
    
    [self.view addSubview:self.tasksList];
    
    [self.tasksList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tasksList.superview);
    }];
    
    UILongPressGestureRecognizer *pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    
    [self.tasksList addGestureRecognizer:pressGesture];
}

- (void)initializeFetchedResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    NSManagedObjectContext *context = [[CoreDataManager sharedInstance] getContext];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"taskTitle" ascending:YES];
    
    [request setSortDescriptors:@[sortDescriptor]];
    [request setResultType:NSManagedObjectResultType];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    self.fetchedResultsController.delegate = self;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:nil];
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell.textLabel setText: [task taskTitle]];
    [cell.detailTextLabel setText:[[task taskDate] description]];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger count = [[[self fetchedResultsController] sections] count];
    return count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [[[[self fetchedResultsController] sections][section] objects] count];
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tasksList isEditing] ? 40 : 80;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [[self tasksList] beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    NSLog(@"Core: section %ld", type);
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    [[self tasksList] insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [[self tasksList] endUpdates];
}



@end
