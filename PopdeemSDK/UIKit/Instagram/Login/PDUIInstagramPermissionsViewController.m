//
//  PDUIInstagramPermissionsViewController.m
//  PopdeemSDK
//
//  Created by Popdeem on 24/01/2020.
//


#import "PDUIInstagramPermissionsViewController.h"
#import "PDTheme.h"
#import "PDUtils.h"
#import "PDConstants.h"
#import "PDUser.h"
#import "PopdeemSDK.h"


@interface PDUIInstagramPermissionsViewController () {
    CGFloat _cardWidth;
}

@end

@implementation PDUIInstagramPermissionsViewController

- (instancetype) initForParent:(UIViewController*)parent {
    if (self = [super init]) {
        _parent = parent;
        _viewModel = [[PDUIInstagramPermissionsViewModel alloc] initWithController:self];
        return self;
    }
    return nil;
}

- (void)viewDidLoad {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    
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
      
        
        NSString *buttonColor;
        
        if (PopdeemThemeHasValueForKey(PDThemeColorButtons)) {
            buttonColor = PopdeemColor(PDThemeColorButtons);
        } else {
            buttonColor = PopdeemColor(PDThemeColorPrimaryApp);
        }
      
      _viewOneActionButton = [[UIButton alloc] initWithFrame:CGRectMake(15, currentY+30, cardWidth-30, 40)];
      [_viewOneActionButton setBackgroundColor:[UIColor whiteColor]];
      [_viewOneActionButton.titleLabel setFont:_viewModel.viewOneActionButtonFont];
      [_viewOneActionButton setTitleColor:_viewModel.viewOneActionButtonTextColor forState:UIControlStateNormal];
      [_viewOneActionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
      [_viewOneActionButton setTitle:_viewModel.viewOneActionButtonText forState:UIControlStateNormal];
      [_viewOneActionButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
      [_viewOneActionButton setTag:1];
      [_viewOneActionButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
      [_firstView addSubview:_viewOneActionButton];
      [_viewOneActionButton setBackgroundColor:buttonColor];
      
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

    }

    - (void) scrollViewDidScroll:(UIScrollView *)scrollView{
      
    }



@end
