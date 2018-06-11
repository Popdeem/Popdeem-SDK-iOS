//
//  PDClaimViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 26/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//
#import "PopdeemSDK.h"
#import "PDUIClaimViewController.h"
#import "PDUIKitUtils.h"
#import "PDUtils.h"
#import "PDUIRewardTableViewCell.h"
#import "PDLocationValidator.h"
#import "PDUIFriendPickerViewController.h"
#import "PDUser+Facebook.h"
#import "PDSocialMediaFriend.h"
#import "PDUISelectNetworkViewController.h"
#import "PDUIPostScanViewController.h"

@interface PDUIClaimViewController () {
  NSArray *_mediaTypes;
  PDReward *_reward;
  BOOL goingToTag;
}

@property (nonatomic, strong) CALayer *textViewBordersLayer;
@property (nonatomic, strong) CALayer *buttonsViewBordersLayer;
@property (nonatomic, strong) CALayer *twitterButtonViewBordersLayer;
@property (nonatomic, strong) CALayer *claimViewBordersLayer;
@property (nonatomic, strong) CALayer *facebookButtonViewBordersLayer;

@property (nonatomic, strong) PDLocationValidator *locationValidator;

@property (nonatomic, strong) PDUIRewardTableViewCell *rewardTableViewCell;

@property (nonatomic, strong) PDUIModalLoadingView *loadingView;

@property (nonatomic, strong) PDUIFriendPickerViewController *friendPicker;

@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *rewardInfoViewHeightConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *locationVerificationViewHeightConstraint;

@end

@implementation PDUIClaimViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
  if (self = [self initWithNibName:@"PDUIClaimViewController" bundle:podBundle]) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = translationForKey(@"popdeem.claims.title", @"Claim");
    self.friendPicker = [[PDUIFriendPickerViewController alloc] initFromNib];
    return self;
  }
  return nil;
}

- (id) initWithMediaTypes:(NSArray*)mediaTypes andReward:(PDReward*)reward location:(PDLocation*)location {
  if (self = [self initFromNib]) {
    _location = location;
    _mediaTypes = mediaTypes;
    _reward = reward;
    
    self.locationVerificationViewHeightConstraint.constant = 0;
    return self;
  }
  return nil;
}


- (void) setupWithReward:(PDReward*)reward {
  _reward = reward;
  _mediaTypes = reward.socialMediaTypes;
  _viewModel = [[PDUIClaimViewModel alloc] initWithMediaTypes:_mediaTypes andReward:_reward location:_location controller:self];
  [_viewModel setViewController:self];
  [_textView setDelegate:_viewModel];
	[_textView setScrollEnabled:YES];
  [_textView setFont:PopdeemFont(PDThemeFontPrimary, 14)];
  [self styleNavbar];
}

- (void) verifyLocation {
  _locationValidator = [[PDLocationValidator alloc] init];
	_viewModel.locationVerified = YES;
	[_locationFailedView setHidden:YES];
	[UIView animateWithDuration:1.0 animations:^{
		self.locationVerificationViewHeightConstraint.constant = 0;
		[self.locationVerificationView setHidden:YES];
	}];
//	
  if (_reward.verifyLocation == NO) {
    _viewModel.locationVerified = YES;
    [_locationFailedView setHidden:YES];
    [UIView animateWithDuration:1.0 animations:^{
      self.locationVerificationViewHeightConstraint.constant = 0;
    }];
    return;
  }
  __weak typeof(self) weakSelf = self;
  [_locationValidator validateLocationForReward:_reward completion:^(BOOL validated, PDLocation *closestLocation){
    weakSelf.location = closestLocation;
    weakSelf.viewModel.location = closestLocation;
    if (weakSelf.loadingView) {
      [weakSelf.loadingView hideAnimated:YES];
    }
    if (validated) {
      weakSelf.viewModel.locationVerified = YES;
      [weakSelf.locationFailedView setHidden:YES];
      [UIView animateWithDuration:1.0 animations:^{
        weakSelf.locationVerificationViewHeightConstraint.constant = 0;
				[weakSelf.locationVerificationView setHidden:YES];
      }];
    } else {
      weakSelf.viewModel.locationVerified = NO;
      [weakSelf.locationFailedView setHidden:NO];
      [weakSelf.view bringSubviewToFront:weakSelf.locationFailedView];
      [UIView animateWithDuration:1.0 animations:^{
        weakSelf.locationVerificationViewHeightConstraint.constant = 50;
      }];
    }
  }];
}

