//
//  PDUIInstagramShareViewController.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PDUIInstagramShareViewModel.h"

@interface PDUIInstagramShareViewController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate>

@property (nonatomic,retain) UIView *backingView;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) PDUIInstagramShareViewModel *viewModel;
@property (nonatomic, assign) UIViewController *parent;
@property (nonatomic, retain) UIView *cardView;
@property (nonatomic, retain) UIPageViewController *pageViewController;
@property (nonatomic,retain) UIView *firstView;
@property (nonatomic,retain) UIView *secondView;
@property (nonatomic,retain) UIView *thirdView;

@property (nonatomic, retain) UILabel *viewOneLabelOne;
@property (nonatomic, retain) UILabel *viewOneLabelTwo;
@property (nonatomic, retain) UIImageView *viewOneImageView;
@property (nonatomic, retain) UIButton *viewOneActionButton;

@property (nonatomic, retain) UILabel *viewTwoLabelOne;
@property (nonatomic, retain) UILabel *viewTwoLabelTwo;
@property (nonatomic, retain) UIImageView *viewTwoImageView;
@property (nonatomic, retain) UIButton *viewTwoActionButton;

@property (nonatomic, retain) UILabel *viewThreeLabelOne;
@property (nonatomic, retain) UILabel *viewThreeLabelTwo;
@property (nonatomic, retain) UIImageView *viewThreeImageView;
@property (nonatomic, retain) UIButton *viewThreeActionButton;

@property (nonatomic, retain) UIDocumentInteractionController *dic;
@property (nonatomic, retain) NSString *message;
@property (nonatomic,retain) UIImage *image;
@property (nonatomic, retain) NSString *imageURLString;

- (instancetype) initForParent:(UIViewController*)parent withMessage:(NSString*)message image:(UIImage*)image imageUrlString:(NSString*)urlString;

@end
