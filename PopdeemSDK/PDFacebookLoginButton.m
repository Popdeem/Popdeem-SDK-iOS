//
//  PDFacebookLoginButton.m
//  PopdeemSocialLogin
//
//  Created by Niall Quinn on 07/10/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDFacebookLoginButton.h"
#import "PDSocialMediaManager.h"
#import "PDAPIClient.h"

@interface PDFacebookLoginButton()
{
    BOOL isLoggedIn;
}
@end

@implementation PDFacebookLoginButton

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
        return self;
    }
    return nil;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if ([super initWithCoder:aDecoder]) {
        [self setup];
        return self;
    }
    return nil;
}

- (void) setup {
    isLoggedIn = [[PDSocialMediaManager manager] isLoggedInWithFacebook];
    if (isLoggedIn) {
        PDUser *user = [self fetchPopdeemUser];
        if (user == nil) {
            [[PDSocialMediaManager manager] logoutFacebook];
            isLoggedIn = NO;
        }
    }
    
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setupForLoggedIn:isLoggedIn];
    [self addTarget:self action:@selector(touched) forControlEvents:UIControlEventTouchUpInside];
}

- (void) setupForLoggedIn:(BOOL)loggedIn {
    if (loggedIn) {
        [self setTitle:@"Log out" forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor colorWithRed:0.353 green:0.435 blue:0.651 alpha:1.000]];
        
    } else {
        [self setTitle:@"Log in with Facebook" forState:UIControlStateNormal];
        [self setBackgroundColor:[UIColor colorWithRed:0.176 green:0.271 blue:0.529 alpha:1.000]];
    }
}

- (void) setDelegate:(id<PDFacebookLoginButtonDelegate>)delegate {
    _delegate = delegate;
    if (isLoggedIn) {
        [_delegate PDFacebookLoginButtonIsLoggedIn];
    }
}

- (void) touched {
    PDSocialMediaManager *manager = [PDSocialMediaManager manager];
    if ([_delegate isKindOfClass:[UIViewController class]]) {
        [manager setHolderViewController:(UIViewController*)_delegate];
    }
    if ([self.titleLabel.text isEqualToString:@"Log out"]) {
        [[PDSocialMediaManager manager] logoutFacebook];
        [_delegate PDFacebookLoginButtonDidLogout:self];
        [self setupForLoggedIn:NO];
    } else {
        [self setTitle:@"Logging in..." forState:UIControlStateNormal];
        [self setEnabled:NO];
        [self setBackgroundColor:[UIColor colorWithRed:0.353 green:0.435 blue:0.651 alpha:1.000]];
        
        [[PDSocialMediaManager manager] loginWithFacebookReadPermissions:_readPermissions registerWithPopdeem:YES success:^(void) {
            //Now register with popdeem
            [_delegate PDFacebookLoginButtonDidFinishLoggingIn];
            isLoggedIn = YES;
            [self setupForLoggedIn:YES];
            [self setEnabled:YES];
            [self writeUserToDevice];
        } failure:^(NSError *error){
            [_delegate PDFacebookLoginButtonDidFailWithError:error];
            isLoggedIn = NO;
            [self setupForLoggedIn:NO];
            [self setEnabled:YES];
        }];
    }
}

- (PDUser*) fetchPopdeemUser {
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[self PopdeemUserStoreUrl]];
    if (!fileExists) return nil;
    NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithFile:[self PopdeemUserStoreUrl]];
    return [PDUser initFromUserDefaults:dict];
}

- (void) writeUserToDevice {
    NSDictionary *userDict = [[PDUser sharedInstance] dictionaryRepresentation];
    [NSKeyedArchiver archiveRootObject:userDict toFile:[self PopdeemUserStoreUrl]];
}

- (NSString*) PopdeemUserStoreUrl {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"popdeemUser.pddata"];
    return appFile;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