- (void) refreshLocationTapped {
  _loadingView = [[PDUIModalLoadingView alloc] initForView:self.view titleText:@"Checking Location" descriptionText:@"Please wait a moment while we verify your location"];
  [_loadingView showAnimated:YES];
  [self performSelector:@selector(verifyLocation) withObject:nil afterDelay:1.0];
}



- (void)viewDidLoad {
  [super viewDidLoad];
  [_locationFailedView setHidden:YES];
  
  
  [self setupView];
	_viewModel = [[PDUIClaimViewModel alloc] initWithMediaTypes:_mediaTypes andReward:_reward location:_location controller:self];
  [_viewModel setViewController:self];
  [_textView setDelegate:_viewModel];
  [_textView setFont:[UIFont systemFontOfSize:14]];
	if (_viewModel.textviewPrepopulatedString) {
		[_textView setText:_viewModel.textviewPrepopulatedString];
		[_viewModel validateHashTag];
	}
	if ([[PDUser sharedInstance] isTester]) {
		self.locationVerificationViewHeightConstraint.constant = 0;
	} else {
		self.locationVerificationViewHeightConstraint.constant = 0;
	}
	
	[self.twitterForcedTagLabel setTextColor:[UIColor lightGrayColor]];
	[self.addHashtagButton setHidden:NO];
    UIColor *tertiaryFontColor = [UIColor blackColor];
    if ([PDTheme.sharedInstance hasValueForKey:PDThemeColorTertiaryFont]) {
        tertiaryFontColor = PopdeemColor(PDThemeColorTertiaryFont);
    } else {
        tertiaryFontColor = PopdeemColor(PDThemeColorPrimaryApp);
    }
	[self.addHashtagButton setTintColor:[UIColor blackColor]];
  [self.addHashtagButton setTitleColor:tertiaryFontColor forState:UIControlStateNormal];
  [_refreshLocationButton addTarget:self action:@selector(refreshLocationTapped) forControlEvents:UIControlEventTouchUpInside];
  [_refreshLocationButton setUserInteractionEnabled:YES];
  
  [self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
  
  [self.shareButton setBackgroundColor:PopdeemColor(PDThemeColorPrimaryApp)];
  [self.shareButton setTitleColor:PopdeemColor(PDThemeColorPrimaryInverse) forState:UIControlStateNormal];
  [self.shareButton.layer setCornerRadius:3.0];
  
  [self.alreadySharedButton setTintColor:[UIColor blackColor]];
  [[self.alreadySharedButton layer] setBorderColor:[UIColor blackColor].CGColor];
  [[self.alreadySharedButton layer] setBorderWidth:1.0f];
  [[self.alreadySharedButton layer] setCornerRadius:3.0];
  if (_reward.forcedTag) {
    [self.alreadySharedButton setTitle:[NSString stringWithFormat:@"I've already shared with %@", _reward.forcedTag] forState:UIControlStateNormal];
  } else {
    [self.alreadySharedButton setTitle:@"I've already shared" forState:UIControlStateNormal];
  }
  [self.alreadySharedButton.titleLabel setFont:PopdeemFont(PDThemeFontPrimary, 15.0)];
  [self.shareButton.titleLabel setFont:PopdeemFont(PDThemeFontPrimary, 15.0)];
  [self styleNavbar];
}

- (void) setupView {
	if (_homeController) {
			self.view.frame = _homeController.view.frame;
	}
//  [self.view setBackgroundColor:[UIColor colorWithRed:239/255 green:239/255 blue:244/255 alpha:1.0]];
  /*
  float currentY = 0;
  float viewWidth = self.view.frame.size.width;
  PDRewardTableViewCell *rewardCell = [[PDRewardTableViewCell alloc] initWithFrame:CGRectMake(0, currentY, viewWidth, 85) reward:_reward];
  [self.view addSubview:rewardCell];
  currentY += 85;
  _textView = [[PD_SZTextView alloc] initWithFrame:CGRectMake(0, currentY, viewWidth, 130)];
  [self.view addSubview:_textView];
  currentY += 130;
  _withLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, viewWidth, 21)];
  */
	[_addPhotoButton setBackgroundColor:[UIColor clearColor]];
	[_addFriendsButton setBackgroundColor:[UIColor clearColor]];
	[_addHashtagButton setBackgroundColor:[UIColor clearColor]];
	
}

- (void) viewWillAppear:(BOOL)animated {
  [self renderView];
  [self drawBorders];
  [self styleNavbar];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
  [[NSNotificationCenter defaultCenter] addObserver:_viewModel
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginSuccess) name:InstagramLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginFailure:) name:InstagramLoginFailure object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginUserDismiss) name:InstagramLoginuserDismissed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramPostMade) name:PDUserLinkedToInstagram object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramVerifySuccess) name:InstagramVerifySuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramVerifyFailure) name:InstagramVerifyFailure object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramVerifyNoAttempt) name:InstagramVerifyNoAttempt object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookWritePermSuccess) name:FacebookPublishSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookWritePermFailure) name:FacebookPublishFailure object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backFromInstagram) name:UIApplicationDidBecomeActiveNotification object:nil];
#pragma clang diagnostic pop
}

