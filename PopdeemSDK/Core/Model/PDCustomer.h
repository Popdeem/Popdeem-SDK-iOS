//
//  PDCustomer.h
//  Bolts
//
//  Created by Niall Quinn on 14/02/2018.
//

#import "JSONModel.h"

@interface PDCustomer : JSONModel

@property (nonatomic, retain) NSString <Optional> *name;
@property (nonatomic, retain) NSString <Optional> *facebookAppId;
@property (nonatomic, retain) NSString <Optional> *facebookAccessToken;
@property (nonatomic, retain) NSString <Optional> *facebookNameSpace;
@property (nonatomic, retain) NSString <Optional> *twitterConsumerKey;
@property (nonatomic, retain) NSString <Optional> *twitterConsumerSecret;
@property (nonatomic, retain) NSString <Optional> *twitterHandle;
@property (nonatomic, retain) NSString <Optional> *instagramClientId;
@property (nonatomic, retain) NSString <Optional> *instagramClientSecret;
@property (nonatomic) NSInteger countdownTimer;
@property (nonatomic, retain) NSNumber <Optional> *incrementAdvocacyPoints;
@property (nonatomic, retain) NSNumber <Optional> *decrementAdvocacyPoints;

+ (PDCustomer*) initFromAPI:(NSString*)json;
+ (instancetype) sharedInstance;
- (BOOL) usesAmbassadorFeatures;
- (BOOL) usesTwitter;
@end

