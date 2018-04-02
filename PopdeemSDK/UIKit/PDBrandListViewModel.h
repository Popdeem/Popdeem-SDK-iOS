//
//  PDBrandListViewModel.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PDUIBrandsListTableViewController;
@interface PDBrandListViewModel : NSObject

@property (nonatomic, assign) PDUIBrandsListTableViewController *viewController;
@property (nonatomic, retain) NSMutableArray *tableData;
@property (nonatomic, retain) NSMutableArray *searchData;

- (void) fetchBrands;

@end
