//
//  PDBrand.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 25/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDBrand.h"

@implementation PDBrand

- (id) initFromApi:(NSDictionary*)params {
    if (self = [super init]) {
        self.identifier = [params[@"id"] integerValue];
        self.name = params[@"name"];
        self.logoUrlString = params[@"logo"];
        self.coverUrlString = params[@"cover_image"];
        
        NSDictionary *contacts = params[@"contacts"];
        self.phoneNumber = contacts[@"phone"];
        self.email = contacts[@"email"];
        self.web  = contacts[@"web"];
        self.facebook = contacts[@"facebook"];
        self.twitter = contacts[@"twitter"];
        
        if (params[@"opening_hours"]) {
            self.openingHours = [[PDOpeningHoursWeek alloc] initFromDictionary:params[@"opening_hours"]];
        }
        
        return self;
    }
    return nil;
}

@end
