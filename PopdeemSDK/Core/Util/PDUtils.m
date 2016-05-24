//
//  PDUtils.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "PDUtils.h"
#import "PDCommon.h"
#import "PDConstants.h"
#import "PopdeemSDK.h"

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
    if ([[PopdeemSDK sharedInstance] apiKey]) return [[PopdeemSDK sharedInstance] apiKey];
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
    if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterAppConsumerKey"]) {
        twitterConsumerKey = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterAppConsumerKey"];
    } else {
        NSLog(@"No Twitter Consumer Key Found");
        NSString *errD = @"There is no Twitter Consumer key in the plist file. Please check that you have your Twitter Consumer key set under the key \"TwitterAppConsumerKey\"";
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errD, NSLocalizedDescriptionKey, nil];
        *err = [[NSError alloc] initWithDomain:kPopdeemErrorDomain code:PDErrorCodeNoAPIKey userInfo:userInfo];
    }
    return twitterConsumerKey;
}

+ (NSString*) getTwitterConsumerSecret:(NSError**)err {
    NSString *twitterConsumerSecret = nil;
    if ([[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterAppConsumerSecret"]) {
        twitterConsumerSecret = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterAppConsumerSecret"];
    } else {
        NSLog(@"No Twitter Consumer Secret Found");
        NSString *errD = @"There is no Twitter Consumer Secret in the plist file. Please check that you have your Twitter Consumer Secret set under the key \"TwitterAppConsumerSecret\"";
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:errD, NSLocalizedDescriptionKey, nil];
        *err = [[NSError alloc] initWithDomain:kPopdeemErrorDomain code:PDErrorCodeNoAPIKey userInfo:userInfo];
    }
    return twitterConsumerSecret;
}

NSString * const kLocalizedStringNotFound = @"kLocalizedStringNotFound";

NSString* translationForKey(NSString *key, NSString *defaultString) {
    return localizedStringForKey(key, defaultString, [NSBundle bundleForClass:[PDUtils class]]);
}


NSString *localizedStringForKey(NSString *key, NSString *value, NSBundle *bundle) {
    // First try main bundle
    NSString * string = [[NSBundle mainBundle] localizedStringForKey:key
                                                               value:kLocalizedStringNotFound
                                                               table:nil];
    
    // Then try the backup bundle
    if ([string isEqualToString:kLocalizedStringNotFound])
    {
        string = [bundle localizedStringForKey:key
                                         value:kLocalizedStringNotFound
                                         table:nil];
    }
    
    // Still not found?
    if ([string isEqualToString:kLocalizedStringNotFound])
    {
//        NSLog(@"No localized string for '%@'", key);
        string = value.length > 0 ? value : key;
    }
    
    return string;
}
@end
