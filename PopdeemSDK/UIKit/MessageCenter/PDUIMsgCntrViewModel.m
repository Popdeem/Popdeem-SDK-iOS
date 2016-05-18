//
//  MsgCntrViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 02/02/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIMsgCntrViewModel.h"
#import "PDMessageAPIService.h"
#import "PDTheme.h"
#import "PDUtils.h"
#import "PDMessageStore.h"
#import "PDUILazyLoader.h"

@implementation PDUIMsgCntrViewModel

- (instancetype) initWithController:(PDUIMsgCntrTblViewController*)controller {
  if (self = [super init]) {
    self.controller = controller;
    [self setup];
    return self;
  }
  return nil;
}

- (void) setup {
  _controller.title = translationForKey(@"popdeem.inbox.title", @"Inbox");
  if ([[PDMessageStore store] count] > 0) {
    _messages = [PDMessageStore orderedByDate];
  }
}

- (void) fetchMessages {
  _messagesLoading = YES;
  PDMessageAPIService *service = [[PDMessageAPIService alloc] init];
  __weak typeof(self) weakSelf = self;
  [service fetchMessagesCompletion:^(NSArray *messages, NSError *error){
    if ([weakSelf.controller.refreshControl isRefreshing]) {
      [weakSelf.controller.refreshControl endRefreshing];
    }
    if (error) {
      NSLog(@"Error while fetching messages");
    }
    weakSelf.messages = messages;
    weakSelf.messagesLoading = NO;
		dispatch_async(dispatch_get_main_queue(), ^{
			[weakSelf.controller.tableView reloadData];
		});
  }];
}

@end
