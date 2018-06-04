//
//  PDUIFacebookShareViewController.h
//  Bolts
//
//  Created by Niall Quinn on 22/05/2018.
//

#import <UIKit/UIKit.h>
#import "PDUIFacebookShareViewModel.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "PDReward.h"
#import "PDUIClaimV2ViewController.h"

@interface PDUIFacebookShareViewController : UIViewController <UIScrollViewDelegate, UIAlertViewDelegate, FBSDKSharingDelegate>

@property (nonatomic,retain) UIView *backingView;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) PDUIFacebookShareViewModel *viewModel;
@property (nonatomic, assign) PDUIClaimV2ViewController *parent;
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

@property (nonatomic, assign) PDReward *reward;
@property (nonatomic) BOOL facebookInstalled;

- (instancetype) initForParent:(PDUIClaimV2ViewController*)parent withMessage:(NSString*)message image:(UIImage*)image imageUrlString:(NSString*)urlString;

@end
