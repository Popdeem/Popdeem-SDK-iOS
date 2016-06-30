//
//  PDUICardViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 17/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUICardViewController.h"
#import "PDTheme.h"
#import "PDUICardViewModel.h"

@interface PDUICardViewController ()
@property (nonatomic, retain) PDUICardViewModel *viewModel;
@end

@implementation PDUICardViewController

- (instancetype) initForParent:(UIViewController*)parent
										headerText:(NSString*)headerText
												 image:(UIImage*)image
											bodyText:(NSString*)bodyText
						 actionButtonTitle:(NSString*)actionButtonTitle
						 otherButtonTitles:(NSArray*)otherButtonTitles
										completion:(void (^)(int buttonIndex))completion {
	
	if (self = [super init]) {
		self.view = [[UIView alloc] initWithFrame:_parent.view.frame];
		self.viewModel = [[PDUICardViewModel alloc] initWithController:self headerText:headerText bodyText:bodyText image:image actionButtonTitle:actionButtonTitle otherButtonTitles:otherButtonTitles];
		self.completion = completion;
		self.parent = parent;
		[self setupView];
		return self;
	}
	return nil;
}

- (void) setupView {
	[self.view setBackgroundColor:[UIColor clearColor]];
	self.effectView = [[UIVisualEffectView alloc] initWithFrame:_parent.view.frame];
	UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
	[self.effectView setEffect:blurEffect];
	UITapGestureRecognizer *backingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
	[_effectView addGestureRecognizer:backingTap];
	[self.view addSubview:_effectView];
	
	CGFloat currentY = 0;
	
	CGFloat cardWidth = _parent.view.frame.size.width * 0.8;
	CGFloat cardHeight = _parent.view.frame.size.height * 0.5;
	CGFloat cardX = _parent.view.frame.size.width * 0.1;
	CGFloat cardY = _parent.view.frame.size.height * 0.25;
	CGRect cardRect = CGRectMake(cardX, cardY, cardWidth, cardHeight);
	
	_cardView = [[UIView alloc] initWithFrame:cardRect];
	[_cardView setBackgroundColor:[UIColor whiteColor]];
	_cardView.layer.cornerRadius = 5.0;
	_cardView.layer.masksToBounds = YES;
	[self.view addSubview:_cardView];
	
	CGFloat headerHeight = cardHeight * 0.15;
	_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cardWidth, headerHeight)];
	[_headerView setBackgroundColor:_viewModel.headerColor];
	
	_headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _headerView.frame.size.width, headerHeight)];
	[_headerLabel setText:_viewModel.headerText];
	[_headerLabel setFont:_viewModel.headerFont];
	[_headerLabel setTextColor:_viewModel.headerLabelColor];
	[_headerLabel setTextAlignment:NSTextAlignmentCenter];
	[_headerLabel setNumberOfLines:2];
	
	[_headerView addSubview:_headerLabel];
	[_cardView addSubview:_headerView];
	currentY += headerHeight;
	
	CGFloat usableHeight = cardHeight - (2 * headerHeight);
	CGFloat imageHeight = (usableHeight / 2) - 30;
	currentY += 15;
	_imageView = [[UIImageView alloc] initWithFrame:CGRectMake((cardWidth/2)-(imageHeight/2), currentY, imageHeight, imageHeight)];
	_imageView.layer.cornerRadius = 2.0;
	_imageView.layer.masksToBounds = YES;
	if (_viewModel.image) {
		[_imageView setImage:_viewModel.image];
	} else {
		[_imageView setImage:PopdeemImage(@"popdeem.images.defaultItemImage")];
	}
	[_cardView addSubview:_imageView];
	
	currentY += imageHeight + 5;
	CGFloat labelHeight = usableHeight/2;
	_bodyLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY, cardWidth-20, labelHeight)];
	[_bodyLabel setNumberOfLines:5];
	[_bodyLabel setTextAlignment:NSTextAlignmentCenter];
	[_bodyLabel setFont:_viewModel.bodyFont];
	[_bodyLabel setTextColor:_viewModel.bodyLabelColor];
	[_bodyLabel setText:_viewModel.bodyText];
	[_bodyLabel sizeToFit];
	[_cardView addSubview:_bodyLabel];
	CGFloat realLabelHeight = _bodyLabel.frame.size.height;
	CGFloat labelDelta = labelHeight-realLabelHeight;
	[_bodyLabel setFrame:CGRectMake(10, currentY+(labelDelta/2), _bodyLabel.frame.size.width, _bodyLabel.frame.size.height)];
	currentY = cardHeight - headerHeight;
	
	int numberOfButtons = _viewModel.otherButtonTitles.count + 1;
	CGFloat buttonWidth = cardWidth / numberOfButtons;
	
	
	_actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, cardHeight-headerHeight, cardWidth, headerHeight)];
	[_actionButton setBackgroundColor:_viewModel.actionButtonColor];
	[_actionButton.titleLabel setFont:_viewModel.actionButtonFont];
	[_actionButton setTitle:_viewModel.actionButtonTitle forState:UIControlStateNormal];
	[_actionButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
	[_actionButton setTag:0];
	[_actionButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[_cardView addSubview:_actionButton];

}

- (void) buttonPressed:(UIButton*)sender {
	_completion((int)sender.tag);
}

- (void) showAnimated:(BOOL)animated {
	
}

- (void) dismiss{
	[self dismissViewControllerAnimated:YES completion:^(void){
		//Cleanup?
	}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
