//
//  PDUIInstagramWebViewController.m
//  PopdeemSDK
//
//  Created by Niall Quinn on 17/06/2016.
//  Copyright © 2016 Popdeem. All rights reserved.
//

#import "PopdeemSDK.h"
#import "PDUIInstagramWebViewController.h"
#import "PDTheme.h"
#import "PDUtils.h"
#import "PDConstants.h"
#import "PDUIInstagramPermissionsViewController.h"

@interface PDUIInstagramWebViewController ()

@end

Boolean didShowInstagramPermissionsPopup = false;

@implementation PDUIInstagramWebViewController

- (instancetype) initFromNib {
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[PDUIInstagramWebViewController class]]] setTintColor:[UIColor blackColor]];
    
	NSBundle *podBundle = [NSBundle bundleForClass:[PopdeemSDK class]];
	if (self = [self initWithNibName:@"PDUIInstagramWebViewController" bundle:podBundle]) {
		self.navigationController.navigationBar.translucent = YES;
		[self.navigationController.navigationBar setBarTintColor:PopdeemColor(PDThemeColorPrimaryApp)];
		[self.navigationController.navigationBar setTintColor:PopdeemColor(PDThemeColorPrimaryInverse)];
		[self.navigationController.navigationBar setTitleTextAttributes:@{
																																			NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryInverse),
																																			NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 16.0f)
																																			}];
		
		[self.navigationController.navigationItem.rightBarButtonItem setTitleTextAttributes:@{
																																													NSForegroundColorAttributeName : PopdeemColor(PDThemeColorPrimaryInverse),
																																													NSFontAttributeName : PopdeemFont(PDThemeFontPrimary, 16.0f)}
																																							 forState:UIControlStateNormal];
		if (PopdeemThemeHasValueForKey(@"popdeem.images.navigationBar")){
			[self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
		}
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
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
    
    
    if(!didShowInstagramPermissionsPopup) {
        [self showInstagramPermissionsWarning];
        didShowInstagramPermissionsPopup = true;
    }
    
    
    
    _loadingView = [[PDUIModalLoadingView alloc] initForView:self.view titleText:@"Please Wait" descriptionText:@"Preparing Instagram Login"];
    //[_loadingView showAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)closeButtonTapped:(id)sender {
  [[NSNotificationCenter defaultCenter] postNotificationName:InstagramLoginCancelPressed object:nil];
  __weak typeof(self) weakSelf = self;
	[self dismissViewControllerAnimated:YES completion:^(void){
		if (weakSelf.wkNewWebView && [weakSelf.wkNewWebView isLoading]) {
				[weakSelf.wkNewWebView stopLoading];
		}
	}];
}

- (void) viewWillDisappear:(BOOL)animated {
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (void) showInstagramPermissionsWarning {
    PDUIInstagramPermissionsViewController *ipvc = [[PDUIInstagramPermissionsViewController alloc] initForParent:self];
    self.definesPresentationContext = YES;
    ipvc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    ipvc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:ipvc animated:YES completion:^(void){}];
}

@end
