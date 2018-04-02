//
//  WalletCache.h
//  Popdeem
//
//  Created by Niall Quinn on 23/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDReward.h"

@interface PDUIWalletCache : NSObject

+ (void) add:(PDReward*)r;
+ (void) remove:(PDReward*)r;
+ (UIImage*) imageForReward:(PDReward*)r;
+ (void) clearCache;
@end
