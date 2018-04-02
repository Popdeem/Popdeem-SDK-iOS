//
//  PDUITwitterLoginViewModel.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 05/08/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PDUITwitterLoginViewModel : NSObject

@property (nonatomic, retain) NSString *labelText;
@property (nonatomic, retain) UIColor *labelColor;
@property (nonatomic, retain) UIFont *labelFont;
@property (nonatomic, retain) UIImage *logoImage;
@property (nonatomic, retain) NSString *buttonText;
@property (nonatomic, retain) UIColor *buttonColor;
@property (nonatomic, retain) UIColor *buttonTextColor;
@property (nonatomic, retain) UIColor *buttonBorderColor;
@property (nonatomic, retain) UIFont *buttonLabelFont;

- (instancetype) initForParent:(UIViewController*)parent;
- (void) setup;
- (void) setIsLoading:(BOOL)loading;

@end
