//
// Created by Niall Quinn on 12/08/15.
// Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "PDOpeningHoursDay.h"


@implementation PDOpeningHoursDay {


}


- (id) initWithAPIStringOpen:(NSString*)openT close:(NSString*)closeT {
    if (self = [super init]) {
        
        NSArray *openComps = [openT componentsSeparatedByString:@":"];
        if ([openComps[0] isEqualToString:@"00"]) {
            self.openingHour = @0;
        } else {
            self.openingHour = [NSNumber numberWithInteger:[openComps[0] integerValue]];
        }
        if ([openComps[1] isEqualToString:@"00"]){
            self.openingMinute = @0;
        } else {
            self.openingMinute = [NSNumber numberWithInteger:[openComps[1] integerValue]];
        }
        
        
        NSArray *closeComps = [closeT componentsSeparatedByString:@":"];
        if ([closeComps[0] isEqualToString:@"00"]) {
            self.closingHour = @0;
        } else {
            self.closingHour = [NSNumber numberWithInteger:[closeComps[0] integerValue]];
        }
        if ([closeComps[1] isEqualToString:@"00"]){
            self.closingMinute = @0;
        } else {
            self.closingMinute = [NSNumber numberWithInteger:[closeComps[1] integerValue]];
        }
        self.isClosedForDay = NO;

        return self;
    };
    return nil;
}

- (id) initAsClosed {
    if (self=[super init]) {
        self.isClosedForDay = YES;
        return self;
    }
    return nil;
}

- (NSString*) hoursStringRepresentation {
    if (_isClosedForDay) {
        return @"Closed";
    } else {
        return [NSString stringWithFormat:@"%@ - %@",self.openingTimeStringRepresentation, self.closingTimeStringRepresentation];
    }
}

- (NSString*) openingTimeStringRepresentation {
    if (_isClosedForDay) return @"Closed";
    return [NSString stringWithFormat:@"%.02ld:%.02ld",(long)self.openingHour.integerValue,(long)self.openingMinute.integerValue];
}

- (NSString*) closingTimeStringRepresentation {
    if (_isClosedForDay) return @"Closed";
    return [NSString stringWithFormat:@"%.02ld:%.02ld",(long)self.closingHour.integerValue,(long)self.closingMinute.integerValue];
}

- (NSString*) description {
    if (self.isClosedForDay == YES) {
        return @"Closed";
    }
    return [NSString stringWithFormat:@"Open: %@, Close: %@",self.openingTimeStringRepresentation, self.closingTimeStringRepresentation];
}

@end