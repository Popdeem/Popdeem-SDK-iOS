//
//  PDUIInstagramShareViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 20/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIInstagramShareViewController.h"
#import "PDTheme.h"
#import "PDUtils.h"
#import "PDConstants.h"
#import "PDUser.h"
#import "PopdeemSDK.h"

CGFloat _cardWidth;

@implementation NSString (NSString_Extended)

- (NSString *)urlencode {
	NSMutableString *output = [NSMutableString string];
	const unsigned char *source = (const unsigned char *)[self UTF8String];
	unsigned long sourceLen = strlen((const char *)source);
	for (int i = 0; i < sourceLen; ++i) {
		const unsigned char thisChar = source[i];
		if (thisChar == ' '){
			[output appendString:@"+"];
		} else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
							 (thisChar >= 'a' && thisChar <= 'z') ||
							 (thisChar >= 'A' && thisChar <= 'Z') ||
							 (thisChar >= '0' && thisChar <= '9')) {
			[output appendFormat:@"%c", thisChar];
		} else {
			[output appendFormat:@"%%%02X", thisChar];
		}
	}
	return output;
}
@end

@interface PDUIInstagramShareViewController ()
@property (nonatomic) BOOL leavingToInstagram;
@end

@implementation PDUIInstagramShareViewController

- (instancetype) initForParent:(UIViewController*)parent withMessage:(NSString*)message image:(UIImage*)image imageUrlString:(NSString *)urlString{
	if (self = [super init]) {
		_parent = parent;
		_message = message;
		_image = image;
		_imageURLString = urlString;
		_viewModel = [[PDUIInstagramShareViewModel alloc] init];
		[_viewModel setup];
		return self;
	}
	return nil;
}

