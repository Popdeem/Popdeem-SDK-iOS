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
#import "PDUIClaimInfoTableViewCell.h"
#import "PDUIInstagramShareViewController.h"
#import "PDUIFacebookShareViewController.h"

@import Photos;

#define kPDUIClaimRewardTableViewCell @"PDUIClaimRewardTableViewCell"
#define kPDUIScanNowTableViewCell @"PDUIScanNowTableViewCell"
#define kPDUIAddPhotoTableViewCell @"PDUIAddPhotoTableViewCell"
#define kPDUISocialClaimTableViewCell @"PDUISocialClaimTableViewCell"
#define kPDUIClaimInfoTableViewCell @"PDUIClaimInfoTableViewCell"
#define FacebookCellIndexPath [NSIndexPath indexPathForRow:1 inSection:1]
#define TwitterCellIndexPath [NSIndexPath indexPathForRow:2 inSection:1]
#define InstagramCellIndexPath [NSIndexPath indexPathForRow:3 inSection:1]

@interface PDUIClaimV2ViewController ()

@property (nonatomic, retain) UIView *scanSectionView;
@property (nonatomic, retain) UIView *shareSectionView;
@property (nonatomic, strong) PDUIModalLoadingView *loadingView;
@property (nonatomic, retain) TOCropViewController *cropViewController;


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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginSuccess) name:InstagramLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginFailure:) name:InstagramLoginFailure object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramLoginUserDismiss) name:InstagramLoginuserDismissed object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramPostMade) name:PDUserLinkedToInstagram object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramVerifySuccess) name:InstagramVerifySuccess object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramVerifyFailure) name:InstagramVerifyFailure object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(instagramVerifyNoAttempt) name:InstagramVerifyNoAttempt object:nil];
    
    //Section Labels
    [self registerNibs];
    
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView reloadData];
    
    if (self.reward) {
        [self setupRewardView];
    }
    [self.tableView setScrollEnabled:NO];
    [self.continueButton.titleLabel setText:translationForKey(@"popdeem.claim.continuebutton.text", @"Continue")];
    [self.continueButton.titleLabel setFont:PopdeemFont(PDThemeFontPrimary, 16)];
    [self.continueButton setTintColor:PopdeemColor(PDThemeColorPrimaryApp)];
    
    CALayer *continueTopBorder = [CALayer layer];
    continueTopBorder.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 1.0f);
    continueTopBorder.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00].CGColor;
    [_continueButton.layer addSublayer:continueTopBorder];
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
    
    UINib *infoNib = [UINib nibWithNibName:@"PDUIClaimInfoTableViewCell" bundle:podBundle];
    [[self tableView] registerNib:infoNib forCellReuseIdentifier:kPDUIClaimInfoTableViewCell];
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
    float tableHeight = self.tableView.frame.size.height - 60;
    float singleHeight = tableHeight/6.5;
    if (indexPath.section == 1 && indexPath.row == 0) {
        return singleHeight * 1.5;
    }
    return singleHeight;
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
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //Scan Now Table View Cell
            PDUIScanNowTableViewCell *scanCell = [[self tableView] dequeueReusableCellWithIdentifier:kPDUIScanNowTableViewCell];
            return scanCell;
            
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            if (_userImage == nil) {
                PDUIAddPhotoTableViewCell *addPhotoCell = [[self tableView] dequeueReusableCellWithIdentifier:kPDUIAddPhotoTableViewCell];
                [addPhotoCell setPhoto:nil];
                return addPhotoCell;
            } else {
                //Cell for added photo
                PDUIAddPhotoTableViewCell *addPhotoCell = [[self tableView] dequeueReusableCellWithIdentifier:kPDUIAddPhotoTableViewCell];
                [addPhotoCell setPhoto:_userImage];
                return addPhotoCell;
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
        } else if (indexPath.row == 4) {
            PDUIClaimInfoTableViewCell *info = [[self tableView] dequeueReusableCellWithIdentifier:kPDUIClaimInfoTableViewCell];
            [info.infoLabel setText:[NSString stringWithFormat:@"Your check-in or photo must contain %@ in the caption to redeem this reward.", _reward.forcedTag]];
            return info;
        }
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    [cell setFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self showPhotoActionSheet];
        }
    }
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

