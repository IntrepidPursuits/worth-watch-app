//
//  InterfaceController.m
//  Worth WatchKit Extension
//
//  Created by Patrick Butkiewicz on 3/13/15.
//  Copyright (c) 2015 Intrepid Pursuits. All rights reserved.
//

#import "InterfaceController.h"

@interface InterfaceController()
@property (weak, nonatomic) IBOutlet WKInterfaceButton *startTimingButton;

@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
}

- (void)willActivate {
    [super willActivate];
}

- (void)didDeactivate {
    [super didDeactivate];
}

@end



