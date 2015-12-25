//
//  TeamViewController.m
//  Hromadske
//
//  Created by Admin on 16.03.15.
//  Copyright (c) 2015 Semeniuk Sviatoslav. All rights reserved.
//

#import "TeamViewController.h"
#import "TeamViewCell.h"
#import "Employe.h"
#import "DataManager.h"
#import <CoreData/CoreData.h>
#import "RestKitManager.h"
#import <UIImageView+AFNetworking.h>

@interface TeamViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
{
    __weak IBOutlet UITableView* _tableView;
    TeamViewCell* _prototypecell;
}
@property (strong, nonatomic)  NSFetchedResultsController* fetchedResultsController;


@end

@implementation TeamViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Perform Fetch
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    
    [self setUpCell];
    _tableView.estimatedRowHeight = 171.f;
    _prototypecell = [_tableView dequeueReusableCellWithIdentifier:@"TeamCell"];
    
    [DataManager fetchRemoterEmploye];
}

#pragma mark - HandleUserInteratcionAccordingMenu

-(void)disableUserInteractionInViews{
    _tableView.userInteractionEnabled = NO;
}

-(void)enableUserInteractionInViews{
    _tableView.userInteractionEnabled = YES;
}

#pragma mark - TableViewDelegates
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.fetchedResultsController sections] objectAtIndex: section] numberOfObjects];
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    TeamViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TeamCell" forIndexPath:indexPath];

    Employe* employe = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [cell.label setText:employe.name];
    [cell.bio setText:employe.bio];
    NSURLRequest* imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:employe.image]
                                                  cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                              timeoutInterval:60];
    [cell.imageview setImageWithURLRequest:imageRequest placeholderImage:[UIImage imageNamed:@"avatar"] success:nil failure:nil];
    return cell;
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    [_prototypecell.bio setText:[(Employe*)[self.fetchedResultsController objectAtIndexPath:indexPath] bio]];

    [_prototypecell layoutIfNeeded];

    return [_prototypecell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
}

- (void)setUpCell
{
    [_tableView registerNib:[UINib nibWithNibName:@"TeamViewCell" bundle:nil] forCellReuseIdentifier:@"TeamCell"];
}

#pragma mark - FetchedResultController

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:NSStringFromClass([Employe class]) inManagedObjectContext:[RestKitManager managedObkjectContext]];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"name" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:[RestKitManager managedObkjectContext] sectionNameKeyPath:nil
                                                   cacheName:nil];
    
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

#pragma mark - FetchedResultControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [_tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [_tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert: {
            [_tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeDelete: {
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeUpdate: {
            [_tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
        case NSFetchedResultsChangeMove: {
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView insertRowsAtIndexPaths: @[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        }
    }
}

@end
