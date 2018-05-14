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
#import "PDUIScanNowTableViewCell.h"
#import "PDUIAddPhotoTableViewCell.h"
#import "PDUISocialClaimTableViewCell.h"
#import "PDUser.h"
#import "PDConstants.h"
#import "PDSocialAPIService.h"
#import "PDUIInstagramLoginViewController.h"
#import "PDAPIClient.h"
#import "PDUITwitterLoginViewController.h"
#import "PDUIFBLoginWithWritePermsViewController.h"
#import "PDSocialMediaManager.h"
#import "PDUIModalLoadingView.h"
#import "PDUILogoutTableViewCell.h"
#import "PDUserAPIService.h"
#import "PDCustomer.h"

#define kPDUIClaimRewardTableViewCell @"PDUIClaimRewardTableViewCell"
#define kPDUIScanNowTableViewCell @"PDUIScanNowTableViewCell"
#define kPDUIAddPhotoTableViewCell @"PDUIAddPhotoTableViewCell"
#define kPDUISocialClaimTableViewCell @"PDUISocialClaimTableViewCell"

@interface PDUIClaimV2ViewController ()

@property (nonatomic, retain) UIView *scanSectionView;
@property (nonatomic, retain) UIView *shareSectionView;


@end

@implementation PDUIClaimV2ViewController

- (instancetype) initFromNib {
    NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
    if (self = [self initWithNibName:@"PDUIClaimV2ViewController" bundle:podBundle]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.title = translationForKey(@"popdeem.claims.title", @"Claim");
        return self;
    }
    return nil;
}

- (void) setupWithReward:(PDReward*)reward {
    _reward = reward;
}

- (void)viewDidLoad {
    //Section Labels
    
    [self registerNibs];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView reloadData];
    
    if (self.reward) {
        [self setupRewardView];
    }
    
    [super viewDidLoad];
    
}

- (void) viewWillAppear:(BOOL)animated {
    _scanSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    UILabel *scanTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width- 40, 30)];
    [scanTitleLabel setText:translationForKey(@"popdeem.claim.scanTitle", @"SCAN")];
    [scanTitleLabel setFont:PopdeemFont(PDThemeFontPrimary, 14)];
    [scanTitleLabel setTextColor:PopdeemColor(PDThemeColorSecondaryFont)];
    [scanTitleLabel sizeToFit];
    [scanTitleLabel setFrame:CGRectMake(20, 30-scanTitleLabel.frame.size.height, scanTitleLabel.frame.size.width, scanTitleLabel.frame.size.height)];
    
    CALayer *scanTopBorder = [CALayer layer];
    scanTopBorder.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 1.0f);
    scanTopBorder.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00].CGColor;
    [_scanSectionView.layer addSublayer:scanTopBorder];
    [_scanSectionView setBackgroundColor:[UIColor whiteColor]];
    [_scanSectionView addSubview:scanTitleLabel];
    
    _shareSectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    UILabel *shareTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.frame.size.width - 40, 30)];
    [shareTitleLabel setText:translationForKey(@"popdeem.claim.shareTitle", @"OR, SHARE NOW")];
    [shareTitleLabel setFont:PopdeemFont(PDThemeFontPrimary, 14)];
    [shareTitleLabel setTextColor:PopdeemColor(PDThemeColorSecondaryFont)];
    [shareTitleLabel sizeToFit];
    [shareTitleLabel setFrame:CGRectMake(20, 30-shareTitleLabel.frame.size.height, shareTitleLabel.frame.size.width, shareTitleLabel.frame.size.height)];
    
    CALayer *shareTopBorder = [CALayer layer];
    shareTopBorder.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 1.0f);
    shareTopBorder.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00].CGColor;
    [_shareSectionView setBackgroundColor:[UIColor whiteColor]];
    [_shareSectionView.layer addSublayer:shareTopBorder];
    [_shareSectionView addSubview:shareTitleLabel];
}

- (void) viewDidLayoutSubviews {
    if (self.tableView.frame.size.height >= self.tableView.contentSize.height) {
        [self.tableView setScrollEnabled:NO];
    } else {
        [self.tableView setScrollEnabled:YES];
    }
}

