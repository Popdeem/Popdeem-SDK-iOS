//
//  InstagramResponseModel.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 17/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface InstagramUserModel : JSONModel
@property (nonatomic) NSInteger id;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *bio;
@property (nonatomic, retain) NSString *website;
@property (nonatomic, retain) NSString *profilePicture;
@property (nonatomic, retain) NSString *fullName;
@end

@interface InstagramResponseModel : JSONModel
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) InstagramUserModel *user;

- (id) initWithJSON:(NSString*)json;
@end