- (void)viewDidLoad {
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
	
	_leavingToInstagram = NO;
	[super viewDidLoad];
	[self.view setBackgroundColor:[UIColor clearColor]];
	self.backingView = [[UIView alloc] initWithFrame:_parent.view.frame];
	[self.view addSubview:_backingView];
	[self.backingView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.8]];
	UITapGestureRecognizer *backingTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
	[self.view addGestureRecognizer:backingTap];
	
	CGFloat currentY = 0;
	
	CGFloat cardWidth = _parent.view.frame.size.width * 0.8;
	CGFloat cardHeight = _parent.view.frame.size.height * 0.8;
	CGFloat cardX = _parent.view.frame.size.width * 0.1;
	CGFloat cardY = _parent.view.frame.size.height * 0.25;
	CGRect cardRect = CGRectMake(cardX, cardY, cardWidth, cardHeight);
	
	_cardView = [[UIView alloc] initWithFrame:cardRect];
	[_cardView setBackgroundColor:[UIColor whiteColor]];
	_cardView.layer.cornerRadius = 5.0;
	_cardView.layer.masksToBounds = YES;
	[self.view addSubview:_cardView];
	
	_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, cardWidth, cardHeight)];
	[_scrollView setContentSize:CGSizeMake(2*cardWidth, cardHeight)];
	[_scrollView setBounces:NO];
	[_scrollView setDelegate:self];
	[_scrollView setShowsVerticalScrollIndicator:NO];
	[_scrollView setShowsHorizontalScrollIndicator:NO];
	[_scrollView setPagingEnabled:YES];
	[_scrollView setScrollEnabled:NO];
	[_scrollView setUserInteractionEnabled:YES];
	[_cardView addSubview:_scrollView];
	
	_secondView = [[UIView alloc] initWithFrame:CGRectMake(cardWidth, 0, cardWidth, cardHeight)];
	[_scrollView addSubview:_secondView];
	
	_viewTwoLabelOne = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, cardWidth-40, 70)];
	[_viewTwoLabelOne setText:_viewModel.viewTwoLabelOneText];
	[_viewTwoLabelOne setFont:_viewModel.viewTwoLabelOneFont];
	[_viewTwoLabelOne setTextColor:_viewModel.viewTwoLabelOneColor];
	[_viewTwoLabelOne setNumberOfLines:4];
	[_viewTwoLabelOne setTextAlignment:NSTextAlignmentCenter];
	CGSize labelSize = [_viewTwoLabelOne sizeThatFits:_viewTwoLabelOne.bounds.size];
	[_viewTwoLabelOne setFrame:CGRectMake(_viewTwoLabelOne.frame.origin.x, 40 , _viewTwoLabelOne.frame.size.width, labelSize.height)];
	[_secondView addSubview:_viewTwoLabelOne];
	currentY = 30 + labelSize.height;
	
	_viewTwoLabelTwo = [[UILabel alloc] initWithFrame:CGRectMake(20, currentY+30, _viewTwoLabelOne.frame.size.width, 70)];
	[_viewTwoLabelTwo setText:_viewModel.viewTwoLabelTwoText];
	[_viewTwoLabelTwo setFont:_viewModel.viewTwoLabelTwoFont];
	[_viewTwoLabelTwo setTextColor:_viewModel.viewTwoLabelTwoColor];
	[_viewTwoLabelTwo setNumberOfLines:4];
	[_viewTwoLabelTwo setTextAlignment:NSTextAlignmentCenter];
	labelSize = [_viewTwoLabelTwo sizeThatFits:_viewTwoLabelTwo.bounds.size];
	[_viewTwoLabelTwo setFrame:CGRectMake(_viewTwoLabelTwo.frame.origin.x, currentY+30 , _viewTwoLabelTwo.frame.size.width, labelSize.height)];
	[_secondView addSubview:_viewTwoLabelTwo];
	
	currentY += 30 + labelSize.height + 30;
	
	_viewTwoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, currentY, cardWidth-30, cardHeight*0.25)];
	[_viewTwoImageView setImage:_viewModel.viewTwoImage];
	[_viewTwoImageView setContentMode:UIViewContentModeScaleAspectFit];
	_viewTwoImageView.backgroundColor = [UIColor clearColor];
	_viewTwoImageView.clipsToBounds = YES;
	[_secondView addSubview:_viewTwoImageView];
	
	currentY += _viewTwoImageView.frame.size.height;
	
	_viewTwoActionButton = [[UIButton alloc] initWithFrame:CGRectMake(15, currentY+30, cardWidth-30, 40)];
  [_viewTwoActionButton setBackgroundColor:PopdeemColor(PDThemeColorPrimaryApp)];
	[_viewTwoActionButton.titleLabel setFont:_viewModel.viewTwoActionButtonFont];
	[_viewTwoActionButton setTitle:_viewModel.viewTwoActionButtonText forState:UIControlStateNormal];
	[_viewTwoActionButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
	[_viewTwoActionButton setTag:1];
	[_viewTwoActionButton addTarget:self action:@selector(shareOnInstagram) forControlEvents:UIControlEventTouchUpInside];
	[_secondView addSubview:_viewTwoActionButton];
	
	cardHeight = currentY + 30 + 40 + 20;
	[_secondView setFrame:CGRectMake(cardWidth, 0, cardWidth, cardHeight)];
	
	CGFloat midY = cardHeight/2;
	_firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cardWidth, cardHeight)];
	[_scrollView addSubview:_firstView];
	
	_viewOneLabelOne = [[UILabel alloc] initWithFrame:_viewTwoLabelOne.frame];
	[_viewOneLabelOne setText:_viewModel.viewOneLabelOneText];
	[_viewOneLabelOne setFont:_viewModel.viewOneLabelOneFont];
	[_viewOneLabelOne setTextColor:_viewModel.viewOneLabelOneColor];
	[_viewOneLabelOne setNumberOfLines:4];
	[_viewOneLabelOne setTextAlignment:NSTextAlignmentCenter];
	[_firstView addSubview:_viewOneLabelOne];
	
	_viewOneLabelTwo = [[UILabel alloc] initWithFrame:_viewTwoLabelTwo.frame];
	[_viewOneLabelTwo setText:_viewModel.viewOneLabelTwoText];
	[_viewOneLabelTwo setFont:_viewModel.viewOneLabelTwoFont];
	[_viewOneLabelTwo setTextColor:_viewModel.viewOneLabelTwoColor];
	[_viewOneLabelTwo setNumberOfLines:4];
	[_viewOneLabelTwo setTextAlignment:NSTextAlignmentCenter];
	[_firstView addSubview:_viewOneLabelTwo];
	
	_viewOneImageView = [[UIImageView alloc] initWithFrame:_viewTwoImageView.frame];
	[_viewOneImageView setImage:_viewModel.viewOneImage];
	[_viewOneImageView setContentMode:UIViewContentModeScaleAspectFit];
	_viewOneImageView.backgroundColor = [UIColor clearColor];
	_viewOneImageView.clipsToBounds = YES;
	[_firstView addSubview:_viewOneImageView];
	
	_viewOneActionButton = [[UIButton alloc] initWithFrame:_viewTwoActionButton.frame];
  [_viewOneActionButton setBackgroundColor:[UIColor whiteColor]];
	[_viewOneActionButton.titleLabel setFont:_viewModel.viewOneActionButtonFont];
	[_viewOneActionButton setTitleColor:_viewModel.viewOneActionButtonTextColor forState:UIControlStateNormal];
	[_viewOneActionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
	[_viewOneActionButton setTitle:_viewModel.viewOneActionButtonText forState:UIControlStateNormal];
	[_viewOneActionButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
	[_viewOneActionButton setTag:1];
	[_viewOneActionButton addTarget:self action:@selector(scroll) forControlEvents:UIControlEventTouchUpInside];
	[_firstView addSubview:_viewOneActionButton];
  _viewOneActionButton.layer.borderColor = PopdeemColor(PDThemeColorPrimaryApp).CGColor;
  _viewOneActionButton.layer.borderWidth = 1.0;
	
	_cardWidth = cardWidth;
	midY = self.view.frame.size.height/2;
	cardY = midY - (cardHeight/2);
	[_cardView setFrame:CGRectMake(cardX, cardY, cardWidth, cardHeight)];
	
}

- (void) scroll {
	[_scrollView setContentOffset:CGPointMake(_cardWidth, 0) animated:YES];
	AbraLogEvent(ABRA_EVENT_PAGE_VIEWED, @{ABRA_PROPERTYNAME_SOURCE_PAGE : ABRA_PROPERTYVALUE_PAGE_INSTA_TUTORIAL_MODULE_TWO});
}

- (void) shareOnInstagram {
	
	NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
	
	if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
	{
		NSString *escapedString   = [_imageURLString urlencode];
//		NSString *escapedCaption  = [@"test" urlencode];
		NSURL *instagramURL       = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://library?LocalIdentifier=%@", escapedString]];
		UIPasteboard *pb = [UIPasteboard generalPasteboard];
		[pb setString:_message];
		if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
			_leavingToInstagram = YES;
			[[UIApplication sharedApplication] openURL:instagramURL];
		} else {
			[self openInDocumentController];
		}
	}
	else
	{
		UIAlertView *errMsg = [[UIAlertView alloc] initWithTitle:@"Instagram Required"
																										 message:@"It appears that you do not have Instagram installed. You will now be directed to the App Store to download the Instagram App."
																										delegate:self
																					 cancelButtonTitle:@"Ok"
																					 otherButtonTitles:nil];
		[errMsg setTag:2];
		[errMsg show];
		_leavingToInstagram = NO;
	}
}

