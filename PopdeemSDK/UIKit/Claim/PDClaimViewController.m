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

@interface PDClaimViewController () {
    CALayer *textViewBordersLayer;
    CALayer *buttonsViewBordersLayer;
    CALayer *twitterViewBordersLayer;
    CALayer *claimViewBordersLayer;
    CALayer *facebookButtonViewBordersLayer;
    CALayer *twitterButtonViewBordersLayer;
}

@end

@implementation PDClaimViewController

- (id) initFromNib {
    NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
    if (self = [self initWithNibName:@"PDClaimViewController" bundle:podBundle]) {
        self.view.backgroundColor = [UIColor clearColor];
        return self;
    }
    return nil;
}

- (id) initWithMediaTypes:(NSArray*)mediaTypes {
    _viewModel = [[PDClaimViewModel alloc] initWithMediaTypes:mediaTypes];
    return [self initFromNib];
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
    [self.rewardActionLabel setText:_viewModel.rewardActionsString];
    [self.textView setPlaceholder:_viewModel.textviewPlaceholder];
    switch (_viewModel.socialMediaTypesAvailable) {
        case FacebookOnly:
            //Ensure Twitter Button is Hidden
            break;
        case TwitterOnly:
            //Ensure Facebook Button is Hidden
            break;
        case FacebookAndTwitter:
            //Ensure both buttons are shown
            break;
        default:
            break;
    }
    [self drawBorders];
}

- (void) drawBorders {
    buttonsViewBordersLayer = [CALayer layer];
    buttonsViewBordersLayer.borderColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1].CGColor;
    buttonsViewBordersLayer.borderWidth = 0.5;
    buttonsViewBordersLayer.frame = CGRectMake(-1, 0, _controlsView.frame.size.width+2, _controlsView.frame.size.height);
    [_controlsView.layer addSublayer:buttonsViewBordersLayer];
    _controlsView.clipsToBounds = YES;
    
    textViewBordersLayer = [CALayer layer];
    textViewBordersLayer.borderColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1].CGColor;
    textViewBordersLayer.borderWidth = 0.5;
    textViewBordersLayer.frame = CGRectMake(-1, 0, _textView.frame.size.width+2, _textView.frame.size.height+1);
    [_textView.layer addSublayer:textViewBordersLayer];
    
    facebookButtonViewBordersLayer = [CALayer layer];
    facebookButtonViewBordersLayer.borderColor = [UIColor colorWithRed:0.783922 green:0.780392 blue:0.8 alpha:1].CGColor;
    facebookButtonViewBordersLayer.borderWidth = 0.5;
    facebookButtonViewBordersLayer.frame = CGRectMake(-1, 0, _facebookButton.frame.size.width+1, _facebookButton.frame.size.height);
    [_facebookButton.layer addSublayer:facebookButtonViewBordersLayer];
    _facebookButton.clipsToBounds = YES;
}

- (IBAction)facebookButtonTapped:(id)sender {
}

- (IBAction)claimButtonTapped:(id)sender {
}
@end
