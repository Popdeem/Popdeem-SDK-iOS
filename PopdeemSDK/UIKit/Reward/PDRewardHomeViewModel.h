//
//  PDRewardHomeViewModel.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 05/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PDRewardHomeViewModel : NSObject

@property (nonatomic, strong) NSString *headerText;
@property (nonatomic, strong) UIImage *headerImage;


- (void) setup;

@end
