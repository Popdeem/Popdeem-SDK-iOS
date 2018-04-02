//
//  PDRealm.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 18/01/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <Realm/Realm.h>

@interface PDRealm : NSObject

+ (void) initRealmDB;
+ (RLMRealm *) db;

@end
