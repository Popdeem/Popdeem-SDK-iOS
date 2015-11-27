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
@property (nonatomic, strong) UIWindow *alertWindow;

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) BOOL didAddPhoto;
@end

@implementation PDClaimViewModel

- (instancetype) init {
  if (self = [super init]) {
    return self;
  }
  return nil;
}

- (instancetype) initWithMediaTypes:(NSArray*)mediaTypes andReward:(PDReward*)reward {
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
  _textviewPlaceholder = translationForKey(@"popdeem.claim.text.placeholder", @"What are you up to?");
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
    UIAlertView *fbV = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.claim.reward.cant.deselect", @"Cannot deselect") message:@"This reward must be claimed with a Facebook post. You can also post to Twitter if you wish" delegate:self cancelButtonTitle:translationForKey(@"common.ok", @"OK") otherButtonTitles:nil];
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
      UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"common.storry", @"Sorry") message:translationForKey(@"popdeem.claim.facebook.connect", @"We couldnt connect you to Facebook") delegate:nil cancelButtonTitle:nil otherButtonTitles:translationForKey(@"common.ok", @"OK"), nil];
      [av show];
      _willFacebook = NO;
      [_viewController.facebookButton setSelected:NO];
    }];
  }
}

- (void) toggleTwitter {
  if (_mustTweet) {
    _willTweet = YES;
    UIAlertView *twitterV = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.claim.reward.cant.deselect", @"Cannot deselect") message:translationForKey(@"popdeem.claim.connect.message", @"This reward must be claimed with a tweet. You can also post to Facebook if you wish") delegate:self cancelButtonTitle:translationForKey(@"common.ok", @"OK") otherButtonTitles:nil];
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
  [self showPhotoActionSheet];
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

- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Claiming -

- (void) claimAction {
  if (!_willTweet && !_willFacebook) {
    UIAlertView *noPost = [[UIAlertView alloc] initWithTitle:translationForKey(@"common.error", @"Error") message:translationForKey(@"popdeem.claim.networkerror",  @"No Network Selected, you must select at least one social network in order to complete this action.") delegate:self cancelButtonTitle:translationForKey(@"common.ok", @"OK") otherButtonTitles:nil];
    [noPost show];
    return;
  }

  if (_willTweet) {
    [[PDSocialMediaManager manager] verifyTwitterCredentialsCompletion:^(BOOL connected, NSError *error){
      if (!connected) {
        [self connectTwitter:^(){
          [self makeClaim];
        } failure:^(NSError *error) {
          UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"common.error", @"Error") message:translationForKey(@"popdeem.claim.twitter.notconnected", @"Twitter not connected, you must connect your twitter account in order to post to Twitter") delegate:self cancelButtonTitle:translationForKey(@"common.back", @"Back") otherButtonTitles: nil];
          [av show];
        }];
        return;
      }
      if (_viewController.twitterCharacterCountLabel.text.integerValue < 0) {
        UIAlertView *tooMany = [[UIAlertView alloc] initWithTitle:translationForKey(@"common.error", @"Error") message:translationForKey(@"popdeem.claim.tweet.toolong", @"Tweet too long, you have written a post longer than the allowed 140 characters. Please shorten your post.") delegate:self cancelButtonTitle:translationForKey(@"common.back", @"Back") otherButtonTitles: nil];
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

  _loadingView = [[PDModalLoadingView alloc] initForView:self.viewController.view titleText:translationForKey(@"popdeem.claim.reward.claiming", @"Claiming Reward") descriptionText:translationForKey(@"popdeem.claim.reward.claiming.message", @"This could take up to 30 seconds")];
  [_loadingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
  [_loadingView showAnimated:YES];
}

- (void) didClaimRewardId:(NSInteger)rewardId {

  [_loadingView hideAnimated:YES];

  [PDRewardStore deleteReward:_reward.identifier];

  UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.claim.reward.claimed", @"Reward Claimed!") message:translationForKey(@"popdeem.claim.reward.success", @"You can view your reward in your wallet") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [av show];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  [self.viewController dismissViewControllerAnimated:YES completion:^{}];
}


- (void) PDAPIClient:(PDAPIClient *)client didFailWithError:(NSError *)error {
  NSLog(@"Error: %@",error);
  [_loadingView hideAnimated:YES];
  UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.sorry", @"Sorry") message:translationForKey(@"popdeem.common.something.wrong", @"Something went wrong. Please try again later") delegate:self cancelButtonTitle:translationForKey(@"common.back", @"Back") otherButtonTitles:nil];
  [av show];
}

#pragma mark - Connecting Twitter -
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
                     NSLog(@"Done!");
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

@end
