//
//  PDScore.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 19/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDScores.h"

@implementation PDScores

- (id) initFromAPI:(NSDictionary *)params {
    if (self = [super init]) {
        self.total = [params[@"total_score"][@"value"] floatValue];
        self.reach = [params[@"influence_score"][@"reach_score_value"] floatValue];
        self.engagement = [params[@"influence_score"][@"engagement_score_value"] floatValue];
        self.frequency = [params[@"influence_score"][@"frequency_score_value"] floatValue];
        self.advocacy = [params[@"advocacy_score"][@"value"] floatValue];
        return self;
    }
    return nil;
}

@end
