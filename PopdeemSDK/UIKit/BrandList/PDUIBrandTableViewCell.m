//
//  PDUIBrandTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 21/07/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIBrandTableViewCell.h"
#import <Shimmer/FBShimmeringView.h>
#import "PopdeemSDK.h"

@interface PDUIBrandTableViewCell()
@property (weak, nonatomic) IBOutlet FBShimmeringView *shimmeringView;

@end

@implementation PDUIBrandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void) setupForBrand:(PDBrand*)b {
	self.brand = b;
	if (b.coverImage) {
		[self.headerImageView setImage:b.coverImage];
	} else {
		if ([b.coverUrlString rangeOfString:@"default"].location == NSNotFound) {
			[self.headerImageView setHidden:YES];
			[_shimmeringView setHidden:NO];
			_shimmeringView.shimmering = YES;
			_shimmeringView.contentView = [[UIImageView alloc] initWithImage:PopdeemImage(PDThemeImageDefaultBrand)];
			[self fetchCoverImage];
		} else {
			[self.headerImageView setImage:PopdeemImage(PDThemeImageDefaultBrand)];
		}
	}
	
	[self.logoImageView setBackgroundColor:[UIColor whiteColor]];
	if (b.logoImage) {
		[self.logoImageView setImage:b.logoImage];
	} else {
		if ([b.logoUrlString rangeOfString:@"default"].location == NSNotFound) {
			[self fetchLogoImage];
		}
		[self.logoImageView setImage:PopdeemImage(PDThemeImageDefaultItem)];
	}
	
	NSMutableParagraphStyle *ps = [[NSMutableParagraphStyle alloc] init];
	ps.lineSpacing = 2.5;
	NSMutableAttributedString *labelAttString = [[NSMutableAttributedString alloc] initWithString:@""
																																										 attributes:@{NSParagraphStyleAttributeName: ps}];
	
	NSString *name = _brand.name;
	NSMutableAttributedString *nameAttString = [[NSMutableAttributedString alloc]
																									initWithString:[NSString stringWithFormat:@"%@ \n",name]
																									attributes:@{
																															 NSFontAttributeName : PopdeemFont(PDThemeFontBold, 16),
																															 NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont)
																															 }];
	[labelAttString appendAttributedString:nameAttString];
	
	NSString *rewards = (_brand.numberOfRewardsAvailable > 1) ? @"Rewards" : @"Reward";
	NSString *available = [NSString stringWithFormat:@"%li %@ Available",(long)_brand.numberOfRewardsAvailable, rewards];
	NSMutableAttributedString *availAttString = [[NSMutableAttributedString alloc]
																						initWithString:[NSString stringWithFormat:@"%@",available]
																						attributes:@{
																												 NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 14),
																												 NSForegroundColorAttributeName : PopdeemColor(PDThemeColorSecondaryFont)
																												 }];
	[labelAttString appendAttributedString:availAttString];
	[labelAttString addAttribute:NSParagraphStyleAttributeName value:ps range:NSMakeRange(0, labelAttString.length)];
	[self.messageLabel setAttributedText:labelAttString];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void) fetchCoverImage {
	NSURL *url = [NSURL URLWithString:self.brand.coverUrlString];
	NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		if (data) {
			UIImage *image = [UIImage imageWithData:data];
			if (image) {
				dispatch_async(dispatch_get_main_queue(), ^{
					[self.headerImageView setHidden:NO];
					self.headerImageView.image = image;
					self.brand.coverImage = image;
					_shimmeringView.shimmering = NO;
					[_shimmeringView removeFromSuperview];
				});
			}
		} else {
			dispatch_async(dispatch_get_main_queue(), ^{
				[self.headerImageView setHidden:NO];
				self.headerImageView.image = PopdeemImage(PDThemeImageDefaultBrand);
				_shimmeringView.shimmering = NO;
				[_shimmeringView removeFromSuperview];
			});
		}
	}];
	[task resume];
}

- (void) fetchLogoImage {
	NSURL *url = [NSURL URLWithString:self.brand.logoUrlString];
	NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		if (data) {
			UIImage *image = [UIImage imageWithData:data];
			if (image) {
				dispatch_async(dispatch_get_main_queue(), ^{
					[self.logoImageView setHidden:NO];
					self.logoImageView.image = image;
					self.brand.logoImage = image;
				});
			}
		} else {
			dispatch_async(dispatch_get_main_queue(), ^{
				self.logoImageView.image = PopdeemImage(PDThemeImageDefaultItem);
			});
		}
	}];
	[task resume];
}
@end
