//
//  PDUIGratitudeView.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 11/02/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDUIGratitudeView : UIView

@property (nonatomic, assign) UIView *parent;
@property (nonatomic, retain) UIView *backingView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *bodyLabel;

- (PDUIGratitudeView*) initForView:(UIView*)parent;
- (void) showAnimated:(BOOL)animated;
- (void) hideAnimated:(BOOL)animated;

@end
