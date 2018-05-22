//
//  PDUIFacebookShareViewController.m
//  Bolts
//
//  Created by Niall Quinn on 22/05/2018.
//

#import "PDUIFacebookShareViewController.h"
#import "PDTheme.h"
#import "PDUtils.h"
#import "PDConstants.h"
#import "PDUser.h"
#import "PopdeemSDK.h"

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

@interface PDUIFacebookShareViewController ()
@property (nonatomic) BOOL leavingToFacebook;
@end

@implementation PDUIFacebookShareViewController {
    CGFloat _cardWidth;
}

- (instancetype) initForParent:(UIViewController*)parent withMessage:(NSString*)message image:(UIImage*)image imageUrlString:(NSString *)urlString{
    if (self = [super init]) {
        _parent = parent;
        _message = message;
        _image = image;
        _imageURLString = urlString;
        _viewModel = [[PDUIFacebookShareViewModel alloc] init];
        [_viewModel setup];
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
    _leavingToFacebook = NO;
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
    [_scrollView setContentSize:CGSizeMake(3*cardWidth, cardHeight)];
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
    
    _thirdView = [[UIView alloc] initWithFrame:CGRectMake(2*cardWidth, 0, cardWidth, cardHeight)];
    [_scrollView addSubview:_thirdView];
    
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
    [_viewTwoActionButton setBackgroundColor:[UIColor whiteColor]];
    [_viewTwoActionButton setTitleColor:PopdeemColor(PDThemeColorPrimaryApp) forState:UIControlStateNormal];
    [_viewTwoActionButton.titleLabel setFont:_viewModel.viewTwoActionButtonFont];
    [_viewTwoActionButton setTitle:_viewModel.viewTwoActionButtonText forState:UIControlStateNormal];
    [_viewTwoActionButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_viewTwoActionButton setTag:1];
    [_viewTwoActionButton addTarget:self action:@selector(scroll) forControlEvents:UIControlEventTouchUpInside];
    [_secondView addSubview:_viewTwoActionButton];
    _viewTwoActionButton.layer.borderColor = PopdeemColor(PDThemeColorPrimaryApp).CGColor;
    _viewTwoActionButton.layer.borderWidth = 1.0;
    
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
    
    
    currentY = 0;
    
    _viewThreeLabelOne = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, cardWidth-40, 70)];
    [_viewThreeLabelOne setText:_viewModel.viewThreeLabelOneText];
    [_viewThreeLabelOne setFont:_viewModel.viewThreeLabelOneFont];
    [_viewThreeLabelOne setTextColor:_viewModel.viewThreeLabelOneColor];
    [_viewThreeLabelOne setNumberOfLines:4];
    [_viewThreeLabelOne setTextAlignment:NSTextAlignmentCenter];
    labelSize = [_viewThreeLabelOne sizeThatFits:_viewThreeLabelOne.bounds.size];
    [_viewThreeLabelOne setFrame:CGRectMake(_viewThreeLabelOne.frame.origin.x, 40 , _viewThreeLabelOne.frame.size.width, labelSize.height)];
    [_thirdView addSubview:_viewThreeLabelOne];
    currentY = 30 + labelSize.height;
    
    _viewThreeLabelTwo = [[UILabel alloc] initWithFrame:CGRectMake(20, currentY+30, _viewThreeLabelOne.frame.size.width, 70)];
    [_viewThreeLabelTwo setText:_viewModel.viewThreeLabelTwoText];
    [_viewThreeLabelTwo setFont:_viewModel.viewThreeLabelTwoFont];
    [_viewThreeLabelTwo setTextColor:_viewModel.viewThreeLabelTwoColor];
    [_viewThreeLabelTwo setNumberOfLines:4];
    [_viewThreeLabelTwo setTextAlignment:NSTextAlignmentCenter];
    labelSize = [_viewThreeLabelTwo sizeThatFits:_viewThreeLabelTwo.bounds.size];
    [_viewThreeLabelTwo setFrame:CGRectMake(_viewThreeLabelTwo.frame.origin.x, currentY+30 , _viewThreeLabelTwo.frame.size.width, labelSize.height)];
    [_thirdView addSubview:_viewThreeLabelTwo];
    
    currentY += 30 + labelSize.height + 30;
    
    _viewThreeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, currentY, cardWidth-20, cardHeight*0.30)];
    [_viewThreeImageView setImage:_viewModel.viewThreeImage];
    [_viewThreeImageView setContentMode:UIViewContentModeScaleAspectFit];
    _viewThreeImageView.backgroundColor = [UIColor clearColor];
    _viewThreeImageView.clipsToBounds = YES;
    [_thirdView addSubview:_viewThreeImageView];
    
    currentY += _viewTwoImageView.frame.size.height;
    
    _viewThreeActionButton = [[UIButton alloc] initWithFrame:CGRectMake(15, currentY+30, cardWidth-30, 40)];
    [_viewThreeActionButton setBackgroundColor:PopdeemColor(PDThemeColorPrimaryApp)];
    [_viewThreeActionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_viewThreeActionButton.titleLabel setFont:_viewModel.viewThreeActionButtonFont];
    [_viewThreeActionButton setTitle:_viewModel.viewThreeActionButtonText forState:UIControlStateNormal];
    [_viewThreeActionButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_viewThreeActionButton setTag:1];
    [_viewThreeActionButton addTarget:self action:@selector(shareOnFacebook) forControlEvents:UIControlEventTouchUpInside];
    [_thirdView addSubview:_viewThreeActionButton];
    
    _cardWidth = cardWidth;
    midY = self.view.frame.size.height/2;
    cardY = midY - (cardHeight/2);
    [_cardView setFrame:CGRectMake(cardX, cardY, cardWidth, cardHeight)];
    
}

