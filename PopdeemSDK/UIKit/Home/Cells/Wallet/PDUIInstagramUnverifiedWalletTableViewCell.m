//
//  PDUIInstagramUnverifiedWalletTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 22/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIInstagramUnverifiedWalletTableViewCell.h"
#import "PDTheme.h"
#import "PDUtils.h"
#import "PDRewardAPIService.h"
#import "PDConstants.h"
#import "PopdeemSDK.h"

@implementation PDUIInstagramUnverifiedWalletTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];
	self.separatorInset = UIEdgeInsetsZero;
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	[_rewardImageView setImage:PopdeemImage(PDThemeImageDefaultItem)];
	[_mainLabel setFont:PopdeemFont(PDThemeFontBold, 14)];
	[_mainLabel setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
	[self setBackgroundColor:[UIColor clearColor]];
	[self.verifyButton setBackgroundColor:[UIColor clearColor]];
	if (PopdeemThemeHasValueForKey(PDThemeColorTableViewCellBackground)) {
		[self setBackgroundColor:PopdeemColor(PDThemeColorTableViewCellBackground)];
		self.contentView.backgroundColor = PopdeemColor(PDThemeColorTableViewCellBackground);
		[self.verifyButton setBackgroundColor:PopdeemColor(PDThemeColorTableViewCellBackground)];
	}
	
	CALayer *verfyBorderLayer = [CALayer layer];
	verfyBorderLayer.borderColor = PopdeemColor(PDThemeColorTableViewSeperator).CGColor;
	verfyBorderLayer.borderWidth = 0.5;
	verfyBorderLayer.frame = CGRectMake(0, -1, _verifyButton.frame.size.width+1, _verifyButton.frame.size.height+2);
	[self.verifyButton.layer addSublayer:verfyBorderLayer];
	_verifyButton.clipsToBounds = YES;
	
	[self.verifyButton setTitleColor:PopdeemColor(PDThemeColorPrimaryApp) forState:UIControlStateNormal];
	[self.verifyButton.titleLabel setText:translationForKey(@"popdeem.instagram.wallet.verifyButtonTitle", @"Verify")];
//	self.verifyButton.layer.cornerRadius = 5.0;
	
	[self.verifyButton addTarget:self action:@selector(verifyTapped:) forControlEvents:UIControlEventTouchUpInside];
}

- (void) wake {
	if (_verifying) {
		[self.activityIndicator startAnimating];
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (void) verifyTapped:(UIButton*)sender {
	[self begin_verifying];
}

- (void) begin_verifying {
//	CGPoint startingPoint = self.verifyButton.center;
	dispatch_async(dispatch_get_main_queue(), ^{
		self.activityIndicator.alpha = 0;
		[self.activityIndicator startAnimating];
		self.activityIndicator.hidden = NO;
		[UIView animateWithDuration:0.5 animations:^{
			self.verifyButton.titleLabel.alpha = 0;
			self.activityIndicator.alpha = 1.0;
		} completion:^(BOOL finished){
			self.verifyButton.titleLabel.hidden = YES;
		}];
		[self verifyReward];
	});
}

- (void) verifyReward {
	_verifying = YES;
	PDRewardAPIService *service = [[PDRewardAPIService alloc] init];
  __weak typeof(self) weakSelf = self;
	[service verifyInstagramPostForReward:_reward completion:^(BOOL verified, NSError *error){
		weakSelf.verifying = NO;
		if (error) {
			[weakSelf.activityIndicator stopAnimating];
			PDLogError(@"Something went wrong while _verifying Reward, Error: %@",error.localizedDescription);
		}
		if (verified) {
			PDLog(@"_verifying Reward: Post Found");
			dispatch_async(dispatch_get_main_queue(), ^{
				[weakSelf.activityIndicator stopAnimating];
				[[NSNotificationCenter defaultCenter] postNotificationName:InstagramVerifySuccessFromWallet object:nil];
			});
		} else {
			PDLog(@"_verifying Reward: Post Found");
			dispatch_async(dispatch_get_main_queue(), ^{
				[weakSelf.activityIndicator stopAnimating];
				[weakSelf.activityIndicator setHidden:YES];
				weakSelf.verifyButton.titleLabel.hidden = NO;
				[weakSelf alertNotVerified];
				[UIView animateWithDuration:0.5 animations:^{
					weakSelf.verifyButton.titleLabel.alpha = 1.0;
					weakSelf.activityIndicator.alpha = 0;
				} completion:^(BOOL finished){

				}];
				[[NSNotificationCenter defaultCenter] postNotificationName:InstagramVerifyFailureFromWallet object:nil];
			});
		}
	}];
}

- (void) alertNotVerified {
	NSString *message = [NSString stringWithFormat:@"Please ensure your Instagram post includes the required hashtag '%@'. You may edit the post and come back here to verify. Unverified rewards expire in 24 hours.",_reward.forcedTag];
	UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Instagram Post Not Verified"
																							 message:message
																							delegate:nil
																		 cancelButtonTitle:@"OK"
																		 otherButtonTitles: nil];
	[av show];
}

- (void) setupForReward:(PDReward*)reward {
	self.reward = reward;
	self.clipsToBounds = YES;
	if (reward.coverImage) {
		[self.rewardImageView setImage:reward.coverImage];
	} else {
		[self.rewardImageView setImage:PopdeemImage(PDThemeImageDefaultItem)];
	}
	
	NSString *labelLineTwo = translationForKey(@"popdeem.instagram.wallet.unverified", @"This reward must be verified.");
	NSMutableAttributedString *labelAttString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{}];
	NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
	ps.paragraphSpacing = 2.0;
	ps.lineSpacing = 0;
	[labelAttString addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, labelAttString.length)];
	
	NSMutableParagraphStyle *innerParagraphStyle = [[NSMutableParagraphStyle alloc] init];
	innerParagraphStyle.lineSpacing = 0;
	
	NSMutableAttributedString *descriptionString = [[NSMutableAttributedString alloc]
																									initWithString:[NSString stringWithFormat:@"%@ \n",reward.rewardDescription]
																									attributes:@{
																															 NSFontAttributeName : PopdeemFont(PDThemeFontBold, 14),
																															 NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont)
																															 }];
	
	[labelAttString appendAttributedString:descriptionString];
	
	NSMutableAttributedString *infoString = [[NSMutableAttributedString alloc]
																					 initWithString:labelLineTwo
																					 attributes:@{
																												NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 12),
																												NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryApp)
																												}];
	
	[labelAttString appendAttributedString:infoString];
	[_mainLabel setAttributedText:labelAttString];
}

@end
