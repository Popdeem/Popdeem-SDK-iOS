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
#import "OAuthConsumer.h"

@interface PDUIInstagramLoginViewController : PDUICardViewController<UIWebViewDelegate> {
	OAConsumer *consumer;
	OAToken *requestToken;
	OAToken *accessToken;
	NSMutableData *receivedData;
}

@property (nonatomic, retain) PDUIInstagramWebViewController *webViewController;
@property (nonatomic, retain) IBOutlet UIWebView *webview;;

- (instancetype) initForParent:(UIViewController*)parent;
- (instancetype) initFromNib;

@end
