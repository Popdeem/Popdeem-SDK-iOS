//
//  PDInstagramAPIService.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 22/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PDInstagramAPIService : NSObject

@property (nonatomic, strong) NSString *baseUrl;

- (void) checkAccessToken:(void (^)(BOOL valid, NSError *error))completion;

@end
