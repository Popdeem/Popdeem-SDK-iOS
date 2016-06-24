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
		return self;
	}
	return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.view setBackgroundColor:[UIColor clearColor]];
	self.effectView = [[UIVisualEffectView alloc] initWithFrame:_parent.view.frame];
	UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
	[self.effectView setEffect:blurEffect];
	UITapGestureRecognizer *backingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
	[_effectView addGestureRecognizer:backingTap];
	[self.view addSubview:_effectView];
	
	CGFloat currentY = 0;
	
	CGFloat cardWidth = _parent.view.frame.size.width * 0.8;
	CGFloat cardHeight = _parent.view.frame.size.height * 0.5;
	CGFloat cardX = _parent.view.frame.size.width * 0.1;
	CGFloat cardY = _parent.view.frame.size.height * 0.25;
	CGRect cardRect = CGRectMake(cardX, cardY, cardWidth, cardHeight);
	
	_cardView = [[UIView alloc] initWithFrame:cardRect];
	[_cardView setBackgroundColor:[UIColor whiteColor]];
	_cardView.layer.cornerRadius = 5.0;
	_cardView.layer.masksToBounds = YES;
	[self.view addSubview:_cardView];
	
	CGFloat headerHeight = cardHeight * 0.15;
	CGFloat usableHeight = cardHeight - (2 * headerHeight);
	CGFloat messageHeight = 60;
	CGFloat padding = 5;
	_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cardWidth, headerHeight)];
	[_headerView setBackgroundColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
	
	_headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _headerView.frame.size.width, headerHeight)];
	[_headerLabel setText:@"Verify"];
	[_headerLabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 17)];
	[_headerLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryInverseColor")];
	[_headerLabel setTextAlignment:NSTextAlignmentCenter];
	[_headerLabel setNumberOfLines:2];
	
	[_headerView addSubview:_headerLabel];
	[_cardView addSubview:_headerView];
	currentY += headerHeight + padding;
	
	_instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY+padding, cardWidth-20, usableHeight/2)];
	[_instructionsLabel setTextAlignment:NSTextAlignmentLeft];
	
	NSString *noBullet = @"Have you completed your post on Instagram? If yes, tap 'Verify' below, so we can check it out! If not, tap anywhere outside this card, and you will be brought back to the claim screen, where you can make the post again.\n";
	
	NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
	paragraphStyle.alignment                = NSTextAlignmentCenter;
	NSMutableAttributedString *notesString = [[NSMutableAttributedString alloc] initWithString:noBullet attributes:@{NSFontAttributeName: PopdeemFont(@"popdeem.fonts.primaryFont", 14), NSForegroundColorAttributeName: PopdeemColor(@"popdeem.colors.primaryFontColor"),NSParagraphStyleAttributeName: paragraphStyle}];
	
	NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName: PopdeemFont(@"popdeem.fonts.primaryFont", 12), NSForegroundColorAttributeName: PopdeemColor(@"popdeem.colors.secondaryFontColor")}];
	
	[attString appendAttributedString:notesString];
	[_instructionsLabel setAttributedText:attString];
	_instructionsLabel.numberOfLines = 10;
	[_cardView addSubview:_instructionsLabel];
	[_instructionsLabel sizeToFit];
	
	currentY += _instructionsLabel.frame.size.height + padding;
	CGFloat buttonWidth = cardWidth;
	
	_actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, currentY, cardWidth, headerHeight)];
	[_actionButton setBackgroundColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
	[_actionButton.titleLabel setFont:PopdeemFont(@"popdeem.fonts.boldFont", 17)];
	[_actionButton.titleLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryInverseColor")];
	[_actionButton setTitle:@"Verify" forState:UIControlStateNormal];
	[_actionButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
	[_actionButton setTag:0];
	[_actionButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[_cardView addSubview:_actionButton];
	
	currentY += headerHeight;
	cardHeight = currentY;
	CGFloat midY = self.view.frame.size.height / 2;
	cardY = midY - (cardHeight/2);
	[_cardView setFrame:CGRectMake(cardX, cardY, cardWidth, cardHeight)];
	
}

- (void) buttonPressed:(id)sender {
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
				[_loadingView hideAnimated:YES];
			});
		} else {
			NSLog(@"Post not found");
			dispatch_async(dispatch_get_main_queue(), ^{
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
	if (_loadingView) {
		[_loadingView hideAnimated:YES];
	}
	[self dismissViewControllerAnimated:YES completion:^(void){}];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
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