- (void) openInDocumentController {
	NSData *imageData = UIImagePNGRepresentation(_image); //convert image into .png format.
	NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
	NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
	NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"insta.igo"]]; //add our image to the path
	[fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
	PDLog(@"image saved");
	
	CGRect rect = CGRectMake(0 ,0 , 0, 0);
	UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
	[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIGraphicsEndImageContext();
	NSString *fileNameToSave = [NSString stringWithFormat:@"Documents/insta.igo"];
	NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fileNameToSave];
	NSString *newJpgPath = [NSString stringWithFormat:@"file://%@",jpgPath];
	NSURL *igImageHookFile = [NSURL URLWithString:newJpgPath];	
	self.dic.UTI = @"com.instagram.exclusivegram";
	// self.documentController = [self setupControllerWithURL:igImageHookFile usingDelegate:self];
	
	UIPasteboard *pb = [UIPasteboard generalPasteboard];
	[pb setString:_message];
	
	self.dic=[UIDocumentInteractionController interactionControllerWithURL:igImageHookFile];
	NSString *caption = _message; //settext as Default Caption
	self.dic.annotation=[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",caption],@"InstagramCaption", nil];
	[self.dic presentOpenInMenuFromRect:rect inView: self.view animated:YES];
	_leavingToInstagram = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setMessage:(NSString *)message {
	self.message = message;
	
	UIPasteboard *pb = [UIPasteboard generalPasteboard];
	[pb setString:message];
}

- (void) dismiss {
	[self dismissViewControllerAnimated:YES completion:^(void){
		
	}];
}

- (NSParagraphStyle*) createParagraphAttribute {
	NSMutableParagraphStyle *paragraphStyle;
	paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
	[paragraphStyle setTabStops:@[[[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentLeft location:15 options:@{}]]];
	[paragraphStyle setDefaultTabInterval:15];
	[paragraphStyle setFirstLineHeadIndent:0];
	[paragraphStyle setHeadIndent:15];
	
	return paragraphStyle;
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	AbraLogEvent(ABRA_EVENT_PAGE_VIEWED, @{ABRA_PROPERTYNAME_SOURCE_PAGE : ABRA_PROPERTYVALUE_PAGE_INSTA_TUTORIAL_MODULE_ONE});
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (void) viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)appDidBecomeActive:(NSNotification *)notification {
}

- (void)appWillEnterForeground:(NSNotification *)notification {
}

- (void)appDidEnterBackground:(NSNotification *)notification {
	if (_leavingToInstagram) {
		[self dismissViewControllerAnimated:YES completion:^(void){
      [[NSNotificationCenter defaultCenter] postNotificationName:PDUserLinkedToInstagram object:nil];
      [[NSNotificationCenter defaultCenter] removeObserver:self];
		}];
		AbraLogEvent(ABRA_EVENT_CLICKED_NEXT_INSTAGRAM_TUTORIAL, nil);
	}
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{

}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 2) {
		NSString *simple = @"itms-apps://itunes.apple.com/app/id389801252";
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:simple]];
	}
}

@end
