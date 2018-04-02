//
//  SZTextView.h
//  SZTextView
//
//  Created by glaszig on 14.03.13.
//  Copyright (c) 2013 glaszig. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for SZTextView.
FOUNDATION_EXPORT double PD_SZTextViewVersionNumber;

//! Project version string for SZTextView.
FOUNDATION_EXPORT const unsigned char PD_SZTextViewVersionString[];



@interface PD_SZTextView : UITextView

@property (copy, nonatomic) NSString *placeholder;
@property (nonatomic) double fadeTime;
@property (copy, nonatomic) NSAttributedString *attributedPlaceholder;
@property (retain, nonatomic) UIColor *placeholderTextColor;

@end
