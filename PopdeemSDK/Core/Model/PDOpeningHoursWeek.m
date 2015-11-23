//
//  PDOpeningHours.m
//  PopdeemBase
//
//  Created by Niall Quinn on 12/08/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "PDOpeningHoursWeek.h"

@implementation PDOpeningHoursWeek

- (id) initFromDictionary:(NSDictionary*)openingHoursDict {
    if (self = [super init]) {
        if (openingHoursDict[@"sunday"]) {
            self.sunday = [self extractOpeningHoursDay:openingHoursDict[@"sunday"]];
        }
        if (openingHoursDict[@"monday"]) {
            self.monday = [self extractOpeningHoursDay:openingHoursDict[@"monday"]];
        }
        if (openingHoursDict[@"tuesday"]) {
            self.tuesday = [self extractOpeningHoursDay:openingHoursDict[@"tuesday"]];
        }
        if (openingHoursDict[@"wednesday"]) {
            self.wednesday = [self extractOpeningHoursDay:openingHoursDict[@"wednesday"]];
        }
        if (openingHoursDict[@"thursday"]) {
            self.thursday = [self extractOpeningHoursDay:openingHoursDict[@"thursday"]];
        }
        if (openingHoursDict[@"friday"]) {
            self.friday = [self extractOpeningHoursDay:openingHoursDict[@"friday"]];
        }
        if (openingHoursDict[@"saturday"]) {
            self.saturday = [self extractOpeningHoursDay:openingHoursDict[@"saturday"]];
        }
        return self;
    }
    return nil;
}

- (PDOpeningHoursDay*) extractOpeningHoursDay:(NSDictionary*)day {
    if ([day[@"closed"] integerValue] == 1) {
        return [[PDOpeningHoursDay alloc] initAsClosed];
    }
    return [[PDOpeningHoursDay alloc] initWithAPIStringOpen:day[@"from"] close:day[@"to"]];
}

@end
