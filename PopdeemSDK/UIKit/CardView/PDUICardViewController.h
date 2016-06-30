//
//  PDUICardViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 17/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDUICardViewController : UIViewController

@property (nonatomic, assign) UIViewController *parent;
@property (nonatomic, copy) void (^completion)(int);

@property (nonatomic, retain) UIVisualEffectView *effectView;
@property (nonatomic, retain) UIView *cardView;
@property (nonatomic, retain) UIView *headerView;

@property (nonatomic, retain) UIImageView *imageView;

@property (nonatomic, retain) UILabel *headerLabel;
@property (nonatomic, retain) UILabel *bodyLabel;

@property (nonatomic, retain) NSArray *actionButtons;
@property (nonatomic, retain) UIButton *actionButton;

- (instancetype) initForParent:(UIViewController*)parent
										headerText:(NSString*)headerText
												 image:(UIImage*)image
											bodyText:(NSString*)bodyText
						 actionButtonTitle:(NSString*)actionButtonTitle
						 otherButtonTitles:(NSArray*)otherButtonTitles
										completion:(void (^)(int buttonIndex))completion;

@end
