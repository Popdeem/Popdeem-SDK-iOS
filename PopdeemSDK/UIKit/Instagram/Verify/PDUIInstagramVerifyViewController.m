//
//  PDUIInstagramVerifyViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 22/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIInstagramVerifyViewController.h"
#import "PDUtils.h"
#import "PDTheme.h"
#import "PDUIModalLoadingView.h"
#import "PDRewardAPIService.h"

@interface PDUIInstagramVerifyViewController ()

@end

@implementation PDUIInstagramVerifyViewController

- (instancetype) initForParent:(UIViewController*)parent forReward:(PDReward*)reward {
	if (self = [super init]) {
		_parent = parent;
		_reward = reward;
		_viewModel = [[PDUIInstagramVerifyViewModel alloc] initForViewController:self];
		return self;
	}
	return nil;
}

- (void)viewDidLoad {
	[_viewModel setup];
	[super viewDidLoad];
	[self.view setBackgroundColor:[UIColor clearColor]];
	self.effectView = [[UIVisualEffectView alloc] initWithFrame:_parent.view.frame];
	UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
	[self.effectView setEffect:blurEffect];
	UITapGestureRecognizer *backingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
	[_effectView addGestureRecognizer:backingTap];
	[self.view addSubview:_effectView];
	
	_cardView = [[UIView alloc] initWithFrame:CGRectZero];
	[self.view addSubview:_cardView];
	_headerView = [[UIView alloc] initWithFrame:CGRectZero];
	[_cardView addSubview:_headerView];
	_headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	[_headerView addSubview:_headerLabel];
	_instructionsLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	[_cardView addSubview:_instructionsLabel];
	_actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_cardView addSubview:_actionButton];
	[self renderView];
}

- (void) renderView {
	
	CGFloat currentY = 0;
	
	CGFloat cardWidth = _parent.view.frame.size.width * 0.8;
	CGFloat cardHeight = _parent.view.frame.size.height * 0.5;
	CGFloat cardX = _parent.view.frame.size.width * 0.1;
	CGFloat cardY = _parent.view.frame.size.height * 0.25;
	CGRect cardRect = CGRectMake(cardX, cardY, cardWidth, cardHeight);
	
	_cardView.frame = cardRect;
	[_cardView setBackgroundColor:[UIColor whiteColor]];
	_cardView.layer.cornerRadius = 5.0;
	_cardView.layer.masksToBounds = YES;
	
	CGFloat headerHeight = cardHeight * 0.15;
	CGFloat usableHeight = cardHeight - (2 * headerHeight);
	CGFloat messageHeight = 60;
	CGFloat padding = 5;
	_headerView.frame = CGRectMake(0, 0, cardWidth, headerHeight);
	[_headerView setBackgroundColor:_viewModel.headerColor];
	
	_headerLabel.frame = CGRectMake(0, 0, _headerView.frame.size.width, headerHeight);
	[_headerLabel setText:_viewModel.headerText];
	[_headerLabel setFont:_viewModel.headerFont];
	[_headerLabel setTextColor:_viewModel.headerFontColor];
	[_headerLabel setTextAlignment:NSTextAlignmentCenter];
	[_headerLabel setNumberOfLines:2];
	
	currentY += headerHeight + padding;
	
	_instructionsLabel.frame = CGRectMake(10, currentY+padding, cardWidth-20, usableHeight/2);
	[_instructionsLabel setTextAlignment:NSTextAlignmentLeft];
	[_instructionsLabel setText:_viewModel.messageText];
	[_instructionsLabel setFont:_viewModel.messageFont];
	[_instructionsLabel setTextColor:_viewModel.messageFontColor];
	_instructionsLabel.numberOfLines = 10;
	[_instructionsLabel sizeToFit];
	
	currentY += _instructionsLabel.frame.size.height + padding;
	CGFloat buttonWidth = cardWidth;
	
	_actionButton.frame = CGRectMake(0, currentY, cardWidth, headerHeight);
	[_actionButton setBackgroundColor:_viewModel.buttonColor];
	[_actionButton.titleLabel setFont:_viewModel.buttonFont];
	[_actionButton setTitleColor:_viewModel.buttonFontColorNormal forState:UIControlStateNormal];
	[_actionButton setTitleColor:_viewModel.buttonFontColorSelected forState:UIControlStateSelected];
	[_actionButton setTitle:_viewModel.buttonText forState:UIControlStateNormal];
	[_actionButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
	[_actionButton setTag:0];
	CALayer *buttonBorderLayer = [CALayer layer];
	buttonBorderLayer.borderColor = _viewModel.buttonBorderColor.CGColor;
	buttonBorderLayer.borderWidth = 0.5;
	buttonBorderLayer.frame = CGRectMake(-1, 0, _actionButton.frame.size.width+2, _actionButton.frame.size.height+1);
	[_actionButton.layer addSublayer:buttonBorderLayer];
	_actionButton.clipsToBounds = YES;
	[_actionButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
	
	currentY += headerHeight;
	cardHeight = currentY;
	CGFloat midY = self.view.frame.size.height / 2;
	cardY = midY - (cardHeight/2);
	[_cardView setFrame:CGRectMake(cardX, cardY, cardWidth, cardHeight)];
}

- (void) buttonPressed:(id)sender {
	switch (_viewModel.state) {
			case PDInstagramVerifyViewStateMustVerify:
			[self verifyReward];
			break;
			case PDInstagramVerifyViewStateVerifySuccess:
			[self dismiss];
			break;
			case PDInstagramVerifyViewStateVerifyFailure:
			[self verifyReward];
			break;
  default:
			break;
	}
}

- (void) verifyReward {
	_loadingView = [[PDUIModalLoadingView alloc] initForView:self.view titleText:@"Please Wait" descriptionText:@"Verifying your post..."];
	[_loadingView showAnimated:YES];
	PDRewardAPIService *service = [[PDRewardAPIService alloc] init];
	[service verifyInstagramPostForReward:_reward completion:^(BOOL verified, NSError *error){
		if (error) {
			NSLog(@"Something went wrong");
		}
		if (verified) {
			NSLog(@"Post Found");
			dispatch_async(dispatch_get_main_queue(), ^{
				[_viewModel setViewModelState:PDInstagramVerifyViewStateVerifySuccess];
				[_loadingView hideAnimated:YES];
			});
		} else {
			NSLog(@"Post not found");
			dispatch_async(dispatch_get_main_queue(), ^{
				[_viewModel setViewModelState:PDInstagramVerifyViewStateVerifyFailure];
				[_loadingView hideAnimated:YES];
			});
		}
	}];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) dismiss {
	switch (_viewModel.state) {
			case PDInstagramVerifyViewStateMustVerify:
			//Didnt Verify Yet
			[[NSNotificationCenter defaultCenter] postNotificationName:InstagramVerifyNoAttempt object:nil];
			break;
			case PDInstagramVerifyViewStateVerifySuccess:
			//Verified OK
			[[NSNotificationCenter defaultCenter] postNotificationName:InstagramVerifySuccess object:nil];
			break;
			case PDInstagramVerifyViewStateVerifyFailure:
			[[NSNotificationCenter defaultCenter] postNotificationName:InstagramVerifyFailure object:nil];
			break;
  default:
			break;
	}
	if (_loadingView) {
		[_loadingView hideAnimated:YES];
	}
	[self dismissViewControllerAnimated:YES completion:^(void){}];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) updateForViewModelState {
	[self renderView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
