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
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <STTwitter/STTwitter.h>
#import <Accounts/Accounts.h>

@interface PDSocialMediaManager()

@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) NSArray *iOSAccounts;
@property (nonatomic, assign) UIViewController *holderViewController;

@end

@implementation PDSocialMediaManager

- (id) initForViewController:(UIViewController*)viewController {
    if (self = [super init]) {
        _holderViewController = viewController;
        return self;
    }
    return nil;
}


#pragma mark - Facebook -

- (void) loginWithFacebookReadPermissions:(NSArray*)permissions
                              success:(void (^)(void))success
                              failure:(void (^)(NSError *err))failure {
    FBSDKLoginManager *lm = [[FBSDKLoginManager alloc] init];
    [lm
     logInWithReadPermissions: permissions
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             failure(error);
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             success();
         }
     }];
}

- (void) logoutFacebook {
    FBSDKLoginManager *lm = [[FBSDKLoginManager alloc] init];
    [lm logOut];
}

- (void) facebookRequestPublishPermissions:(void (^)(void))success
                                 failure:(void (^)(NSError *err))failure {
    FBSDKLoginManager *lm = [[FBSDKLoginManager alloc] init];
    [lm logInWithPublishPermissions:@[@"publish_actions"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
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

#pragma mark - Twitter -

- (void) loginWithTwitter:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure {
    
    
    //Attempt to discover if user is signed in to Twitter on iOS
    
    ACAccountType *accountType = [_accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    ACAccountStoreRequestAccessCompletionHandler handler = ^(BOOL granted, NSError *error) {
        
        if (error) {
            failure(error);
        }
        
        if (granted == NO) {
            
        }
        
        self.iOSAccounts = [_accountStore accountsWithAccountType:accountType];
        
        if (self.iOSAccounts.count > 1) {
            [self chooseAccount:^(ACAccount *account) {
                [self loginWithTwitter:success failure:failure];
            } failure:^(NSError *error) {
                failure(error);
            }];
        } else {
            [self twitterLoginWithAccount:[self.iOSAccounts objectAtIndex:0] success:success failure:failure];
        }
    };
    
    [self.accountStore requestAccessToAccountsWithType:accountType
                                               options:NULL
                                            completion:handler];
}

- (void) twitterLoginWithAccount:(ACAccount*)account success:(void (^)(void))success failure:(void (^)(NSError *error))failure {
    
    NSError *keyError = nil;
    NSError *secretError = nil;
    NSString *twConsumerKey = [PDUtils getTwitterConsumerKey:&keyError];
    NSString *twConsumerSecret = [PDUtils getTwitterConsumerSecret:&secretError];
    
    STTwitterAPI *twitter = [STTwitterAPI twitterAPIWithOAuthConsumerName:nil
                                                              consumerKey:twConsumerKey
                                                           consumerSecret:twConsumerSecret];
    
    [twitter postReverseOAuthTokenRequest:^(NSString *authenticationHeader) {
        
        STTwitterAPI *twitterAPIOS = [STTwitterAPI twitterAPIOSWithAccount:account];
        
        [twitterAPIOS verifyCredentialsWithUserSuccessBlock:^(NSString *username, NSString *userID){
            [twitterAPIOS postReverseAuthAccessTokenWithAuthenticationHeader:authenticationHeader
                                                                successBlock:^(NSString *oAuthToken,
                                                                               NSString *oAuthTokenSecret,
                                                                               NSString *userID,
                                                                               NSString *screenName) {
                                                                    
                                                                    [self twitterRegisterWithPopdeem:oAuthToken secret:oAuthTokenSecret userID:userID screenName:username success:success failure:failure];
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

- (void) twitterRegisterWithPopdeem:(NSString*)oAuthToken
                             secret:(NSString*)oAuthSecret
                             userID:(NSString*)userID
                         screenName:(NSString*)screenName
                            success:(void (^)(void))success
                            failure:(void (^)(NSError* error))failure {
    
}

- (void) twitterConnectAccountToPopdeem:(NSString*)oAuthToken
                                 secret:(NSString*)oAuthSecret
                                 userID:(NSString*)userID
                             screenName:(NSString*)screenName
                                success:(void (^)(void))success
                                failure:(void (^)(NSError* error))failure {
    
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
            
            if([_iOSAccounts count] == 1) {
                ACAccount *account = [_iOSAccounts lastObject];
                success(account);
            } else {
                UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"Select an account:" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
                [ac addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                        //Handle Cancel
                }]];
                for (ACAccount *account in _iOSAccounts) {
                    [ac addAction:[UIAlertAction actionWithTitle:account.username style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                        [self selectedIOSTwitterAccount:account];
                    }]];
                }
                [_holderViewController presentViewController:ac animated:YES completion:nil];
            }
        }];
    };
    
    [self.accountStore requestAccessToAccountsWithType:accountType
                                                   options:NULL
                                                completion:accountStoreRequestCompletionHandler];

}

- (void) selectedIOSTwitterAccount:(ACAccount*)account {
    NSLog(@"Chose Twitter Account: %@",account.username);
}

@end
