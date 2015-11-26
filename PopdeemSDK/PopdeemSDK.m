//
//  PopdeemSDK.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 27/08/2015.
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

#import "PopdeemSDK.h"
#import "PDSocialMediaManager.h"
#import "PDTheme.h"

@interface PopdeemSDK()
@property (nonatomic, strong)id uiKitCore;
@end
@implementation PopdeemSDK

+ (id) sharedInstance {
    static PopdeemSDK *SDK;
    static dispatch_once_t sharedToken;
    dispatch_once(&sharedToken, ^{
        SDK = [[PopdeemSDK alloc] init];

    });
    return SDK;
}

+ (void) withAPIKey:(NSString*)apiKey {
    PopdeemSDK *SDK = [[self class] sharedInstance];
    [SDK setApiKey:apiKey];
}

+ (void) setTwitterOAuthToken:(NSString*)token verifier:(NSString*) verifier {
    [[PDSocialMediaManager manager] setOAuthToken:token oauthVerifier:verifier];
}

+ (void) enableSocialLoginWithNumberOfPrompts:(NSInteger) noOfPrompts {
    id uiKitCore = [[self sharedInstance]popdeemUIKitCore];
    SEL selector = NSSelectorFromString(@"enableSocialLoginWithNumberOfPrompts:");

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [uiKitCore performSelector:selector withObject:@(noOfPrompts)];
#pragma clang diagnostic pop
}

+ (void) presentRewardFlow {
    id uiKitCore = [[self sharedInstance]popdeemUIKitCore];
    SEL selector = NSSelectorFromString(@"presentRewardFlow");

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [uiKitCore performSelector:selector];
#pragma clang diagnostic pop

    [self sharedInstance];
}

- (id)popdeemUIKitCore {
    if(self.uiKitCore) return self.uiKitCore;
    Class coreClazz = NSClassFromString(@"PopdeemUIKItCore");

    if(!coreClazz){
        [NSException raise:@"Popdeem UIKit not installed - pod 'PopdeemSDK/UIKit'" format:@""];
    }

    self.uiKitCore =  [[coreClazz alloc]init];

    return self.uiKitCore;
}

@end