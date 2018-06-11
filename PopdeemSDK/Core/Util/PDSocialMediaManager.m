//
//  PDSocialMediaManager.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 28/09/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDSocialMediaManager.h"
#import "PDUser.h"
#import "PDConstants.h"
#import "PDUtils.h"
#import "PDAPIClient.h"
#import <Accounts/Accounts.h>
#import <STTwitter/STTwitter.h>
#import "PDInstagramAPIClient.h"
#import "PDSocialAPIService.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-retain-self"

@interface PDSocialMediaManager() {
  ACAccount *singleAccount;
	BOOL twitterRegister;
}

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSArray *iOSAccounts;
@property (nonatomic, strong) STTwitterAPI *twitterAPI;

@property (nonatomic, copy) void (^endSuccess)(void);
@property (nonatomic, copy) void (^endError)(NSError *error);

@end

@implementation PDSocialMediaManager

+ (id) manager {
  static dispatch_once_t pred;
  static PDSocialMediaManager *sharedInstance = nil;
  dispatch_once(&pred, ^{
    sharedInstance = [[PDSocialMediaManager alloc] init];
  });
  return sharedInstance;
}

- (id) initForViewController:(UIViewController*)viewController {
  self = [PDSocialMediaManager manager];
  self.holderViewController = viewController;
  self.accountStore = [[ACAccountStore alloc] init];
  return self;
}


-(BOOL) isLoggedIn {
  if ([[PDSocialMediaManager manager] isLoggedInWithFacebook]) {
    if (![PDUser sharedInstance].userToken) {
      //            [[PDSocialMediaManager manager] logoutFacebook];
      return NO;
    }
    return YES;
  }
  return NO;
}

#pragma mark - Facebook -

- (void) loginWithFacebookReadPermissions:(NSArray*)permissions
                      registerWithPopdeem:(BOOL)reg
                                  success:(void (^)(void))success
                                  failure:(void (^)(NSError *err))failure {
  FBSDKLoginManager *lm = [[FBSDKLoginManager alloc] init];
  [lm logInWithReadPermissions:permissions fromViewController:_holderViewController  handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
    if (error) {
      failure(error);
    } else if (result.isCancelled) {
      PDLog(@"Facebook Login Was Cancelled");
      NSError *cancelled = [NSError errorWithDomain:@"Popdeem.Facebook.Cancelled" code:27500 userInfo:nil];
      failure(cancelled);
    } else {
      if (reg) {
        [self registerAfterLogin:^() {
          success();
        } failure:^(NSError *error) {
          failure(error);
        }];
      } else {
        success();
      }
    }
  }];
}

- (void) registerAfterLogin:(void (^)(void))success failure:(void (^)(NSError *error))failure {
  [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"id"}]
   startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
     if (!error) {
       NSString *facebookAccessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
       NSString *facebookID = [result objectForKey:@"id"];
       [[[PDUser sharedInstance] facebookParams] setIdentifier:facebookID];
       PDLog(@"facebook ID: %@",facebookID);
       
       if ([[PDUser sharedInstance] isRegistered]) {
         PDSocialAPIService *socService = [[PDSocialAPIService alloc] init];
         [socService connectFacebookAccount:facebookID accessToken:facebookAccessToken completion:^(NSError *error) {
           if (error) {
             failure(error);
             return;
           }
           success();
         }];
       } else {
         [[PDAPIClient sharedInstance] registerUserwithFacebookAccesstoken:facebookAccessToken facebookId:facebookID success:^(PDUser *user) {
           success();
         } failure:^(NSError *error) {
           failure(error);
         }];
       }
     } else {
       failure(error);
     }
   }];
}

- (void) logoutFacebook {
  FBSDKLoginManager *lm = [[FBSDKLoginManager alloc] init];
  [lm logOut];
}

- (void) logOut {
	if ([[NSUserDefaults standardUserDefaults] objectForKey:@"popdeemUser"]) {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"popdeemUser"];
	}
	[PDUser resetSharedInstance];
}

