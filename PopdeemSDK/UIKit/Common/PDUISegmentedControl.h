//
//  PDSegmentedControl.h
//  Popdeem
//
//  Created by Niall Quinn on 10/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDBrandTheme.h"
#import "PDUICustomBadge.h"

@interface PDUISegmentedControl : UISegmentedControl

@property (nonatomic, retain) NSMutableArray *segmentBadgeNumbers;
@property (nonatomic, retain) NSMutableArray *segmentBadges;
@property (nonatomic, retain) PDUICustomBadge *badge;
@property (nonatomic, assign) UIView *parentView;
@property (nonatomic, retain) UILabel *countLabel;

- (instancetype) initWithItems:(NSArray *)items;
- (void) applyTheme:(PDBrandTheme*)theme;

- (void)setBadgeNumber:(NSUInteger)badgeNumber forSegmentAtIndex:(NSUInteger)segmentIndex usingBlock:(void(^)(PDUICustomBadge *))configureBadge;

// Convenience method for setting a badge number with default look and feel.
- (void)setBadgeNumber:(NSUInteger)badgeNumber forSegmentAtIndex:(NSUInteger)segmentIndex;

// Get the badge number for a specific segment.
- (NSUInteger)getBadgeNumberForSegmentAtIndex:(NSUInteger)segmentIndex;

// Clear badges across all segments.
// If you need to add or remove segments, then call clearBadges first.
- (void)clearBadges;

@end
