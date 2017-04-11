//
//  PDBGScanResponseModel.h
//  PopdeemSDK
//
//  Created by niall quinn on 03/04/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import <JSONModel/JSONModel.h>

NS_ASSUME_NONNULL_BEGIN
@interface PDBGScanResponseModel : JSONModel

@property (nonatomic, retain) NSString<Optional> *mediaUrl;
@property (nonatomic, retain) NSString<Optional> *network;
@property (nonatomic, retain) NSString<Optional> *objectId;
@property (nonatomic, retain) NSString<Optional> *text;
@property (nonatomic, retain) NSString<Optional> *socialName;
@property (nonatomic, retain) NSString<Optional> *profilePictureUrl;
@property (nonatomic, retain) NSString<Optional> *postKey;
@property (nonatomic) BOOL validated;

- (id) initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err;
- (NSDictionary*) toDictionary;

@end
NS_ASSUME_NONNULL_END
