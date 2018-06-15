//
//  PDUIGratitudeProgressView.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 12/02/2018.
//  Copyright © 2018 Popdeem. All rights reserved.
//

#import "PDUIGratitudeProgressView.h"
#import "PDTheme.h"
#import "PDConstants.h"
#import "PDUtils.h"
#import "PDCustomer.h"
#import "PDUserApiService.h"

@interface PDUIGratitudeProgressView()

@end

@implementation PDUIGratitudeProgressView


- (id) initWithInitialValue:(float)value frame:(CGRect)frame increment:(BOOL)increment {
  if (self = [super init]) {
    _initialValue = value;
    _increment = increment;
    self.frame = frame;
    
    float barHeight = 25;
    float padding = 20;
    _barWidth = frame.size.width-(2*padding);
    float barY = frame.size.height - barHeight;
    _progressBackingView = [[UIView alloc] initWithFrame:CGRectMake(padding, barY, _barWidth, barHeight)];
    _progressBackingView.layer.cornerRadius = 8.0;
    _progressBackingView.clipsToBounds = YES;
    _progressBackingView.layer.borderColor = [UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1.00].CGColor;
    _progressBackingView.layer.borderWidth = 1.0;
    _progressBackingView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00];
    
    _progressCurrentView = [[UIView alloc] initWithFrame:CGRectMake(padding, barY, _barWidth*(value/100), barHeight)];
     _progressCurrentView.layer.cornerRadius = 8.0;
    _progressCurrentView.clipsToBounds = YES;
    _progressCurrentView.backgroundColor = PopdeemColor(PDThemeColorPrimaryApp);
    
    float labelWidth = frame.size.width / 0.16;
    float labelHeight = frame.size.height - barHeight;
    float level1labelx = padding + (_barWidth*0.30) - (labelWidth/2);
    float level2labelx = padding + (_barWidth*0.60) - (labelWidth/2);
    float level3labelx = padding + (_barWidth*0.90) - (labelWidth/2);
  
    _level1Label = [[UILabel alloc] initWithFrame:CGRectMake(level1labelx, barY-labelHeight, labelWidth, labelHeight)];
    _level1Transparency = [[UIView alloc] initWithFrame:_level1Label.frame];
    [_level1Transparency setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.3]];
    
    _level2Label = [[UILabel alloc] initWithFrame:CGRectMake(level2labelx, barY-labelHeight, labelWidth, labelHeight)];
    _level2Transparency = [[UIView alloc] initWithFrame:_level2Label.frame];
    [_level2Transparency setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.3]];
    
    _level3Label = [[UILabel alloc] initWithFrame:CGRectMake(level3labelx, barY-labelHeight, labelWidth, labelHeight)];
    _level3Transparency = [[UIView alloc] initWithFrame:_level3Label.frame];
    [_level3Transparency setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.3]];
    
    [_level1Label setFont:PopdeemFont(PDThemeFontPrimary, 10)];
    [_level2Label setFont:PopdeemFont(PDThemeFontPrimary, 10)];
    [_level3Label setFont:PopdeemFont(PDThemeFontPrimary, 10)];
    
    [_level1Label setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
    [_level2Label setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
    [_level3Label setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
    
    [_level1Label setText:translationForKey(@"popdeem.gratitude.level1Name", @"🥉\nBronze\nAmbassador")];
    [_level1Label setTextAlignment:NSTextAlignmentCenter];
    [_level1Label setNumberOfLines:3];
    
    [_level2Label setText:translationForKey(@"popdeem.gratitude.level2Name", @"🥈\nSilver\nAmbassador")];
    [_level2Label setTextAlignment:NSTextAlignmentCenter];
    [_level2Label setNumberOfLines:3];
    
    [_level3Label setText:translationForKey(@"popdeem.gratitude.level3Name", @"🥇\nGold\nAmbassador")];
    [_level3Label setTextAlignment:NSTextAlignmentCenter];
    [_level3Label setNumberOfLines:3];
    return self;
  }
  return nil;
}

- (void) updateUser {
  PDUserAPIService *service = [[PDUserAPIService alloc] init];
  [service getUserDetailsForId:[NSString stringWithFormat:@"%ld",(long)[[PDUser sharedInstance] identifier]]  authenticationToken:[[PDUser sharedInstance] userToken] completion:^(PDUser *user, NSError *error) {
    [[NSNotificationCenter defaultCenter] postNotificationName:PDUserDidUpdate object:nil];
  }];
}

- (void) didMoveToSuperview {
  [self addSubview:_progressBackingView];
  [self addSubview:_progressCurrentView];
  [self addSubview:_level1Label];
  [self addSubview:_level2Label];
  [self addSubview:_level3Label];
  
  if (_initialValue < 30) {
    [_level1Label.layer setOpacity:0.3];
    [_level2Label.layer setOpacity:0.3];
    [_level3Label.layer setOpacity:0.3];
  }
  if (_initialValue >= 30 && _initialValue <= 60) {
    [_level1Label.layer setOpacity:1.0];
    [_level2Label.layer setOpacity:0.3];
    [_level3Label.layer setOpacity:0.3];
  }

  if (_initialValue >= 60 && _initialValue <= 90) {
    [_level1Label.layer setOpacity:1.0];
    [_level2Label.layer setOpacity:1.0];
    [_level3Label.layer setOpacity:0.3];
  }
  
  if (_initialValue >= 90) {
    [_level1Label.layer setOpacity:1.0];
    [_level2Label.layer setOpacity:1.0];
    [_level3Label.layer setOpacity:1.0];
  }
  if (_increment) {
    PDCustomer *customer = [PDCustomer sharedInstance];
    int initialInt = (int)_initialValue;
    [self performSelector:@selector(animateToValue:) withObject:[NSNumber numberWithInteger:initialInt + [customer.incrementAdvocacyPoints integerValue]] afterDelay:1.0];
  }

  [self updateUser];
}

- (void) animateToValue:(NSNumber*)value {
  __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:1.0f delay:0.0 options:UIViewAnimationOptionTransitionNone
                   animations:^{
                     float newperc = value.floatValue/100;
                     
                     weakSelf.progressCurrentView.frame = CGRectMake(weakSelf.progressCurrentView.frame.origin.x, weakSelf.progressCurrentView.frame.origin.y, weakSelf.barWidth*newperc, weakSelf.progressCurrentView.frame.size.height);
                     
                   }
                   completion:^(BOOL finished) {
                     if (value.integerValue <= 30) {
                       [weakSelf.level1Label.layer setOpacity:0.3];
                       [weakSelf.level2Label.layer setOpacity:0.3];
                       [weakSelf.level3Label.layer setOpacity:0.3];
                     }
                     if (value.integerValue >= 30 && value.integerValue < 60) {
                       [weakSelf.level1Label.layer setOpacity:1.0];
                       [weakSelf.level2Label.layer setOpacity:0.3];
                       [weakSelf.level3Label.layer setOpacity:0.3];
                     }

                     if (value.integerValue >= 60 && value.integerValue < 90) {
                       [weakSelf.level1Label.layer setOpacity:1.0];
                       [weakSelf.level2Label.layer setOpacity:1.0];
                       [weakSelf.level3Label.layer setOpacity:0.3];
                     }
                     if (value.integerValue >= 90) {
                       [weakSelf.level1Label.layer setOpacity:1.0];
                       [weakSelf.level2Label.layer setOpacity:1.0];
                       [weakSelf.level3Label.layer setOpacity:1.0];
                     }
                   }
   ];
}


@end
