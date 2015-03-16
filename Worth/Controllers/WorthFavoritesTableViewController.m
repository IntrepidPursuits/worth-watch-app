//
//  WorthFavoritesTableViewController.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthFavoritesTableViewController.h"
#import "WorthCompareUserTableViewCell.h"
#import "WorthCompareViewController.h"
#import "WorthObjectModel.h"
#import "WorthUserManager.h"
#import "WorthUserView.h"
#import "WorthUser+UserGenerated.h"
#import "UIColor+WorthStyle.h"

static NSString * const kWorthCompareUserTableViewCellIdentifier = @"WorthCompareUserTableViewCell";
static NSString * const kSegueCompareIdentifier = @"kCompareSegue";

@interface WorthFavoritesTableViewController () <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchResultsController;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;
@property (weak, nonatomic) IBOutlet WorthUserView *userView;

@end

@implementation WorthFavoritesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    [self configureTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self configureNavigationItems];
}

- (void)configureView {
    WorthUser *user = [[WorthUserManager sharedManager] currentUser];
    [self.userView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth)];
    [self.userView configureWithUser:user];
    [self.userView setBackgroundColor:[UIColor worth_lightGreenColor]];
    [self.view setBackgroundColor:[UIColor worth_greenColor]];
    [self.userView layoutIfNeeded];
}

- (void)configureTableView {
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:kWorthCompareUserTableViewCellIdentifier bundle:nil]
         forCellReuseIdentifier:kWorthCompareUserTableViewCellIdentifier];
    [self.fetchResultsController performFetch:nil];
}

- (void)configureNavigationItems {
    UIBarButtonItem *addBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                      target:self
                                                                                      action:@selector(didTapAddButton:)];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = addBarButtonItem;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegueCompareIdentifier]) {
        WorthUser *user = [self.fetchResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        [(WorthCompareViewController *)segue.destinationViewController setComparedToUser:user];
    }
}

#pragma mark - Button Event Methods

- (void)didTapAddButton:(id)sender {
    NSLog(@"Search");
}

#pragma mark - NSFetchedResultsController Delegate Methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                                  withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kSegueCompareIdentifier sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 72.0f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorthCompareUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWorthCompareUserTableViewCellIdentifier
                                                                          forIndexPath:indexPath];
    WorthUser *user = [self.fetchResultsController objectAtIndexPath:indexPath];
    [cell setContentMode:WorthCompareUserTableCellContentModeOtherUser];
    [cell configureWithUser:user];
    return cell;
}

#pragma mark - Lazy

- (NSFetchedResultsController *)fetchResultsController {
    if (_fetchResultsController == nil) {
        NSManagedObjectContext *moc = [[WorthObjectModel sharedObjectModel] mainContext];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[WorthUser entityName]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currentUser == %@", @(NO)];
        NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        [request setPredicate:predicate];
        [request setSortDescriptors:@[sortDescriptor]];
        _fetchResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                      managedObjectContext:moc
                                                                        sectionNameKeyPath:@"favorited"
                                                                                 cacheName:nil];
        [_fetchResultsController setDelegate:self];
        _fetchRequest = request;
    }
    return _fetchResultsController;
}

@end
