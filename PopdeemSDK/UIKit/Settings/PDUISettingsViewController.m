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
#import "PDUIModalLoadingView.h"
#import "PDUILogoutTableViewCell.h"

#define kSocialNib @"SocialNib"
#define kLogoutNib @"LogoutNib"

@interface PDUISettingsViewController ()
@property (nonatomic, retain) UIImageView *profileImageView;
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
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	[self.tableHeaderNameLabel setFont:PopdeemFont(PDThemeFontBold, 17)];
	[self.tableHeaderImageView.layer setCornerRadius:self.tableHeaderImageView.frame.size.width/2];
	[self.tableHeaderImageView setClipsToBounds:YES];
	[self.tableView reloadData];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
	// Do any additional setup after loading the view from its nib.
}

- (void) viewDidLayoutSubviews {
	[self setupHeaderView];
}

- (void) viewDidAppear:(BOOL)animated {
	AbraLogEvent(ABRA_EVENT_PAGE_VIEWED, @{ABRA_PROPERTYNAME_SOURCE_PAGE : ABRA_PROPERTYVALUE_PAGE_SETTINGS});
}

- (void) registerNibs {
	NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
	UINib *socialNib = [UINib nibWithNibName:@"PDUISocialSettingsTableViewCell" bundle:podBundle];
	UINib *logoutNib = [UINib nibWithNibName:@"PDUILogoutTableViewCell" bundle:podBundle];
	[self.tableView registerNib:socialNib forCellReuseIdentifier:kSocialNib];
	[self.tableView registerNib:logoutNib forCellReuseIdentifier:kLogoutNib];
}

- (void) setupHeaderView {
	self.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 140)];
	self.tableView.tableHeaderView = self.tableHeaderView;
	
	if (PopdeemThemeHasValueForKey(@"popdeem.images.homeHeaderImage")) {
		UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:self.tableHeaderView.frame];
		[bgImageView setHidden:NO];
		[bgImageView setImage:PopdeemImage(@"popdeem.images.homeHeaderImage")];
		[bgImageView setContentMode:UIViewContentModeScaleAspectFill];
		[bgImageView setClipsToBounds:YES];
		UIView *gradientView = [[UIView alloc] initWithFrame:bgImageView.frame];
		[gradientView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]];
		[self.tableHeaderView addSubview:bgImageView];
		[bgImageView addSubview:gradientView];
	}
	
	NSString *pictureUrl = [[[PDUser sharedInstance] facebookParams] profilePictureUrl];
	NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:pictureUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		if (data) {
			UIImage *image = [UIImage imageWithData:data];
			if (image) {
				dispatch_async(dispatch_get_main_queue(), ^{
					UIImage *profileImage = [UIImage imageWithData:data];
					[_profileImageView setImage:profileImage];
					[_profileImageView setHidden:NO];
					[self.view setNeedsDisplay];
				});
			}
		}
	}];
	[task resume];
	float centerx = self.view.frame.size.width/2;
	
	_profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(centerx-40, 20, 80, 80)];
	[_profileImageView setContentMode:UIViewContentModeScaleAspectFill];
	_profileImageView.layer.cornerRadius = 40;
	_profileImageView.layer.masksToBounds = YES;
	[self.tableHeaderView addSubview:_profileImageView];
	[_profileImageView setHidden:YES];


	NSString *userName = [NSString stringWithFormat:@"%@ %@",[[PDUser sharedInstance] firstName],[[PDUser sharedInstance] lastName]];
	UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 40)];
	[nameLabel setFont:PopdeemFont(PDThemeFontBold, 17)];
	[nameLabel setTextColor:[UIColor whiteColor]];
	[nameLabel setText:userName];
	[nameLabel setTextAlignment:NSTextAlignmentCenter];
	[self.tableHeaderView addSubview:nameLabel];
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
	case 1:
			return 1;
			break;
  default:
			return 0;
			break;
	}
	return 0;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	switch (section) {
  case 0:
			return @"Social Networks";
			break;
	case 1:
			return @"";
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
	PDUISocialSettingsTableViewCell *socialCell;
	PDUILogoutTableViewCell *logoutCell;
	switch (indexPath.section) {
		case 0:
			socialCell = [self.tableView dequeueReusableCellWithIdentifier:kSocialNib];
			switch (indexPath.row) {
				case 0:
					[socialCell setSocialNetwork:PDSocialMediaTypeFacebook];
					break;
				case 1:
					[socialCell setSocialNetwork:PDSocialMediaTypeTwitter];
					break;
				case 2:
					[socialCell setSocialNetwork:PDSocialMediaTypeInstagram];
					break;
				default:
					break;
			}
			[socialCell setParent:self];
			return socialCell;
			break;
		case 1:
			logoutCell = [self.tableView dequeueReusableCellWithIdentifier:kLogoutNib];
			[logoutCell setParent:self];
			PDSocialMediaManager *man = [PDSocialMediaManager manager];
//			if ([man isLoggedInWithFacebook]) {
//				[logoutCell.logoutButton setTitle:@"Log Out" forState:UIControlStateNormal];
//			} else {
//				[logoutCell.logoutButton setTitle:@"Log In" forState:UIControlStateNormal];
//			}
			return logoutCell;
			break;
	}
	return nil;
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

	UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		PDSocialAPIService *socialService = [[PDSocialAPIService alloc] init];
		[socialService disconnectTwitterAccountWithCompletion:^(NSError *err){
			
		}];
		AbraLogEvent(ABRA_EVENT_DISCONNECT_SOCIAL_ACCOUNT, (@{
																													ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_TWITTER,
																													ABRA_PROPERTYNAME_SOURCE_PAGE : @"Settings"
																													}));
	}];
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
		dispatch_async(dispatch_get_main_queue(), ^{
			[cell.socialSwitch setOn:NO];
			[_tableView reloadData];
		});
	}];
	UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Disconnect Twitter Account" message:@"This action will disconnect your Twitter account. Are you sure you wish to proceed?" preferredStyle:UIAlertControllerStyleAlert];
	[ac addAction:ok];
	[ac addAction:cancel];
	[self presentViewController:ac animated:YES completion:^{
	}];
}