- (void) facebookRequestPublishPermissions:(void (^)(void))success
                                   failure:(void (^)(NSError *err))failure {
  FBSDKLoginManager *lm = [[FBSDKLoginManager alloc] init];
  
  [lm logInWithPublishPermissions:@[@"publish_actions"] fromViewController:_holderViewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
      [[[PDUser sharedInstance] facebookParams] setAccessToken:[[FBSDKAccessToken currentAccessToken] tokenString]];
      success();
    } else {
      NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                      @"Necessary permissions were not granted", NSLocalizedDescriptionKey,
                                      error, NSUnderlyingErrorKey,
                                      nil];
      NSError *endError = [[NSError alloc] initWithDomain:kPopdeemErrorDomain
                                                     code:PDErrorCodeFBPermissions
                                                 userInfo:userDictionary];
      failure(endError);
    }
  }];
}

- (BOOL) isLoggedInWithFacebook {
  return [FBSDKAccessToken currentAccessToken] != nil;
}

- (BOOL) facebookTokenIsValid {
	if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"email"]){
		return YES;
	}
	return NO;
}

- (BOOL) isLoggedInWithTwitter {
	PDUser *user = [PDUser sharedInstance];
	if (user.twitterParams.accessToken.length > 1 && user.twitterParams.accessSecret.length > 1) {
		return YES;
	}
	return NO;
}

- (void) refreshFacebookAccessToken:(void (^)(NSString *token, NSError *err))completion {
  [FBSDKAccessToken refreshCurrentAccessToken:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
    if (error) {
      completion(nil, error);
    }
    NSString *tokenString = [[FBSDKAccessToken currentAccessToken] tokenString];
    [[[PDUser sharedInstance] facebookParams] setAccessToken:[[FBSDKAccessToken currentAccessToken] tokenString]];
    [[PDAPIClient sharedInstance] updateUserLocationAndDeviceTokenSuccess:^(PDUser *user) {
      if ([[[[PDUser sharedInstance] facebookParams] accessToken] isEqualToString:tokenString]) {
        completion([[FBSDKAccessToken currentAccessToken] tokenString], nil);
      } else {
        NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"Tokens Do Not Match", NSLocalizedDescriptionKey,
                                        error, NSUnderlyingErrorKey,
                                        nil];
        NSError *endError = [[NSError alloc] initWithDomain:kPopdeemErrorDomain
                                                       code:PDErrorCodeUserCreationFailed
                                                   userInfo:userDictionary];
        completion(nil, endError);
      }
    } failure:^(NSError *apiError) {
      completion(nil, apiError);
    }];
  }];
}

- (void) loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error completion:(void (^)(NSError *error))completion {
  [self registerAfterLogin:^{
    completion(nil);
  } failure:^(NSError *error){
    completion(error);
  }];
}

- (void) nextStepForFacebookLoggedInUser:(void (^)(NSError *error))completion {
  [self registerAfterLogin:^{
    completion(nil);
  } failure:^(NSError *error){
    completion(error);
  }];
}

- (void) checkFacebookTokenIsValid:(void (^)(BOOL valid))completion {
	
//	NSString *access_token = [[[PDUser sharedInstance] facebookParams] accessToken];
	dispatch_async(dispatch_get_main_queue(), ^{
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"email"]) {
      completion(YES);
    } else {
      completion(NO);
    }
	});
}

#pragma mark - Twitter -

- (void) registerWithTwitter:(void (^)(void))success
										 failure:(void (^)(NSError *error))failure {
	twitterRegister = YES;
	[self nextStepTwitter:success failure:failure];
}

- (void) loginWithTwitter:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure {
  
  
  //Attempt to discover if user is signed in to Twitter on iOS
	twitterRegister = NO;
	[self nextStepTwitter:success failure:failure];
}

- (void) nextStepTwitter:(void (^)(void))success
								 failure:(void (^)(NSError *error))failure{
  //Login with safari
  self.endSuccess = success;
  self.endError = failure;
  [self loginOnTheWeb];
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
  switch (alertView.tag) {
    case 0:
      //OK button of selecter view
      
      break;
      
    default:
      return;
      break;
  }
}

