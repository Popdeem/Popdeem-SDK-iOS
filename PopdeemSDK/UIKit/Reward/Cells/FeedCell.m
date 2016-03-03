//
//  FeedCell.m
//  Popdeem
//
//  Created by Niall Quinn on 06/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "FeedCell.h"
#import "PDFeedItem.h"
#import "PDTheme.h"
#import "PDUIKitUtils.h"
@implementation FeedCell

- (id) initWithFrame:(CGRect)frame forFeedItem:(PDFeedItem*)feedItem {
  if (self = [super initWithFrame:frame]) {
    float cellHeight = 75;
    float indent = 20.0f;
    self.separatorInset = UIEdgeInsetsZero;
    float logoSize = cellHeight-40;
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(indent, 20, logoSize, logoSize)];
    [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.profileImageView.layer.cornerRadius = logoSize/2;
    self.profileImageView.clipsToBounds = YES;
    [self addSubview:self.profileImageView];
    
    [self.profileImageView setImage:feedItem.profileImage];
    
    float left = indent+logoSize+10;
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(left, 10, frame.size.width-(left + 20), cellHeight-20)];
    [self.label setNumberOfLines:2];
    [self.label setFont:[UIFont systemFontOfSize:16]];
    [self addSubview:self.label];
    [self.label setAttributedText:[self stringForItem:feedItem]];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //Apply Theme
    [self setBackgroundColor:PopdeemColor(@"popdeem.home.tableView.feedCell.backgroundColor")];
    return self;
  }
  return nil;
}

- (NSAttributedString*) stringForItem:(PDFeedItem*)feedItem {
  NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
  
  NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@ ",feedItem.userFirstName,feedItem.userLastName]
                                                                   attributes:@{ NSForegroundColorAttributeName : PopdeemColor(@"popdeem.home.tableView.feedCell.nameTextColor"), NSFontAttributeName : PopdeemFont(@"popdeem.home.tableView.feedCell.fontName", 14)}];
  [string appendAttributedString:nameString];
  
  NSAttributedString *actionString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",feedItem.actionText]
                                                                     attributes:@{NSFontAttributeName : PopdeemFont(@"popdeem.home.tableView.feedCell.fontName", 14), NSForegroundColorAttributeName :PopdeemColor(@"popdeem.home.tableView.feedCell.defaultTextColor")}];
  [string appendAttributedString:actionString];
  
  NSString *rewardDesc = @"";
  int cutoff = (IS_IPHONE_6_OR_GREATER) ? 30 : 20;
  if (feedItem.descriptionString.length > cutoff) {
    rewardDesc = [NSString stringWithFormat:@"%@...",[feedItem.descriptionString substringWithRange:NSMakeRange(0, 15)]];
  } else {
    rewardDesc = feedItem.descriptionString;
  }
  NSAttributedString *rewardString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", rewardDesc]
                                                                     attributes:@{NSForegroundColorAttributeName : PopdeemColor(@"popdeem.home.tableView.feedCell.titleTextColor"), NSFontAttributeName : PopdeemFont(@"popdeem.home.tableView.feedCell.fontName", 14)}];
  [string appendAttributedString:rewardString];
  
  [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"at " attributes:@{NSForegroundColorAttributeName : PopdeemColor(@"popdeem.home.tableView.feedCell.defaultTextColor"), NSFontAttributeName: PopdeemFont(@"popdeem.home.tableView.feedCell.fontName", 14)}]];
  
  NSAttributedString *locationString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",feedItem.brandName] attributes:@{NSFontAttributeName : PopdeemFont(@"popdeem.home.tableView.feedCell.fontName", 14) , NSForegroundColorAttributeName : PopdeemColor(@"popdeem.home.tableView.feedCell.defaultTextColor")}];
  [string appendAttributedString:locationString];
  
  NSAttributedString *timeString = [[NSAttributedString alloc] initWithString:[self timeStringForItem:feedItem] attributes:@{NSForegroundColorAttributeName : PopdeemColor(@"popdeem.home.tableView.feedCell.timeTextColor") , NSFontAttributeName : PopdeemFont(@"popdeem.home.tableView.feedCell.fontName", 14)}];
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
