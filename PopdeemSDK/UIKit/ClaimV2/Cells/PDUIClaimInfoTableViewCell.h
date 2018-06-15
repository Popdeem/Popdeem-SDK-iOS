//
//  PDUIClaimInfoTableViewCell.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 14/05/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDUIClaimInfoTableViewCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *infoLabel;

- (id) initWithFrame:(CGRect)frame text:(NSString*)text;
@end
