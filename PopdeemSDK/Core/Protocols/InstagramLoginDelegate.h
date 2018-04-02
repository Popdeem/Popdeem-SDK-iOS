//
//  InstagramLoginDelegate.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 19/01/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InstagramLoginDelegate <NSObject>

- (void) connectInstagramAccount:(NSString*)identifier accessToken:(NSString*)accessToken userName:(NSString*)userName;

@end
