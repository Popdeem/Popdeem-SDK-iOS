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

@interface PDClaimViewController () 
@property (nonatomic, strong) CALayer *textViewBordersLayer;
@property (nonatomic, strong) CALayer *buttonsViewBordersLayer;
@property (nonatomic, strong) CALayer *twitterButtonViewBordersLayer;
@property (nonatomic, strong) CALayer *claimViewBordersLayer;
@property (nonatomic, strong) CALayer *facebookButtonViewBordersLayer;

//constraints


@end

@implementation PDClaimViewController

- (id) initFromNib {
    NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
    if (self = [self initWithNibName:@"PDClaimViewController" bundle:podBundle]) {
      self.edgesForExtendedLayout = UIRectEdgeNone;
        return self;
    }
    return nil;
}

- (id) initWithMediaTypes:(NSArray*)mediaTypes andReward:(PDReward*)reward {
    if (self = [self initFromNib]) {
        _viewModel = [[PDClaimViewModel alloc] initWithMediaTypes:mediaTypes andReward:reward];
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self renderView];
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
            //Ensure Twitter Button is Hidden
            [self.facebookButton setHidden:YES];
            [self.twitterButton setHidden:YES];
            break;
        case TwitterOnly:
            //Ensure Facebook Button is Hidden
            [self.facebookButton setHidden:YES];
            [self.twitterButton setHidden:NO];
            break;
        case FacebookAndTwitter:
            //Ensure both buttons are shown
            [self.facebookButton setHidden:NO];
            [self.twitterButton setHidden:NO];
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
@end