- (void) registerNibs {
    NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
    UINib *pcnib = [UINib nibWithNibName:@"PDUIClaimRewardTableViewCell" bundle:podBundle];
    [[self tableView] registerNib:pcnib forCellReuseIdentifier:kPDUIClaimRewardTableViewCell];
    
    UINib *scnannib = [UINib nibWithNibName:@"PDUIScanNowTableViewCell" bundle:podBundle];
    [[self tableView] registerNib:scnannib forCellReuseIdentifier:kPDUIScanNowTableViewCell];
    
    UINib *addphotonib = [UINib nibWithNibName:@"PDUIAddPhotoTableViewCell" bundle:podBundle];
    [[self tableView] registerNib:addphotonib forCellReuseIdentifier:kPDUIAddPhotoTableViewCell];
    
    UINib *socialnib = [UINib nibWithNibName:@"PDUISocialClaimTableViewCell" bundle:podBundle];
    [[self tableView] registerNib:socialnib forCellReuseIdentifier:kPDUISocialClaimTableViewCell];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View Delegate

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
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
            if (_reward) {
                return 2 + _reward.socialMediaTypes.count;
            } else {
                return 2;
            }
            break;
        default:
            return 0;
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //Scan Now Table View Cell
            PDUIScanNowTableViewCell *scanCell = [[self tableView] dequeueReusableCellWithIdentifier:kPDUIScanNowTableViewCell];
            return scanCell;
            
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (_addedPhoto == nil) {
                PDUIAddPhotoTableViewCell *addPhotoCell = [[self tableView] dequeueReusableCellWithIdentifier:kPDUIAddPhotoTableViewCell];
                return addPhotoCell;
            } else {
                //Cell for added photo
            }
        } else if (indexPath.row == 1) {
            PDUISocialClaimTableViewCell *facebook = [[self tableView] dequeueReusableCellWithIdentifier:kPDUISocialClaimTableViewCell];
            facebook.parent = self;
            [facebook setSocialNetwork:PDSocialMediaTypeFacebook];
            if (![_reward.socialMediaTypes containsObject:@(PDSocialMediaTypeFacebook)]) {
                [facebook setEnabled:NO];
            }
            return facebook;
        } else if (indexPath.row == 2) {
            PDUISocialClaimTableViewCell *twitter = [[self tableView] dequeueReusableCellWithIdentifier:kPDUISocialClaimTableViewCell];
            twitter.parent = self;
            [twitter setSocialNetwork:PDSocialMediaTypeTwitter];
            if (![_reward.socialMediaTypes containsObject:@(PDSocialMediaTypeTwitter)]) {
                [twitter setEnabled:NO];
            }
            return twitter;
        } else if (indexPath.row == 3) {
            PDUISocialClaimTableViewCell *instagram = [[self tableView] dequeueReusableCellWithIdentifier:kPDUISocialClaimTableViewCell];
            instagram.parent = self;
            [instagram setSocialNetwork:PDSocialMediaTypeInstagram];
             if (![_reward.socialMediaTypes containsObject:@(PDSocialMediaTypeInstagram)]) {
                 [instagram setEnabled:NO];
             }
             return instagram;
        }
    }
    
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

