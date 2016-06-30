//
//  PDUIInstagramVerifyViewModel.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 23/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PDInstagramVerifyViewState) {
	PDInstagramVerifyViewStateMustVerify,
	PDInstagramVerifyViewStateVerifySuccess,
	PDInstagramVerifyViewStateVerifyFailure
};

@interface PDUIInstagramVerifyViewModel : NSObject

@property (nonatomic, retain) NSString *headerText;
@property (nonatomic, retain) NSString *messageText;
@property (nonatomic, retain) NSString *buttonText;

@property (nonatomic, retain) UIFont *headerFont;
@property (nonatomic, retain) UIFont *messageFont;
@property (nonatomic, retain) UIFont *buttonFont;

@property (nonatomic, retain) UIColor *headerColor;
@property (nonatomic, retain) UIColor *headerFontColor;
@property (nonatomic, retain) UIColor *messageFontColor;
@property (nonatomic, retain) UIColor *buttonColor;
@property (nonatomic, retain) UIColor *buttonFontColorNormal;
@property (nonatomic, retain) UIColor *buttonFontColorSelected;
@property (nonatomic, retain) UIColor *buttonBorderColor;

@property (nonatomic) PDInstagramVerifyViewState state;

- (instancetype) initForViewController:(UIViewController*)viewController;
- (void) setup;
- (void) setViewModelState:(PDInstagramVerifyViewState)state;
@end
