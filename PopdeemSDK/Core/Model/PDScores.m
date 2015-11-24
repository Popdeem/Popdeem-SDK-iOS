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
        self.engagement = [params[@"engagement_score"][@"engagement_score_value"] floatValue];
        self.frequency = [params[@"influence_score"][@"frequency_score_value"] floatValue];
        self.advocacy = [params[@"advocacy_score"][@"value"] floatValue];
        return self;
    }
    return nil;
}

- (id) initWithJSON:(NSString*)json {
    NSError *err;
    if (self = [super initWithString:json error:&err]) {
        return  self;
    }
    NSLog(@"JSONModel Error on Score: %@",err);
    return  nil;
}

+(JSONKeyMapper*)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"total_score.value": @"total",
                                                       @"influence_score.engagement_score_value": @"engagement",
                                                       @"influence_score.reach_score_value": @"reach",
                                                       @"influence_score.frequency_score_value": @"frequency",
                                                       @"advocacy_score.value": @"advocacy"
                                                       }];
}


@end