- (void) facebookToggled:(BOOL)on {
    if (!on) {return;}
    NSLog(@"Toggled Facebook: %@", on ? @"ON" : @"OFF");
    PDUISocialClaimTableViewCell *twitterCell = [self twitterCell];
    if (twitterCell) {
        [twitterCell.socialSwitch setOn:NO];
    }
    PDUISocialClaimTableViewCell *instagramCell = [self instagramCell];
    if (instagramCell) {
        [instagramCell.socialSwitch setOn:NO];
    }
    if ([[PDSocialMediaManager manager] isLoggedInWithFacebook]) {
        _willFacebook = YES;
    } else {
        [self loginWithFacebook];
    }
}

- (void) twitterToggled:(BOOL)on {
    NSLog(@"Toggled Twitter: %@", on ? @"ON" : @"OFF");
    if (!on) {return;}
    PDUISocialClaimTableViewCell *instagramCell = [self instagramCell];
    if (instagramCell) {
        [instagramCell.socialSwitch setOn:NO];
    }
    PDUISocialClaimTableViewCell *facebookCell = [self facebookCell];
    if (facebookCell) {
        [facebookCell.socialSwitch setOn:NO];
    }
    [self validateTwitter];
}

- (void) instagramToggled:(BOOL)on {
    NSLog(@"Toggled Instagram: %@", on ? @"ON" : @"OFF");
    if (!on) {return;}
    
    PDSocialMediaManager *manager = [PDSocialMediaManager manager];
    [manager isLoggedInWithInstagram:^(BOOL isLoggedIn){
        if (!isLoggedIn) {
            dispatch_async(dispatch_get_main_queue(), ^{
                PDUIInstagramLoginViewController *instaVC = [[PDUIInstagramLoginViewController alloc] initForParent:self.navigationController delegate:self connectMode:YES];
                if (!instaVC) {
                    return;
                }
                self.definesPresentationContext = YES;
                instaVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
                instaVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
                [self presentViewController:instaVC animated:YES completion:^(void){}];
            });
        }
    }];
    _willInstagram = on;
    _willFacebook = NO;
    _willTweet = NO;
}

- (void) loginWithFacebook {
    
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

- (void) facebookLoginSuccess {
    
    AbraLogEvent(ABRA_EVENT_CONNECTED_ACCOUNT, (@{
                                                  ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_FACEBOOK,
                                                  ABRA_PROPERTYNAME_SOURCE_PAGE : @"Claim Screen"
                                                  }));
}

- (void) facebookLoginFailure {
    //Toggle Facebook Off
    PDUISocialClaimTableViewCell *facebookCell = [self facebookCell];
    if (facebookCell) {
        [facebookCell.socialSwitch setOn:NO];
    }
}

- (void) loginWithWritePerms {
    dispatch_async(dispatch_get_main_queue(), ^{
        PDUIFBLoginWithWritePermsViewController *fbVC = [[PDUIFBLoginWithWritePermsViewController alloc] initForParent:self.navigationController loginType:PDFacebookLoginTypePublish];
        if (!fbVC) {
            return;
        }
        self.definesPresentationContext = YES;
        fbVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
        fbVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:fbVC animated:YES completion:^(void){}];
    });
}

- (void) validateTwitter {
    [[PDSocialMediaManager manager] verifyTwitterCredentialsCompletion:^(BOOL connected, NSError *error) {
        if (!connected) {
            [self connectTwitter:^(){
                [self.continueButton setUserInteractionEnabled:YES];
            } failure:^(NSError *error) {
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:translationForKey(@"popdeem.common.error", @"Error")
                                                             message:translationForKey(@"popdeem.claim.twitter.notconnected", @"Twitter not connected, you must connect your twitter account in order to post to Twitter")
                                                            delegate:self
                                                   cancelButtonTitle:translationForKey(@"popdeem.common.back", @"Back")
                                                   otherButtonTitles: nil];
                [av show];
            }];
            [self.continueButton setUserInteractionEnabled:YES];
            return;
        }
        [self.continueButton setUserInteractionEnabled:YES];
    }];
}

