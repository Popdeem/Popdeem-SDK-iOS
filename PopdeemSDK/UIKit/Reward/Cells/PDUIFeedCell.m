//
//  FeedCell.m
//  Popdeem
//
//  Created by Niall Quinn on 06/07/2015.
//  Copyright (c) 2015 Niall Quinn. All rights reserved.
//

#import "PDUIFeedCell.h"
#import "PDRFeedItem.h"
#import "PDTheme.h"
#import "PDUIKitUtils.h"
#import "PDConstants.h"
@implementation PDUIFeedCell

- (id) initWithFrame:(CGRect)frame forFeedItem:(PDRFeedItem*)feedItem {
  if (self = [super initWithFrame:frame]) {
    self.frame = frame;
    float cellHeight = 65;
    float indent = 20.0f;
    self.separatorInset = UIEdgeInsetsZero;
    float logoSize = cellHeight-30;
    self.profileImageView = [[UIImageView alloc] initWithFrame:CGRectMake(indent, 15, logoSize, logoSize)];
    [self.profileImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.profileImageView.layer.cornerRadius = logoSize/2;
    self.profileImageView.clipsToBounds = YES;
    [self addSubview:self.profileImageView];
		
		if (feedItem.profileImageData) {
			[self.profileImageView setImage:[UIImage imageWithData:feedItem.profileImageData]];
		}else {
			[self.profileImageView setImage:[UIImage imageNamed:@"pduikit_default_user"]];
		}
		
    float left = indent+logoSize+20;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, frame.size.width-(left + 20), 20)];
    NSString *userName;
    if (![feedItem.userFirstName isKindOfClass:[NSNull class]] && ![feedItem.userLastName isKindOfClass:[NSNull class]]) {
      userName = [NSString stringWithFormat:@"%@ %@",feedItem.userFirstName,feedItem.userLastName];
    } else if (![feedItem.userFirstName isKindOfClass:[NSNull class]]) {
      userName = [NSString stringWithFormat:@"%@",feedItem.userFirstName];
    }
  
    [_nameLabel setText:userName];
    [_nameLabel setFont:PopdeemFont(PDThemeFontBold, 14)];
    [_nameLabel setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
    [_nameLabel setNumberOfLines:1];
    [_nameLabel sizeToFit];
    
    [self.nameLabel setFrame:CGRectMake(left, 0, _nameLabel.frame.size.width, 65)];
    [self addSubview:_nameLabel];
  
    //Apply Theme
    [self setBackgroundColor:[UIColor clearColor]];
    if (PopdeemThemeHasValueForKey(PDThemeColorTableViewCellBackground)) {
      [self setBackgroundColor:PopdeemColor(PDThemeColorTableViewCellBackground)];
    }
    
    float imageSize = self.frame.size.width;
    self.actionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 65, imageSize, imageSize)];
    self.actionImageView.clipsToBounds = YES;
    [self.actionImageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.actionImageView setImage:[UIImage imageWithData:feedItem.actionImageData]];
    [self addSubview:self.actionImageView];
    
    NSMutableAttributedString *labelString = [[NSMutableAttributedString alloc] init];
    
    NSMutableAttributedString *userNameString = [[NSMutableAttributedString alloc]
                                                 initWithString:[NSString stringWithFormat:@"%@  ",userName]
                                                 attributes:@{
                                                              NSFontAttributeName : PopdeemFont(PDThemeFontBold, 12),
                                                              NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont)
                                                              }];
    [labelString appendAttributedString:userNameString];
    NSMutableAttributedString *captionString = [[NSMutableAttributedString alloc]
                                                 initWithString:[NSString stringWithFormat:@"%@",feedItem.captionString]
                                                 attributes:@{
                                                              NSFontAttributeName : PopdeemFont(PDThemeFontLight, 12),
                                                              NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont)
                                                              }];
    [labelString appendAttributedString:captionString];
    
    float top = 65 + imageSize;
    UILabel *captionLabel = [[UILabel alloc] initWithFrame:CGRectMake(indent, top + 10, imageSize - 2 * indent, 80)];
    [captionLabel setAttributedText:labelString];
    [captionLabel setNumberOfLines:0];
    [captionLabel sizeToFit];
    [self addSubview:captionLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(indent, top + 10 + captionLabel.frame.size.height, imageSize - 2*indent, 20)];
    [timeLabel setText:feedItem.timeAgoString];
    [timeLabel setFont:PopdeemFont(PDThemeFontLight, 12)];
    [timeLabel setTextColor:PopdeemColor(PDThemeColorSecondaryFont)];
    [self addSubview:timeLabel];
    
    return self;
  }
  
  return nil;
}

- (NSAttributedString*) stringForItem:(PDRFeedItem*)feedItem {
  NSMutableAttributedString *string = [[NSMutableAttributedString alloc] init];
  
  NSAttributedString *nameString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@",feedItem.userFirstName,feedItem.userLastName]
                                                                   attributes:@{
                                                                           NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryApp),
                                                                           NSFontAttributeName : PopdeemFont(PDThemeFontBold, 14)
                                                                   }];
  [string appendAttributedString:nameString];
  
  NSAttributedString *actionString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",feedItem.actionText]
                                                                     attributes:@{
                                                                             NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 14),
                                                                             NSForegroundColorAttributeName :PopdeemColor(PDThemeColorSecondaryFont)
                                                                     }];
  [string appendAttributedString:actionString];
  
  NSString *rewardDesc = @"";
  int cutoff = (IS_IPHONE_6_OR_GREATER) ? 30 : 20;
  if (feedItem.descriptionString.length > cutoff) {
    rewardDesc = [NSString stringWithFormat:@"%@...",[feedItem.descriptionString substringWithRange:NSMakeRange(0, 15)]];
  } else {
    rewardDesc = feedItem.descriptionString;
  }
  NSAttributedString *rewardString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ", rewardDesc]
                                                                     attributes:@{
                                                                             NSForegroundColorAttributeName :
                                                                             PopdeemColor(PDThemeColorPrimaryFont),
                                                                             NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 14)
                                                                     }];
  [string appendAttributedString:rewardString];
  
  [string appendAttributedString:[[NSAttributedString alloc] initWithString:@"at "
                                                                 attributes:@{
                                                                         NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont),
                                                                         NSFontAttributeName: PopdeemFont(PDThemeFontPrimary, 14)
                                                                 }]];
  
  NSAttributedString *locationString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",feedItem.brandName]
                                                                       attributes:@{
                                                                               NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 14) ,
                                                                               NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryFont)
                                                                       }];
  [string appendAttributedString:locationString];
  
  NSAttributedString *timeString = [[NSAttributedString alloc] initWithString:[self timeStringForItem:feedItem]
                                                                   attributes:@{
                                                                           NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryApp) ,
                                                                           NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 14)
                                                                   }];
  [string appendAttributedString:timeString];
  return string;
}

- (NSString*) timeStringForItem:(PDRFeedItem*)item {
  
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
