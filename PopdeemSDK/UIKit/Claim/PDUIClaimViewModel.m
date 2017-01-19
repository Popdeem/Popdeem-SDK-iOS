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
#import "PDSocialMediaFriend.h"
#import "PDSocialMediaManager.h"
#import "PDAPIClient.h"
#import "PDUIInstagramShareViewController.h"
#import "PDUIFBLoginWithWritePermsViewController.h"
#import "UIImage+Resize.h"
#import "PDUITwitterLoginViewController.h"

@import Photos;

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

- (instancetype) initWithMediaTypes:(NSArray*)mediaTypes andReward:(PDReward*)reward location:(PDLocation*)location controller:(PDUIClaimViewController*)controller {
	self = [self init];
	if (!self) return nil;
	_location = location;
	_viewController = controller;
//	[self.viewController.instagramSwitch setHidden:YES];
//	[self.viewController.instagramIconView setHidden:YES];
	if (mediaTypes.count == 1) {
		if ([mediaTypes containsObject:@(PDSocialMediaTypeFacebook)]) {
			self.socialMediaTypesAvailable = FacebookOnly;
		}
		if ([mediaTypes containsObject:@(PDSocialMediaTypeTwitter)]) {
			self.socialMediaTypesAvailable = TwitterOnly;
		}
		if ([mediaTypes containsObject:@(PDSocialMediaTypeInstagram)]) {
			self.socialMediaTypesAvailable = InstagramOnly;
		}
	}
	if (mediaTypes.count == 2) {
		if ([mediaTypes containsObject:@(PDSocialMediaTypeFacebook)] && [mediaTypes containsObject:@(PDSocialMediaTypeTwitter)]) {
			self.socialMediaTypesAvailable = FacebookAndTwitter;
		}
		if ([mediaTypes containsObject:@(PDSocialMediaTypeTwitter)] && [mediaTypes containsObject:@(PDSocialMediaTypeInstagram)]) {
			self.socialMediaTypesAvailable = TwitterAndInstagram;
		}
		if ([mediaTypes containsObject:@(PDSocialMediaTypeFacebook)] && [mediaTypes containsObject:@(PDSocialMediaTypeInstagram)]) {
			self.socialMediaTypesAvailable = FacebookAndInstagram;
		}
	}
	if (mediaTypes.count == 3) {
		self.socialMediaTypesAvailable = Any;
	}
	
	[self setupForReward:reward];
	[self enableSwitches];
	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(keyboardWillShow:)
																							 name:UIKeyboardWillShowNotification object:nil];
	return self;
}

- (void) socialMediaTypesSetup {
	
}

- (void) enableSwitches {
	[_viewController.facebookSwitch setEnabled:[_reward.socialMediaTypes containsObject:@(PDSocialMediaTypeFacebook)]];
	[_viewController.twitterSwitch setEnabled:[_reward.socialMediaTypes containsObject:@(PDSocialMediaTypeTwitter)]];
	[_viewController.instagramSwitch setEnabled:[_reward.socialMediaTypes containsObject:@(PDSocialMediaTypeInstagram)]];
	
	NSString *facebookImage = ([_reward.socialMediaTypes containsObject:@(PDSocialMediaTypeFacebook)]) ? @"pduikit_fbbutton_selected.png" : @"pduikit_fbbutton_deselected.png";
	NSString *twitterImage = ([_reward.socialMediaTypes containsObject:@(PDSocialMediaTypeTwitter)]) ? @"pduikit_twitterbutton_selected.png" : @"pduikit_twitterbutton_deselected.png";
	NSString *instagramImage = ([_reward.socialMediaTypes containsObject:@(PDSocialMediaTypeInstagram)]) ? @"pduikit_instagrambutton_selected.png" : @"pduikit_instagrambutton_deselected.png";
	
	[_viewController.facebookIconView setImage:PopdeemImage(facebookImage)];
	[_viewController.twitterIconView setImage:PopdeemImage(twitterImage)];
	[_viewController.instagramIconView setImage:PopdeemImage(instagramImage)];
	
}