- (void) setupRewardView {
    if (_reward.coverImageUrl) {
        if ([_reward.coverImageUrl rangeOfString:@"reward_default"].location != NSNotFound) {
            [self.rewardImageView setImage:PopdeemImage(PDThemeImageDefaultItem)];
        } else if (_reward.coverImage) {
            [self.rewardImageView setImage:_reward.coverImage];
        } else {
            [self.rewardImageView setImage:nil];
        }
    } else {
        [self.rewardImageView setImage:PopdeemImage(PDThemeImageDefaultItem)];
    }
    [self.rewardImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    NSString *description = _reward.rewardDescription;
    NSString *rules = _reward.rewardRules;
    
    NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
    ps.paragraphSpacing = 8.0;
    ps.lineSpacing = 0;
    
    NSMutableAttributedString *labelAttString = [[NSMutableAttributedString alloc] initWithString:@""
                                                                                       attributes:@{NSParagraphStyleAttributeName: ps}];
    
    NSMutableParagraphStyle *innerParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    
    NSMutableAttributedString *descriptionString = [[NSMutableAttributedString alloc]
                                                    initWithString:[NSString stringWithFormat:@"%@",description]
                                                    attributes:@{
                                                                 NSFontAttributeName : PopdeemFont(PDThemeFontBold, 14),
                                                                 NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont), NSParagraphStyleAttributeName: innerParagraphStyle
                                                                 }];
    
    [labelAttString appendAttributedString:descriptionString];
    
    if (rules.length > 0) {
        NSMutableAttributedString *rulesString = [[NSMutableAttributedString alloc]
                                                  initWithString:[NSString stringWithFormat:@"%@",rules]
                                                  attributes:@{
                                                               NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 12),
                                                               NSForegroundColorAttributeName : PopdeemColor(PDThemeColorSecondaryFont),
                                                               NSParagraphStyleAttributeName: innerParagraphStyle
                                                               }];
        [labelAttString appendAttributedString:rulesString];
    }
    
    
    
    [labelAttString addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, labelAttString.length)];
    
    //Do the label spacing
    //Title Label
    float innerSpacing = 3;
    float labelX = self.rewardImageView.frame.size.width + 40;
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, 0, _rewardView.frame.size.width - labelX - 15, 60)];
        [_rewardView addSubview:_titleLabel];
    } else {
        [_titleLabel setFrame:CGRectMake(labelX, 0, _rewardView.frame.size.width - labelX - 15, 60)];
    }
    
    
    [_titleLabel setNumberOfLines:2];
    [_titleLabel setAttributedText:descriptionString];
    [_titleLabel setContentMode:UIViewContentModeCenter];
    [_titleLabel setBaselineAdjustment:UIBaselineAdjustmentAlignCenters];
    
    CGSize size = [_titleLabel sizeThatFits:CGSizeMake(_rewardView.frame.size.width - labelX - 15, MAXFLOAT)];
    CGRect labelFrame = _titleLabel.frame;
    labelFrame.size.height = size.height;
    _titleLabel.frame = labelFrame;
    _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    float currentY = _titleLabel.frame.size.height + innerSpacing;
    
    //Rules Label
    if (rules.length > 0) {
        NSMutableAttributedString *rulesString = [[NSMutableAttributedString alloc]
                                                  initWithString:[NSString stringWithFormat:@"%@",rules]
                                                  attributes:@{
                                                               NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 12),
                                                               NSForegroundColorAttributeName : PopdeemColor(PDThemeColorSecondaryFont),
                                                               NSParagraphStyleAttributeName: innerParagraphStyle
                                                               }];
        [labelAttString appendAttributedString:rulesString];
        if (_infoLabel == nil) {
            _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelX, currentY, _rewardView.frame.size.width - labelX - 15, 60)];
            [_rewardView addSubview:_infoLabel];
        } else {
            [_infoLabel setFrame:CGRectMake(labelX, currentY, _rewardView.frame.size.width - labelX - 15, 60)];
        }
        [_infoLabel setNumberOfLines:4];
        [_infoLabel setAttributedText:rulesString];
        CGSize infoSize = [_infoLabel sizeThatFits:CGSizeMake(_rewardView.frame.size.width - labelX - 15, MAXFLOAT)];
        CGRect infoLabelFrame = _infoLabel.frame;
        infoLabelFrame.size.height = infoSize.height;
        _infoLabel.frame = infoLabelFrame;
        currentY += _infoLabel.frame.size.height;
        _infoLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    } else {
        [_infoLabel removeFromSuperview];
        _infoLabel = nil;
    }
    
    float combinedHeight = _titleLabel.frame.size.height + _infoLabel.frame.size.height;
    float padding = (_rewardView.frame.size.height - combinedHeight) /2;
    [_titleLabel setFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y + padding, _titleLabel.frame.size.width, _titleLabel.frame.size.height)];
    [_infoLabel setFrame:CGRectMake(_infoLabel.frame.origin.x, _infoLabel.frame.origin.y + padding, _infoLabel.frame.size.width, _infoLabel.frame.size.height)];
    
    [_rewardView addSubview:_titleLabel];
    [_rewardView addSubview:_infoLabel];
}

# pragma mark - Socials

- (void) connectFacebookAccount {
    PDUIFBLoginWithWritePermsViewController *fbVC = [[PDUIFBLoginWithWritePermsViewController alloc] initForParent:self.navigationController
                                                                                                         loginType:PDFacebookLoginTypeRead];
    if (!fbVC) {
        return;
    }
    self.definesPresentationContext = YES;
    fbVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    fbVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLoginSuccess) name:FacebookLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLoginFailure) name:FacebookLoginFailure object:nil];
    [self presentViewController:fbVC animated:YES completion:^(void){
    }];
}

