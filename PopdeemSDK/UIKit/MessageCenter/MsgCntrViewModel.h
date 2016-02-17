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

@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, assign) PDMsgCntrTblViewController *controller;
@property (nonatomic) BOOL messagesLoading;

- (instancetype) initWithController:(PDMsgCntrTblViewController*)controller;
- (void) fetchMessages;
@end
