//
//  WorthUserManager.m
//  Worth
//
//  Created by Patrick Butkiewicz on 3/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "WorthUserManager.h"
#import "WorthObjectModel.h"
#import "WorthUser+UserGenerated.h"

@implementation WorthUserManager

+ (instancetype)sharedManager {
    static WorthUserManager *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

#pragma mark - Public

- (WorthUser *)currentUser {
    NSManagedObjectContext *moc = [[WorthObjectModel sharedObjectModel] mainContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[WorthUser entityName]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"currentUser == %@", @(YES)];
    [request setPredicate:predicate];
    [request setFetchLimit:1];
    WorthUser *user = [[moc executeFetchRequest:request error:nil] lastObject];
    
    if (user == nil) {
        user = [self newWorthUserWithSalary:@(1000000)
                                       name:@"You"
                                  favorited:NO
                                currentUser:YES
                                  inContext:moc];
    }
    return user;
}

- (void)favoriteUser:(WorthUser *)user {
    [user setFavorited:@(YES)];
    [user.managedObjectContext save:nil];
}

#pragma mark - Helpers

- (WorthUser *)newWorthUserWithSalary:(NSNumber *)salary
                                 name:(NSString *)name
                            favorited:(BOOL)favorited
                          currentUser:(BOOL)current
                            inContext:(NSManagedObjectContext *)context {
    NSEntityDescription *entity = [NSEntityDescription entityForName:[WorthUser entityName]
                                              inManagedObjectContext:context];
    WorthUser *user = [[WorthUser alloc] initWithEntity:entity
                         insertIntoManagedObjectContext:context];
    [user setSalary:salary];
    [user setName:name];
    [user setFavorited:@(favorited)];
    [user setCurrentUser:@(current)];
    [context save:nil];
    return user;
}

#pragma mark - Database

- (void)setupSimpleDatabase {
    NSManagedObjectContext *moc = [[WorthObjectModel sharedObjectModel] mainContext];
    NSArray *names = @[@"Barack Obama", @"Patrick Butkiewicz", @"Aaron Tenbuuren", @"Patrick Kane", @"Patrick Ewing",
                       @"Aaron Rodgers", @"Hank Aaron", @"Babe Ruth", @"Mario Lemieux", @"Sarah Jessica Parker",
                       @"Brad Pitt", @"Angelina Jolie", @"Tom Wheeler", @"Larry Bird", @"Charles Barkley",
                       @"Lebron James", @"Kobe Bryant", @"David Beckham", @"Pele", @"Macho Man Randy Savage",
                       @"Tom Brady", @"Peyton Manning", @"Russell Wilson", @"Marshawn Lynch", @"David Lettermen",
                       @"Jay Leno", @"Kevin"];
    
    for (NSString *name in names) {
        [self newWorthUserWithSalary:@(((arc4random() % 3000000) + 300000))
                                name:name
                           favorited:NO
                         currentUser:NO
                           inContext:moc];
    }
    
    [moc save:nil];
}

@end
