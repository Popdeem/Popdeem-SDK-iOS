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
#import "PDUserAPIService.h"
#import "PDUIInstagramVerifyViewController.h"
#import "PDUIGratitudeViewController.h"
#import "PDUIKitUtils.h"

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

@property (nonatomic, retain) TOCropViewController *cropViewController;
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
	
  if (_reward.forcedTag) {
    _twitterForcedTagString = [NSString stringWithFormat:@"%@ %@",_reward.forcedTag, translationForKey(@"popdeem.claim.hashtagRequired", @"Required")];
  } else if (_reward.twitterForcedTag) {
		_twitterForcedTagString = [NSString stringWithFormat:@"%@ %@",_reward.twitterForcedTag, translationForKey(@"popdeem.claim.hashtagRequired", @"Required")];
	}
	
	if (_reward.instagramPrefilledMessage) {
		_instagramPrefilledTextString = _reward.instagramPrefilledMessage;
	}
	
  if (_reward.forcedTag) {
    _instagramForcedTagString = [NSString stringWithFormat:@"%@ %@",_reward.forcedTag, translationForKey(@"popdeem.claim.hashtagRequired", @"Required")];
  } else if (_reward.instagramForcedTag) {
		_instagramForcedTagString = [NSString stringWithFormat:@"%@ %@",_reward.instagramForcedTag, translationForKey(@"popdeem.claim.hashtagRequired", @"Required")];
	}
	
	[_viewController.twitterForcedTagLabel setTextColor:PopdeemColor(PDThemeColorPrimaryApp)];
}


