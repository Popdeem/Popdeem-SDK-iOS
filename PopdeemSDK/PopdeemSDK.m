//
//  PopdeemSDK.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 27/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PopdeemSDK.h"
#import "PDSocialMediaManager.h"

@implementation PopdeemSDK

+ (void) setTwitterOAuthToken:(NSString*)token verifier:(NSString*)verifier {
    [[PDSocialMediaManager manager] setOAuthToken:token oauthVerifier:verifier];
}

@end