- (void) connectTwitter:(void (^)(void))success failure:(void (^)(NSError *failure))failure {
    PDUITwitterLoginViewController *twitterVC = [[PDUITwitterLoginViewController alloc] initForParent:self.navigationController];
    if (!twitterVC) {
        return;
    }
    self.definesPresentationContext = YES;
    twitterVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    twitterVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(twitterLoginSuccess) name:TwitterLoginSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(twitterLoginFailure) name:TwitterLoginFailure object:nil];
    [self.navigationController presentViewController:twitterVC animated:YES completion:^(void){
    }];
}

- (void) twitterLoginSuccess {
    _willTweet = YES;
    [_loadingView hideAnimated:YES];
    PDUISocialClaimTableViewCell *twitterCell = [self twitterCell];
    if (twitterCell) {
        [twitterCell.socialSwitch setOn:YES];
    }
    AbraLogEvent(ABRA_EVENT_CONNECTED_ACCOUNT, (@{
                                                  ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_TWITTER,
                                                  ABRA_PROPERTYNAME_SOURCE_PAGE : @"Claim Screen"
                                                  }));
}

- (void) twitterLoginFailure {
    dispatch_async(dispatch_get_main_queue(), ^{
        PDLogError(@"Twitter didnt log in");
        _willTweet = NO;
        [_loadingView hideAnimated:YES];
        PDUISocialClaimTableViewCell *twitterCell = [self twitterCell];
        if (twitterCell) {
            [twitterCell.socialSwitch setOn:NO];
        }
    });
}

- (void) connectInstagramAccount:(NSString*)identifier accessToken:(NSString*)accessToken userName:(NSString*)userName {
    PDAPIClient *client = [PDAPIClient sharedInstance];
    if ([[PDUser sharedInstance] isRegistered]) {
        [client connectInstagramAccount:identifier accessToken:accessToken screenName:userName success:^(void){
            [[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginSuccess object:nil];
        } failure:^(NSError* error){
            [[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginFailure object:self userInfo:error.userInfo];
        }];
    } else {
        PDUserAPIService *service = [[PDUserAPIService alloc] init];
        [service registerUserWithInstagramId:identifier accessToken:accessToken fullName:@"" userName:userName profilePicture:@"" success:^(PDUser *user) {
            [[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginSuccess object:nil];
        } failure:^(NSError *error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginFailure object:nil];
        }];
    }
}

- (void) instagramLoginSuccess {
    self.willInstagram = YES;
    PDUISocialClaimTableViewCell *instagramCell = [self instagramCell];
    if (instagramCell) {
        [instagramCell.socialSwitch setOn:YES];
    }
    PDLog(@"Instagram Connected");
    AbraLogEvent(ABRA_EVENT_CONNECTED_ACCOUNT, (@{
                                                  ABRA_PROPERTYNAME_SOCIAL_NETWORK : ABRA_PROPERTYVALUE_SOCIAL_NETWORK_INSTAGRAM,
                                                  ABRA_PROPERTYNAME_SOURCE_PAGE : @"Claim Screen"
                                                  }));
}

- (void) instagramLoginUserDismiss {
    dispatch_async(dispatch_get_main_queue(), ^{
        PDUISocialClaimTableViewCell *instagramCell = [self instagramCell];
        if (instagramCell) {
            [instagramCell.socialSwitch setOn:NO];
        }
    });
}

- (void) instagramLoginFailure:(NSNotification*)notification {
    self.willInstagram = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        PDUISocialClaimTableViewCell *instagramCell = [self instagramCell];
        if (instagramCell) {
            [instagramCell.socialSwitch setOn:NO];
        }
   
        if ([[notification.userInfo objectForKey:@"NSLocalizedDescription"] rangeOfString:@"already connected"].location != NSNotFound) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Sorry - Wrong Account" message:@"This social account has been linked to another user." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [av show];
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Error"
                                                         message:@"There was a problem connecting your Instagram Account. Please try again later."
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
            [av show];
        }
    });
}