- (void) viewWillLayoutSubviews {
}

- (void) viewDidAppear:(BOOL)animated {
  [_rewardTableViewCell removeFromSuperview];
  _rewardTableViewCell = [[PDUIRewardTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) reward:_reward];
  [_rewardInfoView addSubview:_rewardTableViewCell];
  goingToTag = NO;
  UITapGestureRecognizer *hiderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiderTap)];
  [_keyboardHiderView addGestureRecognizer:hiderTap];
  [self verifyLocation];
  NSMutableArray *friendsTagged = [NSMutableArray array];
  for (PDSocialMediaFriend *friend in [PDUser taggableFriends]) {
    if (friend.selected) {
      [friendsTagged addObject:friend];
      [_withLabel setHidden:NO];
    }
  }
  
  if ([[PDUser taggableFriends] count] > 0) {
    [_addFriendsButton setHidden:NO];
  }
  
  NSMutableString *withString = [[NSMutableString alloc] init];
  if (friendsTagged.count > 2) {
    withString = [NSMutableString stringWithFormat:@"%@ and %lu others.",[[friendsTagged objectAtIndex:0] name], [friendsTagged count]-1];
  } else if (friendsTagged.count == 2) {
    withString = [NSMutableString stringWithFormat:@"%@ and %@",[[friendsTagged objectAtIndex:0] name], [[friendsTagged objectAtIndex:1] name]];
  } else if (friendsTagged.count == 1) {
    withString = [NSMutableString stringWithFormat:@"%@",[[friendsTagged objectAtIndex:0] name]];
  } else {
    [_withLabel setHidden:YES];
  }
  
  NSMutableAttributedString *attWith = [[NSMutableAttributedString alloc] initWithString:@"With " attributes:@{NSForegroundColorAttributeName:PopdeemColor(PDThemeColorSecondaryFont),NSFontAttributeName:PopdeemFont(PDThemeFontPrimary, 10)}];
  
  NSMutableAttributedString *attNames = [[NSMutableAttributedString alloc] initWithString:withString attributes:@{NSForegroundColorAttributeName:PopdeemColor(PDThemeColorPrimaryApp),NSFontAttributeName:PopdeemFont(PDThemeFontPrimary, 10)}];
  
  NSMutableAttributedString *whole = [[NSMutableAttributedString alloc] initWithAttributedString:attWith];
  [whole appendAttributedString:attNames];
  
  [_withLabel setAttributedText:whole];
  [self.view bringSubviewToFront:_withLabel];
  
  if (_viewModel.willTweet) {
    [self.twitterCharacterCountLabel setHidden:NO];
    [_viewModel calculateTwitterCharsLeft];
  }else {
    [self.twitterCharacterCountLabel setHidden:YES];
  }
  
  [self.twitterForcedTagLabel setHidden:NO];
  if (_reward.twitterForcedTag.length > 0) {
    [self.addHashtagButton setHidden:NO];
  }
  if (_viewModel.reward.forcedTag) {
    [self.twitterForcedTagLabel setText:[NSString stringWithFormat:@"%@ Required",_viewModel.reward.forcedTag]];
  } else if (_viewModel.reward.twitterForcedTag) {
    [self.twitterForcedTagLabel setText:[NSString stringWithFormat:@"%@ Required",_viewModel.reward.twitterForcedTag]];
  }
  
	AbraLogEvent(ABRA_EVENT_PAGE_VIEWED, (@{
																					ABRA_PROPERTYNAME_SOURCE_PAGE : ABRA_PROPERTYVALUE_PAGE_CLAIM,
																					ABRA_PROPERTYNAME_REWARD_TYPE : AbraKeyForRewardType(_reward.type),
																					ABRA_PROPERTYNAME_REWARD_ACTION : AbraKeyForRewardAction(_reward.action),
																					ABRA_PROPERTYNAME_NETWORKS_AVAILABLE : [self readableMediaTypesAvailable],
																					ABRA_PROPERTYNAME_REWARD_NAME : _reward.rewardDescription
																				}));
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) renderView {
  if (!IS_IPHONE_4_OR_LESS) {
    _rewardTableViewCell = [[PDUIRewardTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100) reward:_viewModel.reward];
    [self.rewardInfoView addSubview:_rewardTableViewCell];
  } else {
    self.rewardInfoViewHeightConstraint = 0;
  }
  [self.textView setPlaceholder:_viewModel.textviewPlaceholder];

  [_verifyLocationLabel setText:translationForKey(@"popdeem.claim.verifyLocationFailed", @"You must be at this location to claim this reward. Please come back later, or refresh your location.")];
  [_verifyLocationLabel setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
  [_verifyLocationLabel setFont:PopdeemFont(PDThemeFontPrimary, 10)];
	[_verifyLocationLabel setBackgroundColor:[UIColor clearColor]];
	[_refreshLocationButton setBackgroundColor:[UIColor clearColor]];
  [_facebookButton setImage:[UIImage imageNamed:@"pduikit_fbbutton_selected"] forState:UIControlStateSelected];
  [_facebookButton setImage:[UIImage imageNamed:@"pduikit_fbbutton_deselected"] forState:UIControlStateNormal];
  [_facebookButton setTitleColor:[UIColor colorWithRed:0.169 green:0.247 blue:0.537 alpha:1.000] forState:UIControlStateSelected];
  [_facebookButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
  
  [_twitterButton setImage:[UIImage imageNamed:@"pduikit_twitterbutton_deselected"] forState:UIControlStateNormal];
  [_twitterButton setImage:[UIImage imageNamed:@"pduikit_twitterbutton_selected"] forState:UIControlStateSelected];
  [_twitterButton setTitleColor:[UIColor colorWithRed:0.200 green:0.412 blue:0.596 alpha:1.000] forState:UIControlStateSelected];
  [_twitterButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
  
  if (PopdeemThemeHasValueForKey(@"popdeem.images.tableViewBackgroundImage")) {
    UIImageView *tvbg = [[UIImageView alloc] initWithFrame:self.view.frame];
    [tvbg setImage:PopdeemImage(@"popdeem.images.tableViewBackgroundImage")];
    [self.view addSubview:tvbg];
    [self.view sendSubviewToBack:tvbg];
  }
  
  switch (_viewModel.socialMediaTypesAvailable) {
    case FacebookOnly:
      [self.facebookButton setHidden:NO];
      [self.twitterButton setHidden:NO];
      [self.facebookButton setSelected:YES];
      [self.twitterButton setSelected:NO];
      break;
    case TwitterOnly:
      [self.facebookButton setHidden:NO];
      [self.twitterButton setHidden:NO];
      [self.facebookButton setSelected:NO];
      [self.twitterButton setSelected:YES];
      break;
    case FacebookAndTwitter:
      //Ensure both buttons are shown
      [self.facebookButton setHidden:NO];
      [self.twitterButton setHidden:NO];
      [self.facebookButton setSelected:YES];
      break;
    default:
      break;
  }
}

- (void) drawBorders {
  _buttonsViewBordersLayer = [CALayer layer];
  _buttonsViewBordersLayer.borderColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1].CGColor;
  _buttonsViewBordersLayer.borderWidth = 0.5;
  _buttonsViewBordersLayer.frame = CGRectMake(-1, 0, _controlButtonsView.frame.size.width+2, _controlButtonsView.frame.size.height);
  [_controlButtonsView.layer addSublayer:_buttonsViewBordersLayer];
  _controlButtonsView.clipsToBounds = YES;
  
  _textViewBordersLayer = [CALayer layer];
  _textViewBordersLayer.borderColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1].CGColor;
  _textViewBordersLayer.borderWidth = 0.5;
  _textViewBordersLayer.frame = CGRectMake(-1, 0, _textView.frame.size.width+2, 0.5);
  [_textView.layer addSublayer:_textViewBordersLayer];
	
//  _facebookButtonViewBordersLayer = [CALayer layer];
//  _facebookButtonViewBordersLayer.borderColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1].CGColor;
//  _facebookButtonViewBordersLayer.borderWidth = 0.5;
//  _facebookButtonViewBordersLayer.frame = CGRectMake(-1, 0, _facebookButton.frame.size.width+1, _facebookButton.frame.size.height);
//  [_facebookButton.layer addSublayer:_facebookButtonViewBordersLayer];
//  _facebookButton.clipsToBounds = YES;
//
  _twitterButtonViewBordersLayer = [CALayer layer];
  _twitterButtonViewBordersLayer.borderColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1].CGColor;
  _twitterButtonViewBordersLayer.borderWidth = 0.5;
  _twitterButtonViewBordersLayer.frame = CGRectMake(-1, 0, _twitterButton.frame.size.width+2, _twitterButton.frame.size.height);
  [_twitterButtonView.layer addSublayer:_twitterButtonViewBordersLayer];
  _twitterButtonView.clipsToBounds = YES;
  
  _twitterButtonViewBordersLayer = [CALayer layer];
  _twitterButtonViewBordersLayer.borderColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1].CGColor;
  _twitterButtonViewBordersLayer.borderWidth = 0.5;
  _twitterButtonViewBordersLayer.frame = CGRectMake(-1, 0, _twitterButtonView.frame.size.width+2, _twitterButtonView.frame.size.height);
  [_twitterButtonView.layer addSublayer:_twitterButtonViewBordersLayer];
  _twitterButtonView.clipsToBounds = YES;
}

