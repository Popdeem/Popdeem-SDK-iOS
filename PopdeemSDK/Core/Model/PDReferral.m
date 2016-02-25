//
//  PDReferral.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 06/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDReferral.h"
#import "PDAPIClient.h"

@implementation PDReferral

- (id) initWithSenderId:(NSInteger)senderId senderApp:(NSString*)senderApp type:(PDReferralType)type {
    if (self = [super init]) {
        self.senderId = senderId;
        self.senderAppName = senderApp;
        self.referralType = type;
        return self;
    }
    return nil;
}

- (id) initWithUrl:(NSURL*)url appRef:(NSString*)application {
    if (self = [super init]) {
        [self setupWithithUrl:url appRef:application];
        return self;
    }
    return nil;
}

- (void) setupWithithUrl:(NSURL*)url appRef:(NSString*)application {

}

- (NSInteger) getRequestIdFromURL:(NSString*)url {
    NSArray *comps = [url componentsSeparatedByString:@"/"];
    for (int i = 0; i < comps.count; i++) {
        NSString *s = comps[i];
        if ([s isEqualToString:@"requests"]) {
            NSString *intString = comps[i+1];
            return [intString integerValue];
        }
    }
    return -1;
}

+ (void) logReferral:(PDReferral*)referral {
    [[PDAPIClient sharedInstance] setReferral:referral];
  if ([PDUser sharedInstance] != nil) {
    //App is already open, update immediately
    [[[PDAPIClient sharedInstance] referral] setReferralType:PDReferralTypeReopen];
    [[PDAPIClient sharedInstance] updateUserLocationAndDeviceTokenSuccess:^(PDUser *user){
    } failure:^(NSError *error){
      
    }];
  }
}

- (NSString*) typeString {
    NSString *type = @"";
    switch (self.referralType) {
        case PDReferralTypeInstall:
            type = @"install";
            break;
        case PDReferralTypeReopen:
            type = @"open";
            break;
        default:
            type = @"open";
            break;
    }
    return type;
}

@end
