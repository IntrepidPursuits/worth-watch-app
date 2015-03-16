//
//  WorthFavoritesViewController.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthFavoritesViewController.h"
#import "WorthCompareUserTableViewCell.h"
#import "WorthCompareViewController.h"
#import "WorthObjectModel.h"
#import "WorthUserManager.h"
#import "WorthUserView.h"
#import "WorthUser+UserGenerated.h"
#import "UIColor+WorthStyle.h"
#import "UIFont+WorthStyle.h"

static NSString * const kWorthCompareUserTableViewCellIdentifier = @"WorthCompareUserTableViewCell";
static NSString * const kSegueCompareIdentifier = @"kCompareSegue";

@interface WorthFavoritesViewController () <NSFetchedResultsControllerDelegate, WorthCompareUserTableViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchResultsController;
@property (strong, nonatomic) NSFetchRequest *fetchRequest;
@property (weak, nonatomic) IBOutlet WorthUserView *userView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation WorthFavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
    [self configureTableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self configureNavigationItems];
}

- (void)configureView {
    [self.userView configureWithUser:[[WorthUserManager sharedManager] currentUser]];
    [self.userView setBackgroundColor:[UIColor worth_lightGreenColor]];
    [self.view setBackgroundColor:[UIColor worth_greenColor]];
}

- (void)configureTableView {
    self.tableView.backgroundColor = [UIColor worth_greenColor];
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:kWorthCompareUserTableViewCellIdentifier bundle:nil]
         forCellReuseIdentifier:kWorthCompareUserTableViewCellIdentifier];
    [self.fetchResultsController performFetch:nil];
}

- (void)configureNavigationItems {
    UIBarButtonItem *searchBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                         target:self
                                                                                         action:@selector(didTapSearchButton:)];
    self.navigationController.topViewController.navigationItem.rightBarButtonItem = searchBarButtonItem;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kSegueCompareIdentifier]) {
        WorthUser *user = [self.fetchResultsController objectAtIndexPath:self.tableView.indexPathForSelectedRow];
        [(WorthCompareViewController *)segue.destinationViewController setComparedToUser:user];
    }
}

#pragma mark - Button Event Methods

- (void)didTapSearchButton:(id)sender {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorthCompareUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWorthCompareUserTableViewCellIdentifier
                                                                          forIndexPath:indexPath];
    WorthUser *user = [self.fetchResultsController objectAtIndexPath:indexPath];
    [cell setContentMode:WorthCompareUserTableCellContentModeOtherUser];
    [cell configureWithUser:user];
    [cell setDelegate:self];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:kSegueCompareIdentifier sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [WorthCompareUserTableViewCell preferredHeight];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id<NSFetchedResultsSectionInfo> sectionInfo = [self.fetchResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title;
    if ([self.fetchResultsController sections].count == 2) {
        title = (section == 0) ? @"Favorites" : @"Add New";
    } else {
        title = @"Add New";
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 24)];
    [label setBackgroundColor:[UIColor worth_darkGreenColor]];
    [label setFont:[UIFont worth_regularFontWithSize:16.0f]];
    [label setText:title];
    [label setTextColor:[UIColor whiteColor]];
    return label;
}

#pragma mark - WorthCompareUserTableViewCellDelegate Methods

- (void)compareUserTableViewCell:(WorthCompareUserTableViewCell *)cell didTapFavoriteButton:(id)button {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    WorthUser *user = [self.fetchResultsController objectAtIndexPath:indexPath];
    BOOL isFavorited = [user.favorited boolValue];
    [user setFavorited:@(!isFavorited)];
    [user.managedObjectContext save:nil];
    [self.fetchResultsController performFetch:nil];
}

#pragma mark - Lazy

- (NSFetchedResultsController *)fetchResultsController {
    if (_fetchResultsController == nil) {
        NSManagedObjectContext *moc = [[WorthObjectModel sharedObjectModel] mainContext];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[WorthUser entityName]];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currentUser == %@", @(NO)];
        NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSSortDescriptor *favoriteSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"favorited" ascending:NO];
        [request setPredicate:predicate];
        [request setSortDescriptors:@[favoriteSortDescriptor, nameSortDescriptor]];
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