- (void) connectInstagramAccount {
	PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
	
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
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginUserDismissed) name:InstagramLoginuserDismissed object:nil];
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
		[cell.socialSwitch setOn:NO];
		[_tableView reloadInputViews];
	});
}

- (void) instagramLoginSuccess {
	PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
	dispatch_async(dispatch_get_main_queue(), ^{
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
		[cell.socialSwitch setOn:NO];
		[_tableView reloadData];
	});
}

- (void) instagramLoginUserDismissed {
	PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
	dispatch_async(dispatch_get_main_queue(), ^{
		[cell.socialSwitch setOn:NO];
		[_tableView reloadData];
	});
}

- (void) twitterLoginSuccess {
	PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
	dispatch_async(dispatch_get_main_queue(), ^{
		[_tableView reloadData];
	});
	AbraLogEvent(ABRA_EVENT_CONNECTED_ACCOUNT, (@{
																								ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_TWITTER,
																								ABRA_PROPERTYNAME_SOURCE_PAGE : @"Settings"
																								}));
}

- (void) twitterLoginFailure {
	PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
	dispatch_async(dispatch_get_main_queue(), ^{
		[cell.socialSwitch setOn:NO];
		[_tableView reloadData];
	});
}

- (void) disconnectInstagramAccount {
	UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		PDSocialAPIService *socialService = [[PDSocialAPIService alloc] init];
		[socialService disconnectInstagramAccountWithCompletion:^(NSError *err){
			
		}];
		AbraLogEvent(ABRA_EVENT_DISCONNECT_SOCIAL_ACCOUNT, (@{
																													ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_INSTAGRAM,
																													ABRA_PROPERTYNAME_SOURCE_PAGE : @"Settings"
																													}));
	}];
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
		dispatch_async(dispatch_get_main_queue(), ^{
			[cell.socialSwitch setOn:NO];
			[_tableView reloadData];
		});
	}];
	UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Disconnect Instagram Account" message:@"This action will disconnect your Instagram account. Are you sure you wish to proceed?" preferredStyle:UIAlertControllerStyleAlert];
	[ac addAction:ok];
	[ac addAction:cancel];
	[self presentViewController:ac animated:YES completion:^{
	}];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) logoutUser {
	UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		PDSocialAPIService *socialService = [[PDSocialAPIService alloc] init];
		[socialService disconnectInstagramAccountWithCompletion:^(NSError *err){
			PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
			dispatch_async(dispatch_get_main_queue(), ^{
				[cell.socialSwitch setOn:NO];
				[_tableView reloadData];
			});
		}];
		[socialService disconnectTwitterAccountWithCompletion:^(NSError *err){
			PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
			dispatch_async(dispatch_get_main_queue(), ^{
				[cell.socialSwitch setOn:NO];
				[_tableView reloadData];
			});
		}];
		PDSocialMediaManager *man = [PDSocialMediaManager manager];
		[man logoutFacebook];
		PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
		[cell.socialSwitch setOn:NO animated:NO];
	}];
	UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
	}];
	UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Log out of app" message:@"This action will log you out and disconnect all connected social accounts. Are you sure you wish to proceed?" preferredStyle:UIAlertControllerStyleAlert];
	[ac addAction:ok];
	[ac addAction:cancel];
	[self presentViewController:ac animated:YES completion:^{
	}];
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
