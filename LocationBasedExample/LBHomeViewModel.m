//
//  HomeViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 16/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "LBHomeViewModel.h"
#import "LBMenuOption.h"

@interface LBHomeViewModel ()

@end

@implementation LBHomeViewModel

- (NSArray*) menuOptions {
    return [NSArray arrayWithObjects:[[LBMenuOption alloc] initWithVCName:@"LBLocationsViewController" imageName:@"LocationsIcon" title:@"Locations"],[[LBMenuOption alloc] initWithVCName:@"LBWalletViewController" imageName:@"WalletIcon" title:@"Wallet"],[[LBMenuOption alloc] initWithVCName:@"LBMapViewController" imageName:@"MapIcon" title:@"Map"], nil];
}

@end
