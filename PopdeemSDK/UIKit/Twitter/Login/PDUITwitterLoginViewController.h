//
//  PDUITwitterLoginViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 05/08/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDUITwitterLoginViewModel.h"

@interface PDUITwitterLoginViewController : UIViewController <UIAlertViewDelegate> {
	CGFloat _cardX,_cardY;
	BOOL connected;
}

@property (nonatomic, retain) PDUITwitterLoginViewModel *viewModel;
@property (nonatomic, assign) UIViewController *parent;
@property (nonatomic, retain) UIView *backingView;
@property (nonatomic, retain) UIView *cardView;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIButton *actionButton;

- (instancetype) initForParent:(UIViewController*)parent;

@end
