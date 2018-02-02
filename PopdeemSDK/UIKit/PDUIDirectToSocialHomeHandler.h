//
//  PDUIDirectToSocialHomeHandler.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 02/02/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PDUIDirectToSocialHomeHandler : NSObject

@property (nonatomic, retain) PDUINavigationController *navController;

-(void)handleHomeFlow;
-(void)presentHomeFlow;

@end
