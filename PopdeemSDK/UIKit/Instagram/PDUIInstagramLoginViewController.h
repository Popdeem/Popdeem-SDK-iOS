//
//  PDUIInstagramLoginViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 16/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDUICardViewController.h"
#import "PDTheme.h"
#import "PDUIInstagramWebViewController.h"
#import "NSURL+OAuthAdditions.h"
#import "PDUIInstagramLoginViewModel.h"

@class PDUIClaimViewModel;

@interface PDUIInstagramLoginViewController : UIViewController<UIWebViewDelegate> {
	NSMutableData *receivedData;
	BOOL connected;
}
@property (nonatomic, retain) PDUIInstagramLoginViewModel *viewModel;
@property (nonatomic, assign) UIViewController *parent;
@property (nonatomic, assign) PDUIClaimViewModel *delegate;
@property (nonatomic, retain) UIView *backingView;
@property (nonatomic, retain) UIView *cardView;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIButton *actionButton;

@property (nonatomic, retain) PDUIInstagramWebViewController *webViewController;
@property (nonatomic, retain) IBOutlet UIWebView *webview;;

- (instancetype) initForParent:(UIViewController*)parent delegate:(PDUIClaimViewModel*)delegate;
- (instancetype) initForParent:(UIViewController*)parent connectMode:(BOOL)connectMode;

@end
