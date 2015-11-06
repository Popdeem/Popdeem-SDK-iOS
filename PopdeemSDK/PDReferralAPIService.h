//
//  PDReferralAPIService.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 06/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDAPIService.h"
#import "PDReferral.h"

@interface PDReferralAPIService : PDAPIService

- (void) logReferral:(PDReferral*)referral;

@end
