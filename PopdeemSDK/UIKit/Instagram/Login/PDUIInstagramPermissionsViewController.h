//
//  PDUIInstagramPermissionsViewController.h
//  PopdeemSDK
//
//  Created by Popdeem on 24/01/2020.
//

#import <UIKit/UIKit.h>
#import "PDUIInstagramPermissionsViewModel.h"

@interface PDUIInstagramPermissionsViewController : UIViewController

@property (nonatomic,retain) UIView *backingView;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) PDUIInstagramPermissionsViewModel *viewModel;
//@property (nonatomic, assign) PDUIClaimV2ViewController *parent;
@property (nonatomic, assign) UIViewController *parent;
@property (nonatomic, retain) UIView *cardView;
@property (nonatomic, retain) UIPageViewController *pageViewController;
@property (nonatomic,retain) UIView *firstView;


@property (nonatomic, retain) UILabel *viewOneLabelOne;
@property (nonatomic, retain) UILabel *viewOneLabelTwo;
@property (nonatomic, retain) UIImageView *viewOneImageView;
@property (nonatomic, retain) UIButton *viewOneActionButton;

@property (nonatomic, retain) UILabel *viewTwoLabelOne;
@property (nonatomic, retain) UILabel *viewTwoLabelTwo;
@property (nonatomic, retain) UIImageView *viewTwoImageView;
@property (nonatomic, retain) UIButton *viewTwoActionButton;


- (instancetype) initForParent:(UIViewController*)parent;

@end
