//
//  PDUIInstagramLoginViewController.m
//
//
//  Created by Niall Quinn on 16/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIInstagramLoginViewController.h"
#import "PDUtils.h"
#import "PopdeemSDK.h"
#import "InstagramResponseModel.h"
#import "PDConstants.h"
#import "PDAPIClient.h"
#import "PDUIClaimViewModel.h"


@interface PDUIInstagramLoginViewController ()
@property (nonatomic, retain) PDUIModalLoadingView *loadingView;
@property (nonatomic) BOOL tappedClosed;
@property (nonatomic) BOOL connectMode;
@property (nonatomic) BOOL directConnect;
@end

NSString *client_id;
NSString *secret;
NSString *callback;
CGFloat _cardX,_cardY;

@implementation PDUIInstagramLoginViewController

- (instancetype) initForParent:(UIViewController*)parent delegate:(id<InstagramLoginDelegate>)delegate connectMode:(BOOL)connectMode {
	connected = NO;
	_connectMode = connectMode;
	if (self = [super init]) {
		_parent = parent;
		_delegate = delegate;
		self.viewModel = [[PDUIInstagramLoginViewModel alloc] initForParent:self];
		return self;
	}
	return nil;
}

- (instancetype) initForParent:(UIViewController*)parent {
	connected = NO;
	_connectMode = NO;
	if (self = [super init]) {
		_parent = parent;
		self.viewModel = [[PDUIInstagramLoginViewModel alloc] initForParent:self];
		return self;
	}
	return nil;
}

- (instancetype) initForParent:(UIViewController*)parent connectMode:(BOOL)connectMode {
	connected = NO;
	_connectMode = connectMode;
	if (self = [super init]) {
		_parent = parent;
		self.viewModel = [[PDUIInstagramLoginViewModel alloc] initForParent:self];
		return self;
	}
	return nil;
}

- (instancetype) initForParent:(UIViewController*)parent delegate:(id<InstagramLoginDelegate>)delegate connectMode:(BOOL)connectMode directConnect:(BOOL)directConnect {
  connected = NO;
  _connectMode = connectMode;
  _directConnect = directConnect;
  _delegate = delegate;
  if (self = [super init]) {
    _parent = parent;
    self.viewModel = [[PDUIInstagramLoginViewModel alloc] initForParent:self];
    return self;
  }
  return nil;
}

- (void) renderView {
  
  if (_directConnect) return;
  
	CGFloat currentY = 0;
	
	CGFloat cardWidth = _parent.view.frame.size.width * 0.8;
	CGFloat cardHeight = _parent.view.frame.size.height * 0.5;
	CGFloat cardX = _parent.view.frame.size.width * 0.1;
	CGFloat cardY = _parent.view.frame.size.height * 0.25;
	CGRect cardRect = CGRectMake(cardX, _parent.view.frame.size.height, cardWidth, cardHeight);
	
	_cardView.frame = cardRect;
	[_cardView setBackgroundColor:[UIColor whiteColor]];
	_cardView.layer.cornerRadius = 5.0;
	_cardView.layer.masksToBounds = YES;
	
	CGFloat cardCenterX = cardWidth/2;
	CGFloat imageWidth = cardWidth * 0.40;
	
	CGFloat labelPadding = cardWidth*0.10;
	
	self.label = [[UILabel alloc] initWithFrame:CGRectMake(labelPadding, 40, cardWidth-(2*labelPadding), 50)];
	[self.label setNumberOfLines:3];
	[self.label setFont:_viewModel.labelFont];
	[self.label setTextColor:_viewModel.labelColor];
	[self.label setText:_viewModel.labelText];
	[self.label setTextAlignment:NSTextAlignmentCenter];
	CGSize labelSize = [_label sizeThatFits:_label.bounds.size];
	[self.label setFrame:CGRectMake(_label.frame.origin.x, labelPadding , _label.frame.size.width, labelSize.height)];
	[_cardView addSubview:_label];
	
	currentY += labelPadding + labelSize.height + 40;
	
	self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(cardCenterX-(imageWidth/2), currentY, imageWidth, imageWidth)];
	[self.imageView setImage:_viewModel.logoImage];
	_imageView.layer.cornerRadius = 2.0;
	_imageView.layer.masksToBounds = YES;
	[_cardView addSubview:_imageView];
	
	currentY += imageWidth + 40;
	
	CGRect buttonFrame = CGRectMake(10, currentY, cardWidth-20, 40);
	
	self.actionButton = [[UIButton alloc] initWithFrame:buttonFrame];
	[_actionButton setBackgroundColor:_viewModel.buttonColor];
	[_actionButton.titleLabel setFont:_viewModel.buttonLabelFont];
	[_actionButton setTitle:_viewModel.buttonText forState:UIControlStateNormal];
	[_actionButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
	[_actionButton setTag:0];
	[_actionButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[_cardView addSubview:_actionButton];
	
	currentY += buttonFrame.size.height + labelPadding;
	
	_cardX = cardX;
	_cardY = cardY;
	CGFloat viewCenterY = self.view.frame.size.height/2;
	[_cardView setFrame:CGRectMake(_cardX, viewCenterY-(currentY/2), _cardView.frame.size.width, currentY)];
	[self.view setNeedsDisplay];

}

- (void) buttonPressed:(UIButton*)sender {
	if (connected) {
		[self dismissViewControllerAnimated:YES completion:^(void){}];
		[[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginSuccess object:nil];
	} else {
		[self connectInstagram];
	}
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[_viewModel setup];
	[self.view setBackgroundColor:[UIColor clearColor]];
	self.backingView = [[UIView alloc] initWithFrame:_parent.view.frame];
	[self.backingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
	[self.view addSubview:_backingView];
	UITapGestureRecognizer *backingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissWithTap)];
	[_backingView addGestureRecognizer:backingTap];
	
	_cardView = [[UIView alloc] initWithFrame:CGRectZero];
	[self.view addSubview:_cardView];
	_label = [[UILabel alloc] initWithFrame:CGRectZero];
	[_cardView addSubview:_label];
	_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	[_cardView addSubview:_imageView];
	_actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_actionButton setBackgroundColor:[UIColor clearColor]];
	[_cardView addSubview:_actionButton];
	[self renderView];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
  

}

