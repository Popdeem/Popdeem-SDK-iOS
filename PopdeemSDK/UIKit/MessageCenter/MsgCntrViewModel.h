//
//  MsgCntrViewModel.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 02/02/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDMsgCntrTblViewController.h"

@interface MsgCntrViewModel : NSObject

@property (nonatomic) NSArray *messages;
@property (nonatomic) PDMsgCntrTblViewController *controller;
@property (nonatomic) BOOL messagesLoading;

- (void) fetchMessages;
@end
