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

@interface PDClaimViewController () {
  NSArray *_mediaTypes;
  PDReward *_reward;
  PDLocation *_location;
}
@property (nonatomic, strong) CALayer *textViewBordersLayer;
@property (nonatomic, strong) CALayer *buttonsViewBordersLayer;
@property (nonatomic, strong) CALayer *twitterButtonViewBordersLayer;
@property (nonatomic, strong) CALayer *claimViewBordersLayer;
@property (nonatomic, strong) CALayer *facebookButtonViewBordersLayer;

@property (nonatomic, strong) LocationVisor *locationVisor;

@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *rewardInfoViewHeightConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *locationVerificationViewHeightConstraint;
@end

@implementation PDClaimViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
  if (self = [self initWithNibName:@"PDClaimViewController" bundle:podBundle]) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = translationForKey(@"popdeem.claims.title", @"Claim");
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
  PDLocationValidator *validator = [[PDLocationValidator alloc] init];
  [validator validateLocationForReward:_reward completion:^(BOOL validated){
    if (validated) {
      NSLog(@"All OK");
      [self performSelector:@selector(hideVisor) withObject:nil afterDelay:3.0];
    } else {
      NSLog(@"Not Here");
    }
  }];
}

- (void) hideVisor {
  [_locationVisor hideAnimated:YES];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setupView];
//  _viewModel = [[PDClaimViewModel alloc] initWithMediaTypes:_mediaTypes andReward:_reward location:_location];
//  [_viewModel setViewController:self];
//  [_textView setDelegate:_viewModel];
//  [_textView setFont:[UIFont systemFontOfSize:14]];
//  [self renderView];
//  [self drawBorders];
}

- (void) setupView {
//  [self.view setBackgroundColor:[UIColor colorWithRed:239/255 green:239/255 blue:244/255 alpha:1.0]];
  float currentY = 0;
  float viewWidth = self.view.frame.size.width;
  RewardTableViewCell *rewardCell = [[RewardTableViewCell alloc] initWithFrame:CGRectMake(0, currentY, viewWidth, 85) reward:_reward];
  [self.view addSubview:rewardCell];
  currentY += 85;
  _textView = [[PD_SZTextView alloc] initWithFrame:CGRectMake(0, currentY, viewWidth, 130)];
  [self.view addSubview:_textView];
  currentY += 130;
  _withLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, currentY, viewWidth, 21)];
  
}

- (void) viewDidAppear:(BOOL)animated {
  UITapGestureRecognizer *hiderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiderTap)];
  [_keyboardHiderView addGestureRecognizer:hiderTap];
  [self verifyLocation];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) renderView {
  [self.rewardInfoView addSubview:[[RewardTableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 65) reward:_viewModel.reward]];
  [self.textView setPlaceholder:_viewModel.textviewPlaceholder];
  [self.rewardImageView setImage:_viewModel.reward.coverImage];
  
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
  [self.rewardImageView setHidden:YES];
  self.rewardInfoViewHeightConstraint.constant = 0;
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
@end
