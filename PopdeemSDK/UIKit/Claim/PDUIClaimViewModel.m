//
//  PDClaimViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 26/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <FBSDKLoginKit/FBSDKLoginManager.h>
#import "PDUIClaimViewModel.h"
#import "PDUIClaimViewController.h"
#import "PDUser.h"
#import "PDSocialMediaFriend.h"
#import "PDSocialMediaManager.h"
#import "PDUIModalLoadingView.h"
#import "PDAPIClient.h"
#import "PDUtils.h"
#import "PDTheme.h"
#import "PDUIInstagramLoginViewController.h"
#import "PDUIInstagramShareViewController.h"

@interface PDUIClaimViewModel()
@property (nonatomic) BOOL mustTweet;
@property (nonatomic) BOOL mustInstagram;

@property (nonatomic, strong) PDUIModalLoadingView *loadingView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIWindow *alertWindow;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) BOOL hashtagValidated;
@property (nonatomic) BOOL tvSurpress;
@property (nonatomic) BOOL didAddPhoto;
@end

@implementation PDUIClaimViewModel

- (instancetype) init {
	if (self = [super init]) {
		return self;
	}
	return nil;
}

- (instancetype) initWithMediaTypes:(NSArray*)mediaTypes andReward:(PDReward*)reward location:(PDLocation*)location controller:(UIViewController*)controller {
	self = [self init];
	if (!self) return nil;
	_location = location;
	_viewController = controller;
	if (mediaTypes.count == 1 && [[mediaTypes objectAtIndex:0]  isEqualToNumber: @(PDSocialMediaTypeFacebook)]) {
		//Show only facebook button
		self.socialMediaTypesAvailable = FacebookOnly;
		_willFacebook = YES;
		_mustFacebook = YES;
//		[_viewController.instagramSwitch setEnabled:NO];
		[_viewController.facebookSwitch setOn:YES animated:YES];
	} else if (mediaTypes.count == 1 && [[mediaTypes objectAtIndex:0] isEqualToNumber:@(PDSocialMediaTypeTwitter)]) {
		//Show only Twitter button
		self.socialMediaTypesAvailable = TwitterOnly;
		_mustTweet = YES;
		_willTweet = YES;
		[_viewController.twitterSwitch setOn:YES];
//		[_viewController.instagramSwitch setEnabled:NO];
	} else if (mediaTypes.count == 1 && [[mediaTypes objectAtIndex:0]  isEqualToNumber: @(PDSocialMediaTypeInstagram)]) {
		self.socialMediaTypesAvailable = InstagramOnly;
		_mustInstagram = YES;
		[_viewController.facebookSwitch setEnabled:NO];
		[_viewController.twitterSwitch setEnabled:NO];
	} else if (mediaTypes.count == 2) {
		//Show two buttons
		self.socialMediaTypesAvailable = FacebookAndTwitter;
		_willFacebook = YES;
		_mustTweet = NO;
		_mustFacebook = NO;
		[_viewController.facebookSwitch setOn:YES];
		[_viewController.twitterSwitch setOn:NO];
	} else {
		//too many or not enough
	}
	
	[self setupForReward:reward];
	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(keyboardWillShow:)
																							 name:UIKeyboardWillShowNotification object:nil];
	return self;
}