- (void) disconnectFacebookAccount {
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        PDSocialMediaManager *man = [PDSocialMediaManager manager];
        [man logoutFacebook];
        PDSocialAPIService *socialService = [[PDSocialAPIService alloc] init];
        [socialService disconnectFacebookAccountWithCompletion:^(NSError *err){
            
        }];
        PDUISocialClaimTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        [cell.socialSwitch setOn:NO animated:NO];
        AbraLogEvent(ABRA_EVENT_LOGOUT, (@{
                                           ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_FACEBOOK,
                                           ABRA_PROPERTYNAME_SOURCE_PAGE : @"Settings"
                                           }));  }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        PDUISocialClaimTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.socialSwitch setOn:YES];
            [self.tableView reloadData];
        });
    }];
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Disconnect Facebook Account" message:@"This action will disconnect your Facebook account. Are you sure you wish to proceed?" preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:ok];
    [ac addAction:cancel];
    [self presentViewController:ac animated:YES completion:^{
    }];
}

//- (void) connectTwitterAccount {
//    _twitterVC = [[PDUITwitterLoginViewController alloc] initForParent:self.navigationController];
//    if (!_twitterVC) {
//        return;
//    }
//    self.definesPresentationContext = YES;
//    _twitterVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//    _twitterVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(twitterLoginSuccess) name:TwitterLoginSuccess object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(twitterLoginFailure) name:TwitterLoginFailure object:nil];
//    [self presentViewController:_twitterVC animated:YES completion:^(void){
//    }];
//}

//- (void) disconnectTwitterAccount {
//
//    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        PDSocialAPIService *socialService = [[PDSocialAPIService alloc] init];
//        [socialService disconnectTwitterAccountWithCompletion:^(NSError *err){
//
//        }];
//        AbraLogEvent(ABRA_EVENT_DISCONNECT_SOCIAL_ACCOUNT, (@{
//                                                              ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_TWITTER,
//                                                              ABRA_PROPERTYNAME_SOURCE_PAGE : @"Settings"
//                                                              }));
//    }];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [cell.socialSwitch setOn:NO];
//            [_tableView reloadData];
//        });
//    }];
//    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Disconnect Twitter Account" message:@"This action will disconnect your Twitter account. Are you sure you wish to proceed?" preferredStyle:UIAlertControllerStyleAlert];
//    [ac addAction:ok];
//    [ac addAction:cancel];
//    [self presentViewController:ac animated:YES completion:^{
//    }];
//}

//- (void) connectInstagramAccount {
//    //    PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//
//    dispatch_async(dispatch_get_main_queue(), ^{
//        PDUIInstagramLoginViewController *instaVC = [[PDUIInstagramLoginViewController alloc] initForParent:self.navigationController delegate:self connectMode:YES];
//        if (!instaVC) {
//            return;
//        }
//        self.definesPresentationContext = YES;
//        instaVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
//        instaVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginSuccess) name:InstagramLoginSuccess object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginFailure) name:InstagramLoginFailure object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginUserDismissed) name:InstagramLoginuserDismissed object:nil];
//        [self.navigationController presentViewController:instaVC animated:YES completion:^(void){
//        }];
//    });
//}