- (IBAction)cameraButtonTapped:(id)sender {
  [_viewModel addPhotoAction];
}

- (IBAction)facebookButtonTapped:(id)sender {
  [_viewModel toggleFacebook];
}

- (IBAction)twitterButtonTapped:(id)sender {
  [_viewModel toggleTwitter];
}

- (IBAction)claimButtonTapped:(id)sender {
	[_claimButtonView setUserInteractionEnabled:NO];
  [_viewModel claimAction];
}

- (void) keyboardUp {
	if (_keyboardIsUp) {
		return;
	}
  [self.keyboardHiderView setHidden:NO];
  [self.view bringSubviewToFront:self.keyboardHiderView];
  [self.textView becomeFirstResponder];
  self.rewardInfoViewHeightConstraint.constant = 0;
  self.locationVerificationViewHeightConstraint.constant = 0;
  [self setTitle:translationForKey(@"popdeem.claim.addmessage", @"Add Message")];
  [self.view setNeedsDisplay];
	_keyboardIsUp = YES;
}

- (void) hiderTap {
  __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:0.5
                        delay:0.0
                      options: UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     
                     [weakSelf.keyboardHiderView setHidden:YES];
                     if (!IS_IPHONE_4_OR_LESS) {
                       weakSelf.rewardInfoViewHeightConstraint.constant = (IS_IPHONE_4_OR_LESS) ? 0 : 100;
                     }
                     weakSelf.locationVerificationViewHeightConstraint.constant = weakSelf.viewModel.locationVerified ? 0 : 50;
                     [weakSelf.textView resignFirstResponder];
										 weakSelf.keyboardIsUp = NO;
                     [weakSelf.rewardInfoView setHidden:NO];
                     self.navigationItem.rightBarButtonItem = nil;
                     self.navigationItem.hidesBackButton = NO;
                     [self setTitle:translationForKey(@"popdeem.claim.getreward", @"Claim Reward")];
                   } completion:^(BOOL finished){}];
	
	AbraLogEvent(ABRA_EVENT_ADDED_CLAIM_CONTENT, @{ABRA_PROPERTYNAME_TEXT : _textView.text});
}

