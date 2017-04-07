//
//  PDBGScanResponseModel.m
//  PopdeemSDK
//
//  Created by niall quinn on 03/04/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import "PDBGScanResponseModel.h"
#import "PDLogger.h"

@implementation PDBGScanResponseModel

- (id) initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err {
  if ([super initWithDictionary:dict error:err]) {
    return self;
  }
  PDLogError(@"JSONModel Error on Social Response Params: %@",err);
  return nil;
}

+ (JSONKeyMapper*)keyMapper {
  return  [JSONKeyMapper mapperForSnakeCase];
}

- (NSDictionary*) toDictionary {
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
  if (_mediaUrl != nil) {
    [dict setObject:self.mediaUrl forKey:@"media_url"];
  }
  if (_objectId != nil) {
    [dict setObject:_objectId forKey:@"object_id"];
  }
  if (_text != nil) {
    [dict setObject:_text forKey:@"text"];
  }
  if (_socialName != nil) {
    [dict setObject:_socialName forKey:@"social_name"];
  }
  if (_profilePictureUrl != nil) {
    [dict setObject:_profilePictureUrl forKey:@"profile_picture_url"];
  }
  return [[NSDictionary alloc] initWithDictionary:dict];

}

/*
 mediaUrl;
 @property (nonatomic, retain) NSString<Optional> *network;
 @property (nonatomic, retain) NSString<Optional> *objectId;
 @property (nonatomic, retain) NSString<Optional> *text;
 @property (nonatomic, retain) NSString<Optional> *socialName;
 @property (nonatomic, retain) NSString<Optional> *profilePictureUrl;
 */

@end
