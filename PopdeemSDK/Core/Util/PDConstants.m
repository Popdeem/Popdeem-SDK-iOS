//
//  PDConstants.m
//  Popdeem
//
//  Created by Niall Quinn on 25/05/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDConstants.h"
#import "PDUtils.h"
#import "PopdeemSDK.h"
/*
 API URL Strings
 */

NSString *const USERS_PATH = @"api/v2/users";
NSString *const REWARDS_PATH = @"api/v2/rewards";
NSString *const LOCATIONS_PATH = @"api/v2/locations";
NSString *const WALLET_PATH = @"api/v2/rewards/wallet";
NSString *const MESSAGES_PATH = @"api/v2/messages";
NSString *const FEEDS_PATH = @"api/v2/feeds";
NSString *const BRANDS_PATH = @"api/v2/brands";
NSString *const MOMENTS_PATH = @"api/v2/moments";
NSString *const INSTAGRAM_URL = @"https://api.instagram.com/v1";
NSString *const CUSTOMER_PATH = @"api/v2/customer";
NSString *const READ_TIER_PATH = @"readed_tier";
/*
 End API URL Strings
 */

/*
 * Network Type
 */
NSString *const FACEBOOK_NETWORK = @"facebook";
NSString *const TWITTER_NETWORK = @"twitter";
NSString *const INSTAGRAM_NETWORK = @"instagram";

/*
 NSNotificationCenter Strings
 */
NSString *const PDAPIClientDidClaimRewardNotification = @"PDAPIClientDidClaimRewardNotification";
NSString *const PDAPIClientDidFailWithErrorNotification = @"PDAPIClientDidFailWithErrorNotification";
NSString *const PDBrandCoverImageDidDownload = @"BrandCoverImageDidDownload";
NSString *const PDBrandLogoImageDidDownload = @"BrandLogoImageDidDownload";
NSString *const PDRewardCoverImageDidDownload = @"RewardCoverImageDidDownload";
NSString *const PDFeedItemImageDidDownload = @"PDFeedItemImageDidDownload";
NSString *const PDUserDidLogout = @"PDUserDidLogout";
NSString *const PDUserDidLogin = @"PDUserDidLogin";
NSString *const PDUserDidUpdate = @"PDUserDidUpdate";
NSString *const InstagramLoginSuccess = @"InstagramLoginSuccess";
NSString *const InstagramLoginFailure = @"InstagramLoginFailure";
NSString *const InstagramLoginuserDismissed = @"InstagramLoginuserDismissed";
NSString *const InstagramLoginCancelPressed = @"InstagramLoginCancelPressed";
NSString *const TwitterLoginSuccess = @"TwitterLoginSuccess";
NSString *const TwitterLoginFailure = @"TwitterLoginFailure";
NSString *const InstagramVerifySuccessFromWallet = @"InstagramVerifySuccessFromWallet";
NSString *const InstagramVerifyFailureFromWallet = @"InstagramVerifyFailureFromWallet";
NSString *const FacebookPublishSuccess = @"FacebookPublishSuccess";
NSString *const FacebookPublishFailure = @"FacebookPublishFailure";
NSString *const FacebookLoginSuccess = @"FacebookLoginSuccess";
NSString *const FacebookLoginFailure = @"FacebookLoginFailure";
NSString *const PDUserLinkedToInstagram = @"PDUserLinkedToInstagram";
NSString *const InstagramVerifySuccess = @"InstagramVerifySuccess";
NSString *const InstagramVerifyFailure = @"InstagramVerifyFailure";
NSString *const InstagramVerifyNoAttempt = @"InstagramVerifyNoAttempt";
NSString *const InstagramAppReturn = @"InstagramAppReturn";
NSString *const InstagramPostMade = @"InstagramPostMade";
NSString *const NotificationReceived = @"NotificationReceived";
NSString *const DidFetchBrands = @"DidFetchBrands";
NSString *const DirectToSocialHome = @"DirectToSocialHome";
/*
 End NSNotificationCenter Strings
 */

/*
 * PDTheme Keys
 */
