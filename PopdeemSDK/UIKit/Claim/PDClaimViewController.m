//
//  PDClaimViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 26/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDClaimViewController.h"
#import "PDClaimViewModel.h"
#import "PDUser.h"
#import "PDUIKitUtils.h"
#import "PDUtils.h"
#import "RewardTableViewCell.h"
#import "PDLocationValidator.h"
#import "LocationVisor.h"
#import "PDTheme.h"
#import "PDModalLoadingView.h"
#import "FriendPickerViewController.h"
#import "PDUser+Facebook.h"
#import "PDSocialMediaFriend.h"
#import "PDTheme.h"

@interface PDClaimViewController () {
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

@property (nonatomic, strong) LocationVisor *locationVisor;

@property (nonatomic, strong) PDModalLoadingView *loadingView;

@property (nonatomic, strong) FriendPickerViewController *friendPicker;

@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *rewardInfoViewHeightConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *locationVerificationViewHeightConstraint;
@end

@implementation PDClaimViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
  if (self = [self initWithNibName:@"PDClaimViewController" bundle:podBundle]) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = translationForKey(@"popdeem.claims.title", @"Claim");
    self.friendPicker = [[FriendPickerViewController alloc] initFromNib];
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
  _viewModel = [[PDClaimViewModel alloc] initWithMediaTypes:_mediaTypes andReward:_reward location:_location];
  [_viewModel setViewController:self];
  [_textView setDelegate:_viewModel];
  [_textView setFont:[UIFont systemFontOfSize:14]];
  [self renderView];
  [self drawBorders];
}

- (void) verifyLocation {
  _locationValidator = [[PDLocationValidator alloc] init];
  [_locationValidator validateLocationForReward:_reward completion:^(BOOL validated){
    if (_loadingView) {
      [_loadingView hideAnimated:YES];
    }
    if (validated) {
      _viewModel.locationVerified = YES;
      [_locationFailedView setHidden:YES];
      [UIView animateWithDuration:1.0 animations:^{
        self.locationVerificationViewHeightConstraint.constant = 0;
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
  _loadingView = [[PDModalLoadingView alloc] initForView:self.view titleText:@"Checking Location" descriptionText:@"Please wait a moment while we verify your location"];
  [_loadingView showAnimated:YES];
  [self performSelector:@selector(verifyLocation) withObject:nil afterDelay:1.0];
}

- (void) hideVisor {
  [_locationVisor hideAnimated:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_locationFailedView setHidden:YES];
  [self setupView];
  _viewModel = [[PDClaimViewModel alloc] initWithMediaTypes:_mediaTypes andReward:_reward location:_location];
  [_viewModel setViewController:self];
  [_textView setDelegate:_viewModel];
  [_textView setFont:[UIFont systemFontOfSize:14]];
  self.locationVerificationViewHeightConstraint.constant = 0;
  [_refreshLocationButton addTarget:self action:@selector(refreshLocationTapped) forControlEvents:UIControlEventTouchUpInside];
  [_refreshLocationButton setUserInteractionEnabled:YES];
  [self renderView];
  [self drawBorders];
}

- (void) setupView {
//  [self.view setBackgroundColor:[UIColor colorWithRed:239/255 green:239/255 blue:244/255 alpha:1.0]];
  /*
  float currentY = 0;
  float viewWidth = self.view.frame.size.width;
  RewardTableViewCell *rewardCell = [[RewardTableViewCell alloc] initWithFrame:CGRectMake(0, currentY, viewWidth, 85) reward:_reward];
  [self.view addSubview:rewardCell];
  currentY += 85;
  _textView = [[PD_SZTextView alloc] initWithFrame:CGRectMake(0, currentY, viewWidth, 130)];
  [self.view addSubview:_textView];
  currentY += 130;
  _withLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, viewWidth, 21)];
  */
}

- (void) viewDidAppear:(BOOL)animated {
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
  
  NSMutableAttributedString *attWith = [[NSMutableAttributedString alloc] initWithString:@"With " attributes:@{NSForegroundColorAttributeName:PopdeemColor(@"popdeem.claim.withLabel.fontColor"),NSFontAttributeName:PopdeemFont(@"popdeem.claim.friendsLabel.font", 10)}];
  
  NSMutableAttributedString *attNames = [[NSMutableAttributedString alloc] initWithString:withString attributes:@{NSForegroundColorAttributeName:PopdeemColor(@"popdeem.claim.withLabel.highlightedFontColor"),NSFontAttributeName:PopdeemFont(@"popdeem.claim.friendsLabel.font", 10)}];
  
  NSMutableAttributedString *whole = [[NSMutableAttributedString alloc] initWithAttributedString:attWith];
  [whole appendAttributedString:attNames];
  
  [_withLabel setAttributedText:whole];
  [self.view bringSubviewToFront:_withLabel];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) renderView {
  [self.rewardInfoView addSubview:[[RewardTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) reward:_viewModel.reward]];
  [self.textView setPlaceholder:_viewModel.textviewPlaceholder];

  [_verifyLocationLabel setText:translationForKey(@"popdeem.claim.verifyLocationFailed", @"You must be at this location to claim this reward. Please come back later, or refresh your location.")];
  [_verifyLocationLabel setTextColor:PopdeemColor(@"popdeem.claim.locationVerification.fontColor")];
  [_verifyLocationLabel setFont:PopdeemFont(@"popdeem.claim.locationVerification.font", 10)];
  
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
  _textViewBordersLayer.frame = CGRectMake(-1, 0, _textView.frame.size.width+2, _textView.frame.size.height+1);
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
  [_viewModel claimAction];
}

- (void) keyboardUp {
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
}

- (void) hiderTap {
  [UIView animateWithDuration:0.5
                        delay:0.0
                      options: UIViewAnimationOptionCurveEaseInOut
                   animations:^{
                     
                     [_keyboardHiderView setHidden:YES];
                     if (!IS_IPHONE_4_OR_LESS) {
                       _rewardInfoViewHeightConstraint.constant = (IS_IPHONE_4_OR_LESS) ? 0 : 65;
                     }
                     self.locationVerificationViewHeightConstraint.constant = _viewModel.locationVerified ? 0 : 50;
                     [_textView resignFirstResponder];
                     [_rewardInfoView setHidden:NO];
                     self.navigationItem.rightBarButtonItem = nil;
                     self.navigationItem.hidesBackButton = NO;
                     [self setTitle:translationForKey(@"popdeem.claim.getreward", @"Claim Reward")];
                   } completion:^(BOOL finished){}];
}

- (void) keyboardDown {
  
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
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
