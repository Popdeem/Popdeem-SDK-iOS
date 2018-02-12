//
//  PDUIGratitudeViewController.m
//  Bolts
//
//  Created by Niall Quinn on 12/02/2018.
//

#import "PDUIGratitudeViewController.h"
#import "PDUIKitUtils.h"

@interface PDUIGratitudeViewController ()

@end

@implementation PDUIGratitudeViewController

- (id) init {
  if (self = [super init]) {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    return self;
  }
  return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  UIImage *snapshot = [PDUIKitUtils screenSnapshot];
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
  [imageView setImage:snapshot];
  [self.view addSubview:imageView];
  
  _gratitudeView = [[PDUIGratitudeView alloc] initForView:self.view];
  [self.view addSubview:_gratitudeView];
  
    // Do any additional setup after loading the view from its nib.
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
