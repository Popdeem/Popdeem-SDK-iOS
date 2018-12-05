//
//  PDUINoActionRewardView.m
//  PopdeemSDK
//
//  Created by Popdeem on 27/11/2018.
//

#import "PDUINoActionRewardView.h"
#import "PDUIHomeViewController.h"
#import "PDUtils.h"
#import "PDTheme.h"
#import "PDReward.h"
//#import "PDUIHomeViewModel.h"


@implementation PDUINoActionRewardView



- (PDUINoActionRewardView*) initForView:(UIView*)parent
                            reward:(PDReward*)reward
                           {
    if (self = [super init]) {
    
        //_homeViewController = [[PDUIHomeViewController alloc] initFromNib];
        
        self.parent = parent;
        
        // self.view is a backing view which has 0.5 opacity and will fill the parent
        self.frame = CGRectMake(0,0,parent.frame.size.width,parent.frame.size.height);
        
        float width = parent.frame.size.width;
        float height = parent.frame.size.height;
        
        _backingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        _backingView.alpha = 0.8;
        [_backingView setBackgroundColor:UIColor.lightGrayColor];
 
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width/1.2, height/1.5)];
        _contentView.center = self.backingView.center;
        _contentView.layer.cornerRadius = 5.0;
        [_contentView setBackgroundColor:UIColor.whiteColor];

        float framecenter = _contentView.center.x;

        float bottom = _contentView.frame.size.height;

        // CGRect x, y width, height
        
        
        // Pull in reward image & default if nil
        UIImage *rewardImage;
        
        if(reward.coverImage == nil) {
            rewardImage = PopdeemImage(@"pduikit_starG");
        } else {
            rewardImage = reward.coverImage;
        }
        
        CGRect rewardImageRect = CGRectMake(framecenter -50, framecenter -150, 50, 50);
        _rewardImageView = [[UIImageView alloc] initWithFrame:rewardImageRect];
        _rewardImageView.contentMode = UIViewContentModeScaleAspectFit;
        _rewardImageView.layer.masksToBounds = YES;
        [_rewardImageView setImage:rewardImage];
        
        CGRect titleRect = CGRectMake(5, framecenter -50, _contentView.frame.size.width -10, 60);
        _titleLabel = [[UILabel alloc] initWithFrame:titleRect];
        [self.titleLabel setText:reward.rewardDescription];
        [_titleLabel setNumberOfLines:3];
        [_titleLabel setFont:PopdeemFont(PDThemeFontBold, 16)];
        [_titleLabel setTextColor:[UIColor colorWithRed:0.166 green:0.166 blue:0.166 alpha:1.000]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        CGRect descriptionRect = CGRectMake(5, framecenter + 20, _contentView.frame.size.width -10, 120);
        _descriptionLabel = [[UILabel alloc] initWithFrame:descriptionRect];
        [self.descriptionLabel setText:reward.rewardRules];
        [_descriptionLabel setNumberOfLines:7];
        [_descriptionLabel setFont:PopdeemFont(PDThemeFontPrimary, 16)];
        [_descriptionLabel setTextColor:[UIColor colorWithRed:0.274 green:0.274 blue:0.274 alpha:1.000]];
        [_descriptionLabel setTextAlignment:NSTextAlignmentCenter];
        
    
        CGRect cancelButtonRect = CGRectMake(0, bottom-40, _contentView.frame.size.width/2, 40);
        _cancelButton = [[UIButton alloc] initWithFrame:cancelButtonRect];
        [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:PopdeemColor(PDThemeColorPrimaryApp) forState:UIControlStateNormal];
        [_cancelButton setBackgroundColor:[UIColor colorWithRed:0.93 green:0.92 blue:0.92 alpha:1.0]];
        [_cancelButton setFont:PopdeemFont(PDThemeFontPrimary, 16)];
        _cancelButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        _cancelButton.layer.borderWidth =1.0f;
        _cancelButton.layer.masksToBounds = YES;
        
    

        CGRect claimButtonRect = CGRectMake(_contentView.frame.size.width/2, bottom-40, _contentView.frame.size.width/2, 40);
        _claimButton = [[UIButton alloc] initWithFrame:claimButtonRect];
        [self.claimButton setTitle:@"Claim" forState:UIControlStateNormal];
        [self.claimButton setTitleColor:PopdeemColor(PDThemeColorPrimaryApp) forState:UIControlStateNormal];
        [_claimButton setBackgroundColor:[UIColor colorWithRed:0.93 green:0.92 blue:0.92 alpha:1.0]];
        [_claimButton setFont:PopdeemFont(PDThemeFontPrimary, 16)];
        _claimButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        _claimButton.layer.borderWidth =1.0f;
        _claimButton.layer.masksToBounds = YES;
        
        PDReward *rewardToPass = reward;//can be anything, doesn't have to be NSString
        [_claimButton.layer setValue:rewardToPass forKey:@"rewardKey"];
        
        //IBAction for Dismiss & Claim No Action
        [_cancelButton addTarget:self action:@selector(dismissAction)forControlEvents:UIControlEventTouchDown];
        
        // claimButtonClicked needs a reward to be passed..
        [_claimButton addTarget:self action:@selector(claimButtonClicked:)forControlEvents:UIControlEventTouchUpInside];
    
    
    }
    return self;
}

- (void) didMoveToSuperview {
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_descriptionLabel];
    [self.contentView addSubview:_claimButton];
    [self.contentView addSubview:_cancelButton];
    [self.contentView addSubview:_rewardImageView];

    [self addSubview:_backingView];
    [self addSubview:_contentView];
}



-(void)claimButtonClicked:(UIButton*)sender{
    
    PDReward *rewardThatWasPassed = (PDReward *)[sender.layer valueForKey:@"rewardKey"];
    
    PDUIHomeViewController *homeViewController = [[PDUIHomeViewController alloc]init];
    [homeViewController claimNoActionReward:rewardThatWasPassed];
    
    [self dismissAction];
}


/*
- (void) claimButtonClicked:(PDReward*)reward {
    PDUIHomeViewController *homeViewController = [[PDUIHomeViewController alloc]init];
    [homeViewController claimNoActionReward:reward];
    printf("Reward Desc: ", reward.rewardRules);
}*/



- (void) dismissAction {
    [self hideAnimated:YES];
}




- (void) hideAnimated:(BOOL)animated {
    if (animated) {
        [self.layer removeAllAnimations];
        CATransition *loaderOut =[CATransition animation];
        [loaderOut setDuration:0.5];
        [loaderOut setType:kCATransitionReveal];
        [loaderOut setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [[self layer] addAnimation:loaderOut forKey:kCATransitionReveal];
    }
    [self removeFromSuperview];
}

- (void) showAnimated:(BOOL)animated {
    if (animated) {
        CATransition *loaderIn =[CATransition animation];
        [loaderIn setDuration:0.5];
        [loaderIn setType:kCATransitionReveal];
        [loaderIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [[self layer] addAnimation:loaderIn forKey:kCATransitionReveal];
    }
    [self setHidden:NO];
    [_parent addSubview:self];
    [_parent bringSubviewToFront:self];
}


@end
