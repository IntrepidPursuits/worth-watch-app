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
    
    NSArray *data = @[ @"Angelina Jolie:18000000",
                       @"Will Smith:32000000",
                       @"Clint Eastwood:35000000",
                       @"Tom Hanks:26000000",
                       @"Adam Sandler:37000000",
                       @"Madonna:125000000",
                       @"Oprah Winfrey:82000000",
                       @"Kate Moss:5700000",
                       @"Sandra Bullock:14000000",
                       @"Bill Gates:11500000000",
                       @"Donald Trump:63000000",
                       @"Tim Cook:9220000",
                       @"Dick Costolo:130250",
                       @"Mark Zuckerberg:1",
                       @"Beyonce:115000000",
                       @"50 Cent:8000000",
                       @"Paul McCartney:71000000",
                       @"Kanye West:30000000",
                       @"Lewis Hamilton:32000000",
                       @"Tiger Woods:61200000",
                       @"Serena Williams:22000000",
                       @"Wayne Rooney:23400000",
                       @"LeBron James:64600000",
                       @"Bode Miller:1300000",
                       @"Average Designer:40238",
                       @"Average Developer:66207",
                       @"Average Head Chef:41280",
                       @"Average Waiter:19535",
                       @"Average Fast Food:17862",
                       @"Average HS Teacher:45048",
                       @"Average Dentist:123206",
                       @"Average Engineer:64853",
                       @"Average Barista:21252",
                       @"Average CEO:153353",
                       @"Average Janitor:24250",
                       @"Average Electrician:49580",
                       @"Average Plumber:48750",
                       @"Average Pilot:100191",
                       @"Sidney Crosby:12700000",
                       @"Patrick Kane:6500000",
                       @"Tom Brady:31300000",
                       @"Derek Jeter:12000000",
                       @"Kendrick Lamar:40000000",
                       @"American Worker:26695"];
    
    for (NSString *person in data) {
        NSArray *components = [person componentsSeparatedByString:@":"];
        NSString *name = components[0];
        NSString *salaryString = components[1];
        NSNumber *salary = @([salaryString floatValue]);
        [self newWorthUserWithSalary:salary
                                name:name
                           favorited:NO
                         currentUser:NO
                           inContext:moc];
    }
    
    [moc save:nil];
}

@end
