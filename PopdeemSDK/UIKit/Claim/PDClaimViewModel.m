//
//  PDClaimViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 26/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDClaimViewModel.h"
#import "PDClaimViewController.h"
#import "PDUser.h"
#import "PDSocialMediaManager.h"

@interface PDClaimViewModel()
@property (nonatomic) BOOL mustTweet;
@property (nonatomic) BOOL willTweet;
@property (nonatomic) BOOL mustFacebook;
@property (nonatomic) BOOL willFacebook;
@end

@implementation PDClaimViewModel

- (id) init {
    if (self = [super init]) {
        return self;
    }
    return nil;
}

- (id) initWithMediaTypes:(NSArray*)mediaTypes andReward:(PDReward*)reward {
    self = [self init];
    if (!self) return nil;
    
    if (mediaTypes.count == 1 && [[mediaTypes objectAtIndex:0]  isEqual: @(PDSocialMediaTypeFacebook)]) {
        //Show only facebook button
        self.socialMediaTypesAvailable = FacebookOnly;
    } else if (mediaTypes.count == 1 && [[mediaTypes objectAtIndex:0] isEqual:@(PDSocialMediaTypeTwitter)]) {
        //Show only Twitter button
        self.socialMediaTypesAvailable = TwitterOnly;
    } else if (mediaTypes.count == 2) {
        //Show two buttons
        self.socialMediaTypesAvailable = FacebookAndTwitter;
    } else {
        //too many or not enough
    }
    
    [self setupForReward:reward];
    return self;
}

- (void) setupForReward:(PDReward*)reward {
    _reward = reward;
    _rewardTitleString = _reward.rewardDescription;
    _rewardRulesString = _reward.rewardRules;
    _rewardActionsString = [self actionText];
    if (_reward.coverImage) {
        _rewardImage = _reward.coverImage;
    } else {
        //TODO: Some Default
    }
    _textviewPlaceholder = @"What are you up to?";
    if (_reward.twitterPrefilledMessage) {
        _textviewPrepopulatedString = _reward.twitterPrefilledMessage;
    }
    if (_reward.twitterForcedTag) {
        _forcedTagString = _reward.twitterForcedTag;
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
                    action = @"Check-in or Tweet Required";
                    break;
                case PDRewardActionPhoto:
                    action = @"Photo Required";
                    break;
                case PDRewardActionNone:
                    action = @"No Action Required";
                default:
                    action = @"No Action Required";
                    break;
            }
        } else if ([types[0] isEqualToNumber:@(PDSocialMediaTypeFacebook)]) {
            //Facebook Only
            switch (_reward.action) {
                case PDRewardActionCheckin:
                    action = @"Check-in Required";
                    break;
                case PDRewardActionPhoto:
                    action = @"Photo Required";
                    break;
                case PDRewardActionNone:
                    action = @"No Action Required";
                default:
                    action = @"No Action Required";
                    break;
            }
        } else if ([types[0] isEqualToNumber:@(PDSocialMediaTypeTwitter)]) {
            //Twitter Only
            switch (_reward.action) {
                case PDRewardActionCheckin:
                    action = @"Tweet Required";
                    break;
                case PDRewardActionPhoto:
                    action = @"Tweet with Photo Required";
                    break;
                case PDRewardActionNone:
                    action = @"No Action Required";
                default:
                    action = @"No Action Required";
                    break;
            }
        }
    } else if (types.count == 0) {
        switch (_reward.action) {
            case PDRewardActionCheckin:
                action = @"Check-in Required";
                break;
            case PDRewardActionPhoto:
                action = @"Photo Required";
                break;
            case PDRewardActionNone:
                action = @"No Action Required";
            default:
                action = @"No Action Required";
                break;
        }
    }
    return action;
}

- (void) toggleFacebook {
    if (_mustFacebook) {
        _willFacebook = YES;
        UIAlertView *fbV = [[UIAlertView alloc] initWithTitle:@"Cannot Deselect" message:@"This reward must be claimed with a Facebook post. You can also post to Twitter if you wish" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [fbV show];
        return;
    }
    
    if (_willFacebook) {
        _willFacebook = NO;
        [_viewController.facebookButton setSelected:NO];
        return;
    }
    
    if ([[PDSocialMediaManager manager] isLoggedInWithFacebook]) {
        _willFacebook = YES;
        [_viewController.facebookButton setSelected:YES];
    } else {
        [[PDSocialMediaManager manager] loginWithFacebookReadPermissions:@[@"public_profile", @"email", @"user_birthday", @"user_posts", @"user_friends", @"user_education_history"] registerWithPopdeem:YES success:^(void) {
            _willFacebook = YES;
            [_viewController.facebookButton setSelected:YES];
        } failure:^(NSError *error) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"We couldnt connect you to Facebook" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [av show];
            _willFacebook = NO;
            [_viewController.facebookButton setSelected:NO];
        }];
    }
}

- (void) toggleTwitter {
    if (_mustTweet) {
        _willTweet = YES;
        UIAlertView *twitterV = [[UIAlertView alloc] initWithTitle:@"Cannot Deselect" message:@"This reward must be claimed with a tweet. You can also post to Facebook if you wish" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [twitterV show];
        return;
    }
    
    if (_willTweet) {
        _willTweet = NO;
        [_viewController.twitterForcedTagLabel setHidden:YES];
        [_viewController.twitterCharacterCountLabel setHidden:YES];
        [_viewController.twitterButton setSelected:NO];
        return;
    }
    
    _willTweet = YES;
    [_viewController.twitterButton setSelected:YES];
    [_viewController.twitterForcedTagLabel setHidden:NO];
    [_viewController.twitterCharacterCountLabel setHidden:NO];
    [self calculateTwitterCharsLeft];
}

- (void) addPhotoAction {
    
}

- (void) claimAction {
    
}

- (void) calculateTwitterCharsLeft {
    
}

@end