NSString *const PDThemeColorPrimaryApp = @"popdeem.colors.primaryAppColor";
NSString *const PDThemeColorPrimaryInverse = @"popdeem.colors.primaryInverseColor";
NSString *const PDThemeColorViewBackground = @"popdeem.colors.viewBackgroundColor";
NSString *const PDThemeColorPrimaryFont = @"popdeem.colors.primaryFontColor";
NSString *const PDThemeColorSecondaryFont = @"popdeem.colors.secondaryFontColor";
NSString *const PDThemeColorSecondaryApp = @"popdeem.colors.secondaryAppColor";
NSString *const PDThemeColorTertiaryFont = @"popdeem.colors.tertiaryFontColor";
NSString *const PDThemeColorTableViewCellBackground = @"popdeem.colors.tableViewCellBackgroundColor";
NSString *const PDThemeColorTableViewSeperator = @"popdeem.colors.tableViewSeperatorColor";
NSString *const PDThemeColorNavBarTint = @"popdeem.colors.navBarTintColor";
NSString *const PDThemeColorSegmentedControlBackground = @"popdeem.colors.segmentedControlBackgroundColor";
NSString *const PDThemeColorSegmentedControlForeground = @"popdeem.colors.segmentedControlForegroundColor";
NSString *const PDThemeImageLogin = @"popdeem.images.loginImage";
NSString *const PDThemeImageDefaultItem = @"popdeem.images.defaultItemImage";
NSString *const PDThemeImageDefaultBrand = @"popdeem.images.defaultBrandImage";
NSString *const PDThemeFontPrimary = @"popdeem.fonts.primaryFont";
NSString *const PDThemeFontBold = @"popdeem.fonts.boldFont";
NSString *const PDThemeFontLight = @"popdeem.fonts.lightFont";
NSString *const PDThemeNavUseTheme = @"popdeem.nav.useTheme";
NSString *const PDThemeColorHomeHeaderText = @"popdeem.colors.homeHeaderTextColor";

/*
 NSCoding Keys
 */
//Universal Keys
NSString *const kEncodeKeyPDUserFirstName = @"PDUserFirstName";
NSString *const kEncodeKeyPDUserLastName = @"PDUserLastName";
NSString *const kEncodeKeyPDUserId = @"PDUserId";
NSString *const kEncodeKeyPDImageUrlString = @"PDImageURLString";
NSString *const kEncodeKeyPDBrandName = @"PDBrandName";
NSString *const kEncodeKeyPDDescriptionString = @"PDDescriptionString";
NSString *const kEncodeKeyPDUserProfilePictureString = @"PDUserProfilePictureString";
//Feeds Keys
NSString *const kEncodeKeyPDActionText = @"PDActionText";
NSString *const kEncodeKeyPDActionImage = @"ActionImage";
NSString *const kEncodeKeyPDCaptionString = @"CaptionString";
NSString *const kEncodeKeyPDBrandLogoUrlString = @"PDBrandLogoUrlString";
NSString *const kEncodeKeyPDRewardTypeString = @"PDRewardTypeString";
NSString *const kEncodeKeyPDTimeAgoString = @"PDTimeAgoString";
NSString *const kEncodeKeyPDUserProfileImage = @"PDProfilePicString";
/*
 End NSCoding Keys
 */

//Gratitude
NSString *const PDGratitudeLastCreditCouponUsed = @"PDGratLastCreditCoupon";
NSString *const PDGratitudeLastCouponUsed = @"PDGratLastCoupon";
NSString *const PDGratitudeLastSweepstakeUsed = @"PDGratLastSweepstake";
NSString *const PDGratitudeLastConnectUsed = @"PDGratLastConnect";
NSString *const PDGratitudeLastLoginUsed = @"PDGratLastLogin";
NSString *const PDGratCouponVariations = @"PDGratCouponVariations";
NSString *const PDGratSweepstakeVariations = @"PDGratSweepstakeVariations";
NSString *const PDGratCreditCouponVariations = @"PDGratCreditCouponVariations";
NSString *const PDGratConnectVariations = @"PDGratConnectVariations";
NSString *const PDGratLoginVariations = @"PDGratLoginVariations";

