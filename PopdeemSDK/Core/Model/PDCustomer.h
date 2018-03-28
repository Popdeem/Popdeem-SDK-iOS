//
//  PDCustomer.h
//  Bolts
//
//  Created by Niall Quinn on 14/02/2018.
//

#import "JSONModel.h"

@interface PDCustomer : JSONModel

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *facebookAppId;
@property (nonatomic, retain) NSString *facebookAccessToken;
@property (nonatomic, retain) NSString *facebookNameSpace;
@property (nonatomic, retain) NSString *twitterConsumerKey;
@property (nonatomic, retain) NSString *twitterConsumerSecret;
@property (nonatomic, retain) NSString *twitterHandle;
@property (nonatomic, retain) NSString *instagramClientId;
@property (nonatomic, retain) NSString *instagramClientSecret;
@property (nonatomic) NSInteger countdownTimer;
@property (nonatomic, retain) NSNumber <Optional> *incrementAdvocacyPoints;
@property (nonatomic, retain) NSNumber <Optional> *decrementAdvocacyPoints;

+ (PDCustomer*) initFromAPI:(NSString*)json;
+ (instancetype) sharedInstance;

@end