- (void) toggleFacebook {
  [self validateHashTag];

	_willFacebook = _viewController.facebookSwitch.isOn;
	if ([_viewController.facebookSwitch isOn]) {
		[_viewController.twitterSwitch setOn:NO animated:YES];
		_willTweet = NO;
		[_viewController.instagramSwitch setOn:NO animated:YES];
		_willInstagram = NO;
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
	
	if ([_viewController.twitterSwitch isOn]) {
		[_viewController.facebookSwitch setOn:NO animated:YES];
		_willFacebook = NO;
		[_viewController.instagramSwitch setOn:NO animated:YES];
		_willInstagram = NO;
		[self validateTwitter];
	}
	
	if (_willTweet) {
		_willTweet = NO;
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
  if (_reward.forcedTag) {
    if (_reward.forcedTag.length > 0) {
      [_viewController.addHashtagButton setHidden:NO];
    }
  } else {
    if (_reward.twitterForcedTag.length > 0) {
      [_viewController.addHashtagButton setHidden:NO];
    }
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
		[self validateHashTag];
		return;
	}
	PDSocialMediaManager *manager = [PDSocialMediaManager manager];
  __weak typeof(self) weakSelf = self;
	[manager isLoggedInWithInstagram:^(BOOL isLoggedIn){
		if (!isLoggedIn) {
			dispatch_async(dispatch_get_main_queue(), ^{
				PDUIInstagramLoginViewController *instaVC = [[PDUIInstagramLoginViewController alloc] initForParent:weakSelf.viewController.navigationController delegate:weakSelf connectMode:YES];
				if (!instaVC) {
					return;
				}
				weakSelf.viewController.definesPresentationContext = YES;
				instaVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
				instaVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
				[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
				[weakSelf.viewController presentViewController:instaVC animated:YES completion:^(void){}];
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
		[_viewController.twitterForcedTagLabel setText:[NSString stringWithFormat:@"%@ %@",_reward.instagramForcedTag, translationForKey(@"popdeem.claim.hashtagRequired", @"Required")]];
		[self validateHashTag];
	}
}

- (void) addPhotoAction {
	[self showPhotoActionSheet];
}

- (void) calculateTwitterCharsLeft {
	//Build the string
	NSString *endString = [NSString stringWithString:_viewController.textView.text];

	NSString *sampleMediaString = @"";
	for (int i = 0 ; i < _reward.twitterMediaLength ; i++) {
		sampleMediaString = [sampleMediaString stringByAppendingString:@" "];
	}
	
	//All rewards have a download link now, so deduct this media string length
	endString = [endString stringByAppendingString:[NSString stringWithFormat:@" %@",sampleMediaString]];
	
	if (_rewardImage) {
		endString = [endString stringByAppendingString:[NSString stringWithFormat:@" %@",sampleMediaString]];
	}
	
	int charsLeft = 240 - (int)endString.length;
	
	if (charsLeft < 1) {
		[_viewController.twitterCharacterCountLabel setTextColor:[UIColor redColor]];
	} else {
		[_viewController.twitterCharacterCountLabel setTextColor:PopdeemColor(PDThemeColorPrimaryApp)];
	}
	
	[_viewController.twitterCharacterCountLabel setText:[NSString stringWithFormat:@"%d",charsLeft]];
}

- (void) keyboardWillShow:(NSNotification*)notification {
  __weak typeof(self) weakSelf = self;
	[UIView animateWithDuration:1.0
												delay:0.0
											options: UIViewAnimationOptionCurveEaseInOut
									 animations:^{
										 [weakSelf.viewController keyboardUp];
									 } completion:^(BOOL finished){
                   
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
                     UIBarButtonItem *typingDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:weakSelf.viewController action:@selector(hiderTap)];
#pragma clang diagnostic pop
                     //
                     weakSelf.viewController.navigationItem.rightBarButtonItem = typingDone;
                     weakSelf.viewController.navigationItem.hidesBackButton = YES;

                   }];
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
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.claim.alert.photoRequired.title", @"Photo Required")
																										message:translationForKey(@"popdeem.claim.alert.photoRequired.body", @"A photo is required for this action. Please add a photo.")
																									 delegate:self
																					cancelButtonTitle:translationForKey(@"popdeem.claim.alert.cancelButton.title", @"OK")
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
  if (_reward.forcedTag && !_hashtagValidated) {
    UIAlertView *hashAV = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.claim.hashtagMissing.title", @"Oops!")
                                                     message:[NSString stringWithFormat:translationForKey(@"popdeem.claim.hashtagMissing.message", @"Looks like you have forgotten to add the required hashtag %@, please add this to your message before posting to Facebook"),_reward.instagramForcedTag]
                                                    delegate:self
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles: nil];
    [hashAV show];
    [_viewController.claimButtonView setUserInteractionEnabled:YES];
    return;
  }
	[self makeClaim];
}

- (void) validateTwitterOptionsAndClaim {
	PDUIModalLoadingView *twView = [[PDUIModalLoadingView alloc] initForView:self.viewController.view
																																				titleText:translationForKey(@"popdeem.common.wait", @"Please wait")
																																	descriptionText:translationForKey(@"popdeem.claim.twitter.check", @"Checking Credentials")];
	[twView showAnimated:YES];
	if (_twitterForcedTagString && !_hashtagValidated) {
		UIAlertView *hashAV = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.claim.hashtagMissing.title", @"Oops!")
																										 message:[NSString stringWithFormat:translationForKey(@"popdeem.claim.hashtagMissing.message", @"Looks like you have forgotten to add the required hashtag %@, please add this to your message before posting to Twitter"),_reward.forcedTag]
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
  [twView hideAnimated:YES];
	[self makeClaim];
	return;
}

- (void) validateTwitter {
  __weak typeof(self) weakSelf = self;
	[[PDSocialMediaManager manager] verifyTwitterCredentialsCompletion:^(BOOL connected, NSError *error) {
		if (!connected) {
			[self connectTwitter:^(){
				[weakSelf.viewController.claimButtonView setUserInteractionEnabled:YES];
			} failure:^(NSError *error) {
				UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.error", @"Error")
																										 message:translationForKey(@"popdeem.claim.twitter.notconnected", @"Twitter not connected, you must connect your twitter account in order to post to Twitter")
																										delegate:self
																					 cancelButtonTitle:translationForKey(@"popdeem.common.back", @"Back")
																					 otherButtonTitles: nil];
				[av show];
			}];
			[weakSelf.viewController.claimButtonView setUserInteractionEnabled:YES];
			return;
		}
		[weakSelf.viewController.claimButtonView setUserInteractionEnabled:YES];
	}];
}

- (void) validateInstagramOptionsAndClaim {
	if (!_image) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.claim.action.photo", @"Photo Required")
																										message:translationForKey(@"popdeem.claim.action.photoMessage", @"A photo is required for this action. Please add a photo.")
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
		UIAlertView *hashAV = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.claim.hashtagMissing.title", @"Oops!")
																										 message:[NSString stringWithFormat:translationForKey(@"popdeem.claim.hashtagMissing.message", @"Looks like you have forgotten to add the required hashtag %@, please add this to your message before posting to Instagram"),_reward.instagramForcedTag]
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
  _didGoToInstagram = YES;
	return;
}

- (void) textViewDidChange:(UITextView *)textView {
	[self calculateTwitterCharsLeft];
	if (!_tvSurpress) {
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
    if (_reward.forcedTag) {
      searchString = _reward.forcedTag;
    } else {
      searchString = _reward.twitterForcedTag;
    }
	}
	if (_willInstagram) {
    if (_reward.forcedTag) {
      searchString = _reward.forcedTag;
    } else {
      searchString = _reward.instagramForcedTag;
    }
  } else {
    searchString = _reward.forcedTag;
  }
	
	if (!searchString) {
		_hashtagValidated = YES;
		[_viewController.addHashtagButton setHidden:YES];
		[_viewController.twitterForcedTagLabel setHidden:YES];
		return;
	}
	
	if ([_viewController.textView.text.lowercaseString rangeOfString:searchString.lowercaseString].location != NSNotFound) {
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
		[_viewController.addHashtagButton setHidden:NO];
    [_viewController.twitterForcedTagLabel setHidden:NO];
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
  if (_willTweet) {
    [client claimReward:_reward.identifier
               location:_location withMessage:message
          taggedFriends:taggedFriends
                  image:_image facebook:NO
                twitter:_willTweet
              instagram:NO
                success:^(){

                  [self didClaimRewardId:rewardId];

                } failure:^(NSError *error){
                  [self PDAPIClient:client didFailWithError:error];
                }];
  } else if (_willFacebook) {
      //Use Facebook Share Dialog
      if (_image) {
          //Photo Share
          FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
          photo.image = _image;
          photo.userGenerated = YES;
          FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
//          content.photos = @[photo];
          content.hashtag = [FBSDKHashtag hashtagWithString:_reward.forcedTag];
          FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
          dialog.fromViewController = self.viewController;
          dialog.shareContent = content;
          dialog.mode = FBSDKShareDialogModeShareSheet;
          dialog.delegate = self;
          [dialog show];
      }
  } else {
    if (_willInstagram) {
      [[NSNotificationCenter defaultCenter] postNotificationName:InstagramPostMade object:self userInfo:@{@"rewardId" : @(_reward.identifier)}];
    }
  }
	
//  _loadingView = [[PDUIModalLoadingView alloc] initForView:self.viewController.view
//                                                 titleText:translationForKey(@"popdeem.claim.reward.claiming", @"Claiming Reward")
//                                           descriptionText:translationForKey(@"popdeem.claim.reward.claiming.message", @"This could take up to 30 seconds")];
//  [_loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
//  [_loadingView showAnimated:YES];

}

- (void) loginWithReadAndWritePerms {
  
  PDUIFBLoginWithWritePermsViewController *fbVC = [[PDUIFBLoginWithWritePermsViewController alloc] initForParent:self.viewController.navigationController
                                                                                                         loginType:PDFacebookLoginTypeRead];
  if (!fbVC) {
    return;
  }
  self.viewController.definesPresentationContext = YES;
  fbVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
  fbVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLoginSuccess) name:FacebookLoginSuccess object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLoginFailure) name:FacebookLoginFailure object:nil];
  [self.viewController presentViewController:fbVC animated:YES completion:^(void){
  }];
}

- (void) facebookLoginSuccess {
  
  AbraLogEvent(ABRA_EVENT_CONNECTED_ACCOUNT, (@{
                                                ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_FACEBOOK,
                                                ABRA_PROPERTYNAME_SOURCE_PAGE : @"Claim Screen"
                                                }));
  
  if (![[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
    [self loginWithWritePerms];
  }
  [self.viewController.facebookSwitch setOn:YES];
}

- (void) facebookLoginFailure {
  [self.viewController.facebookSwitch setOn:NO];
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

- (void) connectInstagramAccount:(NSString*)identifier accessToken:(NSString*)accessToken userName:(NSString*)userName {
	PDAPIClient *client = [PDAPIClient sharedInstance];  
  if ([[PDUser sharedInstance] isRegistered]) {
    [client connectInstagramAccount:identifier accessToken:accessToken screenName:userName success:^(void){
      [[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginSuccess object:nil];
    } failure:^(NSError* error){
      [[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginFailure object:self userInfo:error.userInfo];
    }];
  } else {
    PDUserAPIService *service = [[PDUserAPIService alloc] init];
    [service registerUserWithInstagramId:identifier accessToken:accessToken fullName:@"" userName:userName profilePicture:@"" success:^(PDUser *user) {
      [[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginSuccess object:nil];
    } failure:^(NSError *error) {
      [[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginFailure object:nil];
    }];
  }
}

- (void) didClaimRewardId:(NSInteger)rewardId {
	
  //Here is where we will show the ambassador popup or verify the instagram action
  
  if (_willInstagram) {
    //Do the verify flow.
    NSLog(@"Instagram was Chosen");
    PDUIInstagramVerifyViewController *verifyController = [[PDUIInstagramVerifyViewController alloc] initForParent:self.viewController forReward:_reward];
    [self.viewController.navigationController pushViewController:verifyController animated:YES];
    return;
  }
  
	if (_viewController.claimTask != UIBackgroundTaskInvalid) {
		[_viewController endBackgroundUpdateTask];
	}
	
	[_loadingView hideAnimated:YES];
	
	[PDRewardStore deleteReward:_reward.identifier];
	
	_viewController.homeController.didClaim = YES;
	
  [self.viewController.navigationController popViewControllerAnimated:YES];
	
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
  dispatch_async(dispatch_get_main_queue(), ^{
    PDLogError(@"Twitter didnt log in");
    _willTweet = NO;
    [_viewController.twitterButton setImage:[UIImage imageNamed:@"twitterDeselected"] forState:UIControlStateNormal];
    [_loadingView hideAnimated:YES];
    [_viewController.twitterSwitch setOn:NO animated:NO];
    [_viewController.twitterCharacterCountLabel setHidden:YES];
  });
}

#pragma mark - Adding Photo -

- (void) showPhotoActionSheet {
	_alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	_alertWindow.rootViewController = [UIViewController new];
	_alertWindow.windowLevel = 10000001;
	_alertWindow.hidden = NO;
	
	__weak __typeof(self) weakSelf = self;
	
	UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Choose Source" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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
	if (self.image != nil) {
		[alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
			weakSelf.alertWindow.hidden = YES;
			weakSelf.alertWindow = nil;
			weakSelf.image = nil;
			[weakSelf.imageView setImage:nil];
			[weakSelf.imageView setHidden:YES];
			[weakSelf.viewController.view setNeedsDisplay];
			if ([_viewController.textView isFirstResponder]) {
				[_viewController.textView resignFirstResponder];
			}
		}]];
	}
	
	[_alertWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (void)takePhoto {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = _viewController;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    _didGoToImagePicker = YES;
    __weak typeof(_viewController) weakController = _viewController;
    [_viewController presentViewController:picker animated:YES completion:^{
        weakController.spoofView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, weakController.navigationController.view.frame.size.width, weakController.navigationController.view.frame.size.height)];
        weakController.spoofView.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.10 alpha:1.00];
        [weakController.navigationController.view addSubview:weakController.spoofView];
    }];
}

- (void)selectPhoto {
  if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined || [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
      UIImagePickerController *picker = [[UIImagePickerController alloc] init];
      picker.delegate = self;
      picker.allowsEditing = NO;
      picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
      picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
      picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
      dispatch_async(dispatch_get_main_queue(), ^{
        [self.viewController presentViewController:picker animated:YES completion:NULL];
      });
    }];
  } else {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.viewController presentViewController:picker animated:YES completion:NULL];
  }
}

- (void) addPhotoToLibrary:(NSDictionary*)info {
  __block PHObjectPlaceholder *placeholder;
    __weak typeof(self) weakSelf = self;
  [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
    PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:info[UIImagePickerControllerOriginalImage]];
    placeholder = request.placeholderForCreatedAsset;
    weakSelf.imageURLString = placeholder.localIdentifier;
  } completionHandler:^(BOOL success, NSError *error){
    if (success) {
      PDLog(@"Saved Image");
    }
  }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
  [picker dismissViewControllerAnimated:NO completion:NULL];
  [_viewController.spoofView removeFromSuperview];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:NO completion:NULL];
	[[NSNotificationCenter defaultCenter] addObserver:self
																					 selector:@selector(keyboardWillShow:)
																							 name:UIKeyboardWillShowNotification object:nil];
    
    
	UIImage *img = info[UIImagePickerControllerOriginalImage];
	img = [self normalizedImage:img];
	CGRect cropRect = [info[@"UIImagePickerControllerCropRect"] CGRectValue];
	
	if (cropRect.size.width > 0 && !CGRectEqualToRect(CGRectMake(0, 0, img.size.width, img.size.height), cropRect)) {
		CGImageRef imageRef = CGImageCreateWithImageInRect([img CGImage], cropRect);
		img = [UIImage imageWithCGImage:imageRef];
		CGImageRelease(imageRef);
	}
	
	_image = [self resizeImage:img withMinDimension:480];
    _cropViewController = [[TOCropViewController alloc] initWithImage:_image];
    _cropViewController.delegate = self;
    [_viewController presentViewController:_cropViewController animated:NO completion:nil];
	_didAddPhoto = YES;
    
    __weak typeof(self) weakSelf = self;
	[UIView animateWithDuration:0.5
												delay:1.0
											options: UIViewAnimationOptionCurveEaseInOut
									 animations:^{
										 [weakSelf.viewController.textView setTextContainerInset:UIEdgeInsetsMake(10, 8, 10, 70)];
									 }
									 completion:^(BOOL finished){
									 }];
		
	[self calculateTwitterCharsLeft];
	NSString *source = (picker.sourceType == UIImagePickerControllerSourceTypeCamera) ? @"Camera" : @"Photo Library";
	AbraLogEvent(ABRA_EVENT_ADDED_CLAIM_CONTENT, (@{ABRA_PROPERTYNAME_PHOTO : @"Yes", @"Source" : source}));
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [_viewController.spoofView removeFromSuperview];
    if (_cropViewController) {
        [_cropViewController dismissViewControllerAnimated:NO completion:nil];
    }
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined || [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self addPhotoToLibrary:@{UIImagePickerControllerOriginalImage: image}];
            } else {
                PDLog(@"Error saving photo to Library");
            }
        }];
    } else {
        [self addPhotoToLibrary:@{UIImagePickerControllerOriginalImage: image}];
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
    _imageView.image = image;
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
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [_viewController.spoofView removeFromSuperview];
    if (_cropViewController) {
        [_cropViewController dismissViewControllerAnimated:NO completion:nil];
    }
}

- (UIImage *)normalizedImage:(UIImage*)image {
	if (image.imageOrientation == UIImageOrientationUp) return image;
	
	UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
	[image drawInRect:(CGRect){0, 0, image.size}];
	UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return normalizedImage;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo {
	_image = [self resizeImage:image withMinDimension:460];
	_imageView.image = _image;
}

- (UIImage *)resizeImage:(UIImage *)inImage
				withMinDimension:(CGFloat)minDimension {
	
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

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    PDLog(@"FB Error: %@", error.localizedDescription);
}

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    PDLog(@"FB Complete: %@", results);
}

- (void) sharerDidCancel:(id<FBSDKSharing>)sharer {
    PDLog(@"FB Cancelled");
}

@end
