//
//  PDUIGratitudeViewController.m
//  Bolts
//
//  Created by Niall Quinn on 12/02/2018.
//

#import "PDUIGratitudeViewController.h"
#import "PDUIKitUtils.h"
#import "PDUIGratitudeView.h"

@interface PDUIGratitudeViewController ()

@end

@implementation PDUIGratitudeViewController

- (id) initWithType:(PDGratitudeType)type {
  if (self = [super init]) {
    self.view.backgroundColor = [UIColor clearColor];
    self.view.opaque = NO;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    self.type = type;
    NSLog(@"Type is: %li   type",type);
    return self;
  }
  return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewDidLoad];
  UIImage *snapshot = [PDUIKitUtils screenSnapshot];
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
  [imageView setImage:snapshot];
  [self.view addSubview:imageView];
  _gratitudeView = [[PDUIGratitudeView alloc] initForParent:self type:_type];
  [self.view addSubview:_gratitudeView];
  
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) dismissAction {
  [self dismissViewControllerAnimated:YES completion:^{
    
  }];
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
