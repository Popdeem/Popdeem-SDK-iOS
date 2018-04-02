//
//  PDModalLoadingView.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 24/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDUIModalLoadingView : UIView

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *descriptionLabel;
@property (nonatomic,retain) UIActivityIndicatorView *spinner;
@property (nonatomic,assign) UIView *parent;
@property (nonatomic, retain) UIView *contentView;

- (PDUIModalLoadingView*) initWithDefaultsForView:(UIView*)parent;
- (PDUIModalLoadingView*) initForView:(UIView*)parent
                     titleText:(NSString*)titleText
               descriptionText:(NSString*)descriptionText;
- (void) showAnimated:(BOOL)animated;
- (void) hideAnimated:(BOOL)animated;

@end
