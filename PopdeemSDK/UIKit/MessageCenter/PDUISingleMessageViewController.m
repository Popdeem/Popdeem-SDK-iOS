//
//  PDSingleMessageViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 15/02/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PopdeemSDK.h"
#import "PDUISingleMessageViewController.h"
#import "PDUISingleMessageViewModel.h"
#import "PDTheme.h"

@interface PDUISingleMessageViewController ()
@property (nonatomic, strong) PDUISingleMessageViewModel *model;
@end

@implementation PDUISingleMessageViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
  if (self = [self initWithNibName:@"PDUISingleMessageViewController" bundle:podBundle]) {
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    return self;
  }
  return nil;
}

- (void) setMessage:(PDMessage*)message {
  _model = [[PDUISingleMessageViewModel alloc] initWithMessage:message];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view from its nib.
  [self renderView];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (void) viewDidLayoutSubviews {
}

- (void) renderView {
  if (_model.image) {
    [self.imageView setImage:_model.image];
  } else {
    [self.imageView setImage:PopdeemImage(@"popdeem.images.defaultItemImage")];
  }
  [self.topLabel setAttributedText:_model.topAttributedString];
  [self.topLabel setNumberOfLines:0];
  [self.bottomLabel setText:_model.bodyBodyString];
  [self.bottomLabel setNumberOfLines:0];
  [self.bottomLabel setFont:PopdeemFont(PDThemeFontPrimary, 14)];
  [self.bottomLabel setTextColor:PopdeemColor(PDThemeColorPrimaryFont)];
  [self.bottomLabel sizeToFit];
  [self.view setNeedsDisplay];
  
}

- (void) updateImage {
  [self.imageView setImage:_model.image];
  [self.view setNeedsDisplay];
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
