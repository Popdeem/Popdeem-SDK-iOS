//
//  KWSpec+WaitFor.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 18/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "KWSpec.h"

@interface KWSpec (WaitFor)

+ (void) waitWithTimeout:(NSTimeInterval)timeout forCondition:(BOOL(^)())conditionalBlock;

@end
