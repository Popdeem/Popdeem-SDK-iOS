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

@interface PDClaimViewController ()
@property (nonatomic, strong) CALayer *textViewBordersLayer;
@property (nonatomic, strong) CALayer *buttonsViewBordersLayer;
@property (nonatomic, strong) CALayer *twitterButtonViewBordersLayer;
@property (nonatomic, strong) CALayer *claimViewBordersLayer;
@property (nonatomic, strong) CALayer *facebookButtonViewBordersLayer;

@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *facebookButtonViewHeightConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *twitterButtonViewHeightConstraint;
@property (unsafe_unretained, nonatomic) IBOutlet NSLayoutConstraint *rewardInfoViewHeightConstraint;
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

- (id) initWithMediaTypes:(NSArray*)mediaTypes andReward:(PDReward*)reward {
    if (self = [self initFromNib]) {
        _viewModel = [[PDClaimViewModel alloc] initWithMediaTypes:mediaTypes andReward:reward];
        [_viewModel setViewController:self];
        [_textView setDelegate:_viewModel];
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self renderView];
  UITapGestureRecognizer *hiderTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiderTap)];
  [_keyboardHiderView addGestureRecognizer:hiderTap];
  // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) renderView {
    [self.rewardDescriptionLabel setText:_viewModel.rewardTitleString];
    [self.rewardRulesLabel setText:_viewModel.rewardRulesString];
    [self.rewardInfoLabel setText:_viewModel.rewardActionsString];
    [self.textView setPlaceholder:_viewModel.textviewPlaceholder];
    switch (_viewModel.socialMediaTypesAvailable) {
        case FacebookOnly:
        case TwitterOnly:
            [self.facebookButton setHidden:YES];
            [self.twitterButton setHidden:YES];
            self.facebookButtonViewHeightConstraint.constant = 0;
            self.twitterButtonViewHeightConstraint.constant = 0;
            break;
        case FacebookAndTwitter:
            //Ensure both buttons are shown
            [self.facebookButton setHidden:YES];
            [self.twitterButton setHidden:YES];
            self.facebookButtonViewHeightConstraint.constant = 40;
            self.twitterButtonViewHeightConstraint.constant = 40;
            break;
        default:
            break;
    }
    [self drawBorders];
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
                             _rewardInfoViewHeightConstraint.constant = (IS_IPHONE_4_OR_LESS) ? 0 : 86;
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
