//
//  FeedCell.m
//  Popdeem
//
//  Created by Niall Quinn on 06/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "PDUIFeedCell.h"
#import "PDFeedItem.h"
#import "PDTheme.h"
#import "PDUIKitUtils.h"
@implementation PDUIFeedCell

- (id) initWithFrame:(CGRect)frame forFeedItem:(PDFeedItem*)feedItem {
  if (self = [super initWithFrame:frame]) {
    float cellHeight = 75;
    float indent = 20.0f;
    self.separatorInset = UIEdgeInsetsZero;
    float logoSize = cellHeight-30;
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(indent, 15, logoSize, logoSize)];
    [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.profileImageView.layer.cornerRadius = logoSize/2;
    self.profileImageView.clipsToBounds = YES;
    [self addSubview:self.profileImageView];
		
		if (feedItem.profileImage) {
			[self.profileImageView setImage:feedItem.profileImage];
		}else {
			[self.profileImageView setImage:[UIImage imageNamed:@"pduikit_default_user"]];
		}
		
    float left = indent+logoSize+20;
//    self.label = [[UILabel alloc] initWithFrame:CGRectMake(left, 10, frame.size.width-(left + 20), cellHeight-20)];
//    [self.label setNumberOfLines:2];
//    [self.label setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 16)];
//    [self addSubview:self.label];
//    [self.label setAttributedText:[self stringForItem:feedItem]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, frame.size.width-(left + 20), 20)];
    [_nameLabel setText:[NSString stringWithFormat:@"%@ %@",feedItem.userFirstName,feedItem.userLastName]];
    [_nameLabel setFont:PopdeemFont(@"popdeem.fonts.boldFont", 14)];
    [_nameLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryFontColor")];
    [_nameLabel setNumberOfLines:1];
    [_nameLabel sizeToFit];
    
    self.captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, _nameLabel.frame.size.height+5, frame.size.width-(left + 20), 20)];
    [_captionLabel setText:feedItem.captionString];
    [_captionLabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 12)];
    [_captionLabel setTextColor:PopdeemColor(@"popdeem.colors.secondaryFontColor")];
    [_captionLabel setNumberOfLines:1];
//    [_captionLabel sizeToFit];
    
    float floatingHeight = cellHeight;
    float joinedHeight = _nameLabel.frame.size.height + 5 + _captionLabel.frame.size.height;
    float padding = (floatingHeight-joinedHeight)/2;
    [self.nameLabel setFrame:CGRectMake(left, padding, _nameLabel.frame.size.width, _nameLabel.frame.size.height)];
    [self.captionLabel setFrame:CGRectMake(left, padding+5+_nameLabel.frame.size.height, _captionLabel.frame.size.width, _captionLabel.frame.size.height)];
    [self addSubview:_nameLabel];
    [self addSubview:_captionLabel];
    //Apply Theme
    [self setBackgroundColor:[UIColor clearColor]];
    if (PopdeemThemeHasValueForKey(@"popdeem.colors.tableViewCellBackgroundColor")) {
      [self setBackgroundColor:PopdeemColor(@"popdeem.colors.tableViewCellBackgroundColor")];
    }
    return self;
  }
  return nil;
}

- (NSAttributedString*) stringForItem:(PDFeedItem*)feedItem {
  NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
  
  NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@ ",feedItem.userFirstName,feedItem.userLastName]
                                                                   attributes:@{ NSForegroundColorAttributeName : PopdeemColor(@"popdeem.colors.primaryAppColor"), NSFontAttributeName : PopdeemFont(@"popdeem.fonts.boldFont", 14)}];
  [string appendAttributedString:nameString];
  
  NSAttributedString *actionString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",feedItem.actionText]
                                                                     attributes:@{NSFontAttributeName : PopdeemFont(@"popdeem.fonts.primaryFont", 14), NSForegroundColorAttributeName :PopdeemColor(@"popdeem.colors.secondaryFontColor")}];
  [string appendAttributedString:actionString];
  
  NSString *rewardDesc = @"";
  int cutoff = (IS_IPHONE_6_OR_GREATER) ? 30 : 20;
  if (feedItem.descriptionString.length > cutoff) {
    rewardDesc = [NSString stringWithFormat:@"%@...",[feedItem.descriptionString substringWithRange:NSMakeRange(0, 15)]];
  } else {
    rewardDesc = feedItem.descriptionString;
  }
  NSAttributedString *rewardString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", rewardDesc]
                                                                     attributes:@{NSForegroundColorAttributeName : PopdeemColor(@"popdeem.colors.primaryFontColor"), NSFontAttributeName : PopdeemFont(@"popdeem.fonts.primaryFont", 14)}];
  [string appendAttributedString:rewardString];
  
  [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"at " attributes:@{NSForegroundColorAttributeName : PopdeemColor(@"popdeem.colors.primaryFontColor"), NSFontAttributeName: PopdeemFont(@"popdeem.fonts.primaryFont", 14)}]];
  
  NSAttributedString *locationString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",feedItem.brandName] attributes:@{NSFontAttributeName : PopdeemFont(@"popdeem.fonts.primaryFont", 14) , NSForegroundColorAttributeName : PopdeemColor(@"popdeem.colors.primaryFontColor")}];
  [string appendAttributedString:locationString];
  
  NSAttributedString *timeString = [[NSAttributedString alloc] initWithString:[self timeStringForItem:feedItem] attributes:@{NSForegroundColorAttributeName : PopdeemColor(@"popdeem.colors.primaryAppColor") , NSFontAttributeName : PopdeemFont(@"popdeem.fonts.primaryFont", 14)}];
  [string appendAttributedString:timeString];
  return string;
}

- (NSString*) timeStringForItem:(PDFeedItem*)item {
  
  NSString *timeAgoString = [item timeAgoString];
  
  NSString *time = @"m";
  if ([timeAgoString rangeOfString:@"minute"].location != NSNotFound) {
    time = @"m";
  } else if ([timeAgoString rangeOfString:@"hour"].location != NSNotFound) {
    time = @"h";
  } else if ([timeAgoString rangeOfString:@"day"].location != NSNotFound) {
    time = @"d";
  } else if ([timeAgoString rangeOfString:@"week"].location != NSNotFound) {
    time = @"w";
  } else if ([timeAgoString rangeOfString:@"month"].location != NSNotFound) {
    time = @"M";
  }
  
  NSScanner *scanner = [NSScanner scannerWithString:timeAgoString];
  NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
  NSString *numberString;
  [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
  [scanner scanCharactersFromSet:numbers intoString:&numberString];
  int number = [numberString intValue];
  
  return [NSString stringWithFormat:@"%d%@ ago",number,time];
}

- (UIEdgeInsets)layoutMargins {
  return UIEdgeInsetsZero;
}

@end
