//
//  ClaimViewController.h
//  Popdeem
//
//  Created by Niall Quinn on 14/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PD_SZTextView.h"
#import "PDCustomIOS7AlertView.h"
#import "PDAPIClient.h"
#import "PDReward.h"
#import "PDLocation.h"

@interface ClaimViewController : UIViewController <UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, PDCustomIOS7AlertViewDelegate, UIActionSheetDelegate>


@property (nonatomic, retain) PD_SZTextView *textView;
//@property (nonatomic, retain) UIView *buttonsView;
@property (nonatomic, retain) UIView *shareView;
@property (nonatomic, retain) PDReward *reward;

//@property (nonatomic, retain) UIButton *tagFriendsButton;
//@property (nonatomic, retain) UIButton *addPhotoButton;
@property (nonatomic, retain) PDLocation *location;

@property (nonatomic, retain) UIWindow *alertWindow;
- (instancetype) initFromNib;

@end
