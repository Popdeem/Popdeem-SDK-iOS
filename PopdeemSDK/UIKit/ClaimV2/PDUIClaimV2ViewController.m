//
//  PDUIClaimV2ViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 10/05/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDUIClaimV2ViewController.h"
#import "PopdeemSDK.h"
#import "PDTheme.h"

@interface PDUIClaimV2ViewController ()

@property (nonatomic, retain) UIView *scanSectionView;
@property (nonatomic, retain) UIView *shareSectionView;


@end

@implementation PDUIClaimV2ViewController

- (instancetype) initFromNib {
    NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
    if (self = [self initWithNibName:@"PDUIClaimViewController" bundle:podBundle]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.title = translationForKey(@"popdeem.claims.title", @"Claim");
//
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginSuccess) name:InstagramLoginSuccess object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginFailure:) name:InstagramLoginFailure object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginUserDismiss) name:InstagramLoginuserDismissed object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramPostMade) name:PDUserLinkedToInstagram object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramVerifySuccess) name:InstagramVerifySuccess object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramVerifyFailure) name:InstagramVerifyFailure object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramVerifyNoAttempt) name:InstagramVerifyNoAttempt object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookWritePermSuccess) name:FacebookPublishSuccess object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookWritePermFailure) name:FacebookPublishFailure object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backFromInstagram) name:UIApplicationDidBecomeActiveNotification object:nil];
        return self;
    }
    return nil;
}

- (void) setupWithReward:(PDReward*)reward {
    _reward = reward;
//    [self styleNavbar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View Delegate

//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    
//}
//
//- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {}
//
//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {}

//- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    switch (section) {
//        case 0:
//            return _scanSectionView;
//            break;
//        case 1:
//            return _shareSectionView;
//            break;
//        default:
//            break;
//    }
//    return 0;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 5;
            break;
        default:
            return 0;
            break;
    }
    return 0;
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
//    if (_brand.theme != nil) {
//        self.navigationController.navigationBar.translucent = NO;
//        [self.navigationController.navigationBar setBarTintColor:PopdeemColorFromHex(_brand.theme.primaryAppColor)];
//        [self.navigationController.navigationBar setTintColor:PopdeemColorFromHex(_brand.theme.primaryInverseColor)];
//
//        UIFont *headerFont;
//        if (PopdeemThemeHasValueForKey(PDThemeFontNavbar)) {
//            headerFont = PopdeemFont(PDThemeFontNavbar, 17.0f);
//        } else {
//            headerFont = PopdeemFont(PDThemeFontBold, 17.0f);
//        }
//
//        [self.navigationController.navigationBar setTitleTextAttributes:@{
//                                                                          NSForegroundColorAttributeName : PopdeemColorFromHex(_brand.theme.primaryInverseColor),
//                                                                          NSFontAttributeName : headerFont
//                                                                          }];
//
//        [self.navigationController.navigationItem.rightBarButtonItem setTitleTextAttributes:@{
//                                                                                              NSForegroundColorAttributeName : PopdeemColorFromHex(_brand.theme.primaryInverseColor),
//                                                                                              NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 16.0f)}
//                                                                                   forState:UIControlStateNormal];
//    }
}

@end
