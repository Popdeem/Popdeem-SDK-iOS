//
//  PDTierEvent.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 01/03/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PDTierEvent : JSONModel

@property (nonatomic) long date;
@property (nonatomic) NSInteger fromTier;
@property (nonatomic) NSInteger toTier;
@property (nonatomic) BOOL read;
- (nullable instancetype) initWithDictionary:(NSDictionary *)dict;
@end
