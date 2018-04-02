//
//  PDUISelectNetworkViewController.h
//  PopdeemSDK
//
//  Created by niall quinn on 29/03/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDBrand.h"
#import "PDReward.h"
#import "PDUIInstagramLoginViewController.h"

@interface PDUISelectNetworkViewController : UIViewController <InstagramLoginDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *topLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *facebookButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *twitterButton;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *instagramButton;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *bottomLabel;


- (id) initWithMediaTypes:(NSArray*)mediaTypes andReward:(PDReward*)reward brand:(PDBrand*)brand;
- (IBAction)facebookButtonPressed:(id)sender;
- (IBAction)twitterButtonPressed:(id)sender;
- (IBAction)instagramButtonPressed:(id)sender;

@end
