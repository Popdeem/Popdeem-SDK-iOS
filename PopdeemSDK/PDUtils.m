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

@end
