//
//  PDUISettingsViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 05/08/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUISettingsViewController.h"
#import "PopdeemSDK.h"
#import "PDUISocialSettingsTableViewCell.h"
#import "PDUser.h"
#import "PDTheme.h"
#import "PDConstants.h"
#import "PDSocialAPIService.h"
#import "PDUIInstagramLoginViewController.h"
#import "PDAPIClient.h"
#import "PDUITwitterLoginViewController.h"
#import "PDUIFBLoginWithWritePermsViewController.h"
#import "PDSocialMediaManager.h"
#define kSocialNib @"SocialNib"

@interface PDUISettingsViewController ()

@end

@implementation PDUISettingsViewController

- (instancetype) initFromNib {
	NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
	if (self = [self initWithNibName:@"PDUISettingsViewController" bundle:podBundle]) {
		self.view.backgroundColor = [UIColor clearColor];
		return self;
	}
	return nil;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self registerNibs];
	self.tableView.tableHeaderView = _tableHeaderView;
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	[self.tableHeaderNameLabel setFont:PopdeemFont(PDThemeFontBold, 17)];
	[self.tableHeaderImageView.layer setCornerRadius:self.tableHeaderImageView.frame.size.width/2];
	[self.tableHeaderImageView setClipsToBounds:YES];
	[self setupHeaderView];
	[self.tableView reloadData];
	// Do any additional setup after loading the view from its nib.
}

- (void) viewDidAppear:(BOOL)animated {
	AbraLogEvent(ABRA_EVENT_VIEWED_SETTINGS, nil);
}

- (void) registerNibs {
	NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
	UINib *socialNib = [UINib nibWithNibName:@"PDUISocialSettingsTableViewCell" bundle:podBundle];
	[self.tableView registerNib:socialNib forCellReuseIdentifier:kSocialNib];
}

- (void) setupHeaderView {
	NSString *pictureUrl = [[[PDUser sharedInstance] facebookParams] profilePictureUrl];
	NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:pictureUrl]];
	UIImage *profileImage = [UIImage imageWithData:imageData];
	if (profileImage != nil) {
		[self.tableHeaderImageView setImage:profileImage];
	}
	NSString *userName = [NSString stringWithFormat:@"%@ %@",[[PDUser sharedInstance] firstName],[[PDUser sharedInstance] lastName]];
	[self.tableHeaderNameLabel setText:userName];
	[self.tableHeaderView setBackgroundColor:PopdeemColor(PDThemeColorPrimaryApp)];
	[self.tableHeaderNameLabel setTextColor:PopdeemColor(PDThemeColorPrimaryInverse)];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Table View Data Source -
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	switch (section) {
  case 0:
			return 3;
			break;
			
  default:
			return 0;
			break;
	}
	return 0;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
  case 0:
			return @"Social Networks";
			break;
  default:
			return @"Error";
			break;
	}
	return @"";
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	PDUISocialSettingsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kSocialNib];
	switch (indexPath.row) {
  case 0:
			[cell setSocialNetwork:PDSocialMediaTypeFacebook];
			break;
		case 1:
			[cell setSocialNetwork:PDSocialMediaTypeTwitter];
			break;
		case 2:
			[cell setSocialNetwork:PDSocialMediaTypeInstagram];
			break;
  default:
			break;
	}
	[cell setParent:self];
	return cell;
}

- (void) connectFacebookAccount {
	PDUIFBLoginWithWritePermsViewController *fbVC = [[PDUIFBLoginWithWritePermsViewController alloc] initForParent:self.navigationController
																																																			 loginType:PDFacebookLoginTypeRead];
	if (!fbVC) {
		return;
	}
	self.definesPresentationContext = YES;
	fbVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
	fbVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLoginSuccess) name:FacebookLoginSuccess object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLoginFailure) name:FacebookLoginFailure object:nil];
	[self presentViewController:fbVC animated:YES completion:^(void){}];
}

- (void) disconnectFacebookAccount {
	PDSocialMediaManager *man = [PDSocialMediaManager manager];
	[man logoutFacebook];
	PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	[cell.socialSwitch setOn:NO animated:NO];
	AbraLogEvent(ABRA_EVENT_LOGOUT, (@{
																	ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_FACEBOOK,
																	ABRA_PROPERTYNAME_SOURCE_PAGE : @"Settings"
																	}));
}

