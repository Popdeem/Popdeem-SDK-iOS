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

#define kPDUIClaimRewardTableViewCell @"PDUIClaimRewardTableViewCell"

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
    
    //Section Labels
    _scanSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UILabel *scanTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 40)];
    [scanTitleLabel setText:translationForKey(@"popdeem.claim.scanTitle", @"SCAN")];
    [scanTitleLabel setFont:PopdeemFont(PDThemeFontPrimary, 14)];
    [scanTitleLabel setTextColor:PopdeemColor(PDThemeColorSecondaryFont)];
    [_scanSectionView addSubview:scanTitleLabel];
    
    _shareSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    UILabel *shareTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 40)];
    [shareTitleLabel setText:translationForKey(@"popdeem.claim.shareTitle", @"OR, SHARE NOW")];
    [shareTitleLabel setFont:PopdeemFont(PDThemeFontPrimary, 14)];
    [shareTitleLabel setTextColor:PopdeemColor(PDThemeColorSecondaryFont)];
    [_shareSectionView addSubview:shareTitleLabel];
    
    [self registerNibs];
    
    self.tableView.tableFooterView = [UIView new];
    
}

- (void) registerNibs {
    NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
    UINib *pcnib = [UINib nibWithNibName:@"PDUIClaimRewardTableViewCell" bundle:podBundle];
    [[self tableView] registerNib:pcnib forCellReuseIdentifier:kPDUIClaimRewardTableViewCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View Delegate

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return _scanSectionView;
            break;
        case 1:
            return _shareSectionView;
            break;
        default:
            break;
    }
    return 0;
}

- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1.0f)];
        [footerView setBackgroundColor:PopdeemColor(PDThemeColorTableViewSeperator)];
        return footerView;
    }
    return nil;
}

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    [cell setFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    return cell;
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
}

@end
