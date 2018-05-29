//
//  PDUIProfileButtonTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 24/01/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDUIProfileButtonTableViewCell.h"
#import "PDUtils.h"
#import "PDTheme.h"
#import "PDMessageStore.h"

@implementation PDUIProfileButtonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  [self.label setFont:PopdeemFont(PDThemeFontPrimary, 16)];
  [self setSelectionStyle:UITableViewCellSelectionStyleNone];
  self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  self.accessoryView = [[UIImageView alloc] initWithImage:PopdeemImage(@"pduikit_arrow_g")];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) showBadge:(BOOL)show {
  [self.badge setHidden:!show];
  if (show == YES) {
    if (_badge) {
      [_badge autoBadgeSizeWithString:[NSString stringWithFormat:@"%ld",(unsigned long)[PDMessageStore unreadCount]]];
    }
  }
}

- (void) didMoveToSuperview {
  if (_shouldShowBadge) {
    float y = self.frame.size.height/2 - 12.5;
    float x = self.frame.size.width;
    if ([PDMessageStore unreadCount] > 0) {
      if (!_badge) {
        _badge = [PDUICustomBadge customBadgeWithString:[NSString stringWithFormat:@"%ld",(unsigned long)[PDMessageStore unreadCount]]
                                        withStringColor:[UIColor whiteColor]
                                         withInsetColor:[UIColor colorWithRed:0.98 green:0.05 blue:0.11 alpha:1.00]
                                         withBadgeFrame:YES
                                    withBadgeFrameColor:[UIColor whiteColor]
                                              withScale:1.0];
        [_badge setFrame:CGRectMake(x, y, _badge.frame.size.width, _badge.frame.size.height)];
        [self addSubview:_badge];
      } else {
        [_badge autoBadgeSizeWithString:[NSString stringWithFormat:@"%ld",(unsigned long)[PDMessageStore unreadCount]]];
        [_badge setFrame:CGRectMake(x, y, _badge.frame.size.width, _badge.frame.size.height)];
      }
    } else {
      if (_badge) {
        [_badge setHidden:YES];
      }
    }
  }
}

@end
