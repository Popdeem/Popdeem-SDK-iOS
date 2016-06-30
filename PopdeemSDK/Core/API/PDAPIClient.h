//
//  PDAPIClient.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
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

#import <Foundation/Foundation.h>
#import "PDConstants.h"
#import "PDLocation.h"
#import "PDLocationStore.h"
#import "PDUtils.h"
#import "PDUser.h"
#import "PDRewardStore.h"
#import "PDWallet.h"
#import "PDBrandStore.h"
#import "PDUser+Facebook.h"
#import "PDFeeds.h"
#import "PDReferral.h"

NS_ASSUME_NONNULL_BEGIN

/*!
 * @abstract PDAPIClient
 *
 *@discussion PDAPIClient is your main interface for using the Popdeem API. With the client you can retrieve all of the information and data necessary to use the Popdeem platform in your app.
 *
 *  For an in-depth walk through and sample code, see our [iOS Documentation](http://www.popdeem.com/developer/iosdocs "iOS Docs")
 */
@interface PDAPIClient : NSObject

/**
 * @abstract The device token for the user
 * @discussion This should be set as early as possible in the app lifecycle
 */
@property (nonatomic, strong, nullable) NSString *deviceToken;
@property (nonatomic, strong, nullable) PDReferral *referral;
@property (nonatomic, strong, nullable) NSString *thirdPartyToken;

/*!
 * @abstract Return the shared API Client
 *
 *@discussion This returns the singleton instance of PDAPIClient.
 *
 *@return shared API Client
 */
+ (id) sharedInstance;

///-----------------------
///@name Methods
///-----------------------
/*!
* @abstract Get User Details
*
*@discussion Get user details from the Popdeem Server. To retrieve these details, you need the userToken and identifier for the user. A typical use of this endpoint would be to store the user token and identifier on the device, and to retrieve the latest user details on startup. On success, [PDUser sharedInstance} will return the updated user.
 *
 *@param userId the Popdeem Identifier (user.identifier) for the User
 *@param authToken the Popdeem authentication Token (user.userToken) for the User
 *@param success block to be called on success
 *@param failure block to be called on failure
 */
- (void) getUserDetailsForId:(NSString*)userId
         authenticationToken:(NSString*)authToken
                     success:(void (^)(PDUser *user))success
                     failure:(void (^)(NSError *error))failure;

/// ---------------------
///@name Register User
///-----------------------
 /*!
 * @abstract Register User
 *
 *@discussion Use this method to register a user with Popdeem. You must retrieve the User's Facebook Access Token and Facebook ID using the FacebookSDK before. This will result in [PDUser sharedInstance] returning the Popdeem user associated with the logged in Facebook user. NB - if you use this method using credentials of an already registered user, you will just get back that user. You may use this to 'reregister' when a user access token has expired.
 *
 *@param facebookAccessToken (NSString*) the Popdeem Identifier (user.identifier) for the User
 *@param facebookId the Popdeem authentication Token (user.userToken) for the User
 *@param success block to be called on success
 *@param failure block to be called on failure
 */
- (void) registerUserwithFacebookAccesstoken:(NSString*)facebookAccessToken
                                  facebookId:(NSString*)facebookId
                                     success:(void (^)(PDUser *user))success
                                     failure:(void (^)(NSError *error))failure;


- (void) connectTwitterAccount:(NSString*)userId
                   accessToken:(NSString*)accessToken
                  accessSecret:(NSString*)accessSecret
                       success:(void (^)(void))success
                       failure:(void (^)(NSError *error))failure;

- (void) connectInstagramAccount:(NSString*)userId
										 accessToken:(NSString*)accessToken
											screenName:(NSString*)screenName
												 success:(void (^)(void))success
												 failure:(void (^)(NSError *error))failure;

///---------------------
/// @name Update User
///-----------------------
/*!
 * @abstract Update User Location and Device Token
 *
 * @discussion Use this method to update the users location and device token on the Popdeem server. It is recommended to do this often as the user moves around, so we can accurately apply location filtering.
 * @param success block to be called on success
 * @param failure block to be called on failure
 */
- (void) updateUserLocationAndDeviceTokenSuccess:(void (^)(PDUser *user))success
                                         failure:(void (^)(NSError *error))failure;

///---------------------
/// @name Locations
///-----------------------
/*!
 * @abstract Get all locations
 *
 * @discussion This will return all of the locations for the current Customer
 * @param success block to be called on success
 * @param failure block to be called on failure
 */
- (void) getAllLocationsSuccess:(void (^)(void))success
                        failure:(void (^)(NSError *error))failure;

- (void) getLocationsForBrandId:(NSInteger)brandId
                        success:(void (^)(void))success
                        failure:(void (^)(NSError *error))failure;

/// ---------------------
/// @name Rewards
///-----------------------
/*!
 * @abstract Get all Rewards
 *
 * @discussion This will return all of the available rewards for the user. In most cases, this will not be your method to obtain rewards. Use getAllBrands and then getRewardsForBrandId, or getAllLocations and getRewardsForLocationId to obtain rewards in more manageable chunks
 * @param success block to be called on success
 * @param failure block to be called on failure
 */
- (void) getAllRewardsSuccess:(void (^)(void))success
                      failure:(void (^)(NSError *error))failure;

