//
//  PDClaimViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 26/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDUIClaimViewController.h"
#import "PDUIClaimViewModel.h"
#import "PDUser.h"
#import "PDUIKitUtils.h"
#import "PDUtils.h"
#import "PDUIRewardTableViewCell.h"
#import "PDLocationValidator.h"
#import "PDTheme.h"
#import "PDUIModalLoadingView.h"
#import "PDUIFriendPickerViewController.h"
#import "PDUser+Facebook.h"
#import "PDSocialMediaFriend.h"
#import "PDTheme.h"
#import "PDUIInstagramVerifyViewController.h"

@interface PDUIClaimViewController () {
  NSArray *_mediaTypes;
  PDReward *_reward;
  PDLocation *_location;
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

@property (nonatomic) BOOL keyboardIsUp;
@end

@implementation PDUIClaimViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
  if (self = [self initWithNibName:@"PDUIClaimViewController" bundle:podBundle]) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = translationForKey(@"popdeem.claims.title", @"Claim");
    self.friendPicker = [[PDUIFriendPickerViewController alloc] initFromNib];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginSuccess) name:InstagramLoginSuccess object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginFailure) name:InstagramLoginFailure object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramPostMade) name:PDUserLinkedToInstagram object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramVerifySuccess) name:InstagramVerifySuccess object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramVerifyFailure) name:InstagramVerifyFailure object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramVerifyNoAttempt) name:InstagramVerifyNoAttempt object:nil];
    return self;
  }
  return nil;
}

- (id) initWithMediaTypes:(NSArray*)mediaTypes andReward:(PDReward*)reward location:(PDLocation*)location {
  CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
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
  [_textView setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 14)];
}

