//
//  PDUtils.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDUtils.h"
#import "PDCommon.h"
#import "PDConstants.h"

@implementation PDUtils

+ (BOOL) validatePopdeemApiKey {
    NSError *err;
    [PDUtils getPopdeemApiKey:&err];
    if (err) {
        NSLog(@"%@",err.localizedDescription);
        return NO;
    }
    return YES;
}

+ (NSString*) getPopdeemApiKey:(NSError**)err {
    NSString *apiKey = nil;
    if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"PopdeemApiKey"]) {
        apiKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"PopdeemApiKey"];
    } else {
        NSLog(@"No Popdeem API Key Found");
        NSString *errD = @"There is no Api key in the plist file. Please check that you have your Popdeem API key set under the key \"PopdeemApiKey\"";
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errD, NSLocalizedDescriptionKey, nil];
        *err = [[NSError alloc] initWithDomain:kPopdeemErrorDomain code:PDErrorCodeNoAPIKey userInfo:userInfo];
    }
    return apiKey;
}

+ (NSString*) getTwitterConsumerKey:(NSError**)err {
    NSString *twitterConsumerKey = nil;
    if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterConsumerKey"]) {
        twitterConsumerKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterConsumerKey"];
    } else {
        NSLog(@"No Twitter Consumer Key Found");
        NSString *errD = @"There is no Twitter Consumer key in the plist file. Please check that you have your Twitter Consumer key set under the key \"TwitterConsumerKey\"";
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errD, NSLocalizedDescriptionKey, nil];
        *err = [[NSError alloc] initWithDomain:kPopdeemErrorDomain code:PDErrorCodeNoAPIKey userInfo:userInfo];
    }
    return twitterConsumerKey;
}

+ (NSString*) getTwitterConsumerSecret:(NSError**)err {
    NSString *twitterConsumerSecret = nil;
    if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterConsumerSecret"]) {
        twitterConsumerSecret = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterConsumerSecret"];
    } else {
        NSLog(@"No Twitter Consumer Secret Found");
        NSString *errD = @"There is no Twitter Consumer Secret in the plist file. Please check that you have your Twitter Consumer Secret set under the key \"TwitterConsumerSecret\"";
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errD, NSLocalizedDescriptionKey, nil];
        *err = [[NSError alloc] initWithDomain:kPopdeemErrorDomain code:PDErrorCodeNoAPIKey userInfo:userInfo];
    }
    return twitterConsumerSecret;
}

@end
