//
//  PDModalLoadingView.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 24/11/2015.
//  Copyright © 2015 Popdeem. All rights reserved.
//

#import "PDUIModalLoadingView.h"
#import "PDUtils.h"

@implementation PDUIModalLoadingView

- (PDUIModalLoadingView*) initWithDefaultsForView:(UIView*)parent {
    return [self initForView:parent titleText:translationForKey(@"popdeem.common.loading", @"Loading") descriptionText:translationForKey(@"popdeem.common.wait", @"Please wait...")];
}

- (PDUIModalLoadingView*) initForView:(UIView*)parent
                     titleText:(NSString*)titleText
               descriptionText:(NSString*)descriptionText {
    if (self = [super init]) {
        self.parent = parent;
        
        // self.view is a backing view which has 0.5 opacity and will fill the parent
        self.frame = CGRectMake(0,0,parent.frame.size.width,parent.frame.size.height);
        [self setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
        
        float indent = 15;
        float width = parent.frame.size.width - 30;
        float y = (parent.frame.size.height/2) - 55;
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(indent, y, width, 110)];

        _contentView.layer.cornerRadius = 5.0;
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        
        CGRect spinnerRect = CGRectMake((_contentView.frame.size.width/2)-20, 15, 40, 40);
        _spinner = [[UIActivityIndicatorView alloc] initWithFrame:spinnerRect];
        [_spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
        
        CGRect titleRect = CGRectMake(0, 55, _contentView.frame.size.width, 20);
        _titleLabel = [[UILabel alloc] initWithFrame:titleRect];
        [self.titleLabel setText:titleText];
        [_titleLabel setNumberOfLines:2];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [_titleLabel setTextColor:[UIColor colorWithRed:0.166 green:0.166 blue:0.166 alpha:1.000]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        CGRect descriptionRect = CGRectMake(0, 75, _contentView.frame.size.width, 20);
        _descriptionLabel = [[UILabel alloc] initWithFrame:descriptionRect];
        [self.descriptionLabel setText:descriptionText];
        [_descriptionLabel setNumberOfLines:1];
        [_descriptionLabel setFont:[UIFont systemFontOfSize:12]];
        [_descriptionLabel setTextColor:[UIColor colorWithRed:0.274 green:0.274 blue:0.274 alpha:1.000]];
        [_descriptionLabel setTextAlignment:NSTextAlignmentCenter];
        
    }
    return self;
}

- (void) didMoveToSuperview {
    [self.contentView addSubview:_titleLabel];
    [self.contentView addSubview:_descriptionLabel];
    [self.contentView addSubview:_spinner];
    [self addSubview:_contentView];
}

- (void) showAnimated:(BOOL)animated {
    if (animated) {
        CATransition *loaderIn =[CATransition animation];
        [loaderIn setDuration:0.5];
        [loaderIn setType:kCATransitionReveal];
        [loaderIn setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [[self layer] addAnimation:loaderIn forKey:kCATransitionReveal];
    }
    [self setHidden:NO];
    [_spinner startAnimating];
    [_parent addSubview:self];
    [_parent bringSubviewToFront:self];
}

- (void) hideAnimated:(BOOL)animated {
    if (animated) {
        [self.layer removeAllAnimations];
        CATransition *loaderOut =[CATransition animation];
        [loaderOut setDuration:0.5];
        [loaderOut setType:kCATransitionReveal];
        [loaderOut setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
        [[self layer] addAnimation:loaderOut forKey:kCATransitionReveal];
    }
    [_spinner stopAnimating];
    [self removeFromSuperview];
}

@end