- (void) keyboardDown {
	_keyboardIsUp = NO;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
  [_viewModel imagePickerController:picker didFinishPickingMediaWithInfo:info];
}


- (void) viewWillDisappear:(BOOL)animated {
  if (!goingToTag) {
    for (PDSocialMediaFriend *f in [PDUser taggableFriends]) {
      if (f.selected) {
        f.selected = NO;
      }
    }
  }
	[_textView resignFirstResponder];
  [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:_viewModel];
}


- (IBAction)facebookSwitchToggled:(id)sender {
	AbraLogEvent(ABRA_EVENT_TOGGLED_SOCIAL_BUTTON, (@{
																									 ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_FACEBOOK,
																									 ABRA_PROPERTYNAME_SOCIAL_BUTTON_STATE : ([(UISwitch*)sender isOn]) ? ABRA_PROPERTYVALUE_SOCIAL_BUTTON_STATE_ON: ABRA_PROPERTYVALUE_SOCIAL_BUTTON_STATE_OFF
																									 }));
	[_viewModel toggleFacebook];
}
- (IBAction)twitterSwitchToggled:(id)sender {
	AbraLogEvent(ABRA_EVENT_TOGGLED_SOCIAL_BUTTON, (@{
																									 ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_TWITTER,
																									 ABRA_PROPERTYNAME_SOCIAL_BUTTON_STATE : ([(UISwitch*)sender isOn]) ? ABRA_PROPERTYVALUE_SOCIAL_BUTTON_STATE_ON: ABRA_PROPERTYVALUE_SOCIAL_BUTTON_STATE_OFF
																									 }));
	[_viewModel toggleTwitter];
}

