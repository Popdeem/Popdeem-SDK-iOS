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
#import "PDInstagramAPIClient.h"
#import "PDSocialAPIService.h"
#import "TWTRTwitter.h"
#import "PDCustomer.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-retain-self"

@interface PDSocialMediaManager() {
  ACAccount *singleAccount;
	BOOL twitterRegister;
}

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSArray *iOSAccounts;

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
  [lm logOut]; // Clean the tokens

    if ([_holderViewController isKindOfClass:[UIViewController class]]) {
        _holderViewController = nil;
    }
  
  [lm logInWithPermissions:permissions fromViewController:_holderViewController  handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
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

- (BOOL) isLoggedInWithFacebook {
  return [FBSDKAccessToken currentAccessToken] != nil && [[[PDUser sharedInstance] facebookParams] accessToken].length > 0;
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

- (void) twitterKitLogin:(void (^)(void))success
                 failure:(void (^)(NSError *error))failure {
  
  if ([[PDCustomer sharedInstance] twitterConsumerKey] && [[PDCustomer sharedInstance] twitterConsumerSecret]) {
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
      if (session) {
        if (twitterRegister) {
          [self twitterRegisterWithPopdeem:session.authToken
                                    secret:session.authTokenSecret
                                    userId:session.userID
                                screenName:session.userName
                                   success:success
                                   failure:failure];
        } else {
          [self twitterConnectWithPopdeem:session.authToken secret:session.authTokenSecret userID:session.userID screenName:session.userName success:success failure:failure];
        }
      } else {
        failure(error);
      }
    }];
  } else {
    PDLog(@"No Twitter Credentials on Customer");
    failure(nil);
  }
}


- (void) registerWithTwitter:(void (^)(void))success
                     failure:(void (^)(NSError *error))failure {
  twitterRegister = YES;
  [self twitterKitLogin:success failure:failure];
}

- (void) loginWithTwitter:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure {
	twitterRegister = NO;
	[self twitterKitLogin:success failure:failure];
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
  
  TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
  TWTRSession *lastSession = store.session;
  if (store == nil || lastSession == nil) {
    if ([[[PDUser sharedInstance] twitterParams] accessToken] != nil && [[[PDUser sharedInstance] twitterParams] accessSecret] != nil) {
      NSString *authToken = [[[PDUser sharedInstance] twitterParams] accessToken];
      NSString *authSecret = [[[PDUser sharedInstance] twitterParams] accessSecret];
      if (authToken.length > 0 && authSecret.length > 0) {
        [store saveSessionWithAuthToken:authToken authTokenSecret:authSecret completion:^(id<TWTRAuthSession>  _Nullable session, NSError * _Nullable error) {
          PDLog(@"Saved Session");
          completion(YES,nil);
          return;
        }];
      } else {
        completion(NO, nil);
        return;
      }
    }
  } else if (lastSession.authToken && lastSession.authTokenSecret) {
    completion(YES, nil);
    return;
  }
  completion(NO, nil);
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
