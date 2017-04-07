//
//  PDUIPostScanViewController.m
//  PopdeemSDK
//
//  Created by niall quinn on 03/04/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import "PDUIPostScanViewController.h"
#import "PopdeemSDK.h"
#import "PDUser.h"
#import "PDTheme.h"
#import "PDUtils.h"
#import "PDConstants.h"
#import "PDRewardActionAPIService.h"
#import "PDUIHomeViewController.h"
#import "DGActivityIndicatorView.h"
#import "PDBackgroundScan.h"
#import "PDUIClaimViewController.h"

@interface PDUIPostScanViewController () {
  CFAbsoluteTime scanStartTime;
}
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *topLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *profilePicture;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *postTextLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *postImageView;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *claimButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIView *postView;
@property (unsafe_unretained, nonatomic) IBOutlet DGActivityIndicatorView *activityIndicator;
@property (nonatomic, retain) NSString *network;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *backToRewardButton;

@property (nonatomic, retain) PDBGScanResponseModel *postModel;
@property (nonatomic, retain) PDReward *reward;

@property (nonatomic, retain) UILabel *failedLabel;

@end

@implementation PDUIPostScanViewController

- (instancetype) initWithReward:(PDReward*)reward network:(NSString*)network {
  if (self = [self initFromNib]) {
    self.reward = reward;
    self.network = network;
    return self;
  }
  return nil;
}

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
  if (self = [self initWithNibName:@"PDUIPostScanViewController" bundle:podBundle]) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Claim";
    return self;
  }
  return nil;
}

- (void) scan {
  
  PDBackgroundScan *scan = [[PDBackgroundScan alloc] init];
  [scan scanNetwork:_network reward:_reward success:^(BOOL validated, PDBGScanResponseModel *response){
    if (validated == YES) {
      PDLog(@"Scan Successful");
      self.postModel = response;
      
      //We want to delay the display of information slightly if it is very fast for UX
      //ideally if the response comes in under 3 seconds we should delay the display slightly
      CFAbsoluteTime scanEndTime = CFAbsoluteTimeGetCurrent();
      if (scanEndTime - scanStartTime < 3.0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
          [self setupPostView];
        });
      } else {
        dispatch_async(dispatch_get_main_queue(), ^{
          [self setupPostView];
        });
      }
    } else {
      //No Validate
      CFAbsoluteTime scanEndTime = CFAbsoluteTimeGetCurrent();
      if (scanEndTime - scanStartTime < 3.0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
          [self setupViewForFailedValidation];
        });
      } else {
        dispatch_async(dispatch_get_main_queue(), ^{
          [self setupViewForFailedValidation];
        });
      }
    }
  } failure:^(NSError *error) {
    if (error) {
      PDLogError(@"Error on scan: %@", error.localizedDescription);
      [self setupViewForFailedValidation];
    } else {
      [self setupViewForFailedValidation];
    }
  }];
}