- (PDUISocialClaimTableViewCell*) facebookCell {
    PDUISocialClaimTableViewCell *cell = (PDUISocialClaimTableViewCell*)[self.tableView cellForRowAtIndexPath:FacebookCellIndexPath];
    if ([cell isKindOfClass:[PDUISocialClaimTableViewCell class]] && cell.socialMediaType == PDSocialMediaTypeFacebook) {
        return cell;
    }
    return nil;
}

- (PDUISocialClaimTableViewCell*) twitterCell {
    PDUISocialClaimTableViewCell *cell = (PDUISocialClaimTableViewCell*)[self.tableView cellForRowAtIndexPath:TwitterCellIndexPath];
    if ([cell isKindOfClass:[PDUISocialClaimTableViewCell class]] && cell.socialMediaType == PDSocialMediaTypeTwitter) {
        return cell;
    }
    return nil;
}

- (PDUISocialClaimTableViewCell*) instagramCell {
    PDUISocialClaimTableViewCell *cell = (PDUISocialClaimTableViewCell*)[self.tableView cellForRowAtIndexPath:InstagramCellIndexPath];
    if ([cell isKindOfClass:[PDUISocialClaimTableViewCell class]] && cell.socialMediaType == PDSocialMediaTypeInstagram) {
        return cell;
    }
    return nil;
}


#pragma mark - Camera Delegate

- (void)takePhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)selectPhoto {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.modalPresentationStyle = UIModalPresentationOverFullScreen;
    picker.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void) addPhotoToLibrary:(NSDictionary*)info {
    __block PHObjectPlaceholder *placeholder;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *request = [PHAssetChangeRequest creationRequestForAssetFromImage:info[UIImagePickerControllerOriginalImage]];
        placeholder = request.placeholderForCreatedAsset;
        _imageURLString = placeholder.localIdentifier;
    } completionHandler:^(BOOL success, NSError *error){
        if (success) {
            PDLog(@"Saved Image");
        }
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:NO completion:NULL];
    
    UIImage *img = info[UIImagePickerControllerOriginalImage];
    img = [self normalizedImage:img];
    CGRect cropRect = [info[@"UIImagePickerControllerCropRect"] CGRectValue];
    
    if (cropRect.size.width > 0 && !CGRectEqualToRect(CGRectMake(0, 0, img.size.width, img.size.height), cropRect)) {
        CGImageRef imageRef = CGImageCreateWithImageInRect([img CGImage], cropRect);
        img = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }
    
    _userImage = [self resizeImage:img withMinDimension:480];
    _cropViewController = [[TOCropViewController alloc] initWithImage:_userImage];
    _cropViewController.delegate = self;
    [self presentViewController:_cropViewController animated:NO completion:nil];
    _didAddPhoto = YES;
    
    NSString *source = (picker.sourceType == UIImagePickerControllerSourceTypeCamera) ? @"Camera" : @"Photo Library";
    AbraLogEvent(ABRA_EVENT_ADDED_CLAIM_CONTENT, (@{ABRA_PROPERTYNAME_PHOTO : @"Yes", @"Source" : source}));
}

- (void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle
{
    [_spoofView removeFromSuperview];
    if (_cropViewController) {
        [_cropViewController dismissViewControllerAnimated:NO completion:nil];
    }
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined || [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self addPhotoToLibrary:@{UIImagePickerControllerOriginalImage: image}];
            } else {
                PDLog(@"Error saving photo to Library");
            }
        }];
    } else {
        [self addPhotoToLibrary:@{UIImagePickerControllerOriginalImage: image}];
    }
    _userImage = image;
    [self.tableView reloadData];
}

