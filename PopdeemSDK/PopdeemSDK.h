//
//  PopdeemSDK.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 27/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//


#import <Foundation/Foundation.h>



NS_ASSUME_NONNULL_BEGIN
@interface PopdeemSDK : NSObject

+ (void) setTwitterOAuthToken:(NSString*)token verifier:(NSString*)verifier;

@end
NS_ASSUME_NONNULL_END
