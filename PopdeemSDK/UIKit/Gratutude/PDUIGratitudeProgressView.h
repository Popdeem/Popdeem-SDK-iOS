//
//  PDUIGratitudeProgressView.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 12/02/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDUIGratitudeProgressView : UIView

@property (nonatomic) float initialValue;
@property (nonatomic) float barWidth;
@property (nonatomic, retain) UIView *progressBackingView;
@property (nonatomic, retain) UIView *progressCurrentView;
@property (nonatomic, retain) UILabel *level1Label;
@property (nonatomic, retain) UILabel *level2Label;
@property (nonatomic, retain) UILabel *level3Label;


- (id) initWithInitialValue:(float)value frame:(CGRect)frame;


@end
