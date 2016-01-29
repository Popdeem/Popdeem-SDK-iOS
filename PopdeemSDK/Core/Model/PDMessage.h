//
//  PDMessage.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 27/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface PDMessage : JSONModel

@property (nonatomic) NSInteger identifier;
@property (nonatomic) NSInteger brandId;
@property (nonatomic) NSInteger rewardId;
@property (nonatomic) BOOL read;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic) NSInteger createdAt;
@property (nonatomic, strong) NSString *body;

- (id) initWithJSON:(NSString*)json;

@end
