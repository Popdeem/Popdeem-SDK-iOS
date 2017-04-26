//
//  PDSegmentedControl.h
//  Popdeem
//
//  Created by Niall Quinn on 10/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDBrandTheme.h"

@interface PDUISegmentedControl : UISegmentedControl

- (instancetype) initWithItems:(NSArray *)items;
- (void) applyTheme:(PDBrandTheme*)theme;

@end
