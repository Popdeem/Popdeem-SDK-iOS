//
//  PDBrand.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 25/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDBrand.h"
#import "PDUser.h"
#import "PDLocationStore.h"
#import "PDConstants.h"
#import <CoreLocation/CoreLocation.h>

@interface PDBrand () {
    BOOL isDownloadingCover;
    BOOL isDownloadingLogo;
}

@end

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

- (NSComparisonResult)compare:(PDBrand *)otherObject {
    return [self.name compare:otherObject.name];
}

- (NSComparisonResult)compareDistance:(PDBrand *)otherObject {
    if (otherObject.distanceFromUser == self.distanceFromUser) {
        return NSOrderedSame;
    }
    if (otherObject.distanceFromUser < self.distanceFromUser) {
        return NSOrderedDescending;
    }
    return NSOrderedAscending;
}

- (void) calculateDistanceFromUser {
    
    NSArray *locations = [PDLocationStore locationsForBrandIdentifier:self.identifier];
    if (!locations) {
        return;
    }
    PDUser *user = [PDUser sharedInstance];
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:user.lastLocation.latitude longitude:user.lastLocation.longitude];
    
    double closestDistance = MAXFLOAT;
    for (PDLocation *loc in locations) {
        CLLocation *thisLocation = [[CLLocation alloc] initWithLatitude:loc.geoLocation.latitude longitude:loc.geoLocation.longitude];
        
        double distance = [userLocation distanceFromLocation:thisLocation];
        if (distance < closestDistance) {
            closestDistance = distance;
        }
    }
    self.distanceFromUser = closestDistance;
}

- (void) downloadCoverImageSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSDictionary *userDictionary;
    if (isDownloadingCover) {
        userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"Already downloading this image", NSLocalizedDescriptionKey,
                                        nil];
        NSError *error = [[NSError alloc] initWithDomain:kPopdeemErrorDomain code:PDErrorCodeImageDownloadFailed userInfo:userDictionary];
        failure(error);

    };
    if ([self.coverUrlString isKindOfClass:[NSString class]]) {
        if ([self.coverUrlString.lowercaseString rangeOfString:@"default"].location == NSNotFound) {
            isDownloadingCover = YES;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSData *coverData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.coverUrlString]];
                UIImage *coverImage = [UIImage imageWithData:coverData];
                
                self.coverImage = coverImage;
                isDownloadingCover = NO;
                success();
            });
        } else {
            userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                              @"Image is default image", NSLocalizedDescriptionKey,
                              nil];
            NSError *error = [[NSError alloc] initWithDomain:kPopdeemErrorDomain code:PDErrorCodeImageDownloadFailed userInfo:userDictionary];
            failure(error);
        }
    }
}

- (void) downloadLogoImageSuccess:(void (^)())success failure:(void (^)(NSError *error))failure {
    NSDictionary *userDictionary;
    if (isDownloadingLogo) {
        userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Already downloading this image", NSLocalizedDescriptionKey,
                          nil];
        NSError *error = [[NSError alloc] initWithDomain:kPopdeemErrorDomain code:PDErrorCodeImageDownloadFailed userInfo:userDictionary];
        failure(error);
        
    };
    if (self.logoUrlString) {
        isDownloadingLogo = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            self.logoImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.logoUrlString]]];
            isDownloadingLogo = NO;
            success();
        });
    } else {
        userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                          @"Image is default image", NSLocalizedDescriptionKey,
                          nil];
        NSError *error = [[NSError alloc] initWithDomain:kPopdeemErrorDomain code:PDErrorCodeImageDownloadFailed userInfo:userDictionary];
        failure(error);
    }
}

@end
