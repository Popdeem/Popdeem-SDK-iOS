//
//  PDClaimViewModel.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 26/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDReward.h"
#import "PDLocation.h"
#import "InstagramLoginDelegate.h"
@class PDUIClaimViewController;
#import "TOCropViewController/TOCropViewController.h"

@interface PDUIClaimViewModel : NSObject <UITextViewDelegate, UIAlertViewDelegate, InstagramLoginDelegate, TOCropViewControllerDelegate>

typedef NS_ENUM(NSInteger, SocialMediaTypesAvailable) {
	FacebookOnly = 0,
	TwitterOnly,
	InstagramOnly,
	FacebookAndTwitter,
	FacebookAndInstagram,
	TwitterAndInstagram,
	Any	
};

@property (nonatomic, strong) PDUIClaimViewController *viewController;
@property (nonatomic, strong) PDReward *reward;
@property (nonatomic, strong) UIImage *rewardImage;
@property (nonatomic, strong) NSString *imageURLString;
@property (nonatomic, strong) NSString *rewardTitleString;
@property (nonatomic, strong) NSString *rewardRulesString;
@property (nonatomic, strong) NSString *rewardActionsString;
@property (nonatomic, strong) NSString *textviewPlaceholder;
@property (nonatomic, strong) NSString *textviewPrepopulatedString;
@property (nonatomic, strong) NSString *twitterForcedTagString;
@property (nonatomic, strong) NSString *instagramForcedTagString;
@property (nonatomic, strong) NSString *twitterCharCountString;
@property (nonatomic, strong) NSString *twitterPrefilledTextString;
@property (nonatomic, strong) NSString *instagramPrefilledTextString;

@property (nonatomic) BOOL mustFacebook;
@property (nonatomic) BOOL willFacebook;
@property (nonatomic) BOOL willInstagram;
@property (nonatomic) BOOL didGoToInstagram;
@property (nonatomic) BOOL willTweet;
@property (nonatomic) BOOL didGoToImagePicker;

@property (nonatomic, strong) PDLocation *location;

@property (nonatomic) BOOL locationVerified;

@property (nonatomic) SocialMediaTypesAvailable socialMediaTypesAvailable;

- (instancetype) initWithMediaTypes:(NSArray*)mediaTypes andReward:(PDReward*)reward location:(PDLocation*)location controller:(PDUIClaimViewController*)controller;
- (void) toggleFacebook;
- (void) toggleTwitter;
- (void) addPhotoAction;
- (void) claimAction;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void) calculateTwitterCharsLeft;
- (void) validateHashTag;
- (void) instagramSwitchToggled:(UISwitch*)instagramSwitch;
- (void) didClaimRewardId:(NSInteger)rewardId;
- (void) makeClaim;
- (void) instagramLoginSuccess;
- (void) instagramLoginFailure;
- (void) connectInstagramAccount:(NSString*)identifier accessToken:(NSString*)accessToken userName:(NSString*)userName;
@end
