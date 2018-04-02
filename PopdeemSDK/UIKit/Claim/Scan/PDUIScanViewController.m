//
//  PDUIScanViewController.m
//  PopdeemSDK
//
//  Created by niall quinn on 31/03/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import "PDUIScanViewController.h"
#import "PDUtils.h"
#import "PDTheme.h"
#import "PDConstants.h"
#import "PopdeemSDK.h"
#import "DGActivityIndicatorView.h"
#import "PDBackgroundScan.h"
#import "PDUIPostScanViewController.h"


@interface PDUIScanViewController ()
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *topLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *bottomLabel;
@property (nonatomic, retain) PDReward *reward;
@property (nonatomic, retain) NSString *network;
@property (unsafe_unretained, nonatomic) IBOutlet DGActivityIndicatorView *activityIndicator;


@end

@implementation PDUIScanViewController

- (instancetype) initWithReward:(PDReward*)reward andNetwork:(NSString*)network {
  if (self = [self initFromNib]) {
    _reward = reward;
    _network = network;
    return self;
  }
  return nil;
}

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
  if (self = [self initWithNibName:@"PDUIScanViewController" bundle:podBundle]) {
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.title = @"Scan";
    return self;
  }
  return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
  NSString *networkString = @"";
  if ([_network isEqualToString:FACEBOOK_NETWORK]) {
    networkString = @"Facebook";
  } else if ([_network isEqualToString:TWITTER_NETWORK]) {
    networkString = @"Twitter";
  } else if ([_network isEqualToString:INSTAGRAM_NETWORK]) {
    networkString = @"Instagram";
  }
  
  NSMutableAttributedString *topLabelAttributedString = [[NSMutableAttributedString alloc] initWithString:@""
                                                                                                attributes:@{}];


  NSMutableAttributedString *mainString = [[NSMutableAttributedString alloc]
                                                initWithString:[NSString stringWithFormat:@"Scanning for stories on %@ with ",networkString]
                                                 attributes:@{
                                                              NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 12),
                                                              NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont)
                                                              }];
  
  NSMutableAttributedString *hashTagString = [[NSMutableAttributedString alloc]
                                              initWithString:_reward.forcedTag
                                              attributes:@{
                                                           NSFontAttributeName : PopdeemFont(PDThemeFontBold, 12),
                                                           NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont)
                                                           }];
  
  [topLabelAttributedString appendAttributedString:mainString];
  [topLabelAttributedString appendAttributedString:hashTagString];
  
  [_topLabel setAttributedText:topLabelAttributedString];
  
  [_topLabel setFont:PopdeemFont(PDThemeFontLight, 14)];
  [_topLabel setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
  
  [_bottomLabel setText:@"This usually takes a few moments. Please wait.."];
  [_bottomLabel setFont:PopdeemFont(PDThemeFontLight, 14)];
  [_bottomLabel setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
  
  [_activityIndicator setSize:55.0f];
  [_activityIndicator setTintColor:PopdeemColor(PDThemeColorPrimaryApp)];
  [_activityIndicator setBackgroundColor:[UIColor clearColor]];
  [_activityIndicator setType:DGActivityIndicatorAnimationTypeBallPulse];
  [_activityIndicator startAnimating];
  
  if (PopdeemThemeHasValueForKey(@"popdeem.images.tableViewBackgroundImage")) {
    UIImageView *tvbg = [[UIImageView alloc] initWithFrame:self.view.frame];
    [tvbg setImage:PopdeemImage(@"popdeem.images.tableViewBackgroundImage")];
    [self.view addSubview:tvbg];
    [self.view sendSubviewToBack:tvbg];
  }
  
  [self scan];
}

- (void) scan {
  PDBackgroundScan *scan = [[PDBackgroundScan alloc] init];
  [scan scanNetwork:_network reward:_reward success:^(BOOL validated, PDBGScanResponseModel *response){
    if (validated == YES) {
      PDLog(@"Scan Successful");
      [_activityIndicator stopAnimating];
//      PDUIPostScanViewController *postScan = [[PDUIPostScanViewController alloc] initWithModel:response andReward:_reward];
//      [self.navigationController pushViewController:postScan animated:YES];
    } else {
      //No Validate
      UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Post not Found!" message:@"Your post was not found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      [av show];
    }
  } failure:^(NSError *error) {
    if (error) {
      PDLogError(@"Error on scan: %@", error.localizedDescription);
    } else {
      PDLog(@"Scan not successful");
      UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Post not Found!" message:@"Your post was not found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
      [av show];
    }
  }];
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