- (void) setupViewForFailedValidation {
  [_activityIndicator setHidden:YES];
  [_activityIndicator stopAnimating];
  
 
  _failedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.view.frame.size.width-20, 100)];
  
  NSMutableAttributedString *failedLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:@""
                                                                                               attributes:@{}];
  
  
  NSMutableAttributedString *mainString = [[NSMutableAttributedString alloc]
                                           initWithString:[NSString stringWithFormat:@"Whoops! Sorry %@, we could not find a post from the last 48 hours with ",[[PDUser sharedInstance] firstName]]
                                           attributes:@{
                                                        NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 12),
                                                        NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont)
                                                        }];
  
  NSMutableAttributedString *hashTagString = [[NSMutableAttributedString alloc]
                                              initWithString:_reward.instagramForcedTag
                                              attributes:@{
                                                           NSFontAttributeName : PopdeemFont(PDThemeFontBold, 12),
                                                           NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont)
                                                           }];
  
  [failedLabelAttributedString appendAttributedString:mainString];
  [failedLabelAttributedString appendAttributedString:hashTagString];
  
  NSMutableAttributedString *restString = [[NSMutableAttributedString alloc]
                                           initWithString:@"\n\nPlease ensure you've shared from the correct social media account and try again."
                                           attributes:@{
                                                        NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 12),
                                                        NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont)
                                                        }];
  
  [failedLabelAttributedString appendAttributedString:restString];
  
  [_failedLabel setAttributedText:failedLabelAttributedString];
  [_failedLabel setNumberOfLines:0];
  [_failedLabel setTextAlignment:NSTextAlignmentCenter];
  [_failedLabel sizeToFit];
  
  [_backToRewardButton setFrame:CGRectMake(16, _failedLabel.frame.size.height + 40, self.view.frame.size.width-32, 49)];
  _backToRewardButton.layer.borderColor = PopdeemColor(PDThemeColorPrimaryApp).CGColor;
  _backToRewardButton.layer.borderWidth = 2.0;
  _backToRewardButton.backgroundColor = [UIColor clearColor];
  _backToRewardButton.layer.cornerRadius = 5.0;
  _backToRewardButton.clipsToBounds = YES;
  _backToRewardButton.tintColor = PopdeemColor(PDThemeColorPrimaryApp);
  
  [self.view addSubview:_failedLabel];
  [_failedLabel setHidden:YES];
  
  
  [UIView transitionWithView:_activityIndicator
                    duration:0.5
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                    [self.activityIndicator setHidden:YES];
                  }
                  completion:NULL];
  
  [UIView transitionWithView:_failedLabel
                    duration:0.5
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                    [_failedLabel setHidden:NO];
                  }
                  completion:NULL];
  
  [UIView transitionWithView:_backToRewardButton
                    duration:0.5
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                    [_backToRewardButton setHidden:NO];
                  }
                  completion:NULL];
  
}

- (void) setupPostView {
  
  if (_postModel.mediaUrl != nil) {
    NSURL *url = [NSURL URLWithString:_postModel.mediaUrl];
    NSURLSessionTask *task1 = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      if (data) {
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
          dispatch_async(dispatch_get_main_queue(), ^{
            [_postImageView setImage:image];
          });
        }
      }
    }];
    [task1 resume];
  }
  
  if (_postModel.profilePictureUrl != nil) {
    NSString *urlString = @"";
    if ([_postModel.profilePictureUrl containsString:@"https"]) {
      urlString = _postModel.profilePictureUrl;
    } else {
      urlString = [_postModel.profilePictureUrl stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLSessionTask *task2 = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      if (data) {
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
          dispatch_async(dispatch_get_main_queue(), ^{
            [_profilePicture setImage:image];
          });
        }
      }
    }];
    [task2 resume];
  }
  
  _profilePicture.layer.cornerRadius = _profilePicture.frame.size.width/2;
  _profilePicture.clipsToBounds = YES;
  
  NSString *uptohash = [NSString stringWithFormat:@"Hey %@, we found your post with ", [[PDUser sharedInstance] firstName]];
  NSString *hash = _reward.instagramForcedTag;
  
  NSString *afterHash = @". Thanks for sharing! You have unlocked your reward!";
  
  NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
  ps.paragraphSpacing = 2.0;
  ps.lineSpacing = 0;
  ps.alignment = NSTextAlignmentCenter;
  
  NSMutableAttributedString *topLabelAttString = [[NSMutableAttributedString alloc] initWithString:@""
                                                                                     attributes:@{}];
  
  NSMutableParagraphStyle *innerParagraphStyle = [[NSMutableParagraphStyle alloc] init];
  innerParagraphStyle.lineSpacing = 0;
  
  
  NSMutableAttributedString *topString = [[NSMutableAttributedString alloc]
                                                  initWithString:uptohash
                                                  attributes:@{
                                                               NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 12),
                                                               NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont)
                                                               }];
  
  [topLabelAttString appendAttributedString:topString];
  
  NSMutableAttributedString *hashAttString = [[NSMutableAttributedString alloc]
                                          initWithString:hash
                                          attributes:@{
                                                       NSFontAttributeName : PopdeemFont(PDThemeFontBold, 12),
                                                       NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont)
                                                       }];
  
  [topLabelAttString appendAttributedString:hashAttString];
  
  NSMutableAttributedString *afterHashAttString = [[NSMutableAttributedString alloc]
                                              initWithString:afterHash
                                              attributes:@{
                                                           NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 12),
                                                           NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont)
                                                           }];
  
  [topLabelAttString appendAttributedString:afterHashAttString];
  

  [topLabelAttString addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, topLabelAttString.length)];
  [_topLabel setAttributedText:topLabelAttString];
  
  NSString *socialName = [NSString stringWithFormat:@"%@\n",_postModel.socialName];
  
  NSMutableAttributedString *postLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:@""
                                                                                        attributes:@{}];
  NSMutableAttributedString *socialNameString = [[NSMutableAttributedString alloc]
                                          initWithString:socialName
                                          attributes:@{
                                                       NSFontAttributeName : PopdeemFont(PDThemeFontBold, 12),
                                                       NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont)
                                                       }];
                          
  [postLabelAttributedString appendAttributedString:socialNameString];
  
  NSMutableAttributedString *socialPostString = [[NSMutableAttributedString alloc]
                                                 initWithString:_postModel.text
                                                 attributes:@{
                                                              NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 12),
                                                              NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont)
                                                             }];
  
  [postLabelAttributedString appendAttributedString:socialPostString];
  
  [_postTextLabel setAttributedText:postLabelAttributedString];
  
  [_claimButton setBackgroundColor:PopdeemColor(PDThemeColorPrimaryApp)];
  _claimButton.layer.cornerRadius = 5.0;
  _claimButton.clipsToBounds = YES;
  
  
  [UIView transitionWithView:self.topLabel
                    duration:0.5
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                    [self.topLabel setHidden:NO];
                  }
                  completion:NULL];
  
  [UIView transitionWithView:_activityIndicator
                    duration:0.5
                     options:UIViewAnimationOptionTransitionCrossDissolve
                  animations:^{
                    [self.activityIndicator setHidden:YES];
                  }
                  completion:NULL];
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [UIView transitionWithView:_postView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                      [_postView setHidden:NO];
                    }
                    completion:NULL];
  });
  
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [UIView transitionWithView:_claimButton
                      duration:0.5
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                      [self.claimButton setHidden:NO];
                    }
                    completion:NULL];
  });
}

