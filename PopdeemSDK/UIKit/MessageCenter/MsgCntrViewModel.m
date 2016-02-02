//
//  MsgCntrViewModel.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 02/02/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "MsgCntrViewModel.h"
#import "PDMessageAPIService.h"
#import "PDTheme.h"
#import "PDUtils.h"

@implementation MsgCntrViewModel

- (instancetype) initWithController:(PDMsgCntrTblViewController*)controller {
  if (self = [super init]) {
    self.controller = controller;
    [self setup];
    return self;
  }
  return nil;
}

- (void) setup {

  _controller.navigationController.navigationBar.backgroundColor = PopdeemColor(@"popdeem.nav.backgroundColor");
  _controller.navigationController.navigationBar.barTintColor = PopdeemColor(@"popdeem.nav.textColor");
  
  [[[_controller navigationController] navigationBar] setBarTintColor:PopdeemColor(@"popdeem.nav.textColor")];
  [[[_controller navigationController] navigationBar] setBarTintColor:PopdeemColor(@"popdeem.nav.buttonTextColor")];
  [[[_controller navigationController] navigationBar] setTranslucent:NO];
  _controller.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:PopdeemColor(@"popdeem.nav.textColor")};
  
  _controller.title = translationForKey(@"popdeem.inbox.title", @"Inbox");
  [_controller.navigationController setNavigationBarHidden:NO animated:YES];
  [_controller.view setBackgroundColor:PopdeemColor(@"popdeem.messageCenter.tableView.backgroundColor")];
  [_controller.tableView setBackgroundColor:PopdeemColor(@"popdeem.messageCenter.tableView.backgroundColor")];
  [_controller.tableView setSeparatorColor:PopdeemColor(@"popdeem.messageCenter.tableView.seperatorColor")];
}

- (void) fetchMessages {
  _messagesLoading = YES;
  PDMessageAPIService *service = [[PDMessageAPIService alloc] init];
  [service fetchMessagesCompletion:^(NSArray *messages, NSError *error){
    if (error) {
      NSLog(@"Error while fetching messages");
      return;
    }
    self.messages = messages;
    [self.controller.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
  }];
}

@end
