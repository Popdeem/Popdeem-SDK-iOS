//
//  PDUIFBLoginWithWritePermsViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 26/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDUIFBLoginWithWritePermsViewModel.h"


@interface PDUIFBLoginWithWritePermsViewController : UIViewController <UIAlertViewDelegate> {
	CGFloat _cardX,_cardY;
	BOOL connected;
}

@property (nonatomic, retain) PDUIFBLoginWithWritePermsViewModel *viewModel;
@property (nonatomic, assign) UIViewController *parent;
@property (nonatomic, retain) UIView *backingView;
@property (nonatomic, retain) UIView *cardView;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UIImageView *imageView;
@property (nonatomic, retain) UIButton *actionButton;

- (instancetype) initForParent:(UIViewController*)parent loginType:(PDFacebookLoginType)loginType;

@end
