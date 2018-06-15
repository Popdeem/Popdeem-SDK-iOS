//
//  PDRFeedItem.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 18/01/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

@interface PDRFeedItem : RLMObject
NS_ASSUME_NONNULL_BEGIN
@property (nonatomic) NSInteger identifier;
@property (nonatomic, retain, nullable) NSString *brandLogoUrlString;
@property (nonatomic, retain) NSString *brandName;
@property (nonatomic, retain, nullable) NSString *imageUrlString;
@property (nonatomic, retain) NSString *rewardTypeString;
@property (nonatomic, retain, nullable) NSString *userProfilePicUrlString;
@property (nonatomic, retain, nullable) NSString *userFirstName;
@property (nonatomic, retain, nullable) NSString *userLastName;
@property (nonatomic) NSInteger userId;
@property (nonatomic, retain, nullable) NSString *actionText;
@property (nonatomic, retain, nullable) NSString *timeAgoString;
@property (nonatomic, retain, nullable) NSString *descriptionString;
@property (nonatomic, retain, nullable) NSString *captionString;

@property (nonatomic, retain, nullable) NSData *profileImageData;
@property (nonatomic, retain, nullable) NSData *actionImageData;
@property (nonatomic, retain, nullable) NSString *profileImagePath;
@property (nonatomic, retain, nullable) NSString *actionImagePath;

//Ignored by Realm
@property (nonatomic, retain, nullable) UIImage *actionImage;
@property (nonatomic, retain, nullable) UIImage *profileImage;

- (PDRFeedItem*)initFromAPI:(NSMutableDictionary*)params;

NS_ASSUME_NONNULL_END
@end
