//
//  PDLocationValidator.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 12/02/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDGeolocationManager.h"
#import "PDReward.h"
#import "PDLocation.h"

@interface PDLocationValidator : NSObject <CLLocationManagerDelegate, UIAlertViewDelegate>

- (void) validateLocationForReward:(PDReward*)reward completion:(void (^)(BOOL valdated, PDLocation *closestLocation))completion;

@end