- (IBAction)instagramSwitchToggled:(id)sender {
	AbraLogEvent(ABRA_EVENT_TOGGLED_SOCIAL_BUTTON, (@{
																									 ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_INSTAGRAM,
																									 ABRA_PROPERTYNAME_SOCIAL_BUTTON_STATE : ([(UISwitch*)sender isOn]) ? ABRA_PROPERTYVALUE_SOCIAL_BUTTON_STATE_ON: ABRA_PROPERTYVALUE_SOCIAL_BUTTON_STATE_OFF
																									 }));
	[_viewModel instagramSwitchToggled:sender];
}

- (void) instagramLoginSuccess {
  dispatch_async(dispatch_get_main_queue(), ^{
    [_viewModel instagramLoginSuccess];
    [_instagramSwitch setOn:YES animated:NO];
    PDLog(@"Instagram Connected");
    AbraLogEvent(ABRA_EVENT_CONNECTED_ACCOUNT, (@{
                                                  ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_INSTAGRAM,
                                                  ABRA_PROPERTYNAME_SOURCE_PAGE : @"Claim Screen"
                                                  }));
  });
}

- (void) instagramLoginUserDismiss {
  dispatch_async(dispatch_get_main_queue(), ^{
    [_viewModel instagramLoginFailure];
    [_instagramSwitch setOn:NO animated:YES];
  });
}

- (void) instagramLoginFailure:(NSNotification*)notification{
  dispatch_async(dispatch_get_main_queue(), ^{
    [_viewModel instagramLoginFailure];
    [_instagramSwitch setOn:NO animated:YES];
    if ([[notification.userInfo objectForKey:@"NSLocalizedDescription"] rangeOfString:@"already connected"].location != NSNotFound) {
      UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sorry - Wrong Account" message:@"This social account has been linked to another user." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
      [av show];
    } else {
      UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                   message:@"There was a problem connecting your Instagram Account. Please try again later."
                                                  delegate:self
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
      [av show];
    }
  });
}

- (void) instagramPostMade {
	[self beginBackgroundUpdateTask];
	[self.viewModel makeClaim];
	PDLog(@"Background Task Started");
	
}

- (void) beginBackgroundUpdateTask {
	self.claimTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
		PDLog(@"Background Task Expired");
	}];
}

- (void) endBackgroundUpdateTask {
	[[UIApplication sharedApplication] endBackgroundTask: self.claimTask];
	self.claimTask = UIBackgroundTaskInvalid;
	PDLog(@"Background Task Ended");
	
}

- (void) instagramVerifySuccess {
	self.homeController.didClaim = YES;
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) instagramVerifyFailure {
	self.homeController.didClaim = NO;
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) instagramVerifyNoAttempt {
	self.homeController.didClaim = NO;
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) facebookWritePermSuccess {
	[self.viewModel makeClaim];
}

