//
//  PDSocialLoginHandler.h
//  PopdeemSDK
//
//  Created by John Doran on 23/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDUISocialLoginHandler : NSObject

- (void)showPromptIfNeededWithMaxAllowed:(NSNumber*)numberOfTimes;

@end