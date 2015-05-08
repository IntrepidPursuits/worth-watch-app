//
//  WorthUser.h
//  Worth
//
//  Created by Patrick Butkiewicz on 3/15/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface WorthUser : NSManagedObject

@property (nonatomic, retain) NSData *avatar;
@property (nonatomic, retain) NSNumber *currentUser;
@property (nonatomic, retain) NSNumber *favorited;
@property (nonatomic, retain) NSNumber *salary;
@property (nonatomic, retain) NSString *name;

@end
