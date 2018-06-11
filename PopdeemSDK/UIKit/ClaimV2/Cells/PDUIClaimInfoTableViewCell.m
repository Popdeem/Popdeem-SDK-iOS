//
//  PDUIClaimInfoTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 14/05/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDUIClaimInfoTableViewCell.h"
#import "PDUtils.h"
#import "PDTheme.h"

@implementation PDUIClaimInfoTableViewCell

- (id) initWithFrame:(CGRect)frame text:(NSString*)text {
  if (self = [super initWithFrame:frame]) {
    [self setupWithText:text];
    return self;
  }
  return nil;
}

- (void)awakeFromNib {
  [super awakeFromNib];
  [self.infoLabel setFont:PopdeemFont(PDThemeFontPrimary, 12)];
  [self.infoLabel setNumberOfLines:2];
  self.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGFLOAT_MAX);
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  NSLog(@"Set Frame: %.2f", self.frame.size.height);
  CALayer *topBorder = [CALayer layer];
  topBorder.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 1.0f);
  topBorder.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00].CGColor;
  [self.layer addSublayer:topBorder];
}

- (void) setupWithText:(NSString*)text {
  float centerY = self.frame.size.height /2;
  float padding = 20.0f;
  [self.infoLabel setFrame:CGRectMake(padding, 0, self.frame.size.width - (2*padding), 20)];
  [self.infoLabel setText:text];
  [self.infoLabel setFont:PopdeemFont(PDThemeFontPrimary, 12)];
  [self.infoLabel setNumberOfLines:2];
  [self.infoLabel sizeToFit];
  float topPadding = (self.frame.size.height-self.infoLabel.frame.size.height) /2;
  [self.infoLabel setFrame:CGRectMake(padding, topPadding, self.infoLabel.frame.size.width, self.infoLabel.frame.size.height)];
  
  self.separatorInset = UIEdgeInsetsMake(0, 0, 0, CGFLOAT_MAX);
  self.selectionStyle = UITableViewCellSelectionStyleNone;
  NSLog(@"Set Frame: %.2f", self.frame.size.height);
  CALayer *topBorder = [CALayer layer];
  topBorder.frame = CGRectMake(0.0f, 0.0f, self.frame.size.width, 1.0f);
  topBorder.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.00].CGColor;
  [self.layer addSublayer:topBorder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];
  
  // Configure the view for the selected state
}

@end