- (void) scroll {
    if (_scrollView.contentOffset.x == 0) {
        [_scrollView setContentOffset:CGPointMake(_cardWidth, 0) animated:YES];
    }
    if (_scrollView.contentOffset.x > 0 && _scrollView.contentOffset.x <  2*_cardWidth) {
        [_scrollView setContentOffset:CGPointMake(2*_cardWidth, 0) animated:YES];
    }
    AbraLogEvent(ABRA_EVENT_PAGE_VIEWED, @{ABRA_PROPERTYNAME_SOURCE_PAGE : ABRA_PROPERTYVALUE_PAGE_INSTA_TUTORIAL_MODULE_TWO});
}

- (void) shareOnFacebook {
    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.fromViewController = self;
    if (_image != nil) {
        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
        photo.image = _image;
        photo.userGenerated = YES;
        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
        content.photos = @[photo];
        if (_reward.forcedTag) {
            content.hashtag = [FBSDKHashtag hashtagWithString:_reward.forcedTag];
        }
        dialog.shareContent = content;
    }
    dialog.mode = FBSDKShareDialogModeShareSheet;
    if (![dialog canShow]) {
        dialog.mode = FBSDKShareDialogModeNative;
    }
    if (![dialog canShow]) {
        dialog.mode = FBSDKShareDialogModeBrowser;
    }
    dialog.delegate = self;
    [dialog show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (_leavingToFacebook) {
        [self dismissViewControllerAnimated:YES completion:^(void){
            [[NSNotificationCenter defaultCenter] postNotificationName:PDUserLinkedToInstagram object:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }];
        AbraLogEvent(ABRA_EVENT_CLICKED_NEXT_INSTAGRAM_TUTORIAL, nil);
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView{
    
}

//- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    if (alertView.tag == 2) {
//        NSString *simple = @"itms-apps://itunes.apple.com/app/id389801252";
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:simple]];
//    }
//}

# pragma mark - FBSDKSharingDelegate -

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    NSLog(@"Facebook Sharing Complete");
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    NSLog(@"Facebook Sharing Failed");
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    NSLog(@"Facebook Sharing User Cancelled");
}

@end
