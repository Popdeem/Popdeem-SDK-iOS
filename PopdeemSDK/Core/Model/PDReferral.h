//
//  PDReferral.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 06/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 @abstract The Type of Referral
 **/

@class PDReferral;
static PDReferral *globalReferral;

typedef NS_ENUM(NSUInteger, PDReferralType) {
    ///Male
    PDReferralTypeInstall = 1,
    ///Female
    PDReferralTypeReopen
};

@interface PDReferral : NSObject

@property (nonatomic) PDReferralType referralType;
@property (nonatomic, strong) NSString *senderAppName;
@property (nonatomic) NSInteger senderId;
@property (nonatomic) NSInteger requestId;

- (id) initWithSenderId:(NSInteger)senderId senderApp:(NSString*)senderApp type:(PDReferralType)type;
- (id) initWithUrl:(NSURL*)url appRef:(NSString*)application;
- (NSString*) typeString;
+ (void) logReferral:(PDReferral*)referral;

@end
