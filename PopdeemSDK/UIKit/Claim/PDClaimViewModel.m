//
//  PDClaimViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 26/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDClaimViewModel.h"
#import "PDClaimViewController.h"

@implementation PDClaimViewModel

- (id) init {
    if (self = [super init]) {
        return self;
    }
    return nil;
}

- (id) initWithMediaTypes:(NSArray*)mediaTypes {
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
            switch (reward.action) {
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
            switch (reward.action) {
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
            switch (reward.action) {
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
        switch (reward.action) {
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

- (CALayer*) textViewBordersLayer {
    _textViewBordersLayer = [CALayer layer];
    _textViewBordersLayer.borderColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1].CGColor;
    _textViewBordersLayer.borderWidth = 0.5;
    _textViewBordersLayer.frame = CGRectMake(-1, 0, _viewController.textView.frame.size.width+2, _viewController.textView.frame.size.height+1);
}

- (void) facebookButtonTapped {
    //Toggle the facebook
}

@end
