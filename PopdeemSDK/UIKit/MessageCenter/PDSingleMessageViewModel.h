//
//  PDSingleMessageViewModel.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 15/02/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PDMessage.h"
#import "PDSingleMessageViewController.h"

@interface PDSingleMessageViewModel : NSObject

@property (nonatomic, strong) PDMessage *message;
@property (nonatomic, assign) PDSingleMessageViewController *controller;
@property (nonatomic, strong) NSString *senderTagLabelString;
@property (nonatomic, strong) NSString *senderBodyString;
@property (nonatomic, strong) NSString *dateTagString;
@property (nonatomic, strong) NSString *dateBodyString;
@property (nonatomic, strong) NSString *titleTagString;
@property (nonatomic, strong) NSString *titleBodyString;
@property (nonatomic, strong) NSString *bodyTagString;
@property (nonatomic, strong) NSString *bodyBodyString;
@property (nonatomic, strong) NSString *imageName;
@property (nonatomic, strong) UIImage *image;

- (instancetype) initWithMessage:(PDMessage*)message;

@end