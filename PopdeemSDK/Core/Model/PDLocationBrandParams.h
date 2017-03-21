//
//  PDLocationBrandParams.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 07/12/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface PDLocationBrandParams : JSONModel
@property (nonatomic) NSInteger id;
@property (nonatomic, retain) NSString *name;

- (instancetype) initWithDictionary:(NSDictionary *)dict;
@end
