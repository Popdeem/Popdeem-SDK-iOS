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
#import "PDSocialMediaFriend.h"
#import "PDSocialMediaManager.h"
#import "PDModalLoadingView.h"
#import "PDAPIClient.h"
#import "PDUtils.h"

@interface PDClaimViewModel()
@property (nonatomic) BOOL mustTweet;
@property (nonatomic) BOOL willTweet;
@property (nonatomic) BOOL mustFacebook;
@property (nonatomic) BOOL willFacebook;

@property (nonatomic, strong) PDModalLoadingView *loadingView;
@property (nonatomic, strong) UIImage *image;
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
  
  if (mediaTypes.count == 1 && [[mediaTypes objectAtIndex:0]  isEqualToNumber: @(FacebookOnly)]) {
    //Show only facebook button
    self.socialMediaTypesAvailable = FacebookOnly;
    _willFacebook = YES;
  } else if (mediaTypes.count == 1 && [[mediaTypes objectAtIndex:0] isEqualToNumber:@(TwitterOnly)]) {
    //Show only Twitter button
    self.socialMediaTypesAvailable = TwitterOnly;
    _willTweet = YES;
  } else if (mediaTypes.count == 2) {
    //Show two buttons
    self.socialMediaTypesAvailable = FacebookAndTwitter;
    _willFacebook = YES;
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
  _rewardTitleString = _reward.rewardDescription;
  _rewardRulesString = _reward.rewardRules;
  _rewardActionsString = [self actionText];
  if (_reward.coverImage) {
    _rewardImage = _reward.coverImage;
  } else {
    //TODO: Some Default
  }
  _textviewPlaceholder = localizedStringForKey(@"popdeem.claim.text.placeholder", @"What are you up to?";
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

- (void) calculateTwitterCharsLeft {
  
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

- (void) keyboardWillHide:(NSNotification*)notification {
  
}

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Claiming -

- (void) claimAction {
  if (!_willTweet && !_willFacebook) {
    UIAlertView *noPost = [[UIAlertView alloc] initWithTitle:@"No Network Selected" message:@"You must select at least one social network in order to complete this action." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [noPost show];
    return;
  }
  
  if (_willTweet) {
    [[PDSocialMediaManager manager] verifyTwitterCredentialsCompletion:^(BOOL connected, NSError *error){
      if (!connected) {
        [self connectTwitter:^(){
          [self makeClaim];
        } failure:^(NSError *error) {
          UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Twitter not connected" message:@"You must connect your twitter account in order to post to Twitter" delegate:self cancelButtonTitle:@"Back" otherButtonTitles: nil];
          [av show];
        }];
        return;
      }
      if (_viewController.twitterCharacterCountLabel.text.integerValue < 0) {
        UIAlertView *tooMany = [[UIAlertView alloc] initWithTitle:@"Tweet Too Long" message:@"You have written a post longer than the allowed 140 characters. Please shorten your post." delegate:self cancelButtonTitle:@"Back" otherButtonTitles: nil];
        [tooMany show];
        return;
      }
      [self makeClaim];
    }];
    return;
  }
  if ([_viewController.textView isFirstResponder]) {
    [_viewController.textView resignFirstResponder];
  }
  [self makeClaim];
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
  
  PDAPIClient *client = [PDAPIClient sharedInstance];
  NSString *message = [_viewController.textView text];
  
  if (_reward.twitterForcedTag) {
    message = [message stringByAppendingFormat:@" %@",_reward.twitterForcedTag];
  }
    
  NSMutableArray *taggedFriends = [NSMutableArray array];
  for (PDSocialMediaFriend *f in [PDUser taggableFriends]) {
    if (f.selected) {
      [taggedFriends addObject:f.tagIdentifier];
    }
  }
  
  __block NSInteger rewardId = _reward.identifier;
  //location?
  PDLocation *location = [[PDLocationStore locationsOrderedByDistanceToUser] firstObject];
  [client claimReward:_reward.identifier location:location withMessage:message taggedFriends:taggedFriends image:_image facebook:_willFacebook twitter:_willTweet success:^(){
    [self didClaimRewardId:rewardId];
  } failure:^(NSError *error){
    [self PDAPIClient:client didFailWithError:error];
  }];
  
  _loadingView = [[PDModalLoadingView alloc] initForView:self.viewController.view titleText:@"Claiming Reward" descriptionText:@"This could take up to 30 seconds"];
  [_loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
  [_loadingView showAnimated:YES];
}

- (void) didClaimRewardId:(NSInteger)rewardId {
  
  [_loadingView hideAnimated:YES];
  
  [PDRewardStore deleteReward:_reward.identifier];
  
  UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.claim.reward.claimed", @"Reward Claimed!") message:@"You can view your reward in your wallet" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [av show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  [self.viewController dismissViewControllerAnimated:YES completion:^{}];
}


- (void) PDAPIClient:(PDAPIClient *)client didFailWithError:(NSError *)error {
  NSLog(@"Error: %@",error);
  [_loadingView hideAnimated:YES];
  UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.sorry", @"Sorry") message:@"Something went wrong. Please try again later" delegate:self cancelButtonTitle:@"Back" otherButtonTitles:nil];
  [av show];
}

- (void) connectTwitter:(void (^)(void))success failure:(void (^)(NSError *failure))failure {
  PDSocialMediaManager *manager = [[PDSocialMediaManager alloc] initForViewController:_viewController];
  
  _loadingView = [[PDModalLoadingView alloc] initForView:self.viewController.view titleText:translationForKey(@"popdeem.common.wait", @"Please wait") descriptionText:translationForKey(@"popdeem.claim.twitter.connect", @"Connecting Twitter")];
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


@end