- (void) setupForReward:(PDReward*)reward {
	_reward = reward;
	_textviewPlaceholder = translationForKey(@"popdeem.claim.text.placeholder", @"What are you up to?");
	
	if (_reward.twitterPrefilledMessage) {
		_twitterPrefilledTextString = _reward.twitterPrefilledMessage;
	}
	
	if (_reward.twitterForcedTag) {
		_twitterForcedTagString = [NSString stringWithFormat:@"%@ Required",_reward.twitterForcedTag];
	}
	
	if (_reward.instagramPrefilledMessage) {
		_instagramPrefilledTextString = _reward.instagramPrefilledMessage;
	}
	
	if (_reward.instagramForcedTag) {
		_instagramForcedTagString = [NSString stringWithFormat:@"%@ Required",_reward.instagramForcedTag];
	}
	
	[_viewController.twitterForcedTagLabel setTextColor:PopdeemColor(PDThemeColorPrimaryApp)];
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
	if ([_viewController.facebookSwitch isOn]) {
		[_viewController.twitterSwitch setOn:NO animated:YES];
		_willTweet = NO;
		[_viewController.instagramSwitch setOn:NO animated:YES];
		_willInstagram = NO;
		[_viewController.twitterForcedTagLabel setHidden:YES];
		[_viewController.addHashtagButton setHidden:YES];
		[_viewController.twitterCharacterCountLabel setHidden:YES];
		if (![[PDSocialMediaManager manager] isLoggedInWithFacebook]) {
			[self loginWithReadAndWritePerms];
			return;
		}
	}
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
	
	if ([_viewController.twitterSwitch isOn]) {
		[_viewController.facebookSwitch setOn:NO animated:YES];
		_willFacebook = NO;
		[_viewController.instagramSwitch setOn:NO animated:YES];
		_willInstagram = NO;
		[self validateTwitter];
	}
	
	if (_willTweet) {
		_willTweet = NO;
		[_viewController.twitterForcedTagLabel setHidden:YES];
		[_viewController.addHashtagButton setHidden:YES];
		[_viewController.twitterCharacterCountLabel setHidden:YES];
		[_viewController.twitterButton setSelected:NO];
//		if ([_viewController.textView.text rangeOfString:_twitterPrefilledTextString].location != NSNotFound) {
//			NSMutableAttributedString *mstr = [_viewController.textView.attributedText mutableCopy];
//			[mstr replaceCharactersInRange:[_viewController.textView.text rangeOfString:_twitterPrefilledTextString] withString:@""];
//			if ([mstr.string rangeOfString:_twitterForcedTagString].location != NSNotFound) {
//				[mstr replaceCharactersInRange:[mstr.string rangeOfString:_twitterForcedTagString] withString:@""];
//			}
//			[_viewController.textView setAttributedText:mstr];
//		}
		[self validateHashTag];
		return;
	}
	
	_willTweet = YES;
	[_viewController.twitterButton setSelected:YES];
	[_viewController.twitterForcedTagLabel setHidden:NO];
	if (_reward.twitterForcedTag.length > 0) {
		[_viewController.addHashtagButton setHidden:NO];
	}
	
	if (_twitterForcedTagString) {
		[_viewController.twitterForcedTagLabel setText:_twitterForcedTagString];
	}
	if (_twitterPrefilledTextString) {
		if (_viewController.textView.text.length == 0) {
			[_viewController.textView setText:_twitterPrefilledTextString];
		}
	}
	[_viewController.twitterCharacterCountLabel setHidden:NO];
	[self calculateTwitterCharsLeft];
	[self validateHashTag];
}

