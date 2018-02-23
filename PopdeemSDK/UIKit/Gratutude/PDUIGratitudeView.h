//
//  PDUIGratitudeView.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 11/02/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDUIGratitudeProgressView.h"
#import "PDUIGratitudeViewController.h"
#import "PDUser.h"


@interface PDUIGratitudeView : UIView

@property (nonatomic, assign) PDUIGratitudeViewController *parent;
@property (nonatomic, retain) UIView *backingView;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) UILabel *bodyLabel;
@property (nonatomic, retain) PDUIGratitudeProgressView *progressView;
@property (nonatomic, retain) UILabel *infoLabel;
@property (nonatomic, retain) UIButton *profileButton;
@property (nonatomic) PDGratitudeType type;

- (PDUIGratitudeView*) initForParent:(PDUIGratitudeViewController*)parent type:(PDGratitudeType)type;
- (void) showAnimated:(BOOL)animated;
- (void) hideAnimated:(BOOL)animated;

@end
