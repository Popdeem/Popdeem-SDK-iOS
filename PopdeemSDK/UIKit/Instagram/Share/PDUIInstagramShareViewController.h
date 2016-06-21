//
//  PDUIInstagramShareViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDUIInstagramShareViewController : UIViewController

@property (nonatomic, assign) UIViewController *parent;
@property (nonatomic, retain) UIVisualEffectView *effectView;
@property (nonatomic, retain) UIView *cardView;
@property (nonatomic, retain) UIView *headerView;
@property (nonatomic, retain) UIView *messageView;
@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) UILabel *instructionsLabel;
@property (nonatomic, retain) UILabel *headerLabel;
@property (nonatomic, retain) UIButton *actionButton;

@property (nonatomic, retain) UIDocumentInteractionController *dic;
@property (nonatomic, retain) NSString *message;
@property (nonatomic,retain) UIImage *image;

- (instancetype) initFromNib;
- (instancetype) initForParent:(UIViewController*)parent withMessage:(NSString*)message image:(UIImage*)image;

@end
