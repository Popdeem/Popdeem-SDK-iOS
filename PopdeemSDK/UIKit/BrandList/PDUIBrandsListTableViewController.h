//
//  PDUIBrandsListTableViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDBrandListViewModel.h"

@interface PDUIBrandsListTableViewController : UITableViewController <UISearchBarDelegate>

@property (nonatomic, retain) PDBrandListViewModel *viewModel;


@end
