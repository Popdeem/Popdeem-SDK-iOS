//
//  PDCustomer.m
//  Bolts
//
//  Created by Niall Quinn on 14/02/2018.
//

#import "PDCustomer.h"
#import "PDUtils.h"
#import "PDLogger.h"

@implementation PDCustomer

static PDCustomer *globalCustomer = nil;

+ (instancetype) sharedInstance {
  @synchronized(self) {
    if (globalCustomer == nil) {
      globalCustomer = [[PDCustomer alloc] init];
    }
  }
  return globalCustomer;
}

+ (void) resetSharedInstance {
  @synchronized(self) {
    globalCustomer = nil;
  }
}

+ (PDCustomer*) initFromAPI:(NSString*)json {
  PDCustomer *fromJSON = [[PDCustomer alloc] initWithJSON:json];
  if (fromJSON != nil) {
    globalCustomer = fromJSON;
  }
  return globalCustomer;
}

- (id) initWithJSON:(NSString*)json {
  
  NSError *err;
  if (self = [super initWithString:json error:&err]) {
    return  self;
  }
  PDLogError(@"JSONModel Error on Customer: %@",err);
  return  nil;
}

+ (JSONKeyMapper*)keyMapper {
  return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                     @"name": @"name",
                                                     @"fb_app_id": @"facebookAppId",
                                                     @"fb_app_access_token": @"facebookAccessToken",
                                                     @"facebook_namespace": @"facebookNameSpace",
                                                     @"twitter_consumer_key": @"twitterConsumerKey",
                                                     @"twitter_consumer_secret": @"twitterConsumerSecret",
                                                     @"twitter_handle": @"twitterHandle",
                                                     @"instagram_client_id": @"instagramClientId",
                                                     @"instagram_client_secret": @"instagramClientSecret",
                                                     @"increment_advocacy_points": @"incrementAdvocacyPoints",
                                                     @"decrement_advocacy_points": @"decrementAdvocacyPoints"
                                                     }];
}

- (BOOL) usesAmbassadorFeatures {
    if (self.incrementAdvocacyPoints != nil) {
        return YES;
    }
    return NO;
}



- (BOOL) usesTwitter {
    
  if (self.twitterConsumerKey != nil) {
    return YES;
  }
  return NO;
}


- (BOOL) usesFacebook {
    
    if (self.facebookAppId != nil) {
        return YES;
    }
    return NO;
}


- (BOOL) usesInstagram {
    
    if (self.instagramClientId != nil) {
        return YES;
    }
    return NO;
}



@end
