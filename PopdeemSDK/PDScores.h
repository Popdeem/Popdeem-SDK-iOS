//
//  PDScore.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 19/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDScores : NSObject

@property (nonatomic) float total;
@property (nonatomic) float reach;
@property (nonatomic) float engagement;
@property (nonatomic) float frequency;
@property (nonatomic) float advocacy;

- (id) initFromAPI:(NSDictionary*)params;

@end
