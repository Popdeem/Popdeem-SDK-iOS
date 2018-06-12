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
#import "PDCustomer.h"

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

- (instancetype) initForParent:(PDUIClaimV2ViewController*)parent withMessage:(NSString*)message image:(UIImage*)image imageUrlString:(NSString *)urlString{
  if (self = [super init]) {
    _parent = parent;
    _message = message;
    _image = image;
    _imageURLString = urlString;
    _facebookInstalled = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]];
    _viewModel = [[PDUIFacebookShareViewModel alloc] initWithController:self];
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
  [_scrollView setContentSize:CGSizeMake(cardWidth, cardHeight)];
  [_scrollView setBounces:NO];
  [_scrollView setDelegate:self];
  [_scrollView setShowsVerticalScrollIndicator:NO];
  [_scrollView setShowsHorizontalScrollIndicator:NO];
  [_scrollView setPagingEnabled:YES];
  [_scrollView setScrollEnabled:NO];
  [_scrollView setUserInteractionEnabled:YES];
  [_cardView addSubview:_scrollView];
  
  _firstView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cardWidth, cardHeight)];
  [_scrollView addSubview:_firstView];
  
  _viewOneLabelOne = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, cardWidth-40, 70)];
  [_viewOneLabelOne setText:_viewModel.viewOneLabelOneText];
  [_viewOneLabelOne setFont:_viewModel.viewOneLabelOneFont];
  [_viewOneLabelOne setTextColor:_viewModel.viewOneLabelOneColor];
  [_viewOneLabelOne setNumberOfLines:0];
  [_viewOneLabelOne setTextAlignment:NSTextAlignmentCenter];
  CGSize labelSize = [_viewOneLabelOne sizeThatFits:_viewTwoLabelOne.bounds.size];
  [_viewOneLabelOne setFrame:CGRectMake(_viewOneLabelOne.frame.origin.x, currentY+30 , _viewOneLabelOne.frame.size.width, labelSize.height)];
  [_firstView addSubview:_viewOneLabelOne];
  currentY = 30 + labelSize.height;

  _viewOneLabelTwo = [[UILabel alloc] initWithFrame:CGRectMake(20, currentY, cardWidth-40, 70)];
  [_viewOneLabelTwo setText:_viewModel.viewOneLabelTwoText];
  [_viewOneLabelTwo setFont:_viewModel.viewOneLabelTwoFont];
  [_viewOneLabelTwo setTextColor:_viewModel.viewOneLabelTwoColor];
  [_viewOneLabelTwo setNumberOfLines:0];
  [_viewOneLabelTwo setTextAlignment:NSTextAlignmentCenter];
  labelSize = [_viewOneLabelTwo sizeThatFits:_viewOneLabelTwo.bounds.size];
  [_viewOneLabelTwo setFrame:CGRectMake(_viewOneLabelTwo.frame.origin.x, currentY+30 , _viewOneLabelTwo.frame.size.width, labelSize.height)];
  [_firstView addSubview:_viewOneLabelTwo];
  currentY += 30 + labelSize.height + 30;
  
  _viewOneImageView =  [[UIImageView alloc] initWithFrame:CGRectMake(15, currentY, cardWidth-30, cardHeight*0.25)];
  [_viewOneImageView setImage:_viewModel.viewOneImage];
  [_viewOneImageView setContentMode:UIViewContentModeScaleAspectFit];
  _viewOneImageView.backgroundColor = [UIColor clearColor];
  _viewOneImageView.clipsToBounds = YES;
  [_firstView addSubview:_viewOneImageView];
  currentY += _viewOneImageView.frame.size.height;
  
  if (_facebookInstalled) {
    NSString *forcedTagString = (self.parent.reward.forcedTag) ? self.parent.reward.forcedTag : @"hashtag";
    NSDictionary *attributes = @{
                                 NSFontAttributeName: PopdeemFont(PDThemeFontPrimary, 12),
                                 NSForegroundColorAttributeName: [UIColor blackColor],
                                 NSBackgroundColorAttributeName: [UIColor colorWithRed:0.87 green:0.90 blue:0.96 alpha:1.00]
                                 };
    NSMutableAttributedString *hashtagString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ",forcedTagString] attributes:attributes];
    UILabel *hashLabel = [[UILabel alloc] init];
    [hashLabel setAttributedText:hashtagString];
    [hashLabel sizeToFit];
    [hashLabel setFrame:CGRectMake(18, 38, hashLabel.frame.size.width, hashLabel.frame.size.height)];
    hashLabel.layer.cornerRadius = 3.0f;
    hashLabel.clipsToBounds = YES;
    [_viewOneImageView addSubview:hashLabel];
  }
  
  _viewOneActionButton = [[UIButton alloc] initWithFrame:CGRectMake(15, currentY+30, cardWidth-30, 40)];
  [_viewOneActionButton setBackgroundColor:[UIColor whiteColor]];
  [_viewOneActionButton.titleLabel setFont:_viewModel.viewOneActionButtonFont];
  [_viewOneActionButton setTitleColor:_viewModel.viewOneActionButtonTextColor forState:UIControlStateNormal];
  [_viewOneActionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
  [_viewOneActionButton setTitle:_viewModel.viewOneActionButtonText forState:UIControlStateNormal];
  [_viewOneActionButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
  [_viewOneActionButton setTag:1];
  [_viewOneActionButton addTarget:self action:@selector(shareOnFacebook) forControlEvents:UIControlEventTouchUpInside];
  [_firstView addSubview:_viewOneActionButton];
  [_viewOneActionButton setBackgroundColor:PopdeemColor(PDThemeColorPrimaryApp)];
  
  cardHeight = currentY + 30 + 40 + 20;
  [_firstView setFrame:CGRectMake(0, 0, cardWidth, cardHeight)];
  
  _cardWidth = cardWidth;
  float midY = self.view.frame.size.height/2;
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
  if (!_facebookInstalled) {
    [self dismiss];
    return;
  }
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
  dialog.mode = FBSDKShareDialogModeAutomatic;
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
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    [self dismissViewControllerAnimated:NO completion:^(void){
      [weakSelf.parent facebookShared];
    }];
  });
}

- (void) sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
  NSLog(@"Facebook Sharing Failed");
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    [self dismissViewControllerAnimated:YES completion:^(void){
      [weakSelf.parent facebookFailed];
    }];
  });
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
  NSLog(@"Facebook Sharing User Cancelled");
  __weak typeof(self) weakSelf = self;
  dispatch_async(dispatch_get_main_queue(), ^{
    [self dismissViewControllerAnimated:YES completion:^(void){
      [weakSelf.parent facebookCancelled];
    }];
  });
}

@end
