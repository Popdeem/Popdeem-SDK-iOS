//
//  NoRewardsTableViewCell.m
//  Popdeem
//
//  Created by Niall Quinn on 20/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "NoRewardsTableViewCell.h"
#import "PDTheme.h"

@implementation NoRewardsTableViewCell

- (id) initWithFrame:(CGRect)frame text:(NSString*)text {
  if (self = [super initWithFrame:frame]) {
    float centerY = frame.size.height/2;
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, centerY-15, frame.size.width-20, frame.size.height)];
    [infoLabel setNumberOfLines:2];
    [infoLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [infoLabel setTextColor:[UIColor blackColor]];
    [infoLabel setFont:[UIFont fontWithName:PopdeemFontName(@"popdeem.home.tableView.rewardsCell.fontName") size:16]];
    [infoLabel setTextAlignment:NSTextAlignmentCenter];
    [infoLabel setText:text];
    [infoLabel sizeToFit];
    float labelH = infoLabel.frame.size.height;
    float indent = (frame.size.height - labelH)/2;
    [infoLabel setFrame:CGRectMake(10, indent, frame.size.width-20, labelH)];
    [self addSubview:infoLabel];
    [self setBackgroundColor:PopdeemColor(@"popdeem.home.tableView.rewardsCell.backgroundColor")];
    [infoLabel setTextColor:PopdeemColor(@"popdeem.home.tableView.rewardsCell.titleTextColor")];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    return self;
  }
  return nil;
}

@end