- (void)cropViewController:(nonnull TOCropViewController *)cropViewController didFinishCancelled:(BOOL)cancelled {
    [self.spoofView removeFromSuperview];
    if (_cropViewController) {
        [_cropViewController dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void) showPhotoActionSheet {
    _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _alertWindow.rootViewController = [UIViewController new];
    _alertWindow.windowLevel = 10000001;
    _alertWindow.hidden = NO;
    
    __weak __typeof(self) weakSelf = self;
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Choose Source" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.alertWindow.hidden = YES;
        weakSelf.alertWindow = nil;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.alertWindow.hidden = YES;
        weakSelf.alertWindow = nil;
        [weakSelf takePhoto];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Camera Roll" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        weakSelf.alertWindow.hidden = YES;
        weakSelf.alertWindow = nil;
        [weakSelf selectPhoto];
    }]];
    if (self.userImage != nil) {
        [alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.alertWindow.hidden = YES;
            weakSelf.alertWindow = nil;
            weakSelf.userImage = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        }]];
    }
    
    [_alertWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

- (UIImage *)normalizedImage:(UIImage*)image {
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo {
    _userImage = [self resizeImage:image withMinDimension:460];
}

- (UIImage *)resizeImage:(UIImage *)inImage
        withMinDimension:(CGFloat)minDimension {
    
    CGFloat aspect = inImage.size.width / inImage.size.height;
    CGSize newSize;
    
    if (inImage.size.width > inImage.size.height) {
        newSize = CGSizeMake(minDimension*aspect, minDimension);
    } else {
        newSize = CGSizeMake(minDimension, minDimension/aspect);
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 1.0);
    CGRect newImageRect = CGRectMake(0.0, 0.0, newSize.width, newSize.height);
    [inImage drawInRect:newImageRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark - Continue Button Pressed -

- (IBAction)continueButtonPressed:(id)sender {
    //Next steps depending on the network selected
    [self.continueButton setUserInteractionEnabled:NO];
    if (_willFacebook) {
        [self shareOnFacebook];
    } else if (_willTweet) {
        
    } else if (_willInstagram) {
        [self validateInstagramOptionsAndClaim];
        [self.continueButton setUserInteractionEnabled:YES];
    } else {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:translationForKey(@"popdeem.claim.chooseNetwork", @"Choose Network")
                                                                       message:translationForKey(@"popdeem.claim.networkerror",  @"No Network Selected, you must select at least one social network in order to complete this action.")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:translationForKey(@"popdeem.common.ok", @"OK") style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        [self.continueButton setUserInteractionEnabled:YES];
        return;
    }
}

# pragma mark - Instagram -

- (void) validateInstagramOptionsAndClaim {
    if (!_userImage) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:translationForKey(@"popdeem.claim.action.photo", @"Photo Required")
                                                                       message:translationForKey(@"popdeem.claim.action.photoMessage", @"A photo is required for this action. Please add a photo.")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:translationForKey(@"popdeem.common.ok", @"OK") style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        [self.continueButton setUserInteractionEnabled:YES];
        AbraLogEvent(ABRA_EVENT_RECEIVED_ERROR_ON_CLAIM, @{
                                                           ABRA_PROPERTYNAME_ERROR : ABRA_PROPERTYVALUE_ERROR_NOPHOTO
                                                           });
        return;
    }
    
    PDUIInstagramShareViewController *isv = [[PDUIInstagramShareViewController alloc] initForParent:self.navigationController withMessage:@"" image:_userImage imageUrlString:_imageURLString];
    self.definesPresentationContext = YES;
    isv.modalPresentationStyle = UIModalPresentationOverFullScreen;
    isv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self presentViewController:isv animated:YES completion:^(void){}];
    _didGoToInstagram = YES;
    return;
}

# pragma mark - Facebook Sharing -

- (void) shareOnFacebook {
    
    if (_reward.action == PDRewardActionPhoto && _userImage == nil) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:translationForKey(@"popdeem.claim.action.photo", @"Photo Required")
                                                                       message:translationForKey(@"popdeem.claim.action.photoMessage", @"A photo is required for this action. Please add a photo.")
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:translationForKey(@"popdeem.common.ok", @"OK") style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        [self.continueButton setUserInteractionEnabled:YES];
        return;
    }
    
    PDUIFacebookShareViewController *isv = [[PDUIFacebookShareViewController alloc] initForParent:self.navigationController withMessage:@"" image:_userImage imageUrlString:_imageURLString];
    self.definesPresentationContext = YES;
    isv.modalPresentationStyle = UIModalPresentationOverFullScreen;
    isv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    isv.reward = _reward;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self presentViewController:isv animated:YES completion:^(void){}];
    [_continueButton setUserInteractionEnabled:YES];
    return;
}

@end