- (void) instagramSwitchToggled:(UISwitch*)instagramSwitch {
	if (self.socialMediaTypesAvailable == FacebookOnly || self.socialMediaTypesAvailable == FacebookAndTwitter || self.socialMediaTypesAvailable == TwitterOnly) {
		UIAlertView *twitterV = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.claim.reward.instagram.unavailable.title", @"Instagram Unavailable") message:translationForKey(@"popdeem.claim.reward.instagram.unavailable.message", @"Instagram is not an available option to claim this reward.") delegate:self cancelButtonTitle:translationForKey(@"popdeem.common.ok", @"OK") otherButtonTitles:nil];
		[twitterV show];
		return;
	}
	if (!instagramSwitch.isOn) {
		_willInstagram = NO;
		[_viewController.twitterForcedTagLabel setHidden:YES];
		[_viewController.addHashtagButton setHidden:YES];
//		if ([_viewController.textView.text rangeOfString:_instagramPrefilledTextString].location != NSNotFound) {
//			NSMutableAttributedString *mstr = [_viewController.textView.attributedText mutableCopy];
//			[mstr replaceCharactersInRange:[_viewController.textView.text rangeOfString:_instagramPrefilledTextString] withString:@""];
//			if ([mstr.string rangeOfString:_instagramForcedTagString].location != NSNotFound) {
//				[mstr replaceCharactersInRange:[mstr.string rangeOfString:_instagramForcedTagString] withString:@""];
//			}
//			[_viewController.textView setAttributedText:mstr];
//		}
		[self validateHashTag];
		return;
	}
	PDSocialMediaManager *manager = [PDSocialMediaManager manager];
	[manager isLoggedInWithInstagram:^(BOOL isLoggedIn){
		if (!isLoggedIn) {
			dispatch_async(dispatch_get_main_queue(), ^{
				PDUIInstagramLoginViewController *instaVC = [[PDUIInstagramLoginViewController alloc] initForParent:_viewController.navigationController delegate:self connectMode:YES];
				if (!instaVC) {
					return;
				}
				_viewController.definesPresentationContext = YES;
				instaVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
				instaVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
				[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
				[_viewController presentViewController:instaVC animated:YES completion:^(void){}];
			});
		}
	}];
	_willInstagram = instagramSwitch.isOn;
	[_viewController.twitterForcedTagLabel setHidden:NO];
	if (_reward.instagramForcedTag.length > 0) {
		[_viewController.addHashtagButton setHidden:NO];
	}
	if ([instagramSwitch isOn]) {
		[_viewController.facebookSwitch setOn:NO animated:YES];
		_willFacebook = NO;
		[_viewController.twitterSwitch setOn:NO animated:YES];
		_willTweet = NO;
		[_viewController.twitterCharacterCountLabel setHidden:YES];
	}
	if (_instagramPrefilledTextString) {
		if (_viewController.textView.text.length == 0) {
			[_viewController.textView setText:_instagramPrefilledTextString];
		}
	}
	if (_reward.instagramForcedTag) {
		_instagramForcedTagString = _reward.instagramForcedTag;
		[_viewController.twitterForcedTagLabel setText:[NSString stringWithFormat:@"%@ Required",_reward.instagramForcedTag]];
		[self validateHashTag];
	}
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
		[_viewController.twitterCharacterCountLabel setTextColor:PopdeemColor(PDThemeColorPrimaryApp)];
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
	if (!_locationVerified) {
		
	}
	
	if (_reward.action == PDRewardActionPhoto && _image == nil) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo Required"
																										message:@"A photo is required for this action. Please add a photo."
																									 delegate:self
																					cancelButtonTitle:@"OK"
																					otherButtonTitles:nil];
		[alert setTag:1];
		[alert show];
		[_viewController.claimButtonView setUserInteractionEnabled:YES];
		return;
	}
	
	if (!_willTweet && !_willFacebook && !_willInstagram) {
		UIAlertView *noPost = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.error", @"Error") message:translationForKey(@"popdeem.claim.networkerror",  @"No Network Selected, you must select at least one social network in order to complete this action.") delegate:self cancelButtonTitle:translationForKey(@"popdeem.common.ok", @"OK") otherButtonTitles:nil];
		[noPost show];
		[_viewController.claimButtonView setUserInteractionEnabled:YES];
		return;
	}
	
	if (_willInstagram) {
		[self validateInstagramOptionsAndClaim];
	}
	if (_willTweet) {
		[self validateTwitterOptionsAndClaim];
	}
	if (_willFacebook) {
		[self validateFacebookOptionsAndClaim];
	}
	
	if ([_viewController.textView isFirstResponder]) {
		[_viewController.textView resignFirstResponder];
	}
	[_viewController.claimButtonView setUserInteractionEnabled:YES];
}

