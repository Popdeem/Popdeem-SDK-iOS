//
//  PDUser.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 19/08/2015.
//  Copyright (c) 2015 Popdeem. All rights reserved.
//

#import "PDUser.h"
#import "PDUser+Facebook.h"

@interface PDUser()

@end

@implementation PDUser

static PDUser *globalUser = nil;

+ (instancetype) sharedInstance {
  @synchronized(self) {
		if (globalUser == nil) {
			globalUser = [[PDUser alloc] init];
		}
	}
  return globalUser;
}

+ (void) resetSharedInstance {
	@synchronized(self) {
		globalUser = nil;
	}
}

+ (PDUser*) initFromAPI:(NSDictionary*)params preferredSocialMediaType:(PDSocialMediaType)preferredSocialMediaType {
  PDUser *user = [PDUser sharedInstance];
  
  user.preferredSocialMediaType = preferredSocialMediaType;
  NSString *firstName = params[@"first_name"];
  user.firstName = [firstName isKindOfClass:[NSString class]] ? firstName : nil;
  
  NSString *lastName = params[@"last_name"];
  user.lastName = [lastName isKindOfClass:[NSString class]] ? lastName : nil;
  
  NSString *sex = params[@"sex"];
  if ([sex isEqualToString:@"male"]) {
    user.gender = PDGenderMale;
  } else if ([sex isEqualToString:@"female"]) {
    user.gender = PDGenderFemale;
  } else {
    user.gender = PDGenderUnknown;
  }
  
  user.identifier = [params[@"id"] integerValue];
  user.userToken = params[@"user_token"];
  
  float loc_lat = [params[@"location"][@"latitude"] floatValue];
  float loc_long = [params[@"location"][@"longitude"] floatValue];
  user.location = PDGeoLocationMake(loc_lat, loc_long);
  
  NSDictionary *facebookParams = params[@"facebook"];
  user.facebookParams = [[PDUserFacebookParams alloc] initWithParams:facebookParams];
  
  NSDictionary *twitterParams = params[@"twitter"];
  user.twitterParams = [[PDUserTwitterParams alloc] initWithParams:twitterParams];
	
	NSDictionary *instagramParams = params[@"instagram"];
	NSError *err = [[NSError alloc] initWithDomain:@"PDUser Error" code:27700 userInfo:nil];
	if (instagramParams) {
		user.instagramParams = [[PDUserInstagramParams alloc] initWithDictionary:instagramParams error:&err];
	}
	
	
  NSString *testerStatus = facebookParams[@"tester"];
  if ([testerStatus isEqualToString:@"true"]) {
    user.isTester = YES;
  } else {
    user.isTester = NO;
  }
  
  if ([params[@"suspend_until"] length] > 0) {
    user.suspended = YES;
    NSString *suspendedUntil = params[@"suspend_until"];
    user.suspendedUntil = [NSDate dateWithTimeIntervalSince1970:suspendedUntil.integerValue];
  } else {
    user.suspended = NO;
  }
  
  return user;
}

+ (PDUser*) initFromUserDefaults:(NSDictionary*)dict {
  PDUser *user = [PDUser sharedInstance];
  
  user.firstName = [dict objectForKey:@"firstName"] ? [dict objectForKey:@"firstName"] : nil;
  user.lastName = [dict objectForKey:@"lastName"] ? [dict objectForKey:@"lastName"] : nil;
  user.identifier = [[dict objectForKey:@"identifier"] integerValue];
  
  NSString *gender = [dict objectForKey:@"gender"];
  if ([gender isEqualToString:@"male"]) {
    user.gender = PDGenderMale;
  } else if ([gender isEqualToString:@"female"]) {
    user.gender = PDGenderFemale;
  } else {
    user.gender = PDGenderUnknown;
  }
  user.userToken = [dict objectForKey:@"authentication_token"] ? [dict objectForKey:@"authentication_token"] : nil;
  
  user.facebookParams = [[PDUserFacebookParams alloc] init];
  user.facebookParams.accessToken = [dict objectForKey:@"facebook_access_token"] ? [dict objectForKey:@"facebook_access_token"] : nil;
  user.facebookParams.profilePictureUrl = [dict objectForKey:@"facebook_profile_picture_url"] ? [dict objectForKey:@"facebook_profile_picture_url"] : nil;
  user.facebookParams.identifier = [dict objectForKey:@"facebookID"] ? [dict objectForKey:@"facebookID"] : nil;
  
  user.facebookParams.scores = [[PDScores alloc] init];
  user.facebookParams.scores.total = [dict objectForKey:@"totalScore"] ? [[dict objectForKey:@"totalScore"] floatValue] : 0.0;
  user.facebookParams.scores.reach = [dict objectForKey:@"reachScore"] ? [[dict objectForKey:@"reachScore"] floatValue] : 0.0;
  user.facebookParams.scores.engagement = [dict objectForKey:@"engagementScore"] ? [[dict objectForKey:@"engagementScore"] floatValue] : 0.0;
  user.facebookParams.scores.frequency = [dict objectForKey:@"frequencyScore"] ? [[dict objectForKey:@"frequencyScore"] floatValue] : 0.0;
  user.facebookParams.scores.advocacy = [dict objectForKey:@"advocacyScore"] ? [[dict objectForKey:@"advocacyScore"] floatValue] : 0.0;
  
  user.deviceToken = [dict objectForKey:@"deviceToken"] ? [dict objectForKey:@"deviceToken"] : nil;
  
  user.location = PDGeoLocationMake([[dict objectForKey:@"latitude"] floatValue], [[dict objectForKey:@"longitude"] floatValue]);
  user.lastLocation = PDGeoLocationMake([[dict objectForKey:@"lastLocationLat"] floatValue], [[dict objectForKey:@"lastLocationLong"] floatValue]);
  
  user.isTester = [dict objectForKey:@"isTester"] ? [[dict objectForKey:@"isTester"] boolValue] : NO;
  
  return user;
}

