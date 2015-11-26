//
//  PDClaimViewModel.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 26/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDReward.h"
@class PDClaimViewController;

@interface PDClaimViewModel : NSObject <UITextViewDelegate>

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

@property (nonatomic) SocialMediaTypesAvailable socialMediaTypesAvailable;

- (id) initWithMediaTypes:(NSArray*)mediaTypes andReward:(PDReward*)reward;
- (void) toggleFacebook;
- (void) toggleTwitter;
- (void) addPhotoAction;
- (void) claimAction;

@end