- (void) validateFacebookOptionsAndClaim {
	if (![[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
		[self loginWithWritePerms];
		return;
	}
	[self makeClaim];
}

- (void) validateTwitterOptionsAndClaim {
	__weak PDUIModalLoadingView *twView = [[PDUIModalLoadingView alloc] initForView:self.viewController.view
																																				titleText:translationForKey(@"popdeem.common.wait", @"Please wait")
																																	descriptionText:translationForKey(@"popdeem.claim.twitter.check", @"Checking Credentials")];
	[twView showAnimated:YES];
	if (_twitterForcedTagString && !_hashtagValidated) {
		UIAlertView *hashAV = [[UIAlertView alloc] initWithTitle:@"Oops!"
																										 message:[NSString stringWithFormat:@"Looks like you have forgotten to add the required hashtag %@, please add this to your message before posting to Twitter",_reward.twitterForcedTag]
																										delegate:self
																					 cancelButtonTitle:@"OK"
																					 otherButtonTitles: nil];
		[hashAV show];
		[_viewController.claimButtonView setUserInteractionEnabled:YES];
		AbraLogEvent(ABRA_EVENT_RECEIVED_ERROR_ON_CLAIM, @{
																											 @"Error" : @"Hashtag Validation Failed"
																											 });
		return;
	}
	if (_viewController.twitterCharacterCountLabel.text.integerValue < 0) {
		UIAlertView *tooMany = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.error", @"Error")
																											message:translationForKey(@"popdeem.claim.tweet.toolong", @"Tweet too long, you have written a post longer than the allowed 140 characters. Please shorten your post.")
																										 delegate:self
																						cancelButtonTitle:translationForKey(@"popdeem.common.back", @"Back")
																						otherButtonTitles: nil];
		[tooMany setTag:2];
		[tooMany show];
		[_viewController.claimButtonView setUserInteractionEnabled:YES];
		AbraLogEvent(ABRA_EVENT_RECEIVED_ERROR_ON_CLAIM, @{
																											 ABRA_PROPERTYNAME_ERROR : ABRA_PROPERTYVALUE_ERROR_TOOMANYCHARS
																											 });
		return;
	}
	if ([_viewController.textView.text length] < 1) {
		UIAlertView *noContent = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.error", @"Error")
																											message:translationForKey(@"popdeem.claim.tweet.emptyText", @"You must enter text for your tweet.")
																										 delegate:self
																						cancelButtonTitle:translationForKey(@"popdeem.common.back", @"Back")
																						otherButtonTitles: nil];
		[noContent setTag:2];
		[noContent show];
		[_viewController.claimButtonView setUserInteractionEnabled:YES];
		AbraLogEvent(ABRA_EVENT_RECEIVED_ERROR_ON_CLAIM, @{
																											 ABRA_PROPERTYNAME_ERROR : ABRA_PROPERTYVALUE_ERROR_NOCONTENT
																											 });
		return;
	}
	[self makeClaim];
	return;
}

- (void) validateTwitter {
	[[PDSocialMediaManager manager] verifyTwitterCredentialsCompletion:^(BOOL connected, NSError *error) {
		if (!connected) {
			[self connectTwitter:^(){
				[_viewController.claimButtonView setUserInteractionEnabled:YES];
			} failure:^(NSError *error) {
				UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.error", @"Error")
																										 message:translationForKey(@"popdeem.claim.twitter.notconnected", @"Twitter not connected, you must connect your twitter account in order to post to Twitter")
																										delegate:self
																					 cancelButtonTitle:translationForKey(@"popdeem.common.back", @"Back")
																					 otherButtonTitles: nil];
				[av show];
			}];
			[_viewController.claimButtonView setUserInteractionEnabled:YES];
			return;
		}
		[_viewController.claimButtonView setUserInteractionEnabled:YES];
	}];
}

- (void) validateInstagramOptionsAndClaim {
	if (!_image) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Photo Required"
																										message:@"A photo is required for this action. Please add a photo."
																									 delegate:self
																					cancelButtonTitle:@"OK"
																					otherButtonTitles:nil];
		[alert setTag:1];
		[alert show];
		[_viewController.claimButtonView setUserInteractionEnabled:YES];
		AbraLogEvent(ABRA_EVENT_RECEIVED_ERROR_ON_CLAIM, @{
																											 ABRA_PROPERTYNAME_ERROR : ABRA_PROPERTYVALUE_ERROR_NOPHOTO
																											 });
		return;
	}
	if (_instagramForcedTagString && !_hashtagValidated) {
		UIAlertView *hashAV = [[UIAlertView alloc] initWithTitle:@"Oops!"
																										 message:[NSString stringWithFormat:@"Looks like you have forgotten to add the required hashtag %@, please add this to your message before posting to Instagram",_reward.instagramForcedTag]
																										delegate:self
																					 cancelButtonTitle:@"OK"
																					 otherButtonTitles: nil];
		[hashAV show];
		[_viewController.claimButtonView setUserInteractionEnabled:YES];
		return;
	}
	[_loadingView hideAnimated:YES];
	PDUIInstagramShareViewController *isv = [[PDUIInstagramShareViewController alloc] initForParent:_viewController.navigationController withMessage:_viewController.textView.text image:_image imageUrlString:_imageURLString];
	_viewController.definesPresentationContext = YES;
	isv.modalPresentationStyle = UIModalPresentationOverFullScreen;
	isv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[_viewController presentViewController:isv animated:YES completion:^(void){}];
