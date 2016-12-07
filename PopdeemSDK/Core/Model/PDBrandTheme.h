//
//  PDBrandTheme.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 07/12/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PDBrandTheme : JSONModel

@property (nonatomic, strong) NSString *primaryAppColor;
@property (nonatomic, strong) NSString *primaryInverseColor;
@property (nonatomic, strong) NSString *primaryTextColor;
@property (nonatomic, strong) NSString *secondaryTextColor;

@end
