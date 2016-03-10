//
//  PDMessage.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 27/01/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import <UIKit/UIKit.h>

@interface PDMessage : JSONModel

@property (nonatomic) NSInteger identifier;
@property (nonatomic) NSString *senderName;
@property (nonatomic,strong) NSNumber<Optional> *brandId;
@property (nonatomic,strong) NSNumber<Optional> *rewardId;
@property (nonatomic) BOOL read;
@property (nonatomic, strong) NSString<Optional> *imageUrl;
@property (nonatomic, strong) UIImage<Optional> *image;
@property (nonatomic) NSInteger createdAt;
@property (nonatomic, strong) NSString<Optional> *title;
@property (nonatomic, strong) NSString *body;

- (id) initWithJSON:(NSString*)json;
- (void) markAsRead;
- (void) downloadLogoImageCompletion:(void (^)(BOOL Success))completion;

@end
