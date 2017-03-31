//
//  PDUIScanViewController.h
//  PopdeemSDK
//
//  Created by niall quinn on 31/03/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDReward.h"

@interface PDUIScanViewController : UIViewController

- (instancetype) initWithReward:(PDReward*)reward andNetwork:(NSString*)network;

@end
