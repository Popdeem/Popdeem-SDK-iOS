//
//  PDUserInstagramParams.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "JSONModel.h"

@interface PDUserInstagramParams : JSONModel

@property (nonatomic) NSInteger socialAccountId;
@property (nonatomic, retain) NSString<Optional> *instagramId;
@property (nonatomic, retain) NSString<Optional> *screenName;
@property (nonatomic) BOOL isTester;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSString *accessSecret;
@property (nonatomic, retain) NSString *profilePictureUrl;

- (id) initWithJSON:(NSString*)json;
- (id) initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err;

@end
