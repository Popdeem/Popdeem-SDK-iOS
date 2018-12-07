//
//  PDUINoActionRewardView.h
//  PopdeemSDK
//
//  Created by Popdeem on 27/11/2018.
//

#import <UIKit/UIKit.h>
#import "PDReward.h"

@class PDUIHomeViewController;

@interface PDUINoActionRewardView : UIView

@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *descriptionLabel;
@property (nonatomic,retain) UIImageView *rewardImageView;
@property (nonatomic,assign) UIView *parent;
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) UIView *backingView;
@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIButton *claimButton;
@property (nonatomic, retain) UIView *topBorder;
@property (nonatomic, retain) UIView *middleBorder;

@property (nonatomic, retain) PDUIHomeViewController *homeViewController;

@property (nonatomic, assign) PDReward *reward;

- (PDUINoActionRewardView*) initForView:(UIView*)parent
                            reward:(PDReward*)reward
                            homeVC:(PDUIHomeViewController*)homeVC;


- (void) showAnimated:(BOOL)animated;
- (void) hideAnimated:(BOOL)animated;
- (void) setHighlighted:(BOOL)highlighted;

@end
