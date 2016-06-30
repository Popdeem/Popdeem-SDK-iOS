//
//  InstagramResponseModel.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 17/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "JSONModel.h"

@interface InstagramResponseModel : JSONModel
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSString *identifier;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *bio;
@property (nonatomic, retain) NSString *website;
@property (nonatomic, retain) NSString *profilePictureUrlString;
@property (nonatomic, retain) NSString *fullName;
- (id) initWithJSON:(NSString*)json;
@end
