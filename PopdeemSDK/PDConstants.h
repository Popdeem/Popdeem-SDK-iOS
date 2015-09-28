//
//  PDConstants.h
//  Popdeem
//
//  Created by Niall Quinn on 20/05/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

//
//API URL Strings
//
extern NSString *const API_URL;
extern NSString *const USERS_PATH;
extern NSString *const REWARDS_PATH;
extern NSString *const LOCATIONS_PATH;
extern NSString *const WALLET_PATH;
extern NSString *const MESSAGES_PATH;
extern NSString *const FEEDS_PATH;
extern NSString *const BRANDS_PATH;

//
//NSNotificationCenter Strings
//
extern NSString *const PDAPIClientDidClaimRewardNotification;
extern NSString *const PDAPIClientDidFailWithErrorNotification;
extern NSString *const PDBrandCoverImageDidDownload;
extern NSString *const PDBrandLogoImageDidDownload;
extern NSString *const PDRewardCoverImageDidDownload;
//
//End NSNotificationCenter Strings
//

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
//
// End NSCoding Keys
//


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

