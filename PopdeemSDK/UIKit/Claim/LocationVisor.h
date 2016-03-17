//
//  LocationVisor.h
//  PopdeemSDK
//
//  Created by Niall Quinn on 17/03/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationVisor : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIView *parent;

- (instancetype) initForView:(UIView*)view verified:(BOOL)verified;
- (void) showAnimated:(BOOL)animated;
- (void) hideAnimated:(BOOL)animated;
@end
