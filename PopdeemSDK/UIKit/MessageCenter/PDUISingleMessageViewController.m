//
//  PDSingleMessageViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 15/02/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUISingleMessageViewController.h"
#import "PDUISingleMessageViewModel.h"
#import "PDTheme.h"

@interface PDUISingleMessageViewController ()
@property (nonatomic, strong) PDUISingleMessageViewModel *model;
@end

@implementation PDUISingleMessageViewController

- (instancetype) initFromNib {
  NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
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
  [self.senderTagLabel setText:_model.senderTagLabelString];
  [self.senderLabel setText:_model.senderBodyString];
  [self.dateTagLabel setText:_model.dateTagString];
  [self.dateLabel setText:_model.dateBodyString];
  [self.titleTagLabel setText:_model.titleTagString];
  [self.titleLabel setText:_model.titleBodyString];
  [self.bodyTaglabel setText:_model.bodyTagString];
  [self.bodyLabel setText:_model.bodyBodyString];
  
  NSAttributedString *titleAttString = [[NSAttributedString alloc] initWithString:self.titleLabel.text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
  CGRect rulesLabelRect = [titleAttString boundingRectWithSize:(CGSize){self.titleLabel.frame.size.width, 40}
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                       context:nil];
  [self.titleLabel setFrame:CGRectMake(self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, rulesLabelRect.size.width, rulesLabelRect.size.height)];
  
  NSAttributedString *bodyAttString = [[NSAttributedString alloc] initWithString:self.bodyLabel.text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
  CGRect bodyLabelRect = [bodyAttString boundingRectWithSize:(CGSize){self.bodyLabel.frame.size.width, 150}
                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                     context:nil];
  [self.bodyLabel setFrame:CGRectMake(self.bodyLabel.frame.origin.x, self.bodyLabel.frame.origin.y, bodyLabelRect.size.width, bodyLabelRect.size.height)];
  
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