- (void) twitterLoginWithAccount:(ACAccount*)account success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
  
  NSError *keyError = nil;
  NSError *secretError = nil;
  NSString *twConsumerKey = [PDUtils getTwitterConsumerKey:&keyError];
  NSString *twConsumerSecret = [PDUtils getTwitterConsumerSecret:&secretError];
  
  _twitterAPI = [STTwitterAPI twitterAPIWithOAuthConsumerName:nil
                                                  consumerKey:twConsumerKey
                                               consumerSecret:twConsumerSecret];
  
  
  [_twitterAPI postReverseOAuthTokenRequest:^(NSString *authenticationHeader) {
    
    STTwitterAPI *twitterAPIOS = [STTwitterAPI twitterAPIOSWithAccount:account delegate:nil];
    
    [twitterAPIOS verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID){
      [twitterAPIOS postReverseAuthAccessTokenWithAuthenticationHeader:authenticationHeader
                                                          successBlock:^(NSString *oAuthToken,
                                                                         NSString *oAuthTokenSecret,
                                                                         NSString *userID,
                                                                         NSString *screenName) {
																														
																														if (twitterRegister) {
																															[self twitterRegisterWithPopdeem:oAuthToken
																																												secret:oAuthTokenSecret
																																												userId:userID
																																										screenName:screenName
																																											 success:success
																																											 failure:failure];
																														} else {
																																[self twitterConnectWithPopdeem:oAuthToken secret:oAuthTokenSecret userID:userID screenName:username success:success failure:failure];
																														}
                                                          } errorBlock:^(NSError *error) {
                                                            failure(error);
                                                          }];
    } errorBlock:^(NSError *error) {
      failure(error);
    }];
  } errorBlock:^(NSError *error) {
    failure(error);
  }];
  
}

- (void) chooseAccount:(void (^)(ACAccount *account))success failure:(void (^)(NSError *error))failure {
  
  ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  
  ACAccountStoreRequestAccessCompletionHandler accountStoreRequestCompletionHandler = ^(BOOL granted, NSError *error) {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
      
      if (granted == NO) {
        NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                        @"User denied access to twitter accounts", NSLocalizedDescriptionKey,
                                        error, NSUnderlyingErrorKey,
                                        nil];
        NSError *endError = [[NSError alloc] initWithDomain:kPopdeemErrorDomain
                                                       code:PDErrorCodeTWPermissions
                                                   userInfo:userDictionary];
        failure(endError);
        return;
      }
      
      self.iOSAccounts = [_accountStore accountsWithAccountType:accountType];
      
      //            if([_iOSAccounts count] == 1) {
      //                ACAccount *account = [_iOSAccounts lastObject];
      //                success(account);
      //            } else {
      UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Select an account:" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
      [ac addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        failure(nil);
      }]];
      ac.view.tintColor = [UIColor blueColor];
      for (ACAccount *account in _iOSAccounts) {
        [ac addAction:[UIAlertAction actionWithTitle:account.username style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
          success(account);
        }]];
      }
      [_holderViewController presentViewController:ac animated:YES completion:nil];
      ac.view.tintColor = [UIColor blackColor];
      //            }
    }];
  };
  
  [self.accountStore requestAccessToAccountsWithType:accountType
                                             options:NULL
                                          completion:accountStoreRequestCompletionHandler];
  
}

- (void) selectedIOSTwitterAccount:(ACAccount*)account success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
  PDLog(@"Chose Twitter Account: %@",account.username);
  [self twitterLoginWithAccount:account success:^(void){
    success();
  } failure:^(NSError *error) {
    failure(error);
  }];
}

- (void) loginOnTheWeb {
  NSError *keyError = nil;
  NSError *secretError = nil;
  NSString *twConsumerKey = [PDUtils getTwitterConsumerKey:&keyError];
  NSString *twConsumerSecret = [PDUtils getTwitterConsumerSecret:&secretError];
  
  _twitterAPI = [STTwitterAPI twitterAPIWithOAuthConsumerKey:twConsumerKey
                                              consumerSecret:twConsumerSecret];
  
  NSString *callback = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"TwitterCallbackScheme"];
  NSString *fullCallback = [NSString stringWithFormat:@"%@://twitter_access_tokens/",callback];
  [_twitterAPI postTokenRequest:^(NSURL *url, NSString *oauthToken) {
    [[UIApplication sharedApplication] openURL:url];
  } authenticateInsteadOfAuthorize:NO
                     forceLogin:@(YES)
                     screenName:nil
                  oauthCallback:fullCallback
                     errorBlock:^(NSError *error) {
                       PDLogError(@"-- error: %@", error);
                     }];
}

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
  
  [_twitterAPI postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
    if (twitterRegister) {
      [self twitterRegisterWithPopdeem:oauthToken secret:oauthTokenSecret userId:userID screenName:screenName success:^{
        self.endSuccess();
      } failure:^(NSError *error) {
        self.endError(error);
      }];
    } else {
      [self twitterConnectWithPopdeem:oauthToken secret:oauthTokenSecret userID:userID screenName:screenName success:^(void){
        self.endSuccess();
      } failure:^(NSError *error){
        //Something went wrong
        self.endError(error);
      }];
    }
    //Now connect social account
  } errorBlock:^(NSError *error) {
    PDLogError(@"Twitter Error: %@", [error localizedDescription]);
  }];
}