- (void) setupForReward:(PDReward*)reward {
	_reward = reward;
	_textviewPlaceholder = translationForKey(@"popdeem.claim.text.placeholder", @"What are you up to?");
	
	if (_reward.twitterPrefilledMessage) {
		_textviewPrepopulatedString = _reward.twitterPrefilledMessage;
	}
	if (_reward.twitterForcedTag) {
		_forcedTagString = [NSString stringWithFormat:@"%@ Required",_reward.twitterForcedTag];
		[_viewController.twitterForcedTagLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
	}
}

- (NSString*) actionText {
	NSString *action;
	NSArray *types = _reward.socialMediaTypes;
	if (types.count > 0) {
		if (types.count > 1) {
			//Both Networks
			switch (_reward.action) {
				case PDRewardActionCheckin:
					action = translationForKey(@"popdeem.claim.action.tweet.checkin", @"Check-in or Tweet Required");
					break;
				case PDRewardActionPhoto:
					action = translationForKey(@"popdeem.claim.action.photo", @"Photo Required");
					break;
				case PDRewardActionNone:
					action = translationForKey(@"popdeem.claim.action.none", @"No Action Required");
					break;
				default:
					action = translationForKey(@"popdeem.claim.action.none", @"No Action Required");
					break;
			}
		} else if ([types[0] isEqualToNumber:@(PDSocialMediaTypeFacebook)]) {
			//Facebook Only
			switch (_reward.action) {
				case PDRewardActionCheckin:
					action = translationForKey(@"popdeem.claim.action.checkin", @"Check-In required");
					break;
				case PDRewardActionPhoto:
					action = translationForKey(@"popdeem.claim.action.photo", @"Photo Required");
					break;
				case PDRewardActionNone:
					action = translationForKey(@"popdeem.claim.action.none", @"No Action Required");
					break;
				default:
					action = translationForKey(@"popdeem.claim.action.none", @"No Action Required");
					break;
			}
		} else if ([types[0] isEqualToNumber:@(PDSocialMediaTypeTwitter)]) {
			//Twitter Only
			switch (_reward.action) {
				case PDRewardActionCheckin:
					action = translationForKey(@"popdeem.claim.action.tweet", @"Tweet Required");
					break;
				case PDRewardActionPhoto:
					action = translationForKey(@"popdeem.claim.action.tweet.photo", @"Tweet with Photo Required");
					break;
				case PDRewardActionNone:
					action = translationForKey(@"popdeem.claim.action.none", @"No Action Required");
					break;
				default:
					action = translationForKey(@"popdeem.claim.action.none", @"No Action Required");
					break;
			}
		}
	} else if (types.count == 0) {
		switch (_reward.action) {
			case PDRewardActionCheckin:
				action = translationForKey(@"popdeem.claim.action.checkin", @"Check-In required");
				break;
			case PDRewardActionPhoto:
				action = translationForKey(@"popdeem.claim.action.photo", @"Photo Required");
				break;
			case PDRewardActionNone:
				action = translationForKey(@"popdeem.claim.action.none", @"No Action Required");
				break;
			default:
				action = translationForKey(@"popdeem.claim.action.none", @"No Action Required");
				break;
		}
	}
	return action;
}

- (void) toggleFacebook {
	if (_mustFacebook) {
		[_viewController.facebookSwitch setOn:YES animated:NO];
		_willFacebook = YES;
		UIAlertView *fbV = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.claim.reward.cant.deselect", @"Cannot deselect") message:@"This reward must be claimed with a Facebook post. You can also post to Twitter if you wish" delegate:self cancelButtonTitle:translationForKey(@"common.ok", @"OK") otherButtonTitles:nil];
		[fbV show];
		return;
	}
	
	_willFacebook = _viewController.facebookSwitch.isOn;
	
	if (!_willFacebook) {
		return;
	}
	
	if ([[PDSocialMediaManager manager] isLoggedInWithFacebook]) {
		_willFacebook = YES;
	} else {
		[self loginWithReadAndWritePerms];
	}
}

- (void) toggleTwitter {
	if (_mustTweet) {
		_willTweet = YES;
		[_viewController.twitterSwitch setOn:YES animated:NO];
		UIAlertView *twitterV = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.claim.reward.cant.deselect", @"Cannot deselect") message:translationForKey(@"popdeem.claim.connect.message", @"This reward must be claimed with a tweet. You can also post to Facebook if you wish") delegate:self cancelButtonTitle:translationForKey(@"popdeem.common.ok", @"OK") otherButtonTitles:nil];
		[twitterV show];
		[self validateHashTag];
		return;
	}
	
	if (_willTweet) {
		_willTweet = NO;
		[_viewController.twitterForcedTagLabel setHidden:YES];
		[_viewController.twitterCharacterCountLabel setHidden:YES];
		[_viewController.twitterButton setSelected:NO];
		[self validateHashTag];
		return;
	}
	
	_willTweet = YES;
	[_viewController.twitterButton setSelected:YES];
	[_viewController.twitterForcedTagLabel setHidden:NO];
	if (_forcedTagString) {
		[_viewController.twitterForcedTagLabel setText:_forcedTagString];
	}
	[_viewController.twitterCharacterCountLabel setHidden:NO];
	[self calculateTwitterCharsLeft];
	[self validateHashTag];
}

- (void) instagramSwitchToggled:(UISwitch*)instagramSwitch {
	if (!instagramSwitch.isOn) {
		_willInstagram = NO;
		[_viewController.twitterForcedTagLabel setHidden:YES];
		return;
	}
	PDSocialMediaManager *manager = [PDSocialMediaManager manager];
	[manager isLoggedInWithInstagram:^(BOOL isLoggedIn){
		if (!isLoggedIn) {
			[instagramSwitch setOn:NO animated:NO];
			dispatch_async(dispatch_get_main_queue(), ^{
				PDUIInstagramLoginViewController *instaVC = [[PDUIInstagramLoginViewController alloc] initForParent:_viewController.navigationController];
				_viewController.definesPresentationContext = YES;
				instaVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
				[_viewController presentViewController:instaVC animated:YES completion:^(void){}];
			});
		}
	}];
	
	[_viewController.twitterForcedTagLabel setHidden:NO];
	if (_reward.instagramForcedTag) {
		_forcedTagString = _reward.instagramForcedTag;
		[_viewController.twitterForcedTagLabel setText:[NSString stringWithFormat:@"%@ Required",_reward.instagramForcedTag]];
		[self validateHashTag];
	}
	
	_willInstagram = instagramSwitch.isOn;
}

- (void) addPhotoAction {
	[self showPhotoActionSheet];
}

- (void) calculateTwitterCharsLeft {
	//Build the string
	NSString *endString = [NSString stringWithString:_viewController.textView.text];
	if (_reward.twitterForcedTag) {
		endString = [endString stringByAppendingString:[NSString stringWithFormat:@" %@",_reward.twitterForcedTag]];
	}
	NSString *sampleMediaString = @"";
	for (int i = 0 ; i < _reward.twitterMediaLength ; i++) {
		sampleMediaString = [sampleMediaString stringByAppendingString:@" "];
	}
	
	//All rewards have a download link now, so deduct this media string length
	endString = [endString stringByAppendingString:[NSString stringWithFormat:@" %@",sampleMediaString]];
	
	if (_rewardImage) {
		endString = [endString stringByAppendingString:[NSString stringWithFormat:@" %@",sampleMediaString]];
	}
	
	int charsLeft = 140 - (int)endString.length;
	
	if (charsLeft < 1) {
		[_viewController.twitterCharacterCountLabel setTextColor:[UIColor redColor]];
	} else {
		[_viewController.twitterCharacterCountLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
	}
	
	[_viewController.twitterCharacterCountLabel setText:[NSString stringWithFormat:@"%d",charsLeft]];
}

- (void) keyboardWillShow:(NSNotification*)notification {
	[UIView animateWithDuration:2.0
												delay:0.0
											options: UIViewAnimationOptionCurveEaseInOut
									 animations:^{
										 [_viewController keyboardUp];
									 } completion:^(BOOL finished){}];
	
	[self.viewController.view setNeedsLayout];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Claiming -

- (void) claimAction {
	if (_willInstagram) {
		if (!_image) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo Required"
																											message:@"A photo is required for this action. Please add a photo"
																										 delegate:self
																						cancelButtonTitle:@"OK"
																						otherButtonTitles:nil];
			[alert setTag:1];
			[alert show];
			[_viewController.claimButtonView setUserInteractionEnabled:YES];
			return;
		}
		if (_reward.instagramForcedTag && !_hashtagValidated) {
				UIAlertView *hashAV = [[UIAlertView alloc] initWithTitle:@"Oops!" message:[NSString stringWithFormat:@"Looks like you have forgotten to add the required hashtag %@, please add this to your message before posting to Twitter",_reward.twitterForcedTag] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[hashAV show];
				[_viewController.claimButtonView setUserInteractionEnabled:YES];
				return;
		}
		[self makeClaim];
		return;
	}
	if (!_locationVerified) {
		
	}
	
	if (_reward.action == PDRewardActionPhoto && _image == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo Required"
																										message:@"A photo is required for this action. Please add a photo"
																									 delegate:self
																					cancelButtonTitle:@"OK"
																					otherButtonTitles:nil];
		[alert setTag:1];
		[alert show];
		[_viewController.claimButtonView setUserInteractionEnabled:YES];
		return;
	}
	
	if (!_willTweet && !_willFacebook) {
		UIAlertView *noPost = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.error", @"Error") message:translationForKey(@"popdeem.claim.networkerror",  @"No Network Selected, you must select at least one social network in order to complete this action.") delegate:self cancelButtonTitle:translationForKey(@"popdeem.common.ok", @"OK") otherButtonTitles:nil];
		[noPost show];
		[_viewController.claimButtonView setUserInteractionEnabled:YES];
		return;
	}
	
	if (_willTweet) {
		__weak PDUIModalLoadingView *twView = [[PDUIModalLoadingView alloc] initForView:self.viewController.view titleText:translationForKey(@"popdeem.common.wait", @"Please wait") descriptionText:translationForKey(@"popdeem.claim.twitter.check", @"Checking Credentials")];
  [twView showAnimated:YES];
		if (_forcedTagString && !_hashtagValidated) {
			UIAlertView *hashAV = [[UIAlertView alloc] initWithTitle:@"Oops!" message:[NSString stringWithFormat:@"Looks like you have forgotten to add the required hashtag %@, please add this to your message before posting to Twitter",_reward.twitterForcedTag] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[hashAV show];
			[_viewController.claimButtonView setUserInteractionEnabled:YES];
			return;
		}
		[[PDSocialMediaManager manager] verifyTwitterCredentialsCompletion:^(BOOL connected, NSError *error) {
			[twView hideAnimated:YES];
			if (!connected) {
				[self connectTwitter:^(){
					[self makeClaim];
					[_viewController.claimButtonView setUserInteractionEnabled:YES];
				} failure:^(NSError *error) {
					UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.error", @"Error") message:translationForKey(@"popdeem.claim.twitter.notconnected", @"Twitter not connected, you must connect your twitter account in order to post to Twitter") delegate:self cancelButtonTitle:translationForKey(@"popdeem.common.back", @"Back") otherButtonTitles: nil];
					[av show];
				}];
				[_viewController.claimButtonView setUserInteractionEnabled:YES];
				return;
			}
			if (_viewController.twitterCharacterCountLabel.text.integerValue < 0) {
				UIAlertView *tooMany = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.error", @"Error") message:translationForKey(@"popdeem.claim.tweet.toolong", @"Tweet too long, you have written a post longer than the allowed 140 characters. Please shorten your post.") delegate:self cancelButtonTitle:translationForKey(@"popdeem.common.back", @"Back") otherButtonTitles: nil];
				[tooMany setTag:2];
				[tooMany show];
				[_viewController.claimButtonView setUserInteractionEnabled:YES];
				return;
			}
			[self makeClaim];
			[_viewController.claimButtonView setUserInteractionEnabled:YES];
		}];
		return;
	}
	if ([_viewController.textView isFirstResponder]) {
		[_viewController.textView resignFirstResponder];
	}
	[_viewController.claimButtonView setUserInteractionEnabled:YES];
	[self makeClaim];
}

- (void) textViewDidChange:(UITextView *)textView {
	[self calculateTwitterCharsLeft];
	if (_willTweet && !_tvSurpress) {
		[self validateHashTag];
	}
	if (_willInstagram && !_tvSurpress) {
		[self validateHashTag];
	}
	_tvSurpress = NO;
}

- (void) validateHashTag {
	_hashtagValidated = NO;
	if (!_forcedTagString) {
		_hashtagValidated = YES;
		return;
	}
	
	NSString *searchString = @"";
	if (_willTweet) {
		searchString = _reward.twitterForcedTag;
	}
	if (_willInstagram) {
		searchString = _reward.instagramForcedTag;
	}

	if ([_viewController.textView.text.lowercaseString rangeOfString:searchString.lowercaseString].location != NSNotFound && (_willTweet || _willInstagram)) {
		_hashtagValidated = YES;
		_tvSurpress = YES;
		NSRange hashRange = [_viewController.textView.text.lowercaseString rangeOfString:searchString.lowercaseString];
		NSMutableAttributedString *mutString = [[NSMutableAttributedString alloc] initWithString:_viewController.textView.text];
		[mutString addAttribute:NSBackgroundColorAttributeName value:PopdeemColor(@"popdeem.colors.primaryAppColor") range:hashRange];
		[mutString addAttribute:NSForegroundColorAttributeName value:PopdeemColor(@"popdeem.colors.primaryInverseColor") range:hashRange];
		[mutString addAttribute:NSFontAttributeName value:PopdeemFont(@"popdeem.fonts.primaryFont", 14) range:NSMakeRange(0, mutString.length)];
		[_viewController.textView setAttributedText:mutString];
	} else {
		NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_viewController.textView.text];
		_tvSurpress = YES;
		[string setAttributes:@{} range:NSMakeRange(0, string.length)];
		[string addAttribute:NSFontAttributeName value:PopdeemFont(@"popdeem.fonts.primaryFont", 14) range:NSMakeRange(0, string.length)];
		[_viewController.textView setAttributedText:string];
	}
}

- (void) makeClaim {
	
	if (_reward.action == PDRewardActionPhoto && _image == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo Required"
																										message:@"A photo is required for this action. Please add a photo"
																									 delegate:self
																					cancelButtonTitle:@"OK"
																					otherButtonTitles:nil];
		[alert setTag:1];
		[alert show];
		return;
	}
	
	if (!_willInstagram) {
		if (![[PDSocialMediaManager manager] isLoggedInWithFacebook]) {
			[self loginWithReadAndWritePerms];
			return;
		}
		if (![[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
			[self loginWithWritePerms];
			return;
		}
	}
	
	PDAPIClient *client = [PDAPIClient sharedInstance];
	NSString *message = [_viewController.textView text];
	
	NSMutableArray *taggedFriends = [NSMutableArray array];
	for (PDSocialMediaFriend *f in [PDUser taggableFriends]) {
		if (f.selected) {
			[taggedFriends addObject:f.tagIdentifier];
		}
	}
	
	__block NSInteger rewardId = _reward.identifier;
	//location?
	[client claimReward:_reward.identifier location:_location withMessage:message taggedFriends:taggedFriends image:_image facebook:_willFacebook twitter:_willTweet instagram:_willInstagram success:^(){
		if (_willInstagram) {
			[_loadingView hideAnimated:YES];
			PDUIInstagramShareViewController *isv = [[PDUIInstagramShareViewController alloc] initForParent:_viewController.navigationController withMessage:_viewController.textView.text image:_image];
			_viewController.definesPresentationContext = YES;
			isv.modalPresentationStyle = UIModalPresentationOverFullScreen;
			[_viewController presentViewController:isv animated:YES completion:^(void){}];
		} else {
			[self didClaimRewardId:rewardId];
		}
	} failure:^(NSError *error){
		[self PDAPIClient:client didFailWithError:error];
	}];
	
	_loadingView = [[PDUIModalLoadingView alloc] initForView:self.viewController.view titleText:translationForKey(@"popdeem.claim.reward.claiming", @"Claiming Reward") descriptionText:translationForKey(@"popdeem.claim.reward.claiming.message", @"This could take up to 30 seconds")];
	[_loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
	[_loadingView showAnimated:YES];
}

- (void) loginWithReadAndWritePerms {
	[[PDSocialMediaManager manager] loginWithFacebookReadPermissions:@[@"public_profile", @"email", @"user_birthday", @"user_posts", @"user_friends", @"user_education_history"] registerWithPopdeem:YES success:^(void) {
		_willFacebook = YES;
		[_viewController.facebookButton setSelected:YES];
		[self loginWithWritePerms];
	} failure:^(NSError *error) {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.sorry", @"Sorry") message:translationForKey(@"popdeem.claim.facebook.connect", @"We couldnt connect you to Facebook") delegate:nil cancelButtonTitle:nil otherButtonTitles:translationForKey(@"popdeem.common.ok", @"OK"), nil];
		[av show];
		_willFacebook = NO;
		[_viewController.facebookButton setSelected:NO];
	}];
}

- (void) loginWithWritePerms {
	FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
	[loginManager logInWithPublishPermissions:@[@"publish_actions"] fromViewController:self.viewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
		if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
			[[[PDUser sharedInstance] facebookParams] setAccessToken:[[FBSDKAccessToken currentAccessToken] tokenString]];
			[self makeClaim];
		} else {
			UIAlertView *noperm = [[UIAlertView alloc] initWithTitle:@"Invalid Permissions" message:@"You must grant publish permissions in order to make this action" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[noperm show];
		}
	}];
}

- (void) didClaimRewardId:(NSInteger)rewardId {
	
	[_loadingView hideAnimated:YES];
	
	[PDRewardStore deleteReward:_reward.identifier];
	
	_viewController.homeController.didClaim = YES;
	
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.claim.reward.claimed", @"Reward Claimed!") message:translationForKey(@"popdeem.claim.reward.success", @"You can view your reward in your wallet") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[av setTag:9];
	[av show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 9) {
		[self.viewController.navigationController popViewControllerAnimated:YES];
	}
}


- (void) PDAPIClient:(PDAPIClient *)client didFailWithError:(NSError *)error {
	NSLog(@"Error: %@",error);
	[_loadingView hideAnimated:YES];
	[_viewController.claimButtonView setUserInteractionEnabled:YES];
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.sorry", @"Sorry") message:translationForKey(@"popdeem.common.something.wrong", @"Something went wrong. Please try again later") delegate:self cancelButtonTitle:translationForKey(@"common.back", @"Back") otherButtonTitles:nil];
	[av show];
}

#pragma mark - Connecting Twitter -
- (void) connectTwitter:(void (^)(void))success failure:(void (^)(NSError *failure))failure {
	PDSocialMediaManager *manager = [[PDSocialMediaManager alloc] initForViewController:_viewController];
	
	_loadingView = [[PDUIModalLoadingView alloc] initForView:self.viewController.view titleText:translationForKey(@"popdeem.common.wait", @"Please wait") descriptionText:translationForKey(@"popdeem.claim.twitter.connect", @"Connecting Twitter")];
	[_loadingView showAnimated:YES];
	
	[manager loginWithTwitter:^(void){
		//Twitter is logged in
		[_viewController.twitterButton setImage:[UIImage imageNamed:@"Twitter"] forState:UIControlStateNormal];
		_willTweet = YES;
		[_viewController.twitterButton setImage:[UIImage imageNamed:@"twitterSelected"] forState:UIControlStateNormal];
		[_loadingView hideAnimated:YES];
		[self calculateTwitterCharsLeft];
		[_viewController.facebookButton setEnabled:NO];
		[_viewController.withLabel setHidden:YES];
		success();
	} failure:^(NSError *error) {
		//Some error
		NSLog(@"Twitter didnt log in: %@",error);
		if (!_mustTweet) {
			_willTweet = NO;
			[_viewController.twitterButton setImage:[UIImage imageNamed:@"twitterDeselected"] forState:UIControlStateNormal];
		}
		[_loadingView hideAnimated:YES];
		failure(error);
	}];
}

#pragma mark - Adding Photo -

- (void) showPhotoActionSheet {
	_alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	_alertWindow.rootViewController = [UIViewController new];
	_alertWindow.windowLevel = 10000001;
	_alertWindow.hidden = NO;
	
	__weak __typeof(self) weakSelf = self;
	
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Alert" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
	[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
		weakSelf.alertWindow.hidden = YES;
		weakSelf.alertWindow = nil;
	}]];
	[alert addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		weakSelf.alertWindow.hidden = YES;
		weakSelf.alertWindow = nil;
		[weakSelf takePhoto];
		if ([_viewController.textView isFirstResponder]) {
			[_viewController.textView resignFirstResponder];
		}
	}]];
	[alert addAction:[UIAlertAction actionWithTitle:@"Camera Roll" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
		weakSelf.alertWindow.hidden = YES;
		weakSelf.alertWindow = nil;
		[weakSelf selectPhoto];
		if ([_viewController.textView isFirstResponder]) {
			[_viewController.textView resignFirstResponder];
		}
	}]];
	
	[_alertWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)takePhoto {
	
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = _viewController;
	picker.allowsEditing = NO;
	picker.sourceType = UIImagePickerControllerSourceTypeCamera;
	picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
	picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[_viewController presentViewController:picker animated:YES completion:NULL];
	
}