- (NSMutableDictionary*) dictionaryRepresentation {
  
  NSMutableDictionary *userDictionary = [NSMutableDictionary dictionary];
  
  [userDictionary setObject:self.firstName forKey:@"firstName"];
  [userDictionary setObject:self.lastName forKey:@"lastName"];
  [userDictionary setObject:@(self.identifier) forKey:@"identifier"];
  
  NSString *gender = @"";
  switch (self.gender) {
    case PDGenderMale:
      gender = @"male";
      break;
    case PDGenderFemale:
      gender = @"female";
      break;
    case PDGenderUnknown:
      gender = @"unknown";
      break;
    default:
      gender = @"unknown";
      break;
  }
  [userDictionary setObject:gender forKey:@"gender"];
  [userDictionary setObject:self.userToken forKey:@"authentication_token"];
  [userDictionary setObject:self.facebookParams.accessToken forKey:@"facebook_access_token"];
  [userDictionary setObject:self.facebookParams.profilePictureUrl forKey:@"facebook_profile_picture_url"];
  if (self.facebookParams.identifier) {
    [userDictionary setObject:self.facebookParams.identifier forKey:@"facebookID"];
  }
  
  [userDictionary setObject:[NSNumber numberWithFloat:self.scores.total] forKey:@"totalScore"];
  [userDictionary setObject:[NSNumber numberWithFloat:self.scores.reach] forKey:@"reachScore"];
  [userDictionary setObject:[NSNumber numberWithFloat:self.scores.engagement] forKey:@"engagementScore"];
  [userDictionary setObject:[NSNumber numberWithFloat:self.scores.frequency] forKey:@"frequencyScore"];
  [userDictionary setObject:[NSNumber numberWithFloat:self.scores.advocacy] forKey:@"advocacyScore"];
  
  if (self.deviceToken) {
    [userDictionary setObject:self.deviceToken forKey:@"deviceToken"];
  }
  
  [userDictionary setObject:[NSNumber numberWithFloat:self.location.latitude] forKey:@"latitude"];
  [userDictionary setObject:[NSNumber numberWithFloat:self.location.longitude] forKey:@"longitude"];
  [userDictionary setObject:[NSNumber numberWithFloat:self.lastLocation.latitude] forKey:@"lastLocationLat"];
  [userDictionary setObject:[NSNumber numberWithFloat:self.lastLocation.longitude] forKey:@"lastLocationLong"];
  [userDictionary setObject:[NSNumber numberWithBool:self.isTester] forKey:@"isTester"];
  return userDictionary;
}


- (PDScores*) scores {
  switch (_preferredSocialMediaType) {
    case PDSocialMediaTypeFacebook:
      return self.facebookParams.scores;
      break;
    default:
      return self.facebookParams.scores;
      break;
  }
}

- (NSArray*) socialMediaFriendsOrderedAlpha {
  NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
    return [(NSString *)obj1 compare:(NSString *)obj2 options:NSNumericSearch];
  }];
  NSArray *sortedArray = [[PDUser taggableFriends] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
  return sortedArray;
  return nil;
}


@end
