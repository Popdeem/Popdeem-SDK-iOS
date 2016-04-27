//
//  FriendPickerViewController.h
//  ios-test-v0.2
//
//  Created by Niall Quinn on 02/10/2014.
//  Copyright (c) 2014 Niall Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDUser.h"

@interface PDUIFriendPickerViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (unsafe_unretained) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSMutableArray *tableData;

@property (unsafe_unretained) IBOutlet UITextField *textField;

- (instancetype) initFromNib;

@end
