//
//  NSURL+OAuthAdditions.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 24/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (OAuthAdditions)
- (NSString *)URLStringWithoutQuery;
@end
