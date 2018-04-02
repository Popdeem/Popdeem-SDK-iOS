//
//  PDUIBrandPlaceHolderTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Shimmer/FBShimmeringView.h>

@interface PDUIBrandPlaceHolderTableViewCell : UITableViewCell
@property (nonatomic, retain) UIImageView *placeholderImageView;
- (void) setup;
@end