//	[self makeClaim];
	return;
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
	if (!_instagramForcedTagString && !_twitterForcedTagString) {
		_hashtagValidated = YES;
		[_viewController.addHashtagButton setHidden:YES];
		[_viewController.twitterForcedTagLabel setHidden:YES];
		return;
	}
	
	NSString *searchString = @"";
	if (_willTweet) {
		searchString = _reward.twitterForcedTag;
	}
	if (_willInstagram) {
		searchString = _reward.instagramForcedTag;
	}
	
	if (!searchString) {
		_hashtagValidated = YES;
		[_viewController.addHashtagButton setHidden:YES];
		[_viewController.twitterForcedTagLabel setHidden:YES];
		return;
	}
	
	if ([_viewController.textView.text.lowercaseString rangeOfString:searchString.lowercaseString].location != NSNotFound && (_willTweet || _willInstagram)) {
		_hashtagValidated = YES;
		_tvSurpress = YES;
		NSRange hashRange = [_viewController.textView.text.lowercaseString rangeOfString:searchString.lowercaseString];
		NSMutableAttributedString *mutString = [[NSMutableAttributedString alloc] initWithString:_viewController.textView.text];
		[mutString addAttribute:NSBackgroundColorAttributeName value:PopdeemColor(PDThemeColorPrimaryApp) range:hashRange];
		[mutString addAttribute:NSForegroundColorAttributeName value:PopdeemColor(PDThemeColorPrimaryInverse) range:hashRange];
		[mutString addAttribute:NSFontAttributeName value:PopdeemFont(PDThemeFontPrimary, 14) range:NSMakeRange(0, mutString.length)];
		[_viewController.textView setAttributedText:mutString];
		[_viewController.addHashtagButton setHidden:YES];
		[_viewController.twitterForcedTagLabel setHidden:YES];
	} else {
		NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:_viewController.textView.text];
		_tvSurpress = YES;
		[string setAttributes:@{} range:NSMakeRange(0, string.length)];
		[string addAttribute:NSFontAttributeName value:PopdeemFont(PDThemeFontPrimary, 14) range:NSMakeRange(0, string.length)];
		[_viewController.textView setAttributedText:string];
		if (_willTweet || _willInstagram) {
			[_viewController.addHashtagButton setHidden:NO];
			[_viewController.twitterForcedTagLabel setHidden:NO];
		}
	}
}

- (void) makeClaim {
	
	PDAPIClient *client = [PDAPIClient sharedInstance];
	NSString *message = [_viewController.textView text];
	
	NSMutableArray *taggedFriends = [NSMutableArray array];
	for (PDSocialMediaFriend *f in [PDUser taggableFriends]) {
		if (f.selected) {
			[taggedFriends addObject:f.tagIdentifier];
		}
	}
	if (taggedFriends.count > 0) {
		AbraLogEvent(ABRA_EVENT_ADDED_CLAIM_CONTENT, (@{ABRA_PROPERTYNAME_TAGGED_FRIENDS : @"Yes", @"Friends Count" : [NSString stringWithFormat:@"%li",(unsigned long)taggedFriends.count]}));
	}
	
	__block NSInteger rewardId = _reward.identifier;
	//location?
	[client claimReward:_reward.identifier
						 location:_location withMessage:message
				taggedFriends:taggedFriends
								image:_image facebook:_willFacebook
							twitter:_willTweet
						instagram:_willInstagram
							success:^(){
								
								if (_willInstagram) {
									[[NSNotificationCenter defaultCenter] postNotificationName:InstagramPostMade object:self userInfo:@{@"rewardId" : @(_reward.identifier)}];
								}
		[self didClaimRewardId:rewardId];
								
	} failure:^(NSError *error){
		[self PDAPIClient:client didFailWithError:error];
	}];
	
	_loadingView = [[PDUIModalLoadingView alloc] initForView:self.viewController.view
																								 titleText:translationForKey(@"popdeem.claim.reward.claiming", @"Claiming Reward")
																					 descriptionText:translationForKey(@"popdeem.claim.reward.claiming.message", @"This could take up to 30 seconds")];
	[_loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
	[_loadingView showAnimated:YES];
}

- (void) loginWithReadAndWritePerms {
	[[PDSocialMediaManager manager] loginWithFacebookReadPermissions:@[
																																		 @"public_profile",
																																		 @"email",
																																		 @"user_birthday",
																																		 @"user_posts",
																																		 @"user_friends",
																																		 @"user_education_history"]
																							 registerWithPopdeem:YES
																													 success:^(void) {
		_willFacebook = YES;
		[_viewController.facebookButton setSelected:YES];
		[self loginWithWritePerms];
	} failure:^(NSError *error) {
		UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.sorry", @"Sorry")
																								 message:translationForKey(@"popdeem.claim.facebook.connect", @"We couldnt connect you to Facebook")
																								delegate:nil
																			 cancelButtonTitle:nil
																			 otherButtonTitles:translationForKey(@"popdeem.common.ok", @"OK"), nil];
		[av show];
		_willFacebook = NO;
		[_viewController.facebookButton setSelected:NO];
	}];
}

