//
//  PDSocialLoginHandler.h
//  PopdeemSDK
//
//  Created by John Doran Home on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDSocialLoginHandler : NSObject

- (void)showPromptIfNeededWithMaxAllowed:(NSNumber*)numberOfTimes;

@end