- (void) twitterConnectWithPopdeem:(NSString*)oAuthToken
                            secret:(NSString*)oAuthSecret
                            userID:(NSString*)userID
                        screenName:(NSString*)screenName
                           success:(void (^)(void))success
                           failure:(void (^)(NSError* error))failure {
  [[PDAPIClient sharedInstance] connectTwitterAccount:userID accessToken:oAuthToken accessSecret:oAuthSecret success:success failure:failure];
}

- (void) twitterRegisterWithPopdeem:(NSString*)oAuthToken
														 secret:(NSString*)oAuthSecret
														 userId:(NSString*)userId screenName:(NSString*)screenName
														success:(void (^)(void))success
														failure:(void (^)(NSError*))failure {
	[[PDAPIClient sharedInstance] registerUserWithTwitterAccessToken:oAuthToken
																											accessSecret:oAuthSecret
																														userId:userId
																												screenName:screenName
																													 success:^(PDUser *user){
																														 success();
	}
																													 failure:failure];
}

- (void) verifyTwitterCredentialsCompletion:(void (^)(BOOL connected, NSError *error))completion {
  NSError *keyError = nil;
  NSError *secretError = nil;
  NSString *twConsumerKey = [PDUtils getTwitterConsumerKey:&keyError];
  NSString *twConsumerSecret = [PDUtils getTwitterConsumerSecret:&secretError];
  
  NSString *userTwitterToken = [[[PDUser sharedInstance] twitterParams] accessToken];
  NSString *userTwitterSecret = [[[PDUser sharedInstance] twitterParams] accessSecret];
  
  if (userTwitterToken == nil || userTwitterSecret == nil) {
    completion(NO, nil);
    return;
  }
  
  _twitterAPI = [STTwitterAPI twitterAPIWithOAuthConsumerKey:twConsumerKey
                                              consumerSecret:twConsumerSecret
                                                  oauthToken:userTwitterToken
                                            oauthTokenSecret:userTwitterSecret];
  if (!_twitterAPI) {
    completion(NO,nil);
    return;
  }
  [_twitterAPI verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID) {
    completion(YES,nil);
  } errorBlock:^(NSError *error) {
    completion(NO,error);
  }];
}

- (void) userCancelledTwitterLogin {
  NSDictionary *userDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"User Cancelled Login", NSLocalizedDescriptionKey,
                                  nil];
  NSError *endError = [[NSError alloc] initWithDomain:kPopdeemErrorDomain
                                                 code:PDErrorCodeFBPermissions
                                             userInfo:userDictionary];
  self.endError(endError);
}
- (void) twitterLoginSuccessfulToken:(NSString *)token oauthVerifier:(NSString *)verifier {
  [self setOAuthToken:token oauthVerifier:verifier];
}

#pragma mark - Instagram -

- (void) isLoggedInWithInstagram:(void (^)(BOOL isLoggedIn))completion {
	PDUser *user = [PDUser sharedInstance];
	NSString *accessToken = [[user instagramParams] accessToken];
	if (accessToken.length == 0) {
		completion(NO);
		return;
	}
	PDInstagramAPIClient *client = [[PDInstagramAPIClient alloc] init];
	[client checkAccessToken:^(BOOL valid, NSError *error){
		if (error) {
			PDLogError(@"Error when checking Instagram Token: %@",error);
		}
		completion(valid);
	}];
}

- (BOOL) isLoggedInWithAnyNetwork {
	if ([[[PDUser sharedInstance] facebookParams] accessToken] != nil) {
		return YES;
	}
	if ([[[PDUser sharedInstance] twitterParams] accessToken] != nil) {
		return YES;
	}
	if ([[[PDUser sharedInstance] instagramParams] accessToken] !=nil) {
		return YES;
	}
	
	return NO;
}

@end

#pragma clang diagnostic pop
