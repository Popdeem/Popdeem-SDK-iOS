//
//  PDReferral.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 06/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDReferral.h"
#import "PDAPIClient.h"
#import <Bolts/BFURL.h>

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
    BFURL *parsedUrl = [BFURL URLWithInboundURL:url sourceApplication:application];
    if (parsedUrl.appLinkData) {
        // This is AppLink traffic
        NSURL *applinkTargetUrl = parsedUrl.targetURL;
        NSDictionary *alData = parsedUrl.appLinkData;
        NSString *targetUrl = alData[@"target_url"];
        if ([self getRequestIdFromURL:targetUrl] > 0) {
            self.requestId = [self getRequestIdFromURL:targetUrl];
        }
        NSDictionary *refAppLink = alData[@"referer_app_link"];
        if (refAppLink[@"app_name"]) {
            self.senderAppName = refAppLink[@"app_name"];
        }
        if (parsedUrl.inputQueryParameters[@"user_id"]) {
            self.senderId = [parsedUrl.inputQueryParameters[@"user_id"] integerValue];
        }
    }
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
      NSLog(@"Something went wrong while updating the user");
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