- (void) loginWithWritePerms {
	dispatch_async(dispatch_get_main_queue(), ^{
		PDUIFBLoginWithWritePermsViewController *fbVC = [[PDUIFBLoginWithWritePermsViewController alloc] initForParent:_viewController.navigationController loginType:PDFacebookLoginTypePublish];
		if (!fbVC) {
			return;
		}
		_viewController.definesPresentationContext = YES;
		fbVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
		fbVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		[_viewController presentViewController:fbVC animated:YES completion:^(void){}];
	});
}

- (void) connectInstagramAccount:(NSInteger)identifier accessToken:(NSString*)accessToken userName:(NSString*)userName {
	PDAPIClient *client = [PDAPIClient sharedInstance];
	[client connectInstagramAccount:identifier accessToken:accessToken screenName:userName success:^(void){
		[[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginSuccess object:nil];
	} failure:^(NSError* error){
		[[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginFailure object:nil];
	}];
}

- (void) didClaimRewardId:(NSInteger)rewardId {
	
	if (_viewController.claimTask != UIBackgroundTaskInvalid) {
		[_viewController endBackgroundUpdateTask];
	}
	
	[_loadingView hideAnimated:YES];
	
	[PDRewardStore deleteReward:_reward.identifier];
	
	_viewController.homeController.didClaim = YES;
	
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.claim.reward.claimed", @"Reward Claimed!") message:translationForKey(@"popdeem.claim.reward.success", @"You can view your reward in your wallet") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[av setTag:9];
	[av show];
	
	AbraLogEvent(ABRA_EVENT_CLAIMED, (@{
																			ABRA_PROPERTYNAME_SOCIAL_NETWORKS : [self readableNetworksChosen],
																			ABRA_PROPERTYNAME_PHOTO : (_image != nil) ? @"YES" : @"NO",
																			ABRA_PROPERTYNAME_REWARD_TYPE : AbraKeyForRewardType(_reward.type)
																			}));
	
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 9) {
		[self.viewController.navigationController popViewControllerAnimated:YES];
	}
}


- (void) PDAPIClient:(PDAPIClient *)client didFailWithError:(NSError *)error {
	PDLogError(@"Error: %@",error);
	if (_viewController.claimTask != UIBackgroundTaskInvalid) {
		[_viewController endBackgroundUpdateTask];
	}
	[_loadingView hideAnimated:YES];
	[_viewController.claimButtonView setUserInteractionEnabled:YES];
	
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.sorry", @"Sorry") message:translationForKey(@"popdeem.common.something.wrong", @"Something went wrong. Please try again later") delegate:self cancelButtonTitle:translationForKey(@"common.back", @"Back") otherButtonTitles:nil];
	[av show];
}

#pragma mark - Connecting Twitter -
- (void) connectTwitter:(void (^)(void))success failure:(void (^)(NSError *failure))failure {
	PDUITwitterLoginViewController *twitterVC = [[PDUITwitterLoginViewController alloc] initForParent:_viewController.navigationController];
	if (!twitterVC) {
		return;
	}
	_viewController.definesPresentationContext = YES;
	twitterVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
	twitterVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(twitterLoginSuccess) name:TwitterLoginSuccess object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(twitterLoginFailure) name:TwitterLoginFailure object:nil];
	[_viewController.navigationController presentViewController:twitterVC animated:YES completion:^(void){
	}];
}

