//
//  PDSingleMessageViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 15/02/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDSingleMessageViewController.h"
#import "PDSingleMessageViewModel.h"

@interface PDSingleMessageViewController ()
@property (nonatomic, strong) PDSingleMessageViewModel *model;
@end

@implementation PDSingleMessageViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
  if (self = [self initWithNibName:@"PDSingleMessageViewController" bundle:podBundle]) {
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    return self;
  }
  return nil;
}

- (void) setMessage:(PDMessage*)message {
  _model = [[PDSingleMessageViewModel alloc] initWithMessage:message];
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

- (void) renderView {
  if (_model.image) {
    [self.imageView setImage:_model.image];
  } else {
    [self.imageView setImage:[UIImage imageNamed:@"starG"]];
  }
  [self.senderTagLabel setText:_model.senderTagLabelString];
  [self.senderLabel setText:_model.senderBodyString];
  [self.dateTagLabel setText:_model.dateTagString];
  [self.dateLabel setText:_model.dateBodyString];
  [self.titleTagLabel setText:_model.titleTagString];
  [self.titleLabel setText:_model.titleBodyString];
  [self.bodyTaglabel setText:_model.bodyTagString];
  [self.bodyLabel setText:_model.bodyBodyString];
  
  ]
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
