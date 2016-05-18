//
//  NoRewardsTableViewCell.m
//  Popdeem
//
//  Created by Niall Quinn on 20/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "PDUINoRewardsTableViewCell.h"
#import "PDTheme.h"

@implementation PDUINoRewardsTableViewCell

- (id) initWithFrame:(CGRect)frame text:(NSString*)text {
  if (self = [super initWithFrame:frame]) {
    float centerY = frame.size.height/2;
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, centerY-15, frame.size.width-20, frame.size.height)];
    [infoLabel setNumberOfLines:2];
    [infoLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [infoLabel setTextAlignment:NSTextAlignmentCenter];
		[infoLabel setTextColor:PopdeemColor(@"popdeem.colors.secondaryFontColor")];
		[infoLabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 16)];
    [infoLabel setText:text];
    [infoLabel sizeToFit];
    float labelH = infoLabel.frame.size.height;
    float indent = (frame.size.height - labelH)/2;
    [infoLabel setFrame:CGRectMake(10, indent, frame.size.width-20, labelH)];
    [self addSubview:infoLabel];
    if (PopdeemThemeHasValueForKey(@"popdeem.colors.tableViewCellBackgroundColor")) {
      [self setBackgroundColor:PopdeemColor(@"popdeem.colors.tableViewCellBackgroundColor")];
    }
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    return self;
  }
  return nil;
}

@end
