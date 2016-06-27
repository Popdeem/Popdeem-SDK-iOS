//
//  PDUIInstagramWebViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 17/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PDUIInstagramWebViewController.h"
#import "PDTheme.h"
#import "PDUtils.h"
@interface PDUIInstagramWebViewController ()

@end

@implementation PDUIInstagramWebViewController

- (instancetype) initFromNib {
	NSBundle *podBundle = [NSBundle bundleForClass:[self classForCoder]];
	if (self = [self initWithNibName:@"PDUIInstagramWebViewController" bundle:podBundle]) {
		self.edgesForExtendedLayout = UIRectEdgeNone;
		[self.navigationBar setBarTintColor:PopdeemColor(@"popdeem.colors.primaryAppColor")];
		[self.navigationBar setTintColor:PopdeemColor(@"popdeem.colors.primaryInverseColor")];
		[self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : PopdeemColor(@"popdeem.colors.primaryInverseColor"),
																								NSFontAttributeName : PopdeemFont(@"popdeem.fonts.primaryFont", 16.0f)}];
		self.title = translationForKey(@"popdeem.instagram.webview.title",@"Connect Instagram Account");
		return self;
	}
	return nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void) viewDidAppear:(BOOL)animated {
	_loadingView = [[PDUIModalLoadingView alloc] initForView:self.view titleText:@"Please Wait..." descriptionText:@"Preparing Instagram Login"];
	[_loadingView showAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeButtonTapped:(id)sender {
	[self dismissViewControllerAnimated:YES completion:^(void){
		[_webView stopLoading];
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