-(void) facebookWritePermFailure {
  
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString*) readableMediaTypesAvailable {
	switch ([self.viewModel socialMediaTypesAvailable]) {
		case FacebookOnly:
			return @"Facebook";
			break;
		case TwitterOnly:
			return @"Twitter";
			break;
		case InstagramOnly:
			return @"Instagram";
			break;
		case FacebookAndTwitter:
			return @"Facebook & Twitter";
			break;
		case FacebookAndInstagram:
			return @"Facebook & Instagram";
			break;
		case TwitterAndInstagram:
			return @"Twitter & Instagram";
			break;
		case Any:
			return @"Facebook, Twitter & Intagram";
			break;
	}
}

- (IBAction)addHashtagButtonPressed:(id)sender {
	NSString *hashtagString;
	if (_viewModel.willTweet) {
    if (_reward.forcedTag) {
      hashtagString = _reward.forcedTag;
    } else {
      hashtagString = _reward.twitterForcedTag;
    }
	} else if (_viewModel.willInstagram) {
    if (_reward.forcedTag) {
      hashtagString = _reward.forcedTag;
    } else {
      hashtagString = _reward.instagramForcedTag;;
    }
	} else {
		hashtagString = _reward.forcedTag;
	}
	
	if (_textView.text.length > 0) {
		hashtagString = [@" " stringByAppendingString:hashtagString];
	}
	
	NSString *newText = [self.textView.text stringByAppendingString:hashtagString];
	[self.textView setText:newText];
	[_viewModel validateHashTag];
}

- (IBAction)alreadySharedButtonPressed:(id)sender {
  PDUISelectNetworkViewController *selNet = [[PDUISelectNetworkViewController alloc] initWithMediaTypes:_mediaTypes andReward:_reward brand:_brand];
  self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
  [self.navigationController pushViewController:selNet animated:YES];
}

- (void) backFromInstagram {
  if (_viewModel.didGoToInstagram) {
    //We know user was at Instagram, and instagram post is being attempted
    NSLog(@"Back From Instagram");
    PDUIPostScanViewController *scan = [[PDUIPostScanViewController alloc] initWithReward:_reward network:INSTAGRAM_NETWORK];
    [self.navigationController pushViewController:scan animated:YES];
  }
}

- (void) styleNavbar {
  if (PopdeemThemeHasValueForKey(@"popdeem.nav")) {
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:PopdeemColor(PDThemeColorPrimaryApp)];
    [self.navigationController.navigationBar setTintColor:PopdeemColor(PDThemeColorPrimaryInverse)];
    
    UIFont *headerFont;
    if (PopdeemThemeHasValueForKey(PDThemeFontNavbar)) {
      headerFont = PopdeemFont(PDThemeFontNavbar, 22.0f);
    } else {
      headerFont = PopdeemFont(PDThemeFontBold, 17.0f);
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryInverse),
                                                                      NSFontAttributeName : headerFont
                                                                      }];
    
    [self.navigationController.navigationItem.rightBarButtonItem setTitleTextAttributes:@{
                                                                                          NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryInverse),
                                                                                          NSFontAttributeName : PopdeemFont(PDThemeFontNavbar, 17.0f)}
                                                                               forState:UIControlStateNormal];
    if (PopdeemThemeHasValueForKey(@"popdeem.images.navigationBar")){
      [self.navigationController.navigationBar setBackgroundImage:PopdeemImage(@"popdeem.images.navigationBar") forBarMetrics:UIBarMetricsDefault];
    }
  }
  
  //Brand Specific Theme
  if (_brand.theme != nil) {
    self.navigationController.navigationBar.translucent = NO;
    [self.navigationController.navigationBar setBarTintColor:PopdeemColorFromHex(_brand.theme.primaryAppColor)];
    [self.navigationController.navigationBar setTintColor:PopdeemColorFromHex(_brand.theme.primaryInverseColor)];
    
    UIFont *headerFont;
    if (PopdeemThemeHasValueForKey(PDThemeFontNavbar)) {
      headerFont = PopdeemFont(PDThemeFontNavbar, 17.0f);
    } else {
      headerFont = PopdeemFont(PDThemeFontBold, 17.0f);
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName : PopdeemColorFromHex(_brand.theme.primaryInverseColor),
                                                                      NSFontAttributeName : headerFont
                                                                      }];
    
    [self.navigationController.navigationItem.rightBarButtonItem setTitleTextAttributes:@{
                                                                                          NSForegroundColorAttributeName : PopdeemColorFromHex(_brand.theme.primaryInverseColor),
                                                                                          NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 16.0f)}
                                                                               forState:UIControlStateNormal];
  }
}

@end
