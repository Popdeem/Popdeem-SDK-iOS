//
//  PDOpeningHours.h
//  PopdeemBase
//
//  Created by Niall Quinn on 12/08/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDOpeningHoursDay.h"

@interface PDOpeningHoursWeek : NSObject

@property (nonatomic, strong) PDOpeningHoursDay *sunday;
@property (nonatomic, strong) PDOpeningHoursDay *monday;
@property (nonatomic, strong) PDOpeningHoursDay *tuesday;
@property (nonatomic, strong) PDOpeningHoursDay *wednesday;
@property (nonatomic, strong) PDOpeningHoursDay *thursday;
@property (nonatomic, strong) PDOpeningHoursDay *friday;
@property (nonatomic, strong) PDOpeningHoursDay *saturday;

- (id) initFromDictionary:(NSDictionary*)openingHoursDict;

@end
