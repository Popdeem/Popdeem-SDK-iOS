//
//  MsgCntrViewModel.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 02/02/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDUIMsgCntrTblViewController.h"

@interface PDUIMsgCntrViewModel : NSObject

@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, assign) PDUIMsgCntrTblViewController *controller;
@property (nonatomic) BOOL messagesLoading;

- (instancetype) initWithController:(PDUIMsgCntrTblViewController*)controller;
- (void) fetchMessages;
@end