- (void) twitterLoginSuccess {
	[_viewController.twitterButton setImage:[UIImage imageNamed:@"Twitter"] forState:UIControlStateNormal];
	_willTweet = YES;
	[_viewController.twitterButton setImage:[UIImage imageNamed:@"twitterSelected"] forState:UIControlStateNormal];
	[_loadingView hideAnimated:YES];
	[self calculateTwitterCharsLeft];
	[_viewController.facebookButton setEnabled:NO];
	[_viewController.withLabel setHidden:YES];
	AbraLogEvent(ABRA_EVENT_CONNECTED_ACCOUNT, (@{
																								ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_TWITTER,
																								ABRA_PROPERTYNAME_SOURCE_PAGE : @"Claim Screen"
																								}));
}

- (void) twitterLoginFailure {
	PDLogError(@"Twitter didnt log in");
	if (!_mustTweet) {
		_willTweet = NO;
		[_viewController.twitterButton setImage:[UIImage imageNamed:@"twitterDeselected"] forState:UIControlStateNormal];
	}
	[_loadingView hideAnimated:YES];
	[_viewController.twitterSwitch setOn:NO animated:NO];
	[_viewController.twitterForcedTagLabel setHidden:YES];
	[_viewController.twitterCharacterCountLabel setHidden:YES];
	[_viewController.addHashtagButton setHidden:YES];
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
	picker.allowsEditing = YES;
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
	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(keyboardWillShow:)
																							 name:UIKeyboardWillShowNotification object:nil];

	__block PHObjectPlaceholder *placeholder;
	if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
//		if (_willInstagram) {
			[[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
				PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:info[UIImagePickerControllerOriginalImage]];
				placeholder = request.placeholderForCreatedAsset;
				_imageURLString = [NSString stringWithFormat:@"assets-library://asset/asset.JPG?id=%@&ext=JPG",placeholder.localIdentifier];
			} completionHandler:^(BOOL success, NSError *error){
				if (success) {
					PDLog(@"Saved Image");
				}
			}];
	} else {
		NSURL *imageURL = info[@"UIImagePickerControllerReferenceURL"];
		_imageURLString = [imageURL absoluteString];
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
//	UIImage *resized = [img resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:CGSizeMake(480, 480) interpolationQuality:kCGInterpolationHigh];
	
	CGRect cropRect = [info[@"UIImagePickerControllerCropRect"] CGRectValue];
	
	if (!CGRectEqualToRect(CGRectMake(0, 0, img.size.width, img.size.height), cropRect)) {
		CGImageRef imageRef = CGImageCreateWithImageInRect([img CGImage], cropRect);
		img = [UIImage imageWithCGImage:imageRef];
		CGImageRelease(imageRef);
	}
	
	_image = [self resizeImage:img withMinDimension:480];
	_imageView.image = _image;
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
		
	[self calculateTwitterCharsLeft];
	NSString *source = (picker.sourceType == UIImagePickerControllerSourceTypeCamera) ? @"Camera" : @"Photo Library";
	AbraLogEvent(ABRA_EVENT_ADDED_CLAIM_CONTENT, (@{ABRA_PROPERTYNAME_PHOTO : @"Yes", @"Source" : source}));
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo {
	_image = [self resizeImage:image withMinDimension:480];
	_imageView.image = _image;
	
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
- (void) instagramLoginSuccess {
	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(keyboardWillShow:)
																							 name:UIKeyboardWillShowNotification object:nil];
	self.willInstagram = YES;
}


- (void) instagramLoginFailure {
	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(keyboardWillShow:)
																							 name:UIKeyboardWillShowNotification object:nil];
	self.willInstagram = NO;
}

- (NSString *) readableNetworksChosen {
	NSMutableString *chosen = [NSMutableString string];
	if (_willFacebook) {
		[chosen appendString:@" Facebook "];
	}
	if (_willTweet) {
		[chosen appendString:@" Twitter "];
	}
	if (_willInstagram) {
		[chosen appendString:@" Instagram "];
	}
	return chosen;
}
@end
