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

@interface PDUIInstagramShareViewController ()
@property (nonatomic) BOOL leavingToInstagram;
@end

@implementation PDUIInstagramShareViewController

- (instancetype) initForParent:(UIViewController*)parent withMessage:(NSString*)message image:(UIImage*)image {
	if (self = [super init]) {
		_parent = parent;
		_message = message;
	 _image = image;
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
	[_headerView setBackgroundColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
	
	_headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _headerView.frame.size.width, headerHeight)];
	[_headerLabel setText:@"Claim"];
	[_headerLabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 17)];
	[_headerLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryInverseColor")];
	[_headerLabel setTextAlignment:NSTextAlignmentCenter];
	[_headerLabel setNumberOfLines:2];
	
	[_headerView addSubview:_headerLabel];
	[_cardView addSubview:_headerView];
	currentY += headerHeight;
	
	CGFloat usableHeight = cardHeight - (2 * headerHeight);
	CGFloat messageHeight = 60;
	CGFloat padding = 5;
	_messageView = [[UIView alloc] initWithFrame:CGRectMake(10, currentY+10, cardWidth-20, messageHeight)];
	[_messageView.layer setCornerRadius:5];
	_messageView.layer.borderWidth = 1.0;
	_messageView.layer.borderColor = PopdeemColor(@"popdeem.colors.secondaryFontColor").CGColor;
	[_messageView setClipsToBounds:YES];
	[_cardView addSubview:_messageView];
	
	_messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, _messageView.frame.size.width-10, _messageView.frame.size.height-10)];
	[_instructionsLabel setTextAlignment:NSTextAlignmentLeft];
	[_messageLabel setText:_message];
	[_messageLabel setFont:PopdeemFont(@"popdeem.fonts.primaryFont", 14)];
	[_messageLabel setTextColor:PopdeemColor(@"popdeem.colors.secondaryFontColor")];
	[_messageLabel sizeToFit];
	[_messageView setFrame:CGRectMake(10, currentY+10, _messageView.frame.size.width, _messageLabel.frame.size.height+2*padding)];
	[_messageView addSubview:_messageLabel];
	
	
	currentY += 20 + _messageView.frame.size.height;
	
	_instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, currentY+padding, cardWidth-20, usableHeight/2)];
	[_instructionsLabel setTextAlignment:NSTextAlignmentLeft];
	
	NSString *instagramScreenName = [[[PDUser sharedInstance] instagramParams] screenName];
	if (!instagramScreenName) {
		instagramScreenName = @"PopdeemTester1";
	}
	NSString *user = [NSString stringWithFormat:@"Make sure you are logged in as %@",instagramScreenName];
	NSString *noBullet = @"Your message has been copied to the clipboard.\n";
	NSString *bullet1 = @"1. Tap 'Share on Instagram' and choose 'Copy to Instagram' to be taken to the Instagram app.\n";
	NSString *bullet2 = [NSString stringWithFormat:@"2. Paste your caption when prompted. Make sure your post includes the required hashtag.\n" ];
	NSString *bullet3 = @"3. Complete your post on the Instagram App.\n";
	NSString *bullet4 = @"4. Come back here to verify your post.\n";
	
	NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
	paragraphStyle.alignment                = NSTextAlignmentCenter;
	NSMutableAttributedString *notesString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@",user,noBullet] attributes:@{NSFontAttributeName: PopdeemFont(@"popdeem.fonts.primaryFont", 11), NSForegroundColorAttributeName: PopdeemColor(@"popdeem.colors.secondaryFontColor"),NSParagraphStyleAttributeName: paragraphStyle}];
	
	NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:@"" attributes:@{NSFontAttributeName: PopdeemFont(@"popdeem.fonts.primaryFont", 12), NSForegroundColorAttributeName: PopdeemColor(@"popdeem.colors.secondaryFontColor")}];
	
	[attString appendAttributedString:notesString];
	
	NSArray *strings = [NSArray arrayWithObjects:bullet1,bullet2,bullet3,bullet4, nil];
	for (NSString* s in strings) {
		NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:s];
		NSParagraphStyle *paragraphStyle = [self createParagraphAttribute];
		[aString addAttributes:@{NSParagraphStyleAttributeName: paragraphStyle, NSFontAttributeName: PopdeemFont(@"popdeem.fonts.primaryFont", 13), NSForegroundColorAttributeName: PopdeemColor(@"popdeem.colors.primaryFontColor")} range:NSMakeRange(0, aString.length)];
		[attString appendAttributedString:aString];
	}
	
	[_instructionsLabel setAttributedText:attString];
	_instructionsLabel.numberOfLines = 10;
	[_cardView addSubview:_instructionsLabel];
	[_instructionsLabel sizeToFit];
	
	currentY += _instructionsLabel.frame.size.height + padding;
	CGFloat buttonWidth = cardWidth;
	
	_actionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, currentY, cardWidth, headerHeight)];
	[_actionButton setBackgroundColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
	[_actionButton.titleLabel setFont:PopdeemFont(@"popdeem.fonts.boldFont", 17)];
	[_actionButton.titleLabel setTextColor:PopdeemColor(@"popdeem.colors.primaryInverseColor")];
	[_actionButton setTitle:@"Share on Instagram" forState:UIControlStateNormal];
	[_actionButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
	[_actionButton setTag:0];
	[_actionButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
	[_cardView addSubview:_actionButton];
	
	currentY += headerHeight;
	cardHeight = currentY;
	CGFloat midY = self.view.frame.size.height / 2;
	cardY = midY - (cardHeight/2);
	[_cardView setFrame:CGRectMake(cardX, cardY, cardWidth, cardHeight)];
	
}

- (void) buttonPressed:(id)sender {
	NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
	if([[UIApplication sharedApplication] canOpenURL:instagramURL]) //check for App is install or not
	{
		NSData *imageData = UIImagePNGRepresentation(_image); //convert image into .png format.
		NSFileManager *fileManager = [NSFileManager defaultManager];//create instance of NSFileManager
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //create an array and store result of our search for the documents directory in it
		NSString *documentsDirectory = [paths objectAtIndex:0]; //create NSString object, that holds our exact path to the documents directory
		NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"insta.igo"]]; //add our image to the path
		[fileManager createFileAtPath:fullPath contents:imageData attributes:nil]; //finally save the path (image)
		NSLog(@"image saved");
		
		CGRect rect = CGRectMake(0 ,0 , 0, 0);
		UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
		[self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
		UIGraphicsEndImageContext();
		NSString *fileNameToSave = [NSString stringWithFormat:@"Documents/insta.igo"];
		NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fileNameToSave];
		NSLog(@"jpg path %@",jpgPath);
		NSString *newJpgPath = [NSString stringWithFormat:@"file://%@",jpgPath];
		NSLog(@"with File path %@",newJpgPath);
		NSURL *igImageHookFile = [NSURL URLWithString:newJpgPath];
		NSLog(@"url Path %@",igImageHookFile);
		
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
	else
	{
		UIAlertView *errMsg = [[UIAlertView alloc] initWithTitle:@"Warning" message:@"No Instagram Available" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
		[errMsg show];
		_leavingToInstagram = NO;
	}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setMessage:(NSString *)message {
	self.message = message;
	[self.messageLabel setText:message];
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
	[paragraphStyle setTabStops:@[[[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentLeft location:15 options:nil]]];
	[paragraphStyle setDefaultTabInterval:15];
	[paragraphStyle setFirstLineHeadIndent:0];
	[paragraphStyle setHeadIndent:15];
	
	return paragraphStyle;
}

- (void) viewDidAppear:(BOOL)animated {
	NSLog(@"View did appear");
	if (_leavingToInstagram) {
		[self dismiss];
		[[NSNotificationCenter defaultCenter] postNotificationName:PDUserLinkedToInstagram object:nil];
	}
}

- (void)viewDidDisappear:(BOOL)animated {
	NSLog(@"View did disappear");
}

- (void) viewWillDisappear:(BOOL)animated {
	NSLog(@"View will disappear");
	if (_leavingToInstagram) {
		[self dismiss];
		[[NSNotificationCenter defaultCenter] postNotificationName:PDUserLinkedToInstagram object:nil];
	}
}

- (void)appDidBecomeActive:(NSNotification *)notification {
	NSLog(@"did become active notification");
}

- (void)appWillEnterForeground:(NSNotification *)notification {
	NSLog(@"will enter foreground notification");
}

- (void)appDidEnterBackground:(NSNotification *)notification {
	NSLog(@"will enter background notification");
	if (_leavingToInstagram) {
		[self dismissViewControllerAnimated:YES completion:^(void){
			[[NSNotificationCenter defaultCenter] postNotificationName:PDUserLinkedToInstagram object:nil];
			[[NSNotificationCenter defaultCenter] removeObserver:self];
		}];
	}
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
