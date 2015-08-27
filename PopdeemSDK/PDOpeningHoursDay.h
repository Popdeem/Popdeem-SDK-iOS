//
// Created by Niall Quinn on 12/08/15.
// Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDOpeningHoursDay : NSObject

@property (nonatomic, strong) NSNumber *openingHour;
@property (nonatomic, strong) NSNumber *openingMinute;
@property (nonatomic, strong) NSNumber *closingHour;
@property (nonatomic, strong) NSNumber *closingMinute;

@property BOOL isClosedForDay;

- (id) initWithAPIStringOpen:(NSString*)openT close:(NSString*)closeT;
- (id) initAsClosed;
- (BOOL) isOpenNow;
- (NSString*) hoursStringRepresentation;
- (NSString*) openingTimeStringRepresentation;
- (NSString*) closingTimeStringRepresentation;

@end