//- (void) connectInstagramAccount:(NSString*)identifier accessToken:(NSString*)accessToken userName:(NSString*)userName {
//    PDAPIClient *client = [PDAPIClient sharedInstance];
//    _loadingView = [[PDUIModalLoadingView alloc] initForView:self.view titleText:@"Please Wait" descriptionText:@"Connecting Instagram"];
//    [_loadingView showAnimated:YES];
//    if ([[PDUser sharedInstance] isRegistered]) {
//        [client connectInstagramAccount:identifier accessToken:accessToken screenName:userName success:^(void){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//                [cell.socialSwitch setOn:YES animated:YES];
//                [self setProfile];
//                [self.tableView reloadData];
//                [self.tableView reloadInputViews];
//                [self.view setNeedsDisplay];
//                [_loadingView hideAnimated:YES];
//            });
//        } failure:^(NSError* error){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_loadingView hideAnimated:YES];
//            });
//            if ([[error.userInfo objectForKey:@"NSLocalizedDescription"] rangeOfString:@"already connected"].location != NSNotFound) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sorry - Wrong Account" message:@"This social account has been linked to another user." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//                    [av show];
//                });
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//                [cell.socialSwitch setOn:NO animated:YES];
//                [_loadingView hideAnimated:YES];
//                [self.view setNeedsDisplay];
//            });
//        }];
//    } else {
//        PDUserAPIService *service = [[PDUserAPIService alloc] init];
//        [service registerUserWithInstagramId:identifier accessToken:accessToken fullName:@"" userName:userName profilePicture:@"" success:^(PDUser *user) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//                [cell.socialSwitch setOn:YES animated:YES];
//                [_loadingView hideAnimated:YES];
//                [self.tableView reloadData];
//                [self.tableView reloadInputViews];
//                [self setProfile];
//                [self.view setNeedsDisplay];
//            });
//        } failure:^(NSError *error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [_loadingView hideAnimated:YES];
//                PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//                [cell.socialSwitch setOn:NO animated:NO];
//                [self.view setNeedsDisplay];
//            });
//        }];
//    }
//}

- (void) facebookLoginSuccess {
    PDUISocialClaimTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell.socialSwitch setOn:YES];
        [_tableView reloadInputViews];
    });
    AbraLogEvent(ABRA_EVENT_CONNECTED_ACCOUNT, (@{
                                                  ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_FACEBOOK,
                                                  ABRA_PROPERTYNAME_SOURCE_PAGE : @"Settings"
                                                  }));
    
    [self.tableView reloadData];
}

- (void) facebookLoginFailure {
    PDUISocialClaimTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [cell.socialSwitch setOn:NO];
    });
    [self.tableView reloadData];
}

//- (void) instagramLoginSuccess {
//    //    PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_tableView reloadInputViews];
//        [self.tableView reloadData];
//        [self setProfile];
//    });
//    AbraLogEvent(ABRA_EVENT_CONNECTED_ACCOUNT, (@{
//                                                  ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_INSTAGRAM,
//                                                  ABRA_PROPERTYNAME_SOURCE_PAGE : @"Settings"
//                                                  }));
//}
//
//- (void) instagramLoginFailure {
//    PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [cell.socialSwitch setOn:NO];
//        [_tableView reloadData];
//    });
//    [self.tableView reloadData];
//}
//
//- (void) instagramLoginUserDismissed {
//    PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [cell.socialSwitch setOn:NO];
//        [_tableView reloadData];
//    });
//}
//
//- (void) twitterLoginSuccess {
//    //    PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [_tableView reloadData];
//        [self setupHeaderView];
//    });
//    AbraLogEvent(ABRA_EVENT_CONNECTED_ACCOUNT, (@{
//                                                  ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_TWITTER,
//                                                  ABRA_PROPERTYNAME_SOURCE_PAGE : @"Settings"
//                                                  }));
//
//    [_twitterVC removeFromParentViewController];
//    _twitterVC = nil;
//}
//
//- (void) twitterLoginFailure {
//    PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [cell.socialSwitch setOn:NO];
//        [_tableView reloadData];
//    });
//    [_twitterVC removeFromParentViewController];
//}
//
//- (void) disconnectInstagramAccount {
//    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        PDSocialAPIService *socialService = [[PDSocialAPIService alloc] init];
//        [socialService disconnectInstagramAccountWithCompletion:^(NSError *err){
//
//        }];
//        AbraLogEvent(ABRA_EVENT_DISCONNECT_SOCIAL_ACCOUNT, (@{
//                                                              ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_INSTAGRAM,
//                                                              ABRA_PROPERTYNAME_SOURCE_PAGE : @"Settings"
//                                                              }));
//    }];
//    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        PDUISocialSettingsTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [cell.socialSwitch setOn:NO];
//            [_tableView reloadData];
//        });
//    }];
//    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Disconnect Instagram Account" message:@"This action will disconnect your Instagram account. Are you sure you wish to proceed?" preferredStyle:UIAlertControllerStyleAlert];
//    [ac addAction:ok];
//    [ac addAction:cancel];
//    [self presentViewController:ac animated:YES completion:^{
//    }];
//}

@end