/*!
 * @abstract Get all Rewards With Bundled Brand Key
 *
 * @discussion This will return all of the available rewards for the brand key specified in the info.plist, if there is one. If there is none specified, this behaves as getAllRewards
 * @param success block to be called on success
 * @param failure block to be called on failure
 */
- (void) getAllRewardsWithBundledBrandKeySuccess:(void (^)(void))success
                                         failure:(void (^)(NSError *error))failure;

/*!
 * @abstract Get all Rewards With Specified Brand Key
 *
 * @discussion This will return all of the available rewards for the brand key specified in the params, if there is one. If there is none specified, this behaves as getAllRewards
 * @param brandKey the Popdeem key for the brand
 * @param success block to be called on success
 * @param failure block to be called on failure
 */
- (void) getAllRewardsByBrandKey:(NSString*)brandKey
                         success:(void (^)(void))success
                         failure:(void (^)(NSError *error))failure;

///---------------------
/// @name Wallet
///-----------------------
/*!
 * @abstract Get all Rewards in Wallet
 *
 * @discussion This will return all of the available rewards in the Wallet.
 * @param success block to be called on success
 * @param failure block to be called on failure
 */
- (void) getRewardsInWalletSuccess:(void (^)(void))success
                           failure:(void (^)(NSError *error))failure;

/*!
 * @abstract Get all Rewards in Wallet With Bundled Brand Key
 *
 * @discussion This will return all of the available rewards in the Wallet for the brand key specified in info.plist, if there is one. If there is none specified, this behaves as getAllWalletRewards
 * @param success block to be called on success
 * @param failure block to be called on failure
 */
- (void) getAllWalletRewardsWithBundledBrandKeySuccess:(void (^)(void))success
                                               failure:(void (^)(NSError *error))failure;

- (void) getRewardsForBrandId:(NSInteger)brandid
                      success:(void (^)(void))success
                      failure:(void (^)(NSError *error))failure;

/*!
 * @abstract Get all Rewards in Wallet With Specified Brand Key
 *
 * @discussion This will return all of the available rewards in the Wallet for the brand key specified in the params, if there is one. If there is none specified, this behaves as getAllWalletRewards
 * @param brandKey the Popdeem key for the brand
 * @param success block to be called on success
 * @param failure block to be called on failure
 */
- (void) getAllWalletRewardsByBrandKey:(NSString*)brandKey
                               success:(void (^)(void))success
                               failure:(void (^)(NSError *error))failure;

/// ---------------------
/// @name Claim Reward
///-----------------------
/*!
 * @abstract Claim Reward
 *
 * @discussion Claim the specified reward. If the reward action is photo or checkin, this action will result in a post being generated with the provided params. If the reward action is photo, an image must be passed, or this method will fail.
 * @param rewardId the identifier of the reward to be claimed
 * @param message the message string to be posted to Social Media (may be nil)
 * @param taggedFriends the array of tagged friends (may be nil)
 * @param image the image to attach to the post (may be nil)
 * @param success block to be called on success
 * @param failure block to be called on failure
 */
- (void) claimReward:(NSInteger)rewardId
            location:(PDLocation*)location
         withMessage:(nullable NSString*)message
       taggedFriends:(nullable NSArray*)taggedFriends
               image:(nullable UIImage*)image
            facebook:(BOOL)facebook
             twitter:(BOOL)twitter
					 instagram:(BOOL)instagram
             success:(void (^)(void))success
             failure:(void (^)(NSError *error))failure;

/// ---------------------
/// @name Redeem Reward
///-----------------------
/*!
 * @abstract Redeem reward
 *
 * @discussion Redeem the specified reward. Redemption refers to taking action on a *Wallet* reward, to recieve your reward, most likely at a physical location. On success, the reward in question will be removed from the wallet of the user. You should refresh your wallet views if necessary to display this data change, or it will result in an error if the user tries to redeem a reward twice.
 * @param rewardId the identifier of the reward to be redeemed
 * @param success block to be called on success
 * @param failure block to be called on failure
 */
- (void) redeemReward:(NSInteger)rewardId
              success:(void (^)(void))success
              failure:(void (^)(NSError *error))failure;

/*!
 * @abstract Redeem reward on behalf of a user.
 *
 * @discussion Redeem the specified reward on behalf of a user. In this use case, the redemption is being performed by an app in which the user is not logged in. I.E the redemption is being performed at the POS, and not on the users device.
 * @param rewardId the identifier of the reward to be redeemed
 * @param authenticationToken the authentication token for the user
 * @param success block to be called on success
 * @param failure block to be called on failure
 */
//- (void) redeemReward:(NSInteger)rewardId
// forUserWithAuthToken:(NSString*)authenticationToken
//              success:(void (^)(void))success
//              failure:(void (^)(NSError *error))failure;

/// ---------------------
/// @name Feed
///-----------------------
/*!
 * @abstract Get Feeds
 *
 * @discussion The Feeds return a feed of previous activities. The populated feed is accessible via [PDFeeds feed];
 * @param success block to be called on success
 * @param failure block to be called on failure
 */
- (void) getFeedsSuccess:(void (^)(void))success
                 failure:(void (^)(NSError *error))failure;


-(void) getBrandsSuccess:(void (^)(void))success
                 failure:(void (^)(NSError *error))failure;

@end
NS_ASSUME_NONNULL_END