- (void) verifyLocation {
  _locationValidator = [[PDLocationValidator alloc] init];
  if (_reward.verifyLocation == NO) {
    _viewModel.locationVerified = YES;
    [_locationFailedView setHidden:YES];
    [UIView animateWithDuration:1.0 animations:^{
      self.locationVerificationViewHeightConstraint.constant = 0;
    }];
    return;
  }
  [_locationValidator validateLocationForReward:_reward completion:^(BOOL validated, PDLocation *closestLocation){
    _location = closestLocation;
    _viewModel.location = closestLocation;
    if (_loadingView) {
      [_loadingView hideAnimated:YES];
    }
    if (validated) {
      _viewModel.locationVerified = YES;
      [_locationFailedView setHidden:YES];
      [UIView animateWithDuration:1.0 animations:^{
        self.locationVerificationViewHeightConstraint.constant = 0;
				[self.locationVerificationView setHidden:YES];
      }];
    } else {
      _viewModel.locationVerified = NO;
      [_locationFailedView setHidden:NO];
      [self.view bringSubviewToFront:_locationFailedView];
      [UIView animateWithDuration:1.0 animations:^{
        self.locationVerificationViewHeightConstraint.constant = 50;
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
	
	[self.twitterForcedTagLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
  [_refreshLocationButton addTarget:self action:@selector(refreshLocationTapped) forControlEvents:UIControlEventTouchUpInside];
  [_refreshLocationButton setUserInteractionEnabled:YES];
}

- (void) setupView {
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
}

- (void) viewWillAppear:(BOOL)animated {
  [self renderView];
  [self drawBorders];
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
  
  NSMutableAttributedString *attWith = [[NSMutableAttributedString alloc] initWithString:@"With " attributes:@{NSForegroundColorAttributeName:PopdeemColor(@"popdeem.colors.secondaryFontColor"),NSFontAttributeName:PopdeemFont(@"popdeem.fonts.primaryFont", 10)}];
  
  NSMutableAttributedString *attNames = [[NSMutableAttributedString alloc] initWithString:withString attributes:@{NSForegroundColorAttributeName:PopdeemColor(@"popdeem.colors.primaryAppColor"),NSFontAttributeName:PopdeemFont(@"popdeem.fonts.primaryFont", 10)}];
  
  NSMutableAttributedString *whole = [[NSMutableAttributedString alloc] initWithAttributedString:attWith];
  [whole appendAttributedString:attNames];
  
  [_withLabel setAttributedText:whole];
  [self.view bringSubviewToFront:_withLabel];
  
  if (_viewModel.willTweet) {
    [self.twitterForcedTagLabel setHidden:NO];
    if (_viewModel.reward.twitterForcedTag) {
      [self.twitterForcedTagLabel setText:[NSString stringWithFormat:@"%@ Required",_viewModel.reward.twitterForcedTag]];
    }
    [self.twitterCharacterCountLabel setHidden:NO];
    [_viewModel calculateTwitterCharsLeft];
  }
	if (_viewModel.willInstagram) {
		[self.twitterForcedTagLabel setHidden:NO];
		if (_viewModel.reward.instagramForcedTag) {
			[self.twitterForcedTagLabel setTextColor:[NSString stringWithFormat:@"%@ Required", _viewModel.reward.instagramForcedTag]];
		}
		[self.twitterCharacterCountLabel setHidden:YES];
	}
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
  [_verifyLocationLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryFontColor")];
  [_verifyLocationLabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 10)];
  
  [_facebookButton setImage:[UIImage imageNamed:@"pduikit_fbbutton_selected"] forState:UIControlStateSelected];
  [_facebookButton setImage:[UIImage imageNamed:@"pduikit_fbbutton_deselected"] forState:UIControlStateNormal];
  [_facebookButton setTitleColor:[UIColor colorWithRed:0.169 green:0.247 blue:0.537 alpha:1.000] forState:UIControlStateSelected];
  [_facebookButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
  
  [_twitterButton setImage:[UIImage imageNamed:@"pduikit_twitterbutton_deselected"] forState:UIControlStateNormal];
  [_twitterButton setImage:[UIImage imageNamed:@"pduikit_twitterbutton_selected"] forState:UIControlStateSelected];
  [_twitterButton setTitleColor:[UIColor colorWithRed:0.200 green:0.412 blue:0.596 alpha:1.000] forState:UIControlStateSelected];
  [_twitterButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
  
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
	
  _facebookButtonViewBordersLayer = [CALayer layer];
  _facebookButtonViewBordersLayer.borderColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1].CGColor;
  _facebookButtonViewBordersLayer.borderWidth = 0.5;
  _facebookButtonViewBordersLayer.frame = CGRectMake(-1, 0, _facebookButton.frame.size.width+1, _facebookButton.frame.size.height);
  [_facebookButton.layer addSublayer:_facebookButtonViewBordersLayer];
  _facebookButton.clipsToBounds = YES;
  
  _twitterButtonViewBordersLayer = [CALayer layer];
  _twitterButtonViewBordersLayer.borderColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1].CGColor;
  _twitterButtonViewBordersLayer.borderWidth = 0.5;
  _twitterButtonViewBordersLayer.frame = CGRectMake(0, 0, _twitterButton.frame.size.width+1, _twitterButton.frame.size.height);
  [_twitterButton.layer addSublayer:_twitterButtonViewBordersLayer];
  _twitterButton.clipsToBounds = YES;
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
  UIBarButtonItem *typingDone = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hiderTap)];
  
  self.navigationItem.rightBarButtonItem = typingDone;
  self.navigationItem.hidesBackButton = YES;
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
  [UIView animateWithDuration:0.5
                        delay:0.0
                      options: UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     
                     [_keyboardHiderView setHidden:YES];
                     if (!IS_IPHONE_4_OR_LESS) {
                       _rewardInfoViewHeightConstraint.constant = (IS_IPHONE_4_OR_LESS) ? 0 : 100;
                     }
                     self.locationVerificationViewHeightConstraint.constant = _viewModel.locationVerified ? 0 : 50;
                     [_textView resignFirstResponder];
										 _keyboardIsUp = NO;
                     [_rewardInfoView setHidden:NO];
                     self.navigationItem.rightBarButtonItem = nil;
                     self.navigationItem.hidesBackButton = NO;
                     [self setTitle:translationForKey(@"popdeem.claim.getreward", @"Claim Reward")];
                   } completion:^(BOOL finished){}];
}

- (void) keyboardDown {
	_keyboardIsUp = NO;
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
  [_viewModel imagePickerController:picker didFinishPickingMediaWithInfo:info];
}

- (IBAction)addFriendsButtonTapped:(id)sender {
  goingToTag = YES;
  [self.navigationController pushViewController:_friendPicker animated:YES];
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
}
- (IBAction)facebookSwitchToggled:(id)sender {
	[_viewModel toggleFacebook];
}
- (IBAction)twitterSwitchToggled:(id)sender {
	[_viewModel toggleTwitter];
}

- (IBAction)instagramSwitchToggled:(id)sender {
	[_viewModel instagramSwitchToggled:sender];
}

- (void) instagramLoginSuccess {
	[_instagramSwitch setOn:YES animated:NO];
	_viewModel.willInstagram = YES;
	NSLog(@"Instagram Connected");
}

- (void) instagramLoginFailure {
	NSLog(@"Instagram Not Connected");
	_viewModel.willInstagram = NO;
	[_instagramSwitch setOn:NO animated:YES];
}

- (void) instagramPostMade {
	
	PDUIInstagramVerifyViewController *verifyController = [[PDUIInstagramVerifyViewController alloc] initForParent:self.navigationController forReward:_viewModel.reward];
	self.definesPresentationContext = YES;
	verifyController.modalPresentationStyle = UIModalPresentationOverFullScreen;
	[self presentViewController:verifyController animated:YES completion:^(void){
		
	}];
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

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
