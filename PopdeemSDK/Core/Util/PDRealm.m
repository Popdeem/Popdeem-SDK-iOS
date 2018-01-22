//
//  PDRealm.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 18/01/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDRealm.h"
#import "PDRFeedItem.h"

@implementation PDRealm

//This must be called on app launch
+ (void) initRealmDB {
  [self cleanupRealm];
}

+ (RLMRealm *) db {
  RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
  config.fileURL = [[[config.fileURL URLByDeletingLastPathComponent]
                     URLByAppendingPathComponent:@"popdeem"]
                    URLByAppendingPathExtension:@"realm"];
  config.readOnly = YES;
  [RLMRealmConfiguration setDefaultConfiguration:config];
  RLMRealm *realm = [RLMRealm realmWithConfiguration:config error:nil];
  return realm;
}

+ (void) cleanupRealm {
  
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
  NSString *path = [NSString stringWithFormat:@"%@/popdeem_images", basePath];
  
  NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
  NSMutableArray *imagesIds = [NSMutableArray array];
  
  for (int count = 0; count < (int)[directoryContent count]; count++)
  {
    [imagesIds addObject:[directoryContent objectAtIndex:count]];
  }
  
  NSError *error;
  
  RLMResults<PDRFeedItem *> *feed = [PDRFeedItem allObjects];
  for (NSString *imageId in imagesIds) {
    BOOL found = NO;
    for (PDRFeedItem *item in feed) {
      NSString *stringId = [NSString stringWithFormat:@"%ld", item.identifier];
      if ([imageId rangeOfString:stringId].location != NSNotFound) {
        found = YES;
        break;
      }
    }
    if (!found) {
      [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@/popdeem_images/%@", basePath, imageId] error:&error];
    }
  }
}

@end
