//
//  PDUITwitterLoginViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 05/08/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUITwitterLoginViewController.h"
#import "PDSocialMediaManager.h"
#import "PDConstants.h"
#import "PopdeemSDK.h"

@interface PDUITwitterLoginViewController ()

@end

@implementation PDUITwitterLoginViewController

- (instancetype) initForParent:(UIViewController*)parent {
	connected = NO;
	if (self = [super init]) {
		_parent = parent;
		self.viewModel = [[PDUITwitterLoginViewModel alloc] initForParent:self];
		return self;
	}
	return nil;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[_viewModel setup];
	[self.view setBackgroundColor:[UIColor clearColor]];
	self.backingView = [[UIView alloc] initWithFrame:_parent.view.frame];
	[self.backingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
	[self.view addSubview:_backingView];
	UITapGestureRecognizer *backingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
	[_backingView addGestureRecognizer:backingTap];
	
	_cardView = [[UIView alloc] initWithFrame:CGRectZero];
	[self.view addSubview:_cardView];
	_label = [[UILabel alloc] initWithFrame:CGRectZero];
	[_cardView addSubview:_label];
	_imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
	[_cardView addSubview:_imageView];
	_actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
	[_cardView addSubview:_actionButton];
	[self renderView];
	
}

- (void) renderView {
	
	CGFloat currentY = 0;
	
	CGFloat cardWidth = _parent.view.frame.size.width * 0.8;
	CGFloat cardHeight = _parent.view.frame.size.height * 0.80;
	CGFloat cardX = _parent.view.frame.size.width * 0.1;
	CGRect cardRect = CGRectMake(cardX, _parent.view.frame.size.height, cardWidth, cardHeight);
	
	_cardView.frame = cardRect;
	[_cardView setBackgroundColor:[UIColor whiteColor]];
	_cardView.layer.cornerRadius = 5.0;
	_cardView.layer.masksToBounds = YES;
	
	CGFloat cardCenterX = cardWidth/2;
	CGFloat imageWidth = cardWidth * 0.35;
	
	CGFloat labelPadding = cardWidth*0.10;
	currentY += 20;
	self.label = [[UILabel alloc] initWithFrame:CGRectMake(labelPadding, currentY, cardWidth-(2*labelPadding), 60)];
	[self.label setNumberOfLines:0];
	[self.label setFont:_viewModel.labelFont];
	[self.label setTextColor:_viewModel.labelColor];
	[self.label setText:_viewModel.labelText];
	[self.label setTextAlignment:NSTextAlignmentCenter];
	[self.label sizeToFit];
	CGSize labelSize = [_label sizeThatFits:_label.bounds.size];
	[self.label setFrame:CGRectMake(_label.frame.origin.x, currentY , _label.frame.size.width, labelSize.height)];
	[_cardView addSubview:_label];
	
	currentY += 40 + labelSize.height;
	
	self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(cardCenterX-(imageWidth/2), currentY, imageWidth, imageWidth)];
	[self.imageView setImage:_viewModel.logoImage];
	_imageView.layer.cornerRadius = 2.0;
	_imageView.layer.masksToBounds = YES;
	[_cardView addSubview:_imageView];
	self.imageView.contentMode = UIViewContentModeScaleAspectFit;
	currentY += imageWidth + 40;
	
	CGRect buttonFrame = CGRectMake(10, currentY, cardWidth-20, 40);
	
	self.actionButton = [[UIButton alloc] initWithFrame:buttonFrame];
	[_actionButton setBackgroundColor:_viewModel.buttonColor];
	[_actionButton.titleLabel setFont:_viewModel.buttonLabelFont];
	[_actionButton setTitle:_viewModel.buttonText forState:UIControlStateNormal];
	[_actionButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
	[_actionButton setTag:0];
	[_actionButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[_cardView addSubview:_actionButton];
	currentY += 40;
	
	CGFloat totalCardHeight = currentY + 20;
	_cardX = cardX;
	_cardY = (_parent.view.frame.size.height - totalCardHeight)/2;
	[_cardView setFrame:CGRectMake(_cardX, _cardY, cardWidth, totalCardHeight)];
	
	[self.view setNeedsDisplay];
}

- (void) pullModel {
	[_actionButton.layer setBorderColor:_viewModel.buttonBorderColor.CGColor];
	_actionButton.layer.borderWidth = 1.0;
	[_actionButton setBackgroundColor:_viewModel.buttonColor];
	[_actionButton.titleLabel setFont:_viewModel.buttonLabelFont];
	[_actionButton setTitle:_viewModel.buttonText forState:UIControlStateNormal];
	[_actionButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
	[_actionButton.titleLabel setTextColor:_viewModel.buttonTextColor];
	[_actionButton setTitleColor:_viewModel.buttonTextColor forState:UIControlStateNormal];
	
	[self.imageView setImage:_viewModel.logoImage];
	[self.label setFont:_viewModel.labelFont];
	[self.label setTextColor:_viewModel.labelColor];
	[self.label setText:_viewModel.labelText];
}

- (void) buttonPressed:(UIButton*)button {
	PDSocialMediaManager *manager = [[PDSocialMediaManager alloc] initForViewController:self];
	[_viewModel setIsLoading:YES];
	[self pullModel];
	[self.view setUserInteractionEnabled:NO];
	[manager loginWithTwitter:^(void){
		//Twitter Connected Successfully
		PDLog(@"Twitter Logged in");
		connected = YES;
		[self dismiss];
	} failure:^(NSError *error) {
		PDLogError(@"Twitter Not Logged in: %@",error.localizedDescription);
		connected = NO;
		[self dismiss];
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self dismissViewControllerAnimated:YES completion:^{
		
	}];
}

- (void) dismiss {
	if (connected) {
		[[NSNotificationCenter defaultCenter] postNotificationName:TwitterLoginSuccess object:nil];
	} else {
		[[NSNotificationCenter defaultCenter] postNotificationName:TwitterLoginFailure object:nil];
	}
	[self dismissViewControllerAnimated:YES completion:^(void){}];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
