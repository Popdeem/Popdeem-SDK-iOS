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

@interface PDUIInstagramLoginViewController ()
@property (nonatomic, retain) PDUIModalLoadingView *loadingView;
@end

NSString *client_id;
NSString *secret;
NSString *callback;

@implementation PDUIInstagramLoginViewController

- (instancetype) initForParent:(UIViewController*)parent {
	NSString *headerText = translationForKey(@"popdeem.instagram.connect.headerText", @"Connect Instagram");
	NSString *bodyText = translationForKey(@"popdeem.instagram.connect.bodyText", @"You must connect your Instagram Account to perform this action. Dont worry, we will never post without your explicit permission");
	NSString *actionButtonTitle = translationForKey(@"popdeem.instagram.connect.actionButtonTitle", @"Connect Instagram Account");
	connected = NO;
	if (self = [super initForParent:parent headerText:headerText image:[UIImage imageNamed:@"pduikit_instagram_hires"] bodyText:bodyText actionButtonTitle:actionButtonTitle otherButtonTitles:nil completion:^(int buttonIndex){
		if (connected) {
			[self dismissViewControllerAnimated:YES completion:^(void){}];
			[[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginSuccess object:nil];
		} else {
			[self connectInstagram];
		}
	}]){
		return self;
	}
	return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) dismiss {
	if (connected) {
		[[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginSuccess object:nil];
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginFailure object:nil];
	}
	[self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (void) connectInstagram {
	client_id = [PopdeemSDK instagramClientId];
	secret = [PopdeemSDK instagramClientSecret];
	callback = [PopdeemSDK instagramCallback];
	
	NSString *url = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=code&scope=public_content+likes+comments+basic",client_id,callback];
	
	
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
}

#pragma mark - Web View Delegate -

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	if ([[[request URL] URLStringWithoutQuery] rangeOfString:@"accounts/login"].location != NSNotFound) {
		//Show login view
		[_webViewController.loadingView hideAnimated:YES];
	}
	if ([[[request URL] URLStringWithoutQuery] rangeOfString:callback].location != NSNotFound) {
		[_webViewController.loadingView hideAnimated:YES];
		// Extract oauth_verifier from URL query
		_webViewController.loadingView = [[PDUIModalLoadingView alloc] initForView:_webViewController.view titleText:@"Please Wait" descriptionText:@"We are connecting your Instagram Account"];
		[_webViewController.loadingView showAnimated:YES];
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
#pragma TODO Connect Social Account
	PDAPIClient *client = [PDAPIClient sharedInstance];
	[client connectInstagramAccount:instagramModel.identifier accessToken:instagramModel.accessToken screenName:instagramModel.userName success:^(void){
		[_webViewController dismissViewControllerAnimated:NO completion:^(void){}];
		[_webViewController.loadingView hideAnimated:YES];
		connected = YES;
		[[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginSuccess object:nil];
		[self.headerLabel setText:@"Instagram Connected"];
		[self.bodyLabel setText:@"Your Instagram account is now connected. You can claim your reward now!"];
		[self.actionButton setTitle:@"Back to Claim" forState:UIControlStateNormal];
		[self.view setNeedsDisplay];
	} failure:^(NSError* error){
		[_webViewController dismissViewControllerAnimated:NO completion:^(void){}];
		[_webViewController.loadingView hideAnimated:YES];
		connected = NO;
		[[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginFailure object:nil];
		[self.headerLabel setText:@"Instagram Not Connected"];
		[self.bodyLabel setText:@"Your Instagram account is not connected."];
		[self.actionButton setTitle:@"Back to Claim" forState:UIControlStateNormal];
		[self.view setNeedsDisplay];
	}];
}

- (NSString *)URLStringWithoutQuery:(NSURL*)url {
	NSArray *parts = [[url absoluteString] componentsSeparatedByString:@"?"];
	return [parts objectAtIndex:0];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