- (void) connectTwitterAccount {
	PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	[cell.socialSwitch setOn:NO animated:NO];
	PDUITwitterLoginViewController *twitterVC = [[PDUITwitterLoginViewController alloc] initForParent:self.navigationController];
	if (!twitterVC) {
		return;
	}
	self.definesPresentationContext = YES;
	twitterVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
	twitterVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(twitterLoginSuccess) name:TwitterLoginSuccess object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(twitterLoginFailure) name:TwitterLoginFailure object:nil];
	[self.navigationController presentViewController:twitterVC animated:YES completion:^(void){
	}];
}

- (void) disconnectTwitterAccount {
	PDSocialAPIService *socialService = [[PDSocialAPIService alloc] init];
	[socialService disconnectTwitterAccountWithCompletion:^(NSError *err){
		
	}];
	AbraLogEvent(ABRA_EVENT_DISCONNECT_SOCIAL_ACCOUNT, (@{
																												ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_TWITTER,
																												ABRA_PROPERTYNAME_SOURCE_PAGE : @"Settings"
																												}));
}

- (void) connectInstagramAccount {
	PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
	[cell.socialSwitch setOn:NO animated:NO];
	
	dispatch_async(dispatch_get_main_queue(), ^{
		PDUIInstagramLoginViewController *instaVC = [[PDUIInstagramLoginViewController alloc] initForParent:self.navigationController delegate:self];
		if (!instaVC) {
			return;
		}
		self.definesPresentationContext = YES;
		instaVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
		instaVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginSuccess) name:InstagramLoginSuccess object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginFailure) name:InstagramLoginFailure object:nil];
		[self.navigationController presentViewController:instaVC animated:YES completion:^(void){
		}];
	});
}

- (void) connectInstagramAccount:(NSString*)identifier accessToken:(NSString*)accessToken userName:(NSString*)userName {
	PDAPIClient *client = [PDAPIClient sharedInstance];
	[client connectInstagramAccount:identifier accessToken:accessToken screenName:userName success:^(void){
		PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
		[cell.socialSwitch setOn:YES animated:YES];
	} failure:^(NSError* error){
		PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
		[cell.socialSwitch setOn:NO animated:NO];
	}];
}

- (void) facebookLoginSuccess {
	PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
	dispatch_async(dispatch_get_main_queue(), ^{
		[cell.socialSwitch setOn:YES animated:YES];
		[_tableView reloadInputViews];
	});
	AbraLogEvent(ABRA_EVENT_CONNECTED_ACCOUNT, (@{
																								ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_FACEBOOK,
																								ABRA_PROPERTYNAME_SOURCE_PAGE : @"Settings"
																								}));
}

- (void) facebookLoginFailure {
	PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
	dispatch_async(dispatch_get_main_queue(), ^{
		[cell.socialSwitch setOn:NO animated:YES];
		[_tableView reloadInputViews];
	});
}

- (void) instagramLoginSuccess {
	PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
	dispatch_async(dispatch_get_main_queue(), ^{
		[cell.socialSwitch setOn:YES animated:YES];
		[_tableView reloadInputViews];
	});
	AbraLogEvent(ABRA_EVENT_CONNECTED_ACCOUNT, (@{
																								ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_INSTAGRAM,
																								ABRA_PROPERTYNAME_SOURCE_PAGE : @"Settings"
																								}));
}

- (void) instagramLoginFailure {
	PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
	dispatch_async(dispatch_get_main_queue(), ^{
		[cell.socialSwitch setOn:NO animated:YES];
		[_tableView reloadInputViews];
	});
}

- (void) twitterLoginSuccess {
	__block PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
	dispatch_async(dispatch_get_main_queue(), ^{
		[cell.socialSwitch setOn:YES animated:YES];
		[_tableView reloadInputViews];
	});
	AbraLogEvent(ABRA_EVENT_CONNECTED_ACCOUNT, (@{
																								ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_TWITTER,
																								ABRA_PROPERTYNAME_SOURCE_PAGE : @"Settings"
																								}));
}

- (void) twitterLoginFailure {
	PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
	dispatch_async(dispatch_get_main_queue(), ^{
		[cell.socialSwitch setOn:NO animated:YES];
		[_tableView reloadInputViews];
	});
}

- (void) disconnectInstagramAccount {
	PDSocialAPIService *socialService = [[PDSocialAPIService alloc] init];
	[socialService disconnectInstagramAccountWithCompletion:^(NSError *err){
		
	}];
	AbraLogEvent(ABRA_EVENT_DISCONNECT_SOCIAL_ACCOUNT, (@{
																												ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_INSTAGRAM,
																												ABRA_PROPERTYNAME_SOURCE_PAGE : @"Settings"
																												}));
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