- (void)selectPhoto {
	
	UIImagePickerController *picker = [[UIImagePickerController alloc] init];
	picker.delegate = _viewController;
	picker.allowsEditing = YES;
	picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
	picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
	picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[_viewController presentViewController:picker animated:YES completion:NULL];
	
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0) {
		
	}
	
	if (!_imageView) {
		_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(_viewController.textView.frame.size.width-70, 10, 60, 60)];
		[_viewController.textView addSubview:_imageView];
		[_imageView setClipsToBounds:YES];
		[_imageView setContentMode:UIViewContentModeScaleAspectFill];
		[_imageView setHidden:YES];
		UITapGestureRecognizer *imageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhotoActionSheet)];
		[_imageView addGestureRecognizer:imageTap];
		[_imageView setUserInteractionEnabled:YES];
	}
	
	UIImage *img = info[UIImagePickerControllerOriginalImage];
	
	_image = [self resizeImage:img withMinDimension:480];
	_imageView.image = img;
	_imageView.contentMode = UIViewContentModeScaleAspectFit;
	_imageView.backgroundColor = [UIColor blackColor];
	_imageView.layer.masksToBounds = YES;
	_imageView.layer.shadowColor = [UIColor colorWithRed:0.831 green:0.831 blue:0.831 alpha:1.000].CGColor;
	_imageView.layer.shadowOpacity = 0.9;
	_imageView.layer.shadowRadius = 1.0;
	_imageView.clipsToBounds = YES;
	_imageView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
	_imageView.layer.borderWidth = 2.0f;
	[_imageView setHidden:NO];
	[picker dismissViewControllerAnimated:YES completion:NULL];
	
	_didAddPhoto = YES;
	
	[UIView animateWithDuration:0.5
												delay:1.0
											options: UIViewAnimationOptionCurveEaseInOut
									 animations:^{
										 [_viewController.textView setTextContainerInset:UIEdgeInsetsMake(10, 8, 10, 70)];
									 }
									 completion:^(BOOL finished){
									 }];
	
	[_viewController.textView becomeFirstResponder];
	
	[self calculateTwitterCharsLeft];
}

- (UIImage *)resizeImage:(UIImage *)inImage
				withMinDimension:(CGFloat)minDimension
{
	
	CGFloat aspect = inImage.size.width / inImage.size.height;
	CGSize newSize;
	
	if (inImage.size.width > inImage.size.height) {
		newSize = CGSizeMake(minDimension*aspect, minDimension);
	} else {
		newSize = CGSizeMake(minDimension, minDimension/aspect);
	}
	
	UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
	CGRect newImageRect = CGRectMake(0.0, 0.0, newSize.width, newSize.height);
	[inImage drawInRect:newImageRect];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return newImage;
}

- (IBAction)taggedFriendsButtonPressed:(id)sender {
	
}

#pragma mark - instagram -


@end