- (IBAction)claimButtonPressed:(id)sender {
  PDRewardActionAPIService *service = [[PDRewardActionAPIService alloc] init];
  [service claimReward:_reward.identifier location:_reward.locations.firstObject withPost:_postModel completion:^(NSError *error) {
    if (!error) {
      [self didClaimRewardId:_reward.identifier];
    } else {
      PDLogError(@"Error claiming: %@",error);
    }
  }];
}

- (IBAction)backToRewardButtonPressed:(id)sender {
  for (UIViewController *controller in self.navigationController.viewControllers) {
    if ([controller isKindOfClass:[PDUIClaimViewController class]]) {
      [self.navigationController popToViewController:controller
                                            animated:YES];
      break;
    }
  }
}

- (void) didClaimRewardId:(NSInteger)rewardId {
  
  UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.claim.reward.claimed", @"Reward Claimed!") message:translationForKey(@"popdeem.claim.reward.success", @"You can view your reward in your wallet") delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
  [av setTag:9];
  [av show];
  
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  if (alertView.tag == 9) {
    for (UIViewController *controller in self.navigationController.viewControllers) {
      if ([controller isKindOfClass:[PDUIHomeViewController class]]) {
        PDUIHomeViewController *cont = (PDUIHomeViewController*)controller;
        [cont setDidClaim:YES];
        [self.navigationController popToViewController:controller
                                              animated:YES];
        break;
      }
    }
  }
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [_activityIndicator setHidden:NO];
  [_activityIndicator setSize:55.0f];
  [_activityIndicator setTintColor:PopdeemColor(PDThemeColorPrimaryApp)];
  [_activityIndicator setType:DGActivityIndicatorAnimationTypeBallPulse];
  [_activityIndicator startAnimating];
  scanStartTime = CFAbsoluteTimeGetCurrent();
  [self scan];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
