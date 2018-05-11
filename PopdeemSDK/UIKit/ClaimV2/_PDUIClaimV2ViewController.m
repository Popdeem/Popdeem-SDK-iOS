////
////  PDUIClaimV2ViewController.m
////  PopdeemSDK
////
////  Created by Niall Quinn on 10/05/2018.
////  Copyright © 2018 Popdeem. All rights reserved.
////
//
//#import "_PDUIClaimV2ViewController.h"
//#import "PopdeemSDK.h"
//#import "PDUtils.h"
//#import "PDTheme.h"
//#import "PDUIClaimRewardTableViewCell.h"
//
//#define kContinueButtonHeight 60.0f
//
//#define kPDUIClaimRewardTableViewCell @"PDUIClaimRewardTableViewCell"
//
//@interface _PDUIClaimV2ViewController ()
//
//
//@end
//
//@implementation _PDUIClaimV2ViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    
//    //Section Labels
//    _scanSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//    UILabel *scanTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 40)];
//    [scanTitleLabel setText:translationForKey(@"popdeem.claim.scanTitle", @"SCAN")];
//    [scanTitleLabel setFont:PopdeemFont(PDThemeFontPrimary, 14)];
//    [scanTitleLabel setTextColor:PopdeemColor(PDThemeColorSecondaryFont)];
//    [_scanSectionView addSubview:scanTitleLabel];
//    
//    _shareSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
//    UILabel *shareTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 40)];
//    [shareTitleLabel setText:translationForKey(@"popdeem.claim.shareTitle", @"OR, SHARE NOW")];
//    [shareTitleLabel setFont:PopdeemFont(PDThemeFontPrimary, 14)];
//    [shareTitleLabel setTextColor:PopdeemColor(PDThemeColorSecondaryFont)];
//    [_shareSectionView addSubview:shareTitleLabel];
//    
//    [self registerNibs];
//    
//    self.tableView.tableFooterView = [UIView new];
//    
//}
//
//- (void) viewWillAppear:(BOOL)animated {
//    [self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kContinueButtonHeight)];
//    
//    CGRect continueButtonFrame;
//    if ([[self tabBarController] tabBar]) {
//        continueButtonFrame = CGRectMake(0, self.view.frame.size.height-kContinueButtonHeight-(self.tabBarController.tabBar.frame.size.height), self.view.frame.size.width, kContinueButtonHeight);
//    } else {
//        continueButtonFrame = CGRectMake(0, self.view.frame.size.height-kContinueButtonHeight, self.view.frame.size.width, kContinueButtonHeight);
//    }
//    
//    _continueButton = [[UIButton alloc] initWithFrame:continueButtonFrame];
//    [_continueButton setBackgroundColor:[UIColor whiteColor]];
//    [_continueButton setTitleColor:PopdeemColor(PDThemeColorPrimaryApp) forState:UIControlStateNormal];
//    [_continueButton.titleLabel setFont:PopdeemFont(PDThemeFontPrimary, 14)];
//    [_continueButton setEnabled:NO];
//    [_continueButton setTitle:translationForKey(@"popdeem.claim.continueButtonTitle", @"Continue") forState:UIControlStateNormal];
//    [_continueButton addTarget:self action:@selector(continueButtonPressed) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_continueButton];
//    
//}
//
//- (void) continueButtonPressed {
//    
//}
//
//- (void) didMoveToParentViewController:(UIViewController *)parent {
//    [self.tableView setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - kContinueButtonHeight)];
//}
//
//- (void) registerNibs {
//    NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
//    UINib *pcnib = [UINib nibWithNibName:@"PDUIClaimRewardTableViewCell" bundle:podBundle];
//    [[self tableView] registerNib:pcnib forCellReuseIdentifier:kPDUIClaimRewardTableViewCell];
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 3;
//}
//
//- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return 0;
//}
//
//- (UIView*) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    if (section == 2) {
//        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1.0f)];
//        [footerView setBackgroundColor:PopdeemColor(PDThemeColorTableViewSeperator)];
//        return footerView;
//    }
//    return nil;
//}
//
//- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    switch (section) {
//        case 0:
//            return nil;
//            break;
//        case 1:
//            return _scanSectionView;
//            break;
//        case 2:
//            return _shareSectionView;
//            break;
//        default:
//            break;
//    }
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    switch (section) {
//        case 0:
//            //Reward Cell
//            return 1;
//            break;
//        case 1:
//            //Scan Now
//            return 1;
//        case 2:
//            //Main Area
//            return 5;
//            break;
//        default:
//            return 0;
//            break;
//    }
//    return 0;
//}
//
//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.section == 0) {
//        return 150;
//    } else if (indexPath.section == 1) {
//        return 50;
//    } else if (indexPath.section == 2) {
//        return 50;
//    } else {
//        return 50;
//    }
//    return 50;
//}
//
//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        return 0;
//    } else if (section == 1) {
//        return 40;
//    } else if (section == 2) {
//        return 40;
//    } else {
//        return 0;
//    }
//    return 0;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (indexPath.section == 0) {
//        PDUIClaimRewardTableViewCell *rewardCell = [[self tableView] dequeueReusableCellWithIdentifier:kPDUIClaimRewardTableViewCell];
//        rewardCell.reward = _reward;
//        [rewardCell setup];
//        return rewardCell;
//    } else if (indexPath.section == 1) {
//        return [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//    } else if (indexPath.section == 2) {
//        return [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//    } else {
//        return [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//    }
//    return [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//}
//
//
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
