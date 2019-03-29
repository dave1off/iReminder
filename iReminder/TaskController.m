#import "TaskController.h"
#import <Masonry/Masonry.h>
#import "CoreDataManager.h"
#import <CoreData/CoreData.h>
#import "Task.h"
#import "UITextField_Category.h"

@interface TaskController () <UITextFieldDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIView *contentForScroll;

@property (strong, nonatomic) UITextField *titleField;
@property (strong, nonatomic) UITextView *contentView;
@property (strong, nonatomic) UIDatePicker *datePicker;

@property (strong, nonatomic) Task *defaultTask;

@end

@implementation TaskController

- (instancetype)initWithTask:(Task * _Nullable)task {
    self = [super init];
    
    if (self) {
        _defaultTask = task;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self configureNavigationBar];
    [self configureContentForScrollView];
    [self configureScrollView];
    [self configureTitleField];
    [self configureContentView];
    [self configureDatePicker];
}

- (void)configureNavigationBar {
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave
                                                                                target:self action:@selector(saveTask:)
                                   ];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                  target:self action:@selector(cancel:)
                                     ];
    
    [cancelButton setTintColor:[UIColor redColor]];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = saveButton;
    
    NSString *title = self.defaultTask ? self.defaultTask.taskTitle : @"New Ticket";
    [self.navigationItem setTitle:title];
}

- (void)configureContentForScrollView {
    self.contentForScroll = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1000)];
}

- (void)configureScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    [self.scrollView setShowsVerticalScrollIndicator:YES];
    
    [self.view addSubview:self.scrollView];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView.superview);
    }];
    
    [self.scrollView addSubview:self.contentForScroll];
    [self.scrollView setContentSize: self.contentForScroll.frame.size];
}

- (void)configureTitleField {
    self.titleField = [[UITextField alloc] init];
    [self.titleField setBorderStyle:UITextBorderStyleRoundedRect];
    [self.titleField setPlaceholder:@"Type title.."];
    [self.titleField setTextAlignment:NSTextAlignmentCenter];
    [self.titleField setDelegate:self];
    
    NSString *text = self.defaultTask ? self.defaultTask.taskTitle : @"New Ticket";
    [self.titleField setText:text];
    
    [self.contentForScroll addSubview:self.titleField];
    
    [self.titleField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.titleField.superview.mas_width).multipliedBy(0.8);
        make.top.equalTo(self.titleField.superview.mas_top).mas_offset(40);
        make.centerX.equalTo(self.titleField.superview.mas_centerX);
    }];
}

- (void)configureContentView {
    self.contentView = [[UITextView alloc] init];
    [self.contentView setTextAlignment:NSTextAlignmentNatural];
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.cornerRadius = 5;
    
    [self.contentForScroll addSubview:self.contentView];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.contentView.superview.mas_width).multipliedBy(0.9);
        make.height.equalTo([NSNumber numberWithInteger:400]);
        make.top.equalTo(self.titleField.mas_bottom).mas_offset(20);
        make.centerX.equalTo(self.titleField.mas_centerX);
    }];
}

- (void)configureDatePicker {
    self.datePicker = [[UIDatePicker alloc] init];
    
    [self.contentForScroll addSubview:self.datePicker];
    
    [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.datePicker.superview.mas_width).multipliedBy(0.9);
        make.height.equalTo([NSNumber numberWithInteger:300]);
        make.top.equalTo(self.contentView.mas_bottom).mas_offset(20);
        make.centerX.equalTo(self.titleField.mas_centerX);
    }];
}

#pragma mark - Selectors

- (void)saveTask:(UIBarButtonItem *)sender {
    Task *newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:[[CoreDataManager sharedInstance] getContext]];
    
    [newTask setTaskTitle: self.titleField.text];
    [newTask setTaskDescription:self.contentView.text];
    [newTask setTaskDate:[self.datePicker date]];
    
    [[[CoreDataManager sharedInstance] getContext] save:nil];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancel:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *navTitle = [textField textWithChangingIn:range byReplacementString:string];
    
    self.navigationItem.title = navTitle;
    
    return YES;
}

@end
