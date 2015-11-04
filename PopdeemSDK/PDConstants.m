//
//  PDConstants.m
//  Popdeem
//
//  Created by Niall Quinn on 25/05/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDConstants.h"

/*
 API URL Strings
 */
NSString *const API_URL = @"http://api.popdeem.com/";
NSString *const USERS_PATH = @"api/v2/users";
NSString *const REWARDS_PATH = @"api/v2/rewards";
NSString *const LOCATIONS_PATH = @"api/v2/locations";
NSString *const WALLET_PATH = @"api/v2/rewards/wallet";
NSString *const MESSAGES_PATH = @"api/v2/messages";
NSString *const FEEDS_PATH = @"api/v2/feeds";
NSString *const BRANDS_PATH = @"api/v2/brands";
/*
 End API URL Strings
 */

/*
 NSNotificationCenter Strings
 */
NSString *const PDAPIClientDidClaimRewardNotification = @"PDAPIClientDidClaimRewardNotification";
NSString *const PDAPIClientDidFailWithErrorNotification = @"PDAPIClientDidFailWithErrorNotification";
NSString *const PDBrandCoverImageDidDownload = @"BrandCoverImageDidDownload";
NSString *const PDBrandLogoImageDidDownload = @"BrandLogoImageDidDownload";
NSString *const PDRewardCoverImageDidDownload = @"RewardCoverImageDidDownload";
NSString *const PDFeedItemImageDidDownload = @"PDFeedItemImageDidDownload";
/*
 End NSNotificationCenter Strings
 */

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
NSString *const kEncodeKeyPDBrandLogoUrlString = @"PDBrandLogoUrlString";
NSString *const kEncodeKeyPDRewardTypeString = @"PDRewardTypeString";
NSString *const kEncodeKeyPDTimeAgoString = @"PDTimeAgoString";
NSString *const kEncodeKeyPDUserProfileImage = @"PDProfilePicString";
/*
 End NSCoding Keys
 */
