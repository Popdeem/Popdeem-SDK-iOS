//
//  PDUIPostScanViewController.h
//  PopdeemSDK
//
//  Created by niall quinn on 03/04/2017.
//  Copyright © 2017 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDBGScanResponseModel.h"
#import "PDReward.h"

@interface PDUIPostScanViewController : UIViewController <UIAlertViewDelegate>

- (instancetype) initWithReward:(PDReward*)reward network:(NSString*)network;

@end
