//
//  PDModalViewController.h
//  Pods
//
//  Created by John Doran Home on 26/11/2015.
//
//

#import <UIKit/UIKit.h>

@interface PDModalViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIView *popupView;

- (void)presentAsModal;

- (void)dismiss;

@end