- (void) viewDidAppear:(BOOL)animated {
//	[UIView animateWithDuration:0.5 animations:^{
//		[_cardView setFrame:CGRectMake(_cardX, _cardY, _cardView.frame.size.width, _cardView.frame.size.height)];
//	}];
  if (_directConnect) {
    [self connectInstagram];
  }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dismissWithTap {
	AbraLogEvent(ABRA_EVENT_CLICKED_CLOSE_INSTAGRAM_CONNECT, nil);
	_tappedClosed = YES;
	[self dismiss];
}

- (void) dismiss {
	if (connected) {
		[[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginSuccess object:nil];
	} else if (_tappedClosed) {
		[[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginuserDismissed object:nil];
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginFailure object:nil];
	}
	[self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (void) connectInstagram {
	client_id = [PopdeemSDK instagramClientId];
	secret = [PopdeemSDK instagramClientSecret];
	callback = [PopdeemSDK instagramCallback];
	
	NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code&scope=basic",client_id,callback];
	
	
	_webViewController = [[PDUIInstagramWebViewController alloc] initFromNib];
	self.definesPresentationContext = YES;
	_webViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
	
	NSHTTPCookie *cookie;
	NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
	for (cookie in [storage cookies])
	{
		NSString* domainName = [cookie domain];
		NSRange domainRange = [domainName rangeOfString:@"instagram.com"];
		if(domainRange.length > 0) {
			[storage deleteCookie:cookie];
		}
	}
	
	[self presentViewController:_webViewController animated:YES completion:^(void){
		_webViewController.webView.delegate = self;
		[_webViewController.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
	}];
	AbraLogEvent(ABRA_EVENT_CLICKED_SIGN_IN_INSTAGRAM, nil);
}

#pragma mark - Web View Delegate -

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	if ([[[request URL] URLStringWithoutQuery] rangeOfString:@"accounts/login"].location != NSNotFound) {
		//Show login view
		[_webViewController.loadingView hideAnimated:YES];
	}
	NSLog(@"URL: %@", [[request URL] URLStringWithoutQuery]);
	if ([[[request URL] URLStringWithoutQuery] rangeOfString:callback].location != NSNotFound) {
		[_webViewController.loadingView hideAnimated:YES];
		// Extract oauth_verifier from URL query
//		_webViewController.loadingView = [[PDUIModalLoadingView alloc] initForView:_webViewController.view titleText:@"Please Wait" descriptionText:@"We are connecting your Instagram Account"];
//		[_webViewController.loadingView showAnimated:YES];
		NSString* verifier = nil;
		NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
		for (NSString* param in urlParams) {
			NSArray* keyValue = [param componentsSeparatedByString:@"="];
			NSString* key = [keyValue objectAtIndex:0];
			if ([key isEqualToString:@"code"]) {
				verifier = [keyValue objectAtIndex:1];
				break;
			}
		}
		
		if (verifier) {
			
			NSString *data = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=authorization_code&redirect_uri=%@&code=%@",client_id,secret,callback,verifier];
			
			NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/oauth/access_token"];
			
			NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
			[request setHTTPMethod:@"POST"];
			[request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
			NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
			receivedData = [[NSMutableData alloc] init];
		} else {
			// ERROR!
		}
		
		[webView removeFromSuperview];
		
		return NO;
	}
	return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
	// [indicator stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
																									message:[NSString stringWithFormat:@"%@", error]
																								 delegate:nil
																				cancelButtonTitle:@"OK"
																				otherButtonTitles:nil];
	[alert show];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
	InstagramResponseModel *instagramModel = [[InstagramResponseModel alloc] initWithJSON:response];
	if (_connectMode) {
		[self connectWithModel:instagramModel];
	} else {
		[self registerWithModel:instagramModel];
	}
	[self.cardView setHidden:YES];
	[_webViewController dismissViewControllerAnimated:NO completion:nil];
	[self dismissViewControllerAnimated:NO completion:nil];
}

- (void) connectWithModel:(InstagramResponseModel*)instagramModel {
	[_delegate connectInstagramAccount:instagramModel.user.id accessToken:instagramModel.accessToken userName:instagramModel.user.username];
}

- (void) registerWithModel:(InstagramResponseModel*)instagramModel {
	[_delegate connectInstagramAccount:instagramModel.user.id accessToken:instagramModel.accessToken userName:instagramModel.user.username];
}

- (NSString *)URLStringWithoutQuery:(NSURL*)url {
	NSArray *parts = [[url absoluteString] componentsSeparatedByString:@"?"];
	return [parts objectAtIndex:0];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
