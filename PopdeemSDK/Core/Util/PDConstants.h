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
extern NSString *const MOMENTS_PATH;
extern NSString *const INSTAGRAM_URL;

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
extern NSString *const InstagramLoginSuccess;
extern NSString *const InstagramLoginFailure;
extern NSString *const PDUserLinkedToInstagram;
extern NSString *const InstagramVerifySuccess;
extern NSString *const InstagramVerifyFailure;
extern NSString *const InstagramVerifyNoAttempt;
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
extern NSString *const kEncodeKeyPDCaptionString;
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