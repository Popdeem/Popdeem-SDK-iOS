//
//  ProfileTableViewCell.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 24/01/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "ProfileTableViewCell.h"
#import "PDUser.h"
#import "PDTheme.h"
#import "PDUtils.h"
#import "PDUIGratitudeProgressView.h"

@implementation ProfileTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
  [self setProfile];
  [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setProfile {
  if ([[PDUser sharedInstance] firstName] && [[PDUser sharedInstance] lastName]) {
    NSString *userName = [NSString stringWithFormat:@"%@ %@",[[PDUser sharedInstance] firstName],[[PDUser sharedInstance] lastName]];
    
    [_label setFont:PopdeemFont(PDThemeFontPrimary, 14)];
    [_label setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
    [_label setTextAlignment:NSTextAlignmentLeft];
    
    [_label setText:userName];
  }
  self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2;
  self.profileImageView.layer.masksToBounds = YES;
  
  if (!_progressView) {
   _progressView = [[PDUIGratitudeProgressView alloc] initWithInitialValue:[[PDUser sharedInstance] advocacyScore] frame:CGRectMake(0, self.frame.size.height - 75, [[UIScreen mainScreen] bounds].size.width, 75) increment:NO];
    [self addSubview:_progressView];
  } else {
    _progressView = [[PDUIGratitudeProgressView alloc] initWithInitialValue:[[PDUser sharedInstance] advocacyScore] frame:CGRectMake(0, self.frame.size.height - 75, [[UIScreen mainScreen] bounds].size.width, 75)  increment:NO];
  }

  [self getPicture];
}

- (void) getPicture {
  NSString *pictureUrl = [[[PDUser sharedInstance] facebookParams] profilePictureUrl];
  if (pictureUrl == nil || pictureUrl.length == 0) {
    pictureUrl = [[[PDUser sharedInstance] instagramParams] profilePictureUrl];
  }
  if (pictureUrl == nil || pictureUrl.length == 0) {
    pictureUrl = [[[PDUser sharedInstance] twitterParams] profilePictureUrl];
  }
  if ([pictureUrl characterAtIndex:0] == "\\" && [pictureUrl characterAtIndex:1] == "\\") {
    NSString *a = @"https:";
    pictureUrl = [a stringByAppendingString:pictureUrl];
  }
  if (pictureUrl != nil && pictureUrl.length > 0) {
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:pictureUrl] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
      if (data) {
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
          dispatch_async(dispatch_get_main_queue(), ^{
            UIImage *profileImage = [UIImage imageWithData:data];
            [_profileImageView setImage:profileImage];
            [_profileImageView setHidden:NO];
            [self setNeedsDisplay];
          });
        }
      }
    }];
    [task resume];
  }
}
@end
