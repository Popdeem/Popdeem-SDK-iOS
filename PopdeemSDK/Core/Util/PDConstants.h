//
//  PDConstants.h
//  Popdeem
//
//  Created by Niall Quinn on 20/05/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "PDAbraConstants.h"

//
//API URL Strings
//
extern NSString *const USERS_PATH;
extern NSString *const REWARDS_PATH;
extern NSString *const LOCATIONS_PATH;
extern NSString *const WALLET_PATH;
extern NSString *const MESSAGES_PATH;
extern NSString *const FEEDS_PATH;
extern NSString *const BRANDS_PATH;
extern NSString *const MOMENTS_PATH;
extern NSString *const INSTAGRAM_URL;
extern NSString *const CUSTOMER_PATH;
extern NSString *const READ_TIER_PATH;

extern NSString *const FACEBOOK_NETWORK;
extern NSString *const TWITTER_NETWORK;
extern NSString *const INSTAGRAM_NETWORK;

//
//NSNotificationCenter Strings
//
extern NSString *const PDAPIClientDidClaimRewardNotification;
extern NSString *const PDAPIClientDidFailWithErrorNotification;
extern NSString *const PDBrandCoverImageDidDownload;
extern NSString *const PDBrandLogoImageDidDownload;
extern NSString *const PDRewardCoverImageDidDownload;
extern NSString *const PDFeedItemImageDidDownload;
extern NSString *const PDUserDidLogout;
extern NSString *const PDUserDidLogin;
extern NSString *const PDUserDidUpdate;
extern NSString *const InstagramLoginSuccess;
extern NSString *const InstagramLoginFailure;
extern NSString *const InstagramLoginuserDismissed;
extern NSString *const InstagramLoginCancelPressed;
extern NSString *const TwitterLoginSuccess;
extern NSString *const TwitterLoginFailure;
extern NSString *const PDUserLinkedToInstagram;
extern NSString *const InstagramVerifySuccess;
extern NSString *const InstagramVerifyFailure;
extern NSString *const InstagramVerifySuccessFromWallet;
extern NSString *const InstagramVerifyFailureFromWallet;
extern NSString *const InstagramVerifyNoAttempt;
extern NSString *const InstagramAppReturn;
extern NSString *const FacebookPublishSuccess;
extern NSString *const FacebookPublishFailure;
extern NSString *const FacebookLoginSuccess;
extern NSString *const FacebookLoginFailure;
extern NSString *const InstagramPostMade;
extern NSString *const NotificationReceived;
extern NSString *const DidFetchBrands;
extern NSString *const DirectToSocialHome;
extern NSString *const PDUserLinkedToFacebook;
extern NSString *const ShouldUpdateTableView;

extern NSString *const SocialLoginTakeoverUserLoggedIn;
extern NSString *const SocialLoginTakeoverDismissed;




    //
//End NSNotificationCenter Strings
//

//
//Theme File Keys
//
extern NSString *const PDThemeColorPrimaryApp;
extern NSString *const PDThemeColorPrimaryInverse;
extern NSString *const PDThemeColorViewBackground;
extern NSString *const PDThemeColorPrimaryFont;
extern NSString *const PDThemeColorSecondaryFont;
extern NSString *const PDThemeColorSecondaryApp;
extern NSString *const PDThemeColorTertiaryFont;
extern NSString *const PDThemeColorTableViewCellBackground;
extern NSString *const PDThemeColorTableViewSeperator;
extern NSString *const PDThemeColorNavBarTint;
extern NSString *const PDThemeColorSegmentedControlBackground;
extern NSString *const PDThemeColorSegmentedControlForeground;
extern NSString *const PDThemeImageLogin;
extern NSString *const PDThemeImageDefaultItem;
extern NSString *const PDThemeImageDefaultBrand;
extern NSString *const PDThemeFontPrimary;
extern NSString *const PDThemeFontBold;
extern NSString *const PDThemeFontNavbar;
extern NSString *const PDThemeFontLight;
extern NSString *const PDThemeNavUseTheme;
extern NSString *const PDThemeColorHomeHeaderText;

extern NSString *const PDThemeColorRewardAction;
extern NSString *const PDThemeColorButtons;

extern NSString *const PDThemeTitleFontSize;
extern NSString *const PDThemeBodyFontSize;

extern NSString *const PDThemeSocialLoginVariation;

extern NSString *const PDSocialLoginDesignVariation1;
extern NSString *const PDSocialLoginDesignVariation2;

extern NSString *const PDThemeSocialLoginTransition;
extern NSString *const PDSocialLoginTransition1;
extern NSString *const PDSocialLoginTransition2;

//
//NSCoding Keys
//

//Universal
extern NSString *const kEncodeKeyPDUserFirstName;
extern NSString *const kEncodeKeyPDUserLastName;
extern NSString *const kEncodeKeyPDUserId;
extern NSString *const kEncodeKeyPDImageUrlString;
extern NSString *const kEncodeKeyPDBrandName;
extern NSString *const kEncodeKeyPDDescriptionString;
extern NSString *const kEncodeKeyPDUserProfilePictureString;

//PDFeedItem
extern NSString *const kEncodeKeyPDActionText;
extern NSString *const kEncodeKeyPDActionImage;
extern NSString *const kEncodeKeyPDBrandLogoUrlString;
extern NSString *const kEncodeKeyPDRewardTypeString;
extern NSString *const kEncodeKeyPDTimeAgoString;
extern NSString *const kEncodeKeyPDUserProfileImage;
extern NSString *const kEncodeKeyPDCaptionString;
//
// End NSCoding Keys
//

extern NSString *const PDGratitudeLastCreditCouponUsed;
extern NSString *const PDGratitudeLastCouponUsed;
extern NSString *const PDGratitudeLastSweepstakeUsed;
extern NSString *const PDGratitudeLastConnectUsed;
extern NSString *const PDGratitudeLastLoginUsed;
extern NSString *const PDGratCouponVariations;
extern NSString *const PDGratSweepstakeVariations;
extern NSString *const PDGratCreditCouponVariations;
extern NSString *const PDGratConnectVariations;
extern NSString *const PDGratLoginVariations;

//Errors
//Error codes
static NSString *const kPopdeemErrorDomain = @"PopdeemErrorDomain";
typedef NS_ENUM(NSInteger, PDErrorCode) {
    PDErrorCodeNoAPIKey = 27000,
    PDErrorCodeUserCreationFailed = 27001,
    PDErrorCodeGetLocationsFailed = 27002,
    PDErrorCodeClaimFailed = 27003,
    PDErrorCodeRedeemFailed = 27004,
    PDErrorCodeGetFeedsFailed = 27005,
    PDErrorCodeGetBrandsFailed = 27006,
    PDErrorCodeImageDownloadFailed = 27007,
    PDErrorCodeFBPermissions = 27008,
    PDErrorCodeTWPermissions = 27009
};
