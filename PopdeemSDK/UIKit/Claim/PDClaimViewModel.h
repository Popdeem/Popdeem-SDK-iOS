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
@class PDClaimViewController;

@interface PDClaimViewModel : NSObject <UITextViewDelegate, UIAlertViewDelegate>

typedef NS_ENUM(NSInteger, SocialMediaTypesAvailable) {
    FacebookOnly = 0,
    TwitterOnly,
    FacebookAndTwitter
};

@property (nonatomic, strong) PDClaimViewController *viewController;
@property (nonatomic, strong) PDReward *reward;
@property (nonatomic, strong) UIImage *rewardImage;
@property (nonatomic, strong) NSString *rewardTitleString;
@property (nonatomic, strong) NSString *rewardRulesString;
@property (nonatomic, strong) NSString *rewardActionsString;
@property (nonatomic, strong) NSString *textviewPlaceholder;
@property (nonatomic, strong) NSString *textviewPrepopulatedString;
@property (nonatomic, strong) NSString *forcedTagString;
@property (nonatomic, strong) NSString *twitterCharCountString;
@property (nonatomic) BOOL willTweet;

@property (nonatomic, strong) PDLocation *location;

@property (nonatomic) BOOL locationVerified;

@property (nonatomic) SocialMediaTypesAvailable socialMediaTypesAvailable;

- (instancetype) initWithMediaTypes:(NSArray*)mediaTypes andReward:(PDReward*)reward location:(PDLocation*)location;
- (void) toggleFacebook;
- (void) toggleTwitter;
- (void) addPhotoAction;
- (void) claimAction;
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
- (void) calculateTwitterCharsLeft;